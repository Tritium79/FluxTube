import 'package:dartz/dartz.dart';
import 'package:fluxtube/core/operations/math_operations.dart';
import 'package:fluxtube/domain/core/failure/main_failure.dart';
import 'package:fluxtube/domain/subscribes/models/subscribe.dart';
import 'package:fluxtube/domain/subscribes/subscribe_services.dart';
import 'package:injectable/injectable.dart';
import 'package:isar_community/isar.dart';

import '../settings/setting_impl.dart';

@LazySingleton(as: SubscribeServices)
class SubscribeImpl extends SubscribeServices {
  Isar isar = SettingImpl.isar;

  // add new channel info to local database
  Future<void> _addSubscribeInformations(Subscribe subscribeInfo) async {
    await isar.writeTxn(() async {
      await isar.subscribes.put(subscribeInfo);
    });
  }

  // get all stored subscriptions for a specific profile
  Future<List<Subscribe>> _getSubscribeInformations(String profileName) async {
    return await isar.subscribes
        .filter()
        .profileNameEqualTo(profileName)
        .findAll();
  }

  // delete a subscription from local database
  Future<void> _deleteSubscribeInformations(String id, String profileName) async {
    final isarId = fastHash('${id}_$profileName');
    await isar.writeTxn(() async {
      await isar.subscribes.delete(isarId);
    });
  }

  // add subscribe implement
  @override
  Future<Either<MainFailure, List<Subscribe>>> addSubscriberInfo(
      {required Subscribe subscribeInfo, String profileName = 'default'}) async {
    try {
      // Ensure profileName is set
      subscribeInfo.profileName = profileName;
      await _addSubscribeInformations(subscribeInfo);
      List<Subscribe> subscribeListAfter = await _getSubscribeInformations(profileName);
      return Right(subscribeListAfter);
    } catch (e) {
      return const Left(MainFailure.clientFailure());
    }
  }

  // delete subscriber info
  @override
  Future<Either<MainFailure, List<Subscribe>>> deleteSubscriberInfo(
      {required String id, String profileName = 'default'}) async {
    try {
      await _deleteSubscribeInformations(id, profileName);
      List<Subscribe> subscribeListAfter = await _getSubscribeInformations(profileName);
      return Right(subscribeListAfter);
    } catch (e) {
      return const Left(MainFailure.clientFailure());
    }
  }

  // get all subscribed channel list for a profile
  @override
  Future<Either<MainFailure, List<Subscribe>>> getSubscriberInfoList(
      {String profileName = 'default'}) async {
    try {
      List<Subscribe> subscribesList = await _getSubscribeInformations(profileName);
      return Right(subscribesList);
    } catch (e) {
      return const Left(MainFailure.clientFailure());
    }
  }

  // check the channel is present in the local storage for a profile
  @override
  Future<Either<MainFailure, Subscribe>> checkSubscriberInfo(
      {required String id, String profileName = 'default'}) async {
    try {
      List<Subscribe> subscribesList = await _getSubscribeInformations(profileName);
      // Find the channel with the specified ID
      Subscribe foundChannel =
          subscribesList.firstWhere((channel) => channel.id == id);

      return Right(foundChannel);
    } catch (e) {
      // Handle the case where the channel is not found
      return const Left(MainFailure.clientFailure());
    }
  }
}
