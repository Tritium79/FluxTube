import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:fluxtube/core/enums.dart';
import 'package:fluxtube/core/strings.dart';
import 'package:fluxtube/domain/core/failure/main_failure.dart';
import 'package:fluxtube/domain/saved/models/local_store.dart';
import 'package:fluxtube/domain/settings/models/instance.dart';
import 'package:fluxtube/domain/settings/models/settings_db.dart';
import 'package:fluxtube/domain/settings/settings_service.dart';
import 'package:fluxtube/domain/subscribes/models/subscribe.dart';
import 'package:injectable/injectable.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../core/settings.dart';

@LazySingleton(as: SettingsService)
class SettingImpl implements SettingsService {
  static late Isar isar;

  // Initialize the database
  static Future<void> initializeDB() async {
    final dir = await getApplicationCacheDirectory();
    isar = await Isar.open(
        [SettingsDBValueSchema, LocalStoreVideoInfoSchema, SubscribeSchema],
        directory: dir.path);
  }

  // Common setting fetch code
  Future<Map<String, String>> _getOrDefault(
      String settingName, String defaultValue) async {
    final setting = await isar.settingsDBValues
        .filter()
        .nameEqualTo(settingName)
        .findFirst();

    if (setting == null) {
      final newSetting = SettingsDBValue()
        ..name = settingName
        ..value = defaultValue;
      await isar.writeTxn(() async {
        await isar.settingsDBValues.put(newSetting);
      });
      return {settingName: defaultValue};
    } else {
      return {settingName: setting.value ?? defaultValue};
    }
  }

  /// Generic method to set any setting value
  /// Eliminates duplicate code across all setting methods
  Future<Either<MainFailure, T>> _setSetting<T>({
    required String settingName,
    required T value,
    required String Function(T) toStringValue,
  }) async {
    try {
      await isar.writeTxn(() async {
        final existingSetting = await isar.settingsDBValues
            .filter()
            .nameEqualTo(settingName)
            .findFirst();

        final stringValue = toStringValue(value);

        if (existingSetting == null) {
          final newSetting = SettingsDBValue()
            ..name = settingName
            ..value = stringValue;
          await isar.settingsDBValues.put(newSetting);
        } else {
          existingSetting.value = stringValue;
          await isar.settingsDBValues.put(existingSetting);
        }
      });

      return Right(value);
    } catch (e) {
      return const Left(MainFailure.serverFailure());
    }
  }

  // Initialize settings state during app startup
  @override
  Future<List<Map<String, String>>> initializeSettings() async {
    // Define your settings and their default values
    final settingsDefaults = [
      {"name": selectedDefaultLanguage, "default": "en"},
      {"name": selectedDefaultQuality, "default": "720p"},
      {"name": selectedDefaultRegion, "default": "IN"},
      {"name": selectedTheme, "default": "system"},
      {"name": historyVisibility, "default": "true"},
      {"name": dislikeVisibility, "default": "false"},
      {"name": hlsPlayer, "default": "false"},
      {"name": commentsVisibility, "default": "false"},
      {"name": relatedVideoVisibility, "default": "false"},
      {"name": instanceApiUrl, "default": BaseUrl.kBaseUrl},
      {"name": youtubeService, "default": YouTubeServices.iframe.name},
      {"name": playerTypeKey, "default": PlayerType.betterPlayer.name},
      {"name": pipDisabled, "default": "false"},
      // Add more settings here
    ];

    // Initialize settings list
    List<Map<String, String>> settingsList = [];

    // Iterate over settingsDefaults and initialize each setting
    for (var setting in settingsDefaults) {
      settingsList
          .add(await _getOrDefault(setting["name"]!, setting["default"]!));
    }

    return settingsList;
  }

// DEFAULT LANGUAGE SET
  @override
  Future<Either<MainFailure, String>> selectDefaultLanguage(
      {required String language}) async {
    return _setSetting(
      settingName: selectedDefaultLanguage,
      value: language,
      toStringValue: (v) => v,
    );
  }

  // DEFAULT QUALITY SET
  @override
  Future<Either<MainFailure, String>> selectDefaultQuality(
      {required String quality}) async {
    return _setSetting(
      settingName: selectedDefaultQuality,
      value: quality,
      toStringValue: (v) => v,
    );
  }

