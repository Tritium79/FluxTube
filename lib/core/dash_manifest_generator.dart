import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fluxtube/domain/watch/models/newpipe/newpipe_stream.dart';

/// Generates DASH MPD manifests for combining video-only and audio streams.
/// This enables playback of high-quality video with separate audio tracks
/// using BetterPlayer's DASH support.
class DashManifestGenerator {
  /// Generate a DASH manifest that combines a video-only stream with an audio stream.
  ///
  /// Returns the manifest XML string, or null if the streams don't have valid DASH info.
  static String? generateManifest({
    required NewPipeVideoStream video,
    required NewPipeAudioStream audio,
    required int durationSeconds,
  }) {
    // Validate that both streams have DASH segment info
    if (!video.hasDashInfo || !audio.hasDashInfo) {
      debugPrint('DASH Generator: Missing segment info - video: ${video.hasDashInfo}, audio: ${audio.hasDashInfo}');
      return null;
    }

    if (video.url == null || audio.url == null) {
      debugPrint('DASH Generator: Missing stream URLs');
      return null;
    }

    // Escape XML special characters in URLs
    final videoUrl = _escapeXml(video.url!);
    final audioUrl = _escapeXml(audio.url!);

    // Determine MIME types
    final videoMimeType = _getVideoMimeType(video);
    final audioMimeType = _getAudioMimeType(audio);

    // Get codecs
    final videoCodec = video.codec ?? _inferVideoCodec(video);
    final audioCodec = audio.codec ?? _inferAudioCodec(audio);

    final manifest = '''<?xml version="1.0" encoding="UTF-8"?>
<MPD xmlns="urn:mpeg:DASH:schema:MPD:2011"
     xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
     xsi:schemaLocation="urn:mpeg:DASH:schema:MPD:2011 DASH-MPD.xsd"
     profiles="urn:mpeg:dash:profile:full:2011"
     type="static"
     minBufferTime="PT1.5S"
     mediaPresentationDuration="PT${durationSeconds}S">
  <Period id="0" start="PT0S">
    <AdaptationSet id="0" mimeType="$videoMimeType" contentType="video" subsegmentAlignment="true" subsegmentStartsWithSAP="1">
      <Representation id="${video.itag ?? 0}" bandwidth="${video.bitrate ?? 0}" codecs="$videoCodec" width="${video.width ?? 0}" height="${video.height ?? 0}" frameRate="${video.fps ?? 30}">
        <BaseURL>$videoUrl</BaseURL>
        <SegmentBase indexRange="${video.indexStart}-${video.indexEnd}">
          <Initialization range="${video.initStart}-${video.initEnd}"/>
        </SegmentBase>
      </Representation>
    </AdaptationSet>
    <AdaptationSet id="1" mimeType="$audioMimeType" contentType="audio" subsegmentAlignment="true" subsegmentStartsWithSAP="1">
      <Representation id="${audio.itag ?? 0}" bandwidth="${audio.bitrate ?? audio.averageBitrate ?? 0}" codecs="$audioCodec"${audio.sampleRate != null ? ' audioSamplingRate="${audio.sampleRate}"' : ''}>
        <BaseURL>$audioUrl</BaseURL>
        <SegmentBase indexRange="${audio.indexStart}-${audio.indexEnd}">
          <Initialization range="${audio.initStart}-${audio.initEnd}"/>
        </SegmentBase>
      </Representation>
    </AdaptationSet>
  </Period>
</MPD>''';

    return manifest;
  }

