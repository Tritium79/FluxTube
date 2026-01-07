import 'package:isar_community/isar.dart';

import '../../../core/operations/math_operations.dart';

part 'search_history.g.dart';

@Collection()
class LocalSearchHistory {
  String query;

  @Index(unique: true, composite: [CompositeIndex('profileName')])
  Id get isarId => fastHash('${query.toLowerCase()}_$profileName');

  DateTime? searchedAt;
  int searchCount;

  @Index()
  String profileName;

  LocalSearchHistory({
    required this.query,
    this.searchedAt,
    this.searchCount = 1,
    this.profileName = 'default',
  });
}
