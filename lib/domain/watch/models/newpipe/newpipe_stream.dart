import 'package:json_annotation/json_annotation.dart';

part 'newpipe_stream.g.dart';

@JsonSerializable()
class NewPipeAudioStream {
  final String? url;
  final int? averageBitrate;
  final String? format;
  final String? mimeType;
  final String? codec;
  final String? quality;
  final String? id;
  final int? itag;
  // DASH manifest fields from ItagItem
  final int? initStart;
  final int? initEnd;
  final int? indexStart;
  final int? indexEnd;
  final int? contentLength;
  final int? bitrate;
  final int? approxDurationMs;
  final int? audioChannels;
  final int? sampleRate;

  NewPipeAudioStream({
    this.url,
    this.averageBitrate,
    this.format,
    this.mimeType,
    this.codec,
    this.quality,
    this.id,
    this.itag,
    this.initStart,
    this.initEnd,
    this.indexStart,
    this.indexEnd,
    this.contentLength,
    this.bitrate,
    this.approxDurationMs,
    this.audioChannels,
    this.sampleRate,
  });

  /// Check if this stream has valid DASH segment info
  bool get hasDashInfo =>
      initStart != null &&
      initEnd != null &&
      indexStart != null &&
      indexEnd != null &&
      initEnd! >= 0 &&
      indexEnd! >= 0;

  factory NewPipeAudioStream.fromJson(Map<String, dynamic> json) =>
      _$NewPipeAudioStreamFromJson(json);

  Map<String, dynamic> toJson() => _$NewPipeAudioStreamToJson(this);
}

@JsonSerializable()
class NewPipeVideoStream {
  final String? url;
  final String? resolution;
  final String? format;
  final String? mimeType;
  final String? codec;
  final String? quality;
  final int? width;
  final int? height;
  final int? fps;
  final bool? isVideoOnly;
  final String? id;
  final int? itag;
  // DASH manifest fields from ItagItem
  final int? initStart;
  final int? initEnd;
  final int? indexStart;
  final int? indexEnd;
  final int? contentLength;
  final int? bitrate;
  final int? approxDurationMs;

  NewPipeVideoStream({
    this.url,
    this.resolution,
    this.format,
    this.mimeType,
    this.codec,
    this.quality,
    this.width,
    this.height,
    this.fps,
    this.isVideoOnly,
    this.id,
    this.itag,
    this.initStart,
    this.initEnd,
    this.indexStart,
    this.indexEnd,
    this.contentLength,
    this.bitrate,
    this.approxDurationMs,
  });

  /// Check if this stream has valid DASH segment info
  bool get hasDashInfo =>
      initStart != null &&
      initEnd != null &&
      indexStart != null &&
      indexEnd != null &&
      initEnd! >= 0 &&
      indexEnd! >= 0;

  factory NewPipeVideoStream.fromJson(Map<String, dynamic> json) =>
      _$NewPipeVideoStreamFromJson(json);

  Map<String, dynamic> toJson() => _$NewPipeVideoStreamToJson(this);
}