  /// Generate a DASH manifest with multiple video quality options and one audio track.
  static String? generateManifestWithMultipleQualities({
    required List<NewPipeVideoStream> videoStreams,
    required NewPipeAudioStream audio,
    required int durationSeconds,
  }) {
    // Filter to only video streams with valid DASH info
    final validVideos = videoStreams.where((v) => v.hasDashInfo && v.url != null).toList();

    if (validVideos.isEmpty) {
      debugPrint('DASH Generator: No valid video streams with DASH info');
      return null;
    }

    if (!audio.hasDashInfo || audio.url == null) {
      debugPrint('DASH Generator: Audio stream missing DASH info or URL');
      return null;
    }

    final audioUrl = _escapeXml(audio.url!);
    final audioMimeType = _getAudioMimeType(audio);
    final audioCodec = audio.codec ?? _inferAudioCodec(audio);

    // Group videos by MIME type (can't mix mp4 and webm in same AdaptationSet)
    final mp4Videos = validVideos.where((v) => _getVideoMimeType(v) == 'video/mp4').toList();
    final webmVideos = validVideos.where((v) => _getVideoMimeType(v) == 'video/webm').toList();

    // Prefer MP4 for better compatibility
    final videosToUse = mp4Videos.isNotEmpty ? mp4Videos : webmVideos;
    if (videosToUse.isEmpty) {
      debugPrint('DASH Generator: No compatible video streams');
      return null;
    }

    final videoMimeType = _getVideoMimeType(videosToUse.first);

    // Sort by resolution (height) descending
    videosToUse.sort((a, b) => (b.height ?? 0).compareTo(a.height ?? 0));

    final videoRepresentations = videosToUse.map((v) {
      final videoUrl = _escapeXml(v.url!);
      final videoCodec = v.codec ?? _inferVideoCodec(v);
      return '''      <Representation id="${v.itag ?? 0}" bandwidth="${v.bitrate ?? 0}" codecs="$videoCodec" width="${v.width ?? 0}" height="${v.height ?? 0}" frameRate="${v.fps ?? 30}">
        <BaseURL>$videoUrl</BaseURL>
        <SegmentBase indexRange="${v.indexStart}-${v.indexEnd}">
          <Initialization range="${v.initStart}-${v.initEnd}"/>
        </SegmentBase>
      </Representation>''';
    }).join('\n');

    final manifest = '''<?xml version="1.0" encoding="UTF-8"?>
<MPD xmlns="urn:mpeg:DASH:schema:MPD:2011"
     xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
     xsi:schemaLocation="urn:mpeg:DASH:schema:MPD:2011 DASH-MPD.xsd"
     profiles="urn:mpeg:dash:profile:full:2011"
     type="static"
     minBufferTime="PT1.5S"
     mediaPresentationDuration="PT${durationSeconds}S">
  <Period id="0" start="PT0S">
    <AdaptationSet id="0" mimeType="$videoMimeType" contentType="video" subsegmentAlignment="true" subsegmentStartsWithSAP="1">
$videoRepresentations
    </AdaptationSet>
    <AdaptationSet id="1" mimeType="$audioMimeType" contentType="audio" subsegmentAlignment="true" subsegmentStartsWithSAP="1">
      <Representation id="${audio.itag ?? 0}" bandwidth="${audio.bitrate ?? audio.averageBitrate ?? 0}" codecs="$audioCodec"${audio.sampleRate != null ? ' audioSamplingRate="${audio.sampleRate}"' : ''}>
        <BaseURL>$audioUrl</BaseURL>
        <SegmentBase indexRange="${audio.indexStart}-${audio.indexEnd}">
          <Initialization range="${audio.initStart}-${audio.initEnd}"/>
        </SegmentBase>
      </Representation>
    </AdaptationSet>
  </Period>
</MPD>''';

    return manifest;
  }

  /// Save a DASH manifest to a temporary file and return the file path.
  static Future<String?> saveManifestToFile({
    required String manifestContent,
    required String videoId,
  }) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final manifestFile = File('${tempDir.path}/dash_manifest_$videoId.mpd');
      await manifestFile.writeAsString(manifestContent);
      debugPrint('DASH Generator: Manifest saved to ${manifestFile.path}');
      return manifestFile.path;
    } catch (e) {
      debugPrint('DASH Generator: Failed to save manifest: $e');
      return null;
    }
  }

  /// Clean up old manifest files.
  static Future<void> cleanupManifestFiles() async {
    try {
      final tempDir = await getTemporaryDirectory();
      final files = tempDir.listSync().whereType<File>();
      for (final file in files) {
        if (file.path.contains('dash_manifest_') && file.path.endsWith('.mpd')) {
          await file.delete();
        }
      }
    } catch (e) {
      debugPrint('DASH Generator: Failed to cleanup: $e');
    }
  }

  // Helper methods

  static String _escapeXml(String input) {
    return input
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&apos;');
  }

  static String _getVideoMimeType(NewPipeVideoStream video) {
    if (video.mimeType != null) {
      // Extract base mime type (e.g., "video/mp4; codecs=..." -> "video/mp4")
      return video.mimeType!.split(';').first.trim();
    }
    final format = video.format?.toLowerCase() ?? '';
    if (format.contains('webm')) return 'video/webm';
    if (format.contains('3gp')) return 'video/3gpp';
    return 'video/mp4';
  }

  static String _getAudioMimeType(NewPipeAudioStream audio) {
    if (audio.mimeType != null) {
      return audio.mimeType!.split(';').first.trim();
    }
    final format = audio.format?.toLowerCase() ?? '';
    if (format.contains('webm') || format.contains('opus')) return 'audio/webm';
    if (format.contains('m4a') || format.contains('aac')) return 'audio/mp4';
    return 'audio/mp4';
  }

  static String _inferVideoCodec(NewPipeVideoStream video) {
    final format = video.format?.toLowerCase() ?? '';
    final mimeType = video.mimeType?.toLowerCase() ?? '';

    if (mimeType.contains('vp9') || format.contains('vp9')) return 'vp9';
    if (mimeType.contains('vp8') || format.contains('vp8')) return 'vp8';
    if (mimeType.contains('av01') || format.contains('av1')) return 'av01.0.00M.08';
    if (format.contains('webm')) return 'vp9';
    return 'avc1.4d401f'; // Default to H.264
  }

  static String _inferAudioCodec(NewPipeAudioStream audio) {
    final format = audio.format?.toLowerCase() ?? '';
    final mimeType = audio.mimeType?.toLowerCase() ?? '';

    if (mimeType.contains('opus') || format.contains('opus')) return 'opus';
    if (mimeType.contains('vorbis') || format.contains('vorbis')) return 'vorbis';
    if (format.contains('webm')) return 'opus';
    return 'mp4a.40.2'; // Default to AAC
  }
}
