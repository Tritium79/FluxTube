# Drift Migration Plan - FluxTube Database

## Overview

Migrate from `isar_community` to `drift` (SQLite-based) for long-term stability and open-source licensing.

---

## Current State Analysis

### Isar Collections (7 total)

| Collection | Purpose | Profile Support | Key Fields |
|------------|---------|-----------------|------------|
| `SettingsDBValue` | App settings (key-value) | No | name (unique), value |
| `LocalStoreVideoInfo` | Saved videos & history | Yes | id+profile composite |
| `Subscribe` | Channel subscriptions | Yes | id+profile composite |
| `LocalSearchHistory` | Search queries | Yes | query+profile composite |
| `UserInteraction` | Recommendation tracking | Yes | type+entity+profile composite |
| `UserTopicPreference` | Topic preferences | Yes | topic+profile composite |
| `DownloadItem` | Download progress | Yes | videoId (indexed), profile |

### Files to Modify

**Model Files (6):**
- `lib/domain/settings/models/settings_db.dart`
- `lib/domain/saved/models/local_store.dart`
- `lib/domain/subscribes/models/subscribe.dart`
- `lib/domain/search/models/search_history.dart`
- `lib/domain/user_preferences/models/user_preferences.dart`
- `lib/domain/download/models/download_item.dart`

**Implementation Files (7):**
- `lib/infrastructure/settings/setting_impl.dart` (main DB init + settings ops)
- `lib/infrastructure/saved/saved_impl.dart`
- `lib/infrastructure/subscribe/subscribe_impl.dart`
- `lib/infrastructure/search/search_history_impl.dart`
- `lib/infrastructure/user_preferences/user_preferences_impl.dart`
- `lib/infrastructure/download/download_impl.dart`
- `lib/infrastructure/settings/newpipe_data_service.dart` (import/export)

**Build Files:**
- `pubspec.yaml` (dependencies)

---

## Migration Steps

### Phase 1: Setup Drift

1. **Update pubspec.yaml**
   - Remove: `isar_community`, `isar_community_flutter_libs`, `isar_community_generator`
   - Add: `drift`, `drift_flutter`, `sqlite3_flutter_libs`
   - Add dev: `drift_dev`

2. **Create database definition file**
   - New file: `lib/infrastructure/database/app_database.dart`
   - Define all tables using Drift syntax
   - Configure database class with all tables

### Phase 2: Define Drift Tables

Create Drift table definitions to replace Isar collections:

```dart
// settings_table.dart
class SettingsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
  TextColumn get value => text().nullable()();
}

// local_store_video_table.dart
class LocalStoreVideoTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get videoId => text()();
  TextColumn get profileName => text()();
  TextColumn get title => text().nullable()();
  IntColumn get views => integer().nullable()();
  TextColumn get thumbnail => text().nullable()();
  TextColumn get uploadedDate => text().nullable()();
  TextColumn get uploaderName => text().nullable()();
  TextColumn get uploaderId => text().nullable()();
  TextColumn get uploaderAvatar => text().nullable()();
  TextColumn get uploaderSubscriberCount => text().nullable()();
  IntColumn get duration => integer().nullable()();
  BoolColumn get uploaderVerified => boolean().withDefault(const Constant(false))();
  BoolColumn get isSaved => boolean().withDefault(const Constant(false))();
  BoolColumn get isHistory => boolean().withDefault(const Constant(false))();
  BoolColumn get isLive => boolean().withDefault(const Constant(false))();
  IntColumn get playbackPosition => integer().nullable()();
  DateTimeColumn get time => dateTime().nullable()();

  @override
  List<Set<Column>> get uniqueKeys => [{videoId, profileName}];
}

// subscribe_table.dart
class SubscribeTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get channelId => text()();
  TextColumn get profileName => text()();
  TextColumn get channelName => text()();
  BoolColumn get isVerified => boolean().withDefault(const Constant(false))();
  TextColumn get avatarUrl => text().nullable()();

  @override
  List<Set<Column>> get uniqueKeys => [{channelId, profileName}];
}

// search_history_table.dart
class SearchHistoryTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get query => text()();
  TextColumn get profileName => text()();
  DateTimeColumn get searchedAt => dateTime()();
  IntColumn get searchCount => integer().withDefault(const Constant(1))();

  @override
  List<Set<Column>> get uniqueKeys => [{query, profileName}];
}

// user_interaction_table.dart
class UserInteractionTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get entityId => text()();
  IntColumn get interactionType => integer()(); // enum ordinal
  TextColumn get profileName => text()();
  DateTimeColumn get timestamp => dateTime()();
  RealColumn get weight => real().withDefault(const Constant(1.0))();
  TextColumn get title => text().nullable()();
  TextColumn get channelName => text().nullable()();
  TextColumn get category => text().nullable()();
  TextColumn get tags => text().nullable()(); // JSON array as string

  @override
  List<Set<Column>> get uniqueKeys => [{interactionType, entityId, profileName}];
}

// user_topic_preference_table.dart
class UserTopicPreferenceTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get topic => text()();
  TextColumn get profileName => text()();
  RealColumn get relevanceScore => real().withDefault(const Constant(0.0))();
  DateTimeColumn get lastUpdated => dateTime()();

  @override
  List<Set<Column>> get uniqueKeys => [{topic, profileName}];
}

// download_item_table.dart
class DownloadItemTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get videoId => text()();
  TextColumn get profileName => text()();
  TextColumn get title => text()();
  TextColumn get channelName => text()();
  TextColumn get thumbnailUrl => text().nullable()();
  IntColumn get duration => integer().nullable()();
  TextColumn get videoQuality => text().nullable()();
  TextColumn get audioQuality => text().nullable()();
  IntColumn get downloadType => integer()(); // enum ordinal
  IntColumn get status => integer()(); // enum ordinal
  TextColumn get videoUrl => text().nullable()();
  TextColumn get audioUrl => text().nullable()();
  TextColumn get videoFilePath => text().nullable()();
  TextColumn get audioFilePath => text().nullable()();
  TextColumn get outputFilePath => text().nullable()();
  IntColumn get totalBytes => integer().nullable()();
  IntColumn get downloadedBytes => integer().withDefault(const Constant(0))();
  IntColumn get downloadSpeed => integer().withDefault(const Constant(0))();
  IntColumn get etaSeconds => integer().nullable()();
  TextColumn get errorMessage => text().nullable()();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get startedAt => dateTime().nullable()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  RealColumn get videoProgress => real().withDefault(const Constant(0.0))();
  RealColumn get audioProgress => real().withDefault(const Constant(0.0))();
}
```

