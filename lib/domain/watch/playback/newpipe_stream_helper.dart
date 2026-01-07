import 'package:fluxtube/domain/watch/models/newpipe/newpipe_stream.dart';
import 'package:fluxtube/domain/watch/models/newpipe/newpipe_watch_resp.dart';
import 'package:fluxtube/domain/watch/playback/models/stream_quality_info.dart';

/// Stream selection and sorting utilities (mimics NewPipe's ListHelper.java)
class NewPipeStreamHelper {
  /// Format preferences (best to worst)
  static const List<String> _preferredVideoFormats = ['MP4', 'WEBM', 'M4A'];
  static const List<String> _preferredAudioFormats = ['M4A', 'OPUS', 'WEBM'];

  /// Check if a quality requires stream merging (video-only + audio)
  static bool requiresMerging(String qualityLabel) {
    // Extract resolution number
    final resolution =
        int.tryParse(qualityLabel.replaceAll(RegExp(r'[^\d]'), ''));
    if (resolution == null) return false;

    // YouTube muxed streams are only available up to 360p
    return resolution > 360;
  }

  /// Get all available qualities from watch response
  static List<StreamQualityInfo> getAvailableQualities(
      NewPipeWatchResp watchResp) {
    final qualities = <StreamQualityInfo>[];
    final seenLabels = <String>{};

    // Process video-only streams FIRST (videoOnlyStreams - need audio, >360p)
    // These are higher quality and should be preferred
    final bestAudio = getBestAudioStream(watchResp.audioStreams ?? []);

    for (var videoStream in watchResp.videoOnlyStreams ?? []) {
      if (videoStream.url == null || videoStream.url!.isEmpty) continue;

      final resolution = _parseResolution(videoStream.resolution);
      if (resolution == null) continue;

      final label = _getQualityLabel(videoStream);

      // Skip if we already have this quality label
      if (seenLabels.contains(label)) continue;
      seenLabels.add(label);

      qualities.add(StreamQualityInfo(
        label: label,
        resolution: resolution,
        fps: videoStream.fps,
        format: videoStream.format,
        requiresMerging: true, // Video-only needs audio
        isVideoOnly: videoStream.isVideoOnly ?? true,
        videoStream: videoStream,
        audioStream: bestAudio,
      ));
    }

    // Process muxed streams (videoStreams - have audio, ≤360p)
    for (var videoStream in watchResp.videoStreams ?? []) {
      if (videoStream.url == null || videoStream.url!.isEmpty) continue;

      final resolution = _parseResolution(videoStream.resolution);
      if (resolution == null) continue;

      final label = _getQualityLabel(videoStream);

      // Skip if we already have this quality label (prefer video-only + audio)
      if (seenLabels.contains(label)) continue;
      seenLabels.add(label);

      qualities.add(StreamQualityInfo(
        label: label,
        resolution: resolution,
        fps: videoStream.fps,
        format: videoStream.format,
        requiresMerging: false, // Muxed streams already have audio
        isVideoOnly: false,
        videoStream: videoStream,
        audioStream: null,
      ));
    }

    // Sort by resolution (highest first), then fps (highest first)
    qualities.sort((a, b) => a.compareTo(b));

    return qualities;
  }

  /// Get quality label for video stream (e.g., "1080p", "720p 60fps")
  static String _getQualityLabel(NewPipeVideoStream stream) {
    String label = stream.resolution ?? 'Unknown';

    // Add fps if higher than 30
    if (stream.fps != null && stream.fps! > 30) {
      label += ' ${stream.fps}fps';
    }

    return label;
  }

  /// Parse resolution from string (e.g., "1080p" -> 1080)
  static int? _parseResolution(String? resolution) {
    if (resolution == null) return null;
    return int.tryParse(resolution.replaceAll(RegExp(r'[^\d]'), ''));
  }

  /// Sort video streams by quality (NewPipe's algorithm)
  static List<NewPipeVideoStream> sortVideoStreams(
    List<NewPipeVideoStream> streams, {
    List<String> preferredFormats = _preferredVideoFormats,
  }) {
    final sorted = List<NewPipeVideoStream>.from(streams);

    sorted.sort((a, b) {
      // 1. Resolution (higher first)
      final aRes = _parseResolution(a.resolution) ?? 0;
      final bRes = _parseResolution(b.resolution) ?? 0;
      if (aRes != bRes) return bRes.compareTo(aRes);

      // 2. FPS (higher first)
      final aFps = a.fps ?? 0;
      final bFps = b.fps ?? 0;
      if (aFps != bFps) return bFps.compareTo(aFps);

      // 3. Format preference
      final aFormatIndex =
          preferredFormats.indexOf(a.format?.toUpperCase() ?? '');
      final bFormatIndex =
          preferredFormats.indexOf(b.format?.toUpperCase() ?? '');

      // If both are in preferred list, compare indices (lower index = more preferred)
      if (aFormatIndex >= 0 && bFormatIndex >= 0) {
        return aFormatIndex.compareTo(bFormatIndex);
      }

      // Preferred format wins over non-preferred
      if (aFormatIndex >= 0) return -1;
      if (bFormatIndex >= 0) return 1;

      // 4. Bitrate (higher first)
      final aBitrate = a.bitrate ?? 0;
      final bBitrate = b.bitrate ?? 0;
      return bBitrate.compareTo(aBitrate);
    });

    return sorted;
  }

