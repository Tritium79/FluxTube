// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'newpipe_related.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewPipeRelatedStream _$NewPipeRelatedStreamFromJson(
        Map<String, dynamic> json) =>
    NewPipeRelatedStream(
      url: json['url'] as String?,
      name: json['name'] as String?,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      type: json['type'] as String?,
      uploaderName: json['uploaderName'] as String?,
      uploaderUrl: json['uploaderUrl'] as String?,
      uploaderAvatarUrl: json['uploaderAvatarUrl'] as String?,
      uploaderVerified: json['uploaderVerified'] as bool?,
      duration: (json['duration'] as num?)?.toInt(),
      viewCount: (json['viewCount'] as num?)?.toInt(),
      uploadDate: json['uploadDate'] as String?,
      isLive: json['isLive'] as bool?,
      isShort: json['isShort'] as bool?,
      subscriberCount: (json['subscriberCount'] as num?)?.toInt(),
      isVerified: json['isVerified'] as bool?,
      description: json['description'] as String?,
      streamCount: (json['streamCount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$NewPipeRelatedStreamToJson(
        NewPipeRelatedStream instance) =>
    <String, dynamic>{
      'url': instance.url,
      'name': instance.name,
      'thumbnailUrl': instance.thumbnailUrl,
      'type': instance.type,
      'uploaderName': instance.uploaderName,
      'uploaderUrl': instance.uploaderUrl,
      'uploaderAvatarUrl': instance.uploaderAvatarUrl,
      'uploaderVerified': instance.uploaderVerified,
      'duration': instance.duration,
      'viewCount': instance.viewCount,
      'uploadDate': instance.uploadDate,
      'isLive': instance.isLive,
      'isShort': instance.isShort,
      'subscriberCount': instance.subscriberCount,
      'isVerified': instance.isVerified,
      'description': instance.description,
      'streamCount': instance.streamCount,
    };
