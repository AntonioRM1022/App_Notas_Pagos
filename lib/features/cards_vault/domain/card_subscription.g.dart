// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_subscription.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCardSubscriptionCollection on Isar {
  IsarCollection<CardSubscription> get cardSubscriptions => this.collection();
}

const CardSubscriptionSchema = CollectionSchema(
  name: r'CardSubscription',
  id: -923600599021697952,
  properties: {
    r'amount': PropertySchema(
      id: 0,
      name: r'amount',
      type: IsarType.double,
    ),
    r'billingDay': PropertySchema(
      id: 1,
      name: r'billingDay',
      type: IsarType.long,
    ),
    r'isActive': PropertySchema(
      id: 2,
      name: r'isActive',
      type: IsarType.bool,
    ),
    r'isDeleted': PropertySchema(
      id: 3,
      name: r'isDeleted',
      type: IsarType.bool,
    ),
    r'lastProcessedDate': PropertySchema(
      id: 4,
      name: r'lastProcessedDate',
      type: IsarType.dateTime,
    ),
    r'serviceName': PropertySchema(
      id: 5,
      name: r'serviceName',
      type: IsarType.string,
    )
  },
  estimateSize: _cardSubscriptionEstimateSize,
  serialize: _cardSubscriptionSerialize,
  deserialize: _cardSubscriptionDeserialize,
  deserializeProp: _cardSubscriptionDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'card': LinkSchema(
      id: 327609553631981602,
      name: r'card',
      target: r'CreditCard',
      single: true,
      linkName: r'subscriptions',
    )
  },
  embeddedSchemas: {},
  getId: _cardSubscriptionGetId,
  getLinks: _cardSubscriptionGetLinks,
  attach: _cardSubscriptionAttach,
  version: '3.1.0+1',
);

int _cardSubscriptionEstimateSize(
  CardSubscription object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.serviceName.length * 3;
  return bytesCount;
}

void _cardSubscriptionSerialize(
  CardSubscription object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.amount);
  writer.writeLong(offsets[1], object.billingDay);
  writer.writeBool(offsets[2], object.isActive);
  writer.writeBool(offsets[3], object.isDeleted);
  writer.writeDateTime(offsets[4], object.lastProcessedDate);
  writer.writeString(offsets[5], object.serviceName);
}

CardSubscription _cardSubscriptionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CardSubscription();
  object.amount = reader.readDouble(offsets[0]);
  object.billingDay = reader.readLong(offsets[1]);
  object.id = id;
  object.isActive = reader.readBool(offsets[2]);
  object.isDeleted = reader.readBool(offsets[3]);
  object.lastProcessedDate = reader.readDateTimeOrNull(offsets[4]);
  object.serviceName = reader.readString(offsets[5]);
  return object;
}

