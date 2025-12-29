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

  NewPipeAudioStream({
    this.url,
    this.averageBitrate,
    this.format,
    this.mimeType,
    this.codec,
    this.quality,
    this.id,
    this.itag,
  });

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
  });

  factory NewPipeVideoStream.fromJson(Map<String, dynamic> json) =>
      _$NewPipeVideoStreamFromJson(json);

  Map<String, dynamic> toJson() => _$NewPipeVideoStreamToJson(this);
}
