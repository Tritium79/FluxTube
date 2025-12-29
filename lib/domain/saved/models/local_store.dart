// ignore_for_file: public_member_api_docs, sort_constructors_first
// FOR STORE SAVED VIDEOS & HISTORY

import 'package:isar_community/isar.dart';

import '../../../core/operations/math_operations.dart';

part 'local_store.g.dart';

//--------LOCAL STORAGE MODEL--------//
// `flutter pub run build_runner build` to generate file

@Collection()
class LocalStoreVideoInfo {
  String id;
  // Use composite key: id + profileName for unique identification per profile
  @Index(unique: true, composite: [CompositeIndex('profileName')])
  Id get isarId => fastHash('${id}_$profileName');
  String? title;
  int? views;
  String? thumbnail;
  String? uploadedDate;
  String? uploaderName;
  String? uploaderId;
  String? uploaderAvatar;
  String? uploaderSubscriberCount;
  int? duration;
  bool? uploaderVerified;
  bool? isSaved;
  bool? isHistory;
  bool? isLive;
  int? playbackPosition;
  DateTime? time;
  @Index()
  String profileName;
  LocalStoreVideoInfo({
    required this.id,
    this.title,
    this.views,
    this.thumbnail,
    this.uploadedDate,
    this.uploaderName,
    this.uploaderId,
    this.uploaderAvatar,
    this.uploaderSubscriberCount,
    this.duration,
    this.uploaderVerified,
    this.isSaved,
    this.isHistory,
    this.isLive,
    this.playbackPosition,
    this.time,
    this.profileName = 'default',
  });
  LocalStoreVideoInfo.init({
    this.id = '',
    this.title = '',
    this.views = 0,
    this.thumbnail = '',
    this.uploadedDate = '',
    this.uploaderName = '',
    this.uploaderId = '',
    this.uploaderAvatar = '',
    this.uploaderSubscriberCount = '',
    this.duration = 0,
    this.uploaderVerified = false,
    this.isSaved = false,
    this.isHistory = false,
    this.isLive = false,
    this.playbackPosition = 0,
    this.time,
    this.profileName = 'default',
  });
}