P _cardSubscriptionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _cardSubscriptionGetId(CardSubscription object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _cardSubscriptionGetLinks(CardSubscription object) {
  return [object.card];
}

void _cardSubscriptionAttach(
    IsarCollection<dynamic> col, Id id, CardSubscription object) {
  object.id = id;
  object.card.attach(col, col.isar.collection<CreditCard>(), r'card', id);
}

extension CardSubscriptionQueryWhereSort
    on QueryBuilder<CardSubscription, CardSubscription, QWhere> {
  QueryBuilder<CardSubscription, CardSubscription, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CardSubscriptionQueryWhere
    on QueryBuilder<CardSubscription, CardSubscription, QWhereClause> {
  QueryBuilder<CardSubscription, CardSubscription, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<CardSubscription, CardSubscription, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<CardSubscription, CardSubscription, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CardSubscription, CardSubscription, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CardSubscription, CardSubscription, QAfterWhereClause> idBetween(
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
}

extension CardSubscriptionQueryFilter
    on QueryBuilder<CardSubscription, CardSubscription, QFilterCondition> {
  QueryBuilder<CardSubscription, CardSubscription, QAfterFilterCondition>
      amountEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'amount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CardSubscription, CardSubscription, QAfterFilterCondition>
      amountGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'amount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CardSubscription, CardSubscription, QAfterFilterCondition>
      amountLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'amount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CardSubscription, CardSubscription, QAfterFilterCondition>
      amountBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'amount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CardSubscription, CardSubscription, QAfterFilterCondition>
      billingDayEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'billingDay',
        value: value,
      ));
    });
  }

  QueryBuilder<CardSubscription, CardSubscription, QAfterFilterCondition>
      billingDayGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'billingDay',
        value: value,
      ));
    });
  }

  QueryBuilder<CardSubscription, CardSubscription, QAfterFilterCondition>
      billingDayLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'billingDay',
        value: value,
      ));
    });
  }

  QueryBuilder<CardSubscription, CardSubscription, QAfterFilterCondition>
      billingDayBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'billingDay',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CardSubscription, CardSubscription, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CardSubscription, CardSubscription, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<CardSubscription, CardSubscription, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<CardSubscription, CardSubscription, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<CardSubscription, CardSubscription, QAfterFilterCondition>
      isActiveEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isActive',
        value: value,
      ));
    });
  }

  QueryBuilder<CardSubscription, CardSubscription, QAfterFilterCondition>
      isDeletedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isDeleted',
        value: value,
      ));
    });
  }

  QueryBuilder<CardSubscription, CardSubscription, QAfterFilterCondition>
      lastProcessedDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastProcessedDate',
      ));
    });
  }

  QueryBuilder<CardSubscription, CardSubscription, QAfterFilterCondition>
      lastProcessedDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastProcessedDate',
      ));
    });
  }

  QueryBuilder<CardSubscription, CardSubscription, QAfterFilterCondition>
      lastProcessedDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastProcessedDate',
        value: value,
      ));
    });
  }

  QueryBuilder<CardSubscription, CardSubscription, QAfterFilterCondition>
      lastProcessedDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastProcessedDate',
        value: value,
      ));
    });
  }

  QueryBuilder<CardSubscription, CardSubscription, QAfterFilterCondition>
      lastProcessedDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastProcessedDate',
        value: value,
      ));
    });
  }

  QueryBuilder<CardSubscription, CardSubscription, QAfterFilterCondition>
      lastProcessedDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastProcessedDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CardSubscription, CardSubscription, QAfterFilterCondition>
      serviceNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'serviceName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardSubscription, CardSubscription, QAfterFilterCondition>
      serviceNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'serviceName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardSubscription, CardSubscription, QAfterFilterCondition>
      serviceNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'serviceName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardSubscription, CardSubscription, QAfterFilterCondition>
      serviceNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'serviceName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardSubscription, CardSubscription, QAfterFilterCondition>
      serviceNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'serviceName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardSubscription, CardSubscription, QAfterFilterCondition>
      serviceNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'serviceName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardSubscription, CardSubscription, QAfterFilterCondition>
      serviceNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'serviceName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardSubscription, CardSubscription, QAfterFilterCondition>
      serviceNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'serviceName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardSubscription, CardSubscription, QAfterFilterCondition>
      serviceNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'serviceName',
        value: '',
      ));
    });
  }

  QueryBuilder<CardSubscription, CardSubscription, QAfterFilterCondition>
      serviceNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'serviceName',
        value: '',
      ));
    });
  }
}

extension CardSubscriptionQueryObject
    on QueryBuilder<CardSubscription, CardSubscription, QFilterCondition> {}

extension CardSubscriptionQueryLinks
    on QueryBuilder<CardSubscription, CardSubscription, QFilterCondition> {
  QueryBuilder<CardSubscription, CardSubscription, QAfterFilterCondition> card(
      FilterQuery<CreditCard> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'card');
    });
  }

  QueryBuilder<CardSubscription, CardSubscription, QAfterFilterCondition>
      cardIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'card', 0, true, 0, true);
    });
  }
}

extension CardSubscriptionQuerySortBy
    on QueryBuilder<CardSubscription, CardSubscription, QSortBy> {
  QueryBuilder<CardSubscription, CardSubscription, QAfterSortBy>
      sortByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<CardSubscription, CardSubscription, QAfterSortBy>
      sortByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<CardSubscription, CardSubscription, QAfterSortBy>
      sortByBillingDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'billingDay', Sort.asc);
    });
  }

  QueryBuilder<CardSubscription, CardSubscription, QAfterSortBy>
      sortByBillingDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'billingDay', Sort.desc);
    });
  }

  QueryBuilder<CardSubscription, CardSubscription, QAfterSortBy>
      sortByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<CardSubscription, CardSubscription, QAfterSortBy>
      sortByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<CardSubscription, CardSubscription, QAfterSortBy>
      sortByIsDeleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDeleted', Sort.asc);
    });
  }

  QueryBuilder<CardSubscription, CardSubscription, QAfterSortBy>
      sortByIsDeletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDeleted', Sort.desc);
    });
  }

  QueryBuilder<CardSubscription, CardSubscription, QAfterSortBy>
      sortByLastProcessedDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastProcessedDate', Sort.asc);
    });
  }

  QueryBuilder<CardSubscription, CardSubscription, QAfterSortBy>
      sortByLastProcessedDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastProcessedDate', Sort.desc);
    });
  }

  QueryBuilder<CardSubscription, CardSubscription, QAfterSortBy>
      sortByServiceName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serviceName', Sort.asc);
    });
  }

  QueryBuilder<CardSubscription, CardSubscription, QAfterSortBy>
      sortByServiceNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serviceName', Sort.desc);
    });
  }
}

