import 'package:dartz/dartz.dart';
import 'package:fluxtube/domain/core/failure/main_failure.dart';
import 'package:fluxtube/domain/search/models/search_history.dart';
import 'package:fluxtube/domain/search/search_history_service.dart';
import 'package:fluxtube/infrastructure/settings/setting_impl.dart';
import 'package:injectable/injectable.dart';
import 'package:isar_community/isar.dart';

@LazySingleton(as: SearchHistoryService)
class SearchHistoryImpl implements SearchHistoryService {
  @override
  Future<Either<MainFailure, List<LocalSearchHistory>>> getSearchHistory({
    String profileName = 'default',
    int limit = 20,
  }) async {
    try {
      final allResults = await SettingImpl.isar.localSearchHistorys
          .filter()
          .profileNameEqualTo(profileName)
          .sortBySearchedAtDesc()
          .findAll();

      // Apply limit in Dart
      final results = allResults.take(limit).toList();
      return Right(results);
    } catch (e) {
      return const Left(MainFailure.serverFailure());
    }
  }

  @override
  Future<Either<MainFailure, LocalSearchHistory>> addSearchQuery({
    required String query,
    String profileName = 'default',
  }) async {
    try {
      final trimmedQuery = query.trim();
      if (trimmedQuery.isEmpty) {
        return const Left(MainFailure.clientFailure());
      }

      // Check if query already exists
      final existing = await SettingImpl.isar.localSearchHistorys
          .filter()
          .queryEqualTo(trimmedQuery, caseSensitive: false)
          .profileNameEqualTo(profileName)
          .findFirst();

      late LocalSearchHistory searchHistory;

      await SettingImpl.isar.writeTxn(() async {
        if (existing != null) {
          // Update existing entry
          searchHistory = LocalSearchHistory(
            query: trimmedQuery,
            searchedAt: DateTime.now(),
            searchCount: existing.searchCount + 1,
            profileName: profileName,
          );
        } else {
          // Create new entry
          searchHistory = LocalSearchHistory(
            query: trimmedQuery,
            searchedAt: DateTime.now(),
            searchCount: 1,
            profileName: profileName,
          );
        }
        await SettingImpl.isar.localSearchHistorys.put(searchHistory);
      });

      return Right(searchHistory);
    } catch (e) {
      return const Left(MainFailure.serverFailure());
    }
  }

  @override
  Future<Either<MainFailure, bool>> deleteSearchQuery({
    required String query,
    String profileName = 'default',
  }) async {
    try {
      final existing = await SettingImpl.isar.localSearchHistorys
          .filter()
          .queryEqualTo(query, caseSensitive: false)
          .profileNameEqualTo(profileName)
          .findFirst();

      if (existing != null) {
        await SettingImpl.isar.writeTxn(() async {
          await SettingImpl.isar.localSearchHistorys.delete(existing.isarId);
        });
      }

      return const Right(true);
    } catch (e) {
      return const Left(MainFailure.serverFailure());
    }
  }

  @override
  Future<Either<MainFailure, bool>> clearAllSearchHistory({
    String profileName = 'default',
  }) async {
    try {
      await SettingImpl.isar.writeTxn(() async {
        await SettingImpl.isar.localSearchHistorys
            .filter()
            .profileNameEqualTo(profileName)
            .deleteAll();
      });

      return const Right(true);
    } catch (e) {
      return const Left(MainFailure.serverFailure());
    }
  }
}