  // CONTENT REGION SET
  @override
  Future<Either<MainFailure, String>> selectRegion(
      {required String region}) async {
    return _setSetting(
      settingName: selectedDefaultRegion,
      value: region,
      toStringValue: (v) => v,
    );
  }

  // THEME TOGGLE
  @override
  Future<Either<MainFailure, String>> setTheme(
      {required String themeMode}) async {
    return _setSetting(
      settingName: selectedTheme,
      value: themeMode,
      toStringValue: (v) => v,
    );
  }

  // HISTORY VISIBILITY TOGGLE SETTING
  @override
  Future<Either<MainFailure, bool>> toggleHistoryVisibility(
      {required bool isHistoryVisible}) async {
    return _setSetting(
      settingName: historyVisibility,
      value: isHistoryVisible,
      toStringValue: (v) => v.toString(),
    );
  }

  // DISLIKE VISIBILITY TOGGLE SETTING
  @override
  Future<Either<MainFailure, bool>> toggleDislikeVisibility(
      {required bool isDislikeVisible}) async {
    return _setSetting(
      settingName: dislikeVisibility,
      value: isDislikeVisible,
      toStringValue: (v) => v.toString(),
    );
  }

  // HLS PLAYER TOGGLE SETTING
  @override
  Future<Either<MainFailure, bool>> toggleHlsPlayer(
      {required bool isHlsPlayer}) async {
    return _setSetting(
      settingName: hlsPlayer,
      value: isHlsPlayer,
      toStringValue: (v) => v.toString(),
    );
  }

  @override
  Future<Either<MainFailure, bool>> toggleHideComments(
      {required bool isHideComments}) async {
    return _setSetting(
      settingName: commentsVisibility,
      value: isHideComments,
      toStringValue: (v) => v.toString(),
    );
  }

  @override
  Future<Either<MainFailure, bool>> toggleHideRelatedVideos(
      {required bool isHideRelated}) async {
    return _setSetting(
      settingName: relatedVideoVisibility,
      value: isHideRelated,
      toStringValue: (v) => v.toString(),
    );
  }

  @override
  Future<Either<MainFailure, List<Instance>>> fetchInstances() async {
    final dio = Dio();
    final List<Instance> instances = [];
    try {
      final response = await dio.get(kInstanceUrl);
      int skipped = 0;
      final lines = response.data.toString().split('\n');
      for (final line in lines) {
        final split = line.split('|');
        if (split.length == 5) {
          if (skipped < 2) {
            skipped++;
            continue;
          }
          instances.add(Instance(
              name: split[0].trim(),
              api: '${split[1].trim()}/',
              locations: split[2].trim(),));
        }
      }
      return Right(instances);
    } catch (_) {
      return const Left(MainFailure.serverFailure());
    }
  }

  @override
  Future<Either<MainFailure, String>> setInstance(
      {required String instanceApi}) async {
    return _setSetting(
      settingName: instanceApiUrl,
      value: instanceApi,
      toStringValue: (v) => v,
    );
  }

  @override
  Future<Either<MainFailure, YouTubeServices>> setTYService(
      {required YouTubeServices service}) async {
    return _setSetting(
      settingName: youtubeService,
      value: service,
      toStringValue: (v) => v.name,
    );
  }

  @override
  Future<Either<MainFailure, PlayerType>> setPlayerType(
      {required PlayerType playerType}) async {
    return _setSetting(
      settingName: playerTypeKey,
      value: playerType,
      toStringValue: (v) => v.name,
    );
  }

  @override
  Future<Either<MainFailure, List<Instance>>> fetchInvidiousInstances() async {
    try {
      final dio = Dio();
      final List<Instance> instances = [];
      final response = await dio.get(kInvidiousInstanceUrl);
      final data = response.data as List<dynamic>;

      for (final instanceData in data) {
        final instanceInfo = instanceData[1] as Map<String, dynamic>;

        // Only include instances with API enabled and HTTPS type
        final apiEnabled = instanceInfo['api'] == true;
        final isHttps = instanceInfo['type'] == 'https';

        if (isHttps) {
          instances.add(Instance(
            name: '${instanceData[0] as String}${apiEnabled ? '' : ' (API disabled)'}',
            api: instanceInfo['uri'] as String,
            locations: instanceInfo['region'] as String? ?? 'Unknown',
          ));
        }
      }

      return Right(instances);
    } catch (_) {
      return const Left(MainFailure.serverFailure());
    }
  }

