import 'package:dartz/dartz.dart';
import 'package:fluxtube/core/operations/math_operations.dart';
import 'package:fluxtube/domain/core/failure/main_failure.dart';
import 'package:fluxtube/domain/saved/models/local_store.dart';
import 'package:fluxtube/domain/saved/saved_services.dart';
import 'package:fluxtube/infrastructure/settings/setting_impl.dart';
import 'package:injectable/injectable.dart';
import 'package:isar_community/isar.dart';

@LazySingleton(as: SavedServices)
class SavedImpl extends SavedServices {
  Isar isar = SettingImpl.isar;

  // add new video info to local database
  Future<void> _addVideoInformations(LocalStoreVideoInfo videoInfo) async {
    videoInfo.time = DateTime.now();
    await isar.writeTxn(() async {
      await isar.localStoreVideoInfos.put(videoInfo);
    });
  }

  // get all stored video infos for a specific profile
  Future<List<LocalStoreVideoInfo>> _getVideoInformations(String profileName) async {
    return await isar.localStoreVideoInfos
        .filter()
        .profileNameEqualTo(profileName)
        .findAll();
  }

  // delete a video info from local database
  Future<void> _deleteVideoInformations(String id, String profileName) async {
    final isarId = fastHash('${id}_$profileName');
    await isar.writeTxn(() async {
      await isar.localStoreVideoInfos.delete(isarId);
    });
  }

  // add video info implement
  @override
  Future<Either<MainFailure, List<LocalStoreVideoInfo>>> addVideoInfo(
      {required LocalStoreVideoInfo videoInfo, String profileName = 'default'}) async {
    try {
      // Ensure profileName is set
      videoInfo.profileName = profileName;
      await _addVideoInformations(videoInfo);
      List<LocalStoreVideoInfo> videoInfoListAfter =
          await _getVideoInformations(profileName);
      return Right(videoInfoListAfter);
    } catch (e) {
      return const Left(MainFailure.clientFailure());
    }
  }

  // delete video info
  @override
  Future<Either<MainFailure, List<LocalStoreVideoInfo>>> deleteVideoInfo(
      {required String id, String profileName = 'default'}) async {
    try {
      await _deleteVideoInformations(id, profileName);
      List<LocalStoreVideoInfo> videoInfoList = await _getVideoInformations(profileName);
      return Right(videoInfoList);
    } catch (e) {
      return const Left(MainFailure.clientFailure());
    }
  }

  // get all video info list for a profile
  @override
  Future<Either<MainFailure, List<LocalStoreVideoInfo>>>
      getVideoInfoList({String profileName = 'default'}) async {
    try {
      List<LocalStoreVideoInfo> videoInfoList = await _getVideoInformations(profileName);
      return Right(videoInfoList);
    } catch (e) {
      return const Left(MainFailure.clientFailure());
    }
  }

  // check the video info is present in the local storage for a profile
  @override
  Future<Either<MainFailure, LocalStoreVideoInfo>> checkVideoInfo(
      {required String id, String profileName = 'default'}) async {
    try {
      List<LocalStoreVideoInfo> videoInfoList = await _getVideoInformations(profileName);
      // Find the video with the specified ID
      LocalStoreVideoInfo foundVideo =
          videoInfoList.firstWhere((video) => video.id == id);

      return Right(foundVideo);
    } catch (e) {
      // Handle the case where the video is not found
      return const Left(MainFailure.clientFailure());
    }
  }
}
