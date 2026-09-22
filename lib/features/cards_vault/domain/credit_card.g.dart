// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit_card.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCreditCardCollection on Isar {
  IsarCollection<CreditCard> get creditCards => this.collection();
}

const CreditCardSchema = CollectionSchema(
  name: r'CreditCard',
  id: 687928797046475984,
  properties: {
    r'alias': PropertySchema(
      id: 0,
      name: r'alias',
      type: IsarType.string,
    ),
    r'cutoffDay': PropertySchema(
      id: 1,
      name: r'cutoffDay',
      type: IsarType.long,
    ),
    r'paymentLimitDay': PropertySchema(
      id: 2,
      name: r'paymentLimitDay',
      type: IsarType.long,
    )
  },
  estimateSize: _creditCardEstimateSize,
  serialize: _creditCardSerialize,
  deserialize: _creditCardDeserialize,
  deserializeProp: _creditCardDeserializeProp,
  idName: r'id',
  indexes: {
    r'alias': IndexSchema(
      id: 5319372933673974885,
      name: r'alias',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'alias',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {
    r'transactions': LinkSchema(
      id: 789814051446267595,
      name: r'transactions',
      target: r'CardTransaction',
      single: false,
    ),
    r'subscriptions': LinkSchema(
      id: 7288340690836658835,
      name: r'subscriptions',
      target: r'CardSubscription',
      single: false,
    )
  },
  embeddedSchemas: {},
  getId: _creditCardGetId,
  getLinks: _creditCardGetLinks,
  attach: _creditCardAttach,
  version: '3.1.0+1',
);

int _creditCardEstimateSize(
  CreditCard object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.alias.length * 3;
  return bytesCount;
}

void _creditCardSerialize(
  CreditCard object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.alias);
  writer.writeLong(offsets[1], object.cutoffDay);
  writer.writeLong(offsets[2], object.paymentLimitDay);
}

CreditCard _creditCardDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CreditCard();
  object.alias = reader.readString(offsets[0]);
  object.cutoffDay = reader.readLong(offsets[1]);
  object.id = id;
  object.paymentLimitDay = reader.readLong(offsets[2]);
  return object;
}

P _creditCardDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _creditCardGetId(CreditCard object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _creditCardGetLinks(CreditCard object) {
  return [object.transactions, object.subscriptions];
}

void _creditCardAttach(IsarCollection<dynamic> col, Id id, CreditCard object) {
  object.id = id;
  object.transactions
      .attach(col, col.isar.collection<CardTransaction>(), r'transactions', id);
  object.subscriptions.attach(
      col, col.isar.collection<CardSubscription>(), r'subscriptions', id);
}

extension CreditCardByIndex on IsarCollection<CreditCard> {
  Future<CreditCard?> getByAlias(String alias) {
    return getByIndex(r'alias', [alias]);
  }

  CreditCard? getByAliasSync(String alias) {
    return getByIndexSync(r'alias', [alias]);
  }

  Future<bool> deleteByAlias(String alias) {
    return deleteByIndex(r'alias', [alias]);
  }

  bool deleteByAliasSync(String alias) {
    return deleteByIndexSync(r'alias', [alias]);
  }

  Future<List<CreditCard?>> getAllByAlias(List<String> aliasValues) {
    final values = aliasValues.map((e) => [e]).toList();
    return getAllByIndex(r'alias', values);
  }

  List<CreditCard?> getAllByAliasSync(List<String> aliasValues) {
    final values = aliasValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'alias', values);
  }

  Future<int> deleteAllByAlias(List<String> aliasValues) {
    final values = aliasValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'alias', values);
  }

  int deleteAllByAliasSync(List<String> aliasValues) {
    final values = aliasValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'alias', values);
  }

  Future<Id> putByAlias(CreditCard object) {
    return putByIndex(r'alias', object);
  }

  Id putByAliasSync(CreditCard object, {bool saveLinks = true}) {
    return putByIndexSync(r'alias', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByAlias(List<CreditCard> objects) {
    return putAllByIndex(r'alias', objects);
  }

  List<Id> putAllByAliasSync(List<CreditCard> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'alias', objects, saveLinks: saveLinks);
  }
}

extension CreditCardQueryWhereSort
    on QueryBuilder<CreditCard, CreditCard, QWhere> {
  QueryBuilder<CreditCard, CreditCard, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CreditCardQueryWhere
    on QueryBuilder<CreditCard, CreditCard, QWhereClause> {
  QueryBuilder<CreditCard, CreditCard, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterWhereClause> aliasEqualTo(
      String alias) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'alias',
        value: [alias],
      ));
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterWhereClause> aliasNotEqualTo(
      String alias) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'alias',
              lower: [],
              upper: [alias],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'alias',
              lower: [alias],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'alias',
              lower: [alias],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'alias',
              lower: [],
              upper: [alias],
              includeUpper: false,
            ));
      }
    });
  }
}

