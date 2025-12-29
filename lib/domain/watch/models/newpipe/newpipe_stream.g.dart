// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'newpipe_stream.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewPipeAudioStream _$NewPipeAudioStreamFromJson(Map<String, dynamic> json) =>
    NewPipeAudioStream(
      url: json['url'] as String?,
      averageBitrate: (json['averageBitrate'] as num?)?.toInt(),
      format: json['format'] as String?,
      mimeType: json['mimeType'] as String?,
      codec: json['codec'] as String?,
      quality: json['quality'] as String?,
      id: json['id'] as String?,
      itag: (json['itag'] as num?)?.toInt(),
    );

Map<String, dynamic> _$NewPipeAudioStreamToJson(NewPipeAudioStream instance) =>
    <String, dynamic>{
      'url': instance.url,
      'averageBitrate': instance.averageBitrate,
      'format': instance.format,
      'mimeType': instance.mimeType,
      'codec': instance.codec,
      'quality': instance.quality,
      'id': instance.id,
      'itag': instance.itag,
    };

NewPipeVideoStream _$NewPipeVideoStreamFromJson(Map<String, dynamic> json) =>
    NewPipeVideoStream(
      url: json['url'] as String?,
      resolution: json['resolution'] as String?,
      format: json['format'] as String?,
      mimeType: json['mimeType'] as String?,
      codec: json['codec'] as String?,
      quality: json['quality'] as String?,
      width: (json['width'] as num?)?.toInt(),
      height: (json['height'] as num?)?.toInt(),
      fps: (json['fps'] as num?)?.toInt(),
      isVideoOnly: json['isVideoOnly'] as bool?,
      id: json['id'] as String?,
      itag: (json['itag'] as num?)?.toInt(),
    );

Map<String, dynamic> _$NewPipeVideoStreamToJson(NewPipeVideoStream instance) =>
    <String, dynamic>{
      'url': instance.url,
      'resolution': instance.resolution,
      'format': instance.format,
      'mimeType': instance.mimeType,
      'codec': instance.codec,
      'quality': instance.quality,
      'width': instance.width,
      'height': instance.height,
      'fps': instance.fps,
      'isVideoOnly': instance.isVideoOnly,
      'id': instance.id,
      'itag': instance.itag,
    };