  /// Sort audio streams by quality (NewPipe's algorithm)
  static List<NewPipeAudioStream> sortAudioStreams(
    List<NewPipeAudioStream> streams, {
    List<String> preferredFormats = _preferredAudioFormats,
  }) {
    final sorted = List<NewPipeAudioStream>.from(streams);

    sorted.sort((a, b) {
      // 1. Average bitrate (higher first)
      final aBitrate = a.averageBitrate ?? 0;
      final bBitrate = b.averageBitrate ?? 0;
      if (aBitrate != bBitrate) return bBitrate.compareTo(aBitrate);

      // 2. Format preference
      final aFormatIndex =
          preferredFormats.indexOf(a.format?.toUpperCase() ?? '');
      final bFormatIndex =
          preferredFormats.indexOf(b.format?.toUpperCase() ?? '');

      if (aFormatIndex >= 0 && bFormatIndex >= 0) {
        return aFormatIndex.compareTo(bFormatIndex);
      }

      if (aFormatIndex >= 0) return -1;
      if (bFormatIndex >= 0) return 1;

      // 3. Audio channels (more first)
      final aChannels = a.audioChannels ?? 0;
      final bChannels = b.audioChannels ?? 0;
      if (aChannels != bChannels) return bChannels.compareTo(aChannels);

      // 4. Sample rate (higher first)
      final aSampleRate = a.sampleRate ?? 0;
      final bSampleRate = b.sampleRate ?? 0;
      return bSampleRate.compareTo(aSampleRate);
    });

    return sorted;
  }

  /// Get best video stream for target quality
  static NewPipeVideoStream? getBestVideoStream(
    List<NewPipeVideoStream> streams,
    String targetQuality, {
    bool allowVideoOnly = true,
  }) {
    if (streams.isEmpty) return null;

    // Filter by video-only preference
    var filtered = streams
        .where((s) =>
            s.url != null &&
            s.url!.isNotEmpty &&
            (allowVideoOnly || s.isVideoOnly != true))
        .toList();

    if (filtered.isEmpty) return null;

    // Sort streams
    final sorted = sortVideoStreams(filtered);

    // Extract target resolution
    final targetRes = _parseResolution(targetQuality) ?? 720;

    // Try to find exact match first
    for (var stream in sorted) {
      final streamRes = _parseResolution(stream.resolution) ?? 0;
      if (streamRes == targetRes) return stream;
    }

    // Find closest match
    NewPipeVideoStream? closest = sorted.first;
    int smallestDiff = double.maxFinite.toInt();

    for (var stream in sorted) {
      final streamRes = _parseResolution(stream.resolution) ?? 0;
      final diff = (streamRes - targetRes).abs();

      if (diff < smallestDiff) {
        smallestDiff = diff;
        closest = stream;
      }
    }

    return closest;
  }

  /// Get best audio stream (highest quality with best format)
  static NewPipeAudioStream? getBestAudioStream(
    List<NewPipeAudioStream> streams,
  ) {
    if (streams.isEmpty) return null;

    // Filter valid streams
    final filtered =
        streams.where((s) => s.url != null && s.url!.isNotEmpty).toList();

    if (filtered.isEmpty) return null;

    // Sort and return best
    final sorted = sortAudioStreams(filtered);
    return sorted.first;
  }

  /// Get video stream from quality info
  static NewPipeVideoStream? getVideoStreamForQuality(
    NewPipeWatchResp watchResp,
    String qualityLabel,
  ) {
    // Check if quality requires merging (>360p)
    if (requiresMerging(qualityLabel)) {
      // Look in video-only streams
      final sorted = sortVideoStreams(watchResp.videoOnlyStreams ?? []);
      return getBestVideoStream(sorted, qualityLabel, allowVideoOnly: true);
    } else {
      // Look in muxed streams
      final sorted = sortVideoStreams(watchResp.videoStreams ?? []);
      return getBestVideoStream(sorted, qualityLabel, allowVideoOnly: false);
    }
  }

  /// Get maximum available quality
  static String? getMaxAvailableQuality(NewPipeWatchResp watchResp) {
    final qualities = getAvailableQualities(watchResp);
    if (qualities.isEmpty) return null;
    return qualities.first.label;
  }
}