extension CreditCardQueryFilter
    on QueryBuilder<CreditCard, CreditCard, QFilterCondition> {
  QueryBuilder<CreditCard, CreditCard, QAfterFilterCondition> aliasEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'alias',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterFilterCondition> aliasGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'alias',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterFilterCondition> aliasLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'alias',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterFilterCondition> aliasBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'alias',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterFilterCondition> aliasStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'alias',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterFilterCondition> aliasEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'alias',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterFilterCondition> aliasContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'alias',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterFilterCondition> aliasMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'alias',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterFilterCondition> aliasIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'alias',
        value: '',
      ));
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterFilterCondition>
      aliasIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'alias',
        value: '',
      ));
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterFilterCondition> cutoffDayEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cutoffDay',
        value: value,
      ));
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterFilterCondition>
      cutoffDayGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cutoffDay',
        value: value,
      ));
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterFilterCondition> cutoffDayLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cutoffDay',
        value: value,
      ));
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterFilterCondition> cutoffDayBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cutoffDay',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterFilterCondition>
      paymentLimitDayEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'paymentLimitDay',
        value: value,
      ));
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterFilterCondition>
      paymentLimitDayGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'paymentLimitDay',
        value: value,
      ));
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterFilterCondition>
      paymentLimitDayLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'paymentLimitDay',
        value: value,
      ));
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterFilterCondition>
      paymentLimitDayBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'paymentLimitDay',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension CreditCardQueryObject
    on QueryBuilder<CreditCard, CreditCard, QFilterCondition> {}

extension CreditCardQueryLinks
    on QueryBuilder<CreditCard, CreditCard, QFilterCondition> {
  QueryBuilder<CreditCard, CreditCard, QAfterFilterCondition> transactions(
      FilterQuery<CardTransaction> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'transactions');
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterFilterCondition>
      transactionsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'transactions', length, true, length, true);
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterFilterCondition>
      transactionsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'transactions', 0, true, 0, true);
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterFilterCondition>
      transactionsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'transactions', 0, false, 999999, true);
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterFilterCondition>
      transactionsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'transactions', 0, true, length, include);
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterFilterCondition>
      transactionsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'transactions', length, include, 999999, true);
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterFilterCondition>
      transactionsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'transactions', lower, includeLower, upper, includeUpper);
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterFilterCondition> subscriptions(
      FilterQuery<CardSubscription> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'subscriptions');
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterFilterCondition>
      subscriptionsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'subscriptions', length, true, length, true);
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterFilterCondition>
      subscriptionsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'subscriptions', 0, true, 0, true);
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterFilterCondition>
      subscriptionsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'subscriptions', 0, false, 999999, true);
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterFilterCondition>
      subscriptionsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'subscriptions', 0, true, length, include);
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterFilterCondition>
      subscriptionsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'subscriptions', length, include, 999999, true);
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterFilterCondition>
      subscriptionsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'subscriptions', lower, includeLower, upper, includeUpper);
    });
  }
}

extension CreditCardQuerySortBy
    on QueryBuilder<CreditCard, CreditCard, QSortBy> {
  QueryBuilder<CreditCard, CreditCard, QAfterSortBy> sortByAlias() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alias', Sort.asc);
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterSortBy> sortByAliasDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alias', Sort.desc);
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterSortBy> sortByCutoffDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cutoffDay', Sort.asc);
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterSortBy> sortByCutoffDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cutoffDay', Sort.desc);
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterSortBy> sortByPaymentLimitDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentLimitDay', Sort.asc);
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterSortBy>
      sortByPaymentLimitDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentLimitDay', Sort.desc);
    });
  }
}

extension CreditCardQuerySortThenBy
    on QueryBuilder<CreditCard, CreditCard, QSortThenBy> {
  QueryBuilder<CreditCard, CreditCard, QAfterSortBy> thenByAlias() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alias', Sort.asc);
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterSortBy> thenByAliasDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alias', Sort.desc);
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterSortBy> thenByCutoffDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cutoffDay', Sort.asc);
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterSortBy> thenByCutoffDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cutoffDay', Sort.desc);
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterSortBy> thenByPaymentLimitDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentLimitDay', Sort.asc);
    });
  }

  QueryBuilder<CreditCard, CreditCard, QAfterSortBy>
      thenByPaymentLimitDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentLimitDay', Sort.desc);
    });
  }
}

extension CreditCardQueryWhereDistinct
    on QueryBuilder<CreditCard, CreditCard, QDistinct> {
  QueryBuilder<CreditCard, CreditCard, QDistinct> distinctByAlias(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'alias', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CreditCard, CreditCard, QDistinct> distinctByCutoffDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cutoffDay');
    });
  }

  QueryBuilder<CreditCard, CreditCard, QDistinct> distinctByPaymentLimitDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'paymentLimitDay');
    });
  }
}

extension CreditCardQueryProperty
    on QueryBuilder<CreditCard, CreditCard, QQueryProperty> {
  QueryBuilder<CreditCard, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CreditCard, String, QQueryOperations> aliasProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'alias');
    });
  }

  QueryBuilder<CreditCard, int, QQueryOperations> cutoffDayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cutoffDay');
    });
  }

  QueryBuilder<CreditCard, int, QQueryOperations> paymentLimitDayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'paymentLimitDay');
    });
  }
}