  @override
  Future<Either<MainFailure, bool>> togglePipPlayer({required bool isPipDisabled}) async {
    return _setSetting(
      settingName: pipDisabled,
      value: isPipDisabled,
      toStringValue: (v) => v.toString(),
    );
  }

  @override
  Future<Either<MainFailure, String>> findWorkingPipedInstance({
    required List<Instance> instances,
    String? preferredInstanceApi,
    void Function(String instanceName)? onTestingInstance,
  }) async {
    // If user has a preferred instance, test it first
    if (preferredInstanceApi != null && preferredInstanceApi.isNotEmpty) {
      final preferredInstance = instances.firstWhere(
        (i) => i.api == preferredInstanceApi,
        orElse: () => Instance(name: 'Preferred', api: preferredInstanceApi, locations: ''),
      );

      onTestingInstance?.call(preferredInstance.name);
      final isWorking = await testInstanceConnection(preferredInstanceApi);
      if (isWorking) {
        return Right(preferredInstanceApi);
      }
    }

    // Test other instances
    for (final instance in instances) {
      // Skip the preferred instance since we already tested it
      if (instance.api == preferredInstanceApi) continue;

      try {
        onTestingInstance?.call(instance.name);
        final isWorking = await testInstanceConnection(instance.api);
        if (isWorking) {
          return Right(instance.api);
        }
      } catch (_) {
        continue;
      }
    }

    return const Left(MainFailure.serverFailure());
  }

  @override
  Future<bool> testInstanceConnection(String apiUrl) async {
    final dio = Dio();
    dio.options.connectTimeout = const Duration(seconds: 5);
    dio.options.receiveTimeout = const Duration(seconds: 5);

    try {
      final testUrl = '${apiUrl}trending?region=US';
      final response = await dio.get(testUrl);
      dio.close();

      if (response.statusCode == 200 && response.data != null) {
        // Verify response is valid JSON array (trending returns array of videos)
        if (response.data is List && (response.data as List).isNotEmpty) {
          return true;
        }
      }
      return false;
    } catch (_) {
      dio.close();
      return false;
    }
  }

  @override
  Future<Either<MainFailure, String>> findWorkingInvidiousInstance({
    required List<Instance> instances,
    String? preferredInstanceApi,
    void Function(String instanceName)? onTestingInstance,
  }) async {
    // If user has a preferred instance, test it first
    if (preferredInstanceApi != null && preferredInstanceApi.isNotEmpty) {
      final preferredInstance = instances.firstWhere(
        (i) => i.api == preferredInstanceApi,
        orElse: () => Instance(name: 'Preferred', api: preferredInstanceApi, locations: ''),
      );

      onTestingInstance?.call(preferredInstance.name);
      final isWorking = await testInvidiousInstanceConnection(preferredInstanceApi);
      if (isWorking) {
        return Right(preferredInstanceApi);
      }
    }

    // Filter to only test instances without "(API disabled)" in name
    final apiEnabledInstances = instances.where(
      (i) => !i.name.contains('(API disabled)') && i.api != preferredInstanceApi,
    ).toList();

    // Test API-enabled instances first
    for (final instance in apiEnabledInstances) {
      try {
        onTestingInstance?.call(instance.name);
        final isWorking = await testInvidiousInstanceConnection(instance.api);
        if (isWorking) {
          return Right(instance.api);
        }
      } catch (_) {
        continue;
      }
    }

    return const Left(MainFailure.serverFailure());
  }

  @override
  Future<bool> testInvidiousInstanceConnection(String apiUrl) async {
    final dio = Dio();
    dio.options.connectTimeout = const Duration(seconds: 5);
    dio.options.receiveTimeout = const Duration(seconds: 5);

    try {
      // Invidious API uses /api/v1/trending endpoint
      final testUrl = '$apiUrl/api/v1/trending?region=US';
      final response = await dio.get(testUrl);
      dio.close();

      if (response.statusCode == 200 && response.data != null) {
        // Verify response is valid JSON array (trending returns array of videos)
        if (response.data is List && (response.data as List).isNotEmpty) {
          return true;
        }
      }
      return false;
    } catch (_) {
      dio.close();
      return false;
    }
  }
}