### Phase 3: Create Database Class

```dart
// lib/infrastructure/database/app_database.dart
@DriftDatabase(tables: [
  SettingsTable,
  LocalStoreVideoTable,
  SubscribeTable,
  SearchHistoryTable,
  UserInteractionTable,
  UserTopicPreferenceTable,
  DownloadItemTable,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'fluxtube.db');
  }
}
```

### Phase 4: Update Implementation Files

For each implementation file, convert:

| Isar Pattern | Drift Pattern |
|--------------|---------------|
| `isar.writeTxn(() => collection.put(item))` | `into(table).insert(item, mode: InsertMode.insertOrReplace)` |
| `collection.filter().propertyEqualTo(x).findAll()` | `(select(table)..where((t) => t.property.equals(x))).get()` |
| `collection.filter().propertyEqualTo(x).findFirst()` | `(select(table)..where((t) => t.property.equals(x))).getSingleOrNull()` |
| `collection.delete(id)` | `(delete(table)..where((t) => t.id.equals(id))).go()` |
| `collection.filter().deleteAll()` | `(delete(table)..where((t) => condition)).go()` |

### Phase 5: Update Export/Import

**NewPipe Data Service Changes:**
- Already uses SQLite for export - simplify by directly copying from Drift DB
- Import remains similar (read from imported SQLite, insert to Drift)
- JSON export/import stays the same (serialize model objects)

**Key Consideration:**
- NewPipe export creates its own SQLite database
- With Drift, we can potentially reuse schema or export directly
- Must maintain NewPipe format compatibility for cross-app import

### Phase 6: Model Updates

Keep domain models mostly unchanged but:
1. Remove Isar annotations (`@Collection()`, `@Index()`, `@Enumerated()`)
2. Remove generated `.g.dart` parts
3. Add Drift companion object converters where needed
4. Keep helper methods (formatters, computed properties)

### Phase 7: Cleanup

1. Run `flutter pub run build_runner build --delete-conflicting-outputs`
2. Remove old `.g.dart` Isar generated files
3. Update imports throughout codebase
4. Remove Isar from pubspec.yaml

---

## Import/Export Compatibility

### Current Export Formats

1. **NewPipe ZIP** (primary)
   - SQLite database (`newpipe.db`)
   - Preferences JSON
   - Settings file

2. **JSON** (legacy)
   - Subscriptions only
   - NewPipe-compatible format

### Migration Impact

| Feature | Before (Isar) | After (Drift) | Compatible? |
|---------|---------------|---------------|-------------|
| NewPipe ZIP Export | Creates temp SQLite | Direct from Drift | Yes |
| NewPipe ZIP Import | Reads SQLite → Isar | Reads SQLite → Drift | Yes |
| JSON Export | Isar → JSON | Drift → JSON | Yes |
| JSON Import | JSON → Isar | JSON → Drift | Yes |

**Advantages of Drift for Export:**
- Native SQLite - no conversion layer needed
- Can export actual database file directly
- Better compatibility with other apps using SQLite

---

## Risk Assessment

| Risk | Mitigation |
|------|------------|
| Data loss during migration | Test on backup data first |
| Export format incompatibility | Keep same SQLite schema for NewPipe compat |
| Performance regression | Drift is well-optimized, benchmark critical paths |
| Build issues | Clean build after removing Isar generators |

---

## Execution Order

1. [ ] Add Drift dependencies to pubspec.yaml
2. [ ] Create table definitions in new file
3. [ ] Create AppDatabase class
4. [ ] Run build_runner to generate Drift code
5. [ ] Update SettingImpl (main entry point)
6. [ ] Update SavedImpl
7. [ ] Update SubscribeImpl
8. [ ] Update SearchHistoryImpl
9. [ ] Update UserPreferencesImpl
10. [ ] Update DownloadImpl
11. [ ] Update NewPipeDataService
12. [ ] Clean up old Isar model annotations
13. [ ] Remove Isar dependencies
14. [ ] Final build_runner clean build
15. [ ] Test all operations
16. [ ] Verify import/export compatibility

---

## Estimated Changes

- **New files:** 1 (database definition)
- **Modified files:** 13
- **Deleted files:** 0 (but generated .g.dart files will change)
- **Lines changed:** ~2000-3000