extension CardSubscriptionQuerySortThenBy
    on QueryBuilder<CardSubscription, CardSubscription, QSortThenBy> {
  QueryBuilder<CardSubscription, CardSubscription, QAfterSortBy>
      thenByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<CardSubscription, CardSubscription, QAfterSortBy>
      thenByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<CardSubscription, CardSubscription, QAfterSortBy>
      thenByBillingDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'billingDay', Sort.asc);
    });
  }

  QueryBuilder<CardSubscription, CardSubscription, QAfterSortBy>
      thenByBillingDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'billingDay', Sort.desc);
    });
  }

  QueryBuilder<CardSubscription, CardSubscription, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CardSubscription, CardSubscription, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CardSubscription, CardSubscription, QAfterSortBy>
      thenByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<CardSubscription, CardSubscription, QAfterSortBy>
      thenByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<CardSubscription, CardSubscription, QAfterSortBy>
      thenByIsDeleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDeleted', Sort.asc);
    });
  }

  QueryBuilder<CardSubscription, CardSubscription, QAfterSortBy>
      thenByIsDeletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDeleted', Sort.desc);
    });
  }

  QueryBuilder<CardSubscription, CardSubscription, QAfterSortBy>
      thenByLastProcessedDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastProcessedDate', Sort.asc);
    });
  }

  QueryBuilder<CardSubscription, CardSubscription, QAfterSortBy>
      thenByLastProcessedDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastProcessedDate', Sort.desc);
    });
  }

  QueryBuilder<CardSubscription, CardSubscription, QAfterSortBy>
      thenByServiceName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serviceName', Sort.asc);
    });
  }

  QueryBuilder<CardSubscription, CardSubscription, QAfterSortBy>
      thenByServiceNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serviceName', Sort.desc);
    });
  }
}

extension CardSubscriptionQueryWhereDistinct
    on QueryBuilder<CardSubscription, CardSubscription, QDistinct> {
  QueryBuilder<CardSubscription, CardSubscription, QDistinct>
      distinctByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amount');
    });
  }

  QueryBuilder<CardSubscription, CardSubscription, QDistinct>
      distinctByBillingDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'billingDay');
    });
  }

  QueryBuilder<CardSubscription, CardSubscription, QDistinct>
      distinctByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isActive');
    });
  }

  QueryBuilder<CardSubscription, CardSubscription, QDistinct>
      distinctByIsDeleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isDeleted');
    });
  }

  QueryBuilder<CardSubscription, CardSubscription, QDistinct>
      distinctByLastProcessedDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastProcessedDate');
    });
  }

  QueryBuilder<CardSubscription, CardSubscription, QDistinct>
      distinctByServiceName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'serviceName', caseSensitive: caseSensitive);
    });
  }
}

extension CardSubscriptionQueryProperty
    on QueryBuilder<CardSubscription, CardSubscription, QQueryProperty> {
  QueryBuilder<CardSubscription, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CardSubscription, double, QQueryOperations> amountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amount');
    });
  }

  QueryBuilder<CardSubscription, int, QQueryOperations> billingDayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'billingDay');
    });
  }

  QueryBuilder<CardSubscription, bool, QQueryOperations> isActiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isActive');
    });
  }

  QueryBuilder<CardSubscription, bool, QQueryOperations> isDeletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isDeleted');
    });
  }

  QueryBuilder<CardSubscription, DateTime?, QQueryOperations>
      lastProcessedDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastProcessedDate');
    });
  }

  QueryBuilder<CardSubscription, String, QQueryOperations>
      serviceNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'serviceName');
    });
  }
}
