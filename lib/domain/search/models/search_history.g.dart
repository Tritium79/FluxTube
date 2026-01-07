// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_history.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetLocalSearchHistoryCollection on Isar {
  IsarCollection<LocalSearchHistory> get localSearchHistorys =>
      this.collection();
}

const LocalSearchHistorySchema = CollectionSchema(
  name: r'LocalSearchHistory',
  id: 7424136778962281428,
  properties: {
    r'profileName': PropertySchema(
      id: 0,
      name: r'profileName',
      type: IsarType.string,
    ),
    r'query': PropertySchema(
      id: 1,
      name: r'query',
      type: IsarType.string,
    ),
    r'searchCount': PropertySchema(
      id: 2,
      name: r'searchCount',
      type: IsarType.long,
    ),
    r'searchedAt': PropertySchema(
      id: 3,
      name: r'searchedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _localSearchHistoryEstimateSize,
  serialize: _localSearchHistorySerialize,
  deserialize: _localSearchHistoryDeserialize,
  deserializeProp: _localSearchHistoryDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'profileName': IndexSchema(
      id: 83478810300269620,
      name: r'profileName',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'profileName',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _localSearchHistoryGetId,
  getLinks: _localSearchHistoryGetLinks,
  attach: _localSearchHistoryAttach,
  version: '3.3.0-dev.1',
);

int _localSearchHistoryEstimateSize(
  LocalSearchHistory object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.profileName.length * 3;
  bytesCount += 3 + object.query.length * 3;
  return bytesCount;
}

void _localSearchHistorySerialize(
  LocalSearchHistory object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.profileName);
  writer.writeString(offsets[1], object.query);
  writer.writeLong(offsets[2], object.searchCount);
  writer.writeDateTime(offsets[3], object.searchedAt);
}

LocalSearchHistory _localSearchHistoryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LocalSearchHistory(
    profileName: reader.readStringOrNull(offsets[0]) ?? 'default',
    query: reader.readString(offsets[1]),
    searchCount: reader.readLongOrNull(offsets[2]) ?? 1,
    searchedAt: reader.readDateTimeOrNull(offsets[3]),
  );
  return object;
}

P _localSearchHistoryDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset) ?? 'default') as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset) ?? 1) as P;
    case 3:
      return (reader.readDateTimeOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _localSearchHistoryGetId(LocalSearchHistory object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _localSearchHistoryGetLinks(
    LocalSearchHistory object) {
  return [];
}

void _localSearchHistoryAttach(
    IsarCollection<dynamic> col, Id id, LocalSearchHistory object) {}

extension LocalSearchHistoryQueryWhereSort
    on QueryBuilder<LocalSearchHistory, LocalSearchHistory, QWhere> {
  QueryBuilder<LocalSearchHistory, LocalSearchHistory, QAfterWhere>
      anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension LocalSearchHistoryQueryWhere
    on QueryBuilder<LocalSearchHistory, LocalSearchHistory, QWhereClause> {
  QueryBuilder<LocalSearchHistory, LocalSearchHistory, QAfterWhereClause>
      isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<LocalSearchHistory, LocalSearchHistory, QAfterWhereClause>
      isarIdNotEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<LocalSearchHistory, LocalSearchHistory, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<LocalSearchHistory, LocalSearchHistory, QAfterWhereClause>
      isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<LocalSearchHistory, LocalSearchHistory, QAfterWhereClause>
      isarIdBetween(
    Id lowerIsarId,
    Id upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerIsarId,
        includeLower: includeLower,
        upper: upperIsarId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalSearchHistory, LocalSearchHistory, QAfterWhereClause>
      profileNameEqualTo(String profileName) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'profileName',
        value: [profileName],
      ));
    });
  }

  QueryBuilder<LocalSearchHistory, LocalSearchHistory, QAfterWhereClause>
      profileNameNotEqualTo(String profileName) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'profileName',
              lower: [],
              upper: [profileName],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'profileName',
              lower: [profileName],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'profileName',
              lower: [profileName],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'profileName',
              lower: [],
              upper: [profileName],
              includeUpper: false,
            ));
      }
    });
  }
}

extension LocalSearchHistoryQueryFilter
    on QueryBuilder<LocalSearchHistory, LocalSearchHistory, QFilterCondition> {
  QueryBuilder<LocalSearchHistory, LocalSearchHistory, QAfterFilterCondition>
      isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalSearchHistory, LocalSearchHistory, QAfterFilterCondition>
      isarIdGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalSearchHistory, LocalSearchHistory, QAfterFilterCondition>
      isarIdLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalSearchHistory, LocalSearchHistory, QAfterFilterCondition>
      isarIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isarId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalSearchHistory, LocalSearchHistory, QAfterFilterCondition>
      profileNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'profileName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalSearchHistory, LocalSearchHistory, QAfterFilterCondition>
      profileNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'profileName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalSearchHistory, LocalSearchHistory, QAfterFilterCondition>
      profileNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'profileName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalSearchHistory, LocalSearchHistory, QAfterFilterCondition>
      profileNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'profileName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalSearchHistory, LocalSearchHistory, QAfterFilterCondition>
      profileNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'profileName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalSearchHistory, LocalSearchHistory, QAfterFilterCondition>
      profileNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'profileName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalSearchHistory, LocalSearchHistory, QAfterFilterCondition>
      profileNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'profileName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalSearchHistory, LocalSearchHistory, QAfterFilterCondition>
      profileNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'profileName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalSearchHistory, LocalSearchHistory, QAfterFilterCondition>
      profileNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'profileName',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalSearchHistory, LocalSearchHistory, QAfterFilterCondition>
      profileNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'profileName',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalSearchHistory, LocalSearchHistory, QAfterFilterCondition>
      queryEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'query',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalSearchHistory, LocalSearchHistory, QAfterFilterCondition>
      queryGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'query',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalSearchHistory, LocalSearchHistory, QAfterFilterCondition>
      queryLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'query',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalSearchHistory, LocalSearchHistory, QAfterFilterCondition>
      queryBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'query',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalSearchHistory, LocalSearchHistory, QAfterFilterCondition>
      queryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'query',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalSearchHistory, LocalSearchHistory, QAfterFilterCondition>
      queryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'query',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalSearchHistory, LocalSearchHistory, QAfterFilterCondition>
      queryContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'query',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalSearchHistory, LocalSearchHistory, QAfterFilterCondition>
      queryMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'query',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalSearchHistory, LocalSearchHistory, QAfterFilterCondition>
      queryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'query',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalSearchHistory, LocalSearchHistory, QAfterFilterCondition>
      queryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'query',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalSearchHistory, LocalSearchHistory, QAfterFilterCondition>
      searchCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'searchCount',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalSearchHistory, LocalSearchHistory, QAfterFilterCondition>
      searchCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'searchCount',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalSearchHistory, LocalSearchHistory, QAfterFilterCondition>
      searchCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'searchCount',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalSearchHistory, LocalSearchHistory, QAfterFilterCondition>
      searchCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'searchCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalSearchHistory, LocalSearchHistory, QAfterFilterCondition>
      searchedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'searchedAt',
      ));
    });
  }

  QueryBuilder<LocalSearchHistory, LocalSearchHistory, QAfterFilterCondition>
      searchedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'searchedAt',
      ));
    });
  }

  QueryBuilder<LocalSearchHistory, LocalSearchHistory, QAfterFilterCondition>
      searchedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'searchedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalSearchHistory, LocalSearchHistory, QAfterFilterCondition>
      searchedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'searchedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalSearchHistory, LocalSearchHistory, QAfterFilterCondition>
      searchedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'searchedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalSearchHistory, LocalSearchHistory, QAfterFilterCondition>
      searchedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'searchedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension LocalSearchHistoryQueryObject
    on QueryBuilder<LocalSearchHistory, LocalSearchHistory, QFilterCondition> {}

extension LocalSearchHistoryQueryLinks
    on QueryBuilder<LocalSearchHistory, LocalSearchHistory, QFilterCondition> {}

extension LocalSearchHistoryQuerySortBy
    on QueryBuilder<LocalSearchHistory, LocalSearchHistory, QSortBy> {
  QueryBuilder<LocalSearchHistory, LocalSearchHistory, QAfterSortBy>
      sortByProfileName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profileName', Sort.asc);
    });
  }

  QueryBuilder<LocalSearchHistory, LocalSearchHistory, QAfterSortBy>
      sortByProfileNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profileName', Sort.desc);
    });
  }

  QueryBuilder<LocalSearchHistory, LocalSearchHistory, QAfterSortBy>
      sortByQuery() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'query', Sort.asc);
    });
  }

  QueryBuilder<LocalSearchHistory, LocalSearchHistory, QAfterSortBy>
      sortByQueryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'query', Sort.desc);
    });
  }

  QueryBuilder<LocalSearchHistory, LocalSearchHistory, QAfterSortBy>
      sortBySearchCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'searchCount', Sort.asc);
    });
  }

  QueryBuilder<LocalSearchHistory, LocalSearchHistory, QAfterSortBy>
      sortBySearchCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'searchCount', Sort.desc);
    });
  }

  QueryBuilder<LocalSearchHistory, LocalSearchHistory, QAfterSortBy>
      sortBySearchedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'searchedAt', Sort.asc);
    });
  }

  QueryBuilder<LocalSearchHistory, LocalSearchHistory, QAfterSortBy>
      sortBySearchedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'searchedAt', Sort.desc);
    });
  }
}

extension LocalSearchHistoryQuerySortThenBy
    on QueryBuilder<LocalSearchHistory, LocalSearchHistory, QSortThenBy> {
  QueryBuilder<LocalSearchHistory, LocalSearchHistory, QAfterSortBy>
      thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<LocalSearchHistory, LocalSearchHistory, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<LocalSearchHistory, LocalSearchHistory, QAfterSortBy>
      thenByProfileName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profileName', Sort.asc);
    });
  }

  QueryBuilder<LocalSearchHistory, LocalSearchHistory, QAfterSortBy>
      thenByProfileNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profileName', Sort.desc);
    });
  }

  QueryBuilder<LocalSearchHistory, LocalSearchHistory, QAfterSortBy>
      thenByQuery() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'query', Sort.asc);
    });
  }

  QueryBuilder<LocalSearchHistory, LocalSearchHistory, QAfterSortBy>
      thenByQueryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'query', Sort.desc);
    });
  }

  QueryBuilder<LocalSearchHistory, LocalSearchHistory, QAfterSortBy>
      thenBySearchCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'searchCount', Sort.asc);
    });
  }

  QueryBuilder<LocalSearchHistory, LocalSearchHistory, QAfterSortBy>
      thenBySearchCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'searchCount', Sort.desc);
    });
  }

  QueryBuilder<LocalSearchHistory, LocalSearchHistory, QAfterSortBy>
      thenBySearchedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'searchedAt', Sort.asc);
    });
  }

  QueryBuilder<LocalSearchHistory, LocalSearchHistory, QAfterSortBy>
      thenBySearchedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'searchedAt', Sort.desc);
    });
  }
}

extension LocalSearchHistoryQueryWhereDistinct
    on QueryBuilder<LocalSearchHistory, LocalSearchHistory, QDistinct> {
  QueryBuilder<LocalSearchHistory, LocalSearchHistory, QDistinct>
      distinctByProfileName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'profileName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalSearchHistory, LocalSearchHistory, QDistinct>
      distinctByQuery({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'query', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalSearchHistory, LocalSearchHistory, QDistinct>
      distinctBySearchCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'searchCount');
    });
  }

  QueryBuilder<LocalSearchHistory, LocalSearchHistory, QDistinct>
      distinctBySearchedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'searchedAt');
    });
  }
}

extension LocalSearchHistoryQueryProperty
    on QueryBuilder<LocalSearchHistory, LocalSearchHistory, QQueryProperty> {
  QueryBuilder<LocalSearchHistory, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<LocalSearchHistory, String, QQueryOperations>
      profileNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'profileName');
    });
  }

  QueryBuilder<LocalSearchHistory, String, QQueryOperations> queryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'query');
    });
  }

  QueryBuilder<LocalSearchHistory, int, QQueryOperations>
      searchCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'searchCount');
    });
  }

  QueryBuilder<LocalSearchHistory, DateTime?, QQueryOperations>
      searchedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'searchedAt');
    });
  }
}
