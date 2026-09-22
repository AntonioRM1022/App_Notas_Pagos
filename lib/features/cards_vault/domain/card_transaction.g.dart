// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_transaction.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCardTransactionCollection on Isar {
  IsarCollection<CardTransaction> get cardTransactions => this.collection();
}

const CardTransactionSchema = CollectionSchema(
  name: r'CardTransaction',
  id: 7526698676185230725,
  properties: {
    r'amount': PropertySchema(
      id: 0,
      name: r'amount',
      type: IsarType.double,
    ),
    r'concept': PropertySchema(
      id: 1,
      name: r'concept',
      type: IsarType.string,
    ),
    r'date': PropertySchema(
      id: 2,
      name: r'date',
      type: IsarType.dateTime,
    ),
    r'deferredCycles': PropertySchema(
      id: 3,
      name: r'deferredCycles',
      type: IsarType.long,
    ),
    r'installments': PropertySchema(
      id: 4,
      name: r'installments',
      type: IsarType.long,
    ),
    r'isDeleted': PropertySchema(
      id: 5,
      name: r'isDeleted',
      type: IsarType.bool,
    ),
    r'type': PropertySchema(
      id: 6,
      name: r'type',
      type: IsarType.string,
      enumMap: _CardTransactiontypeEnumValueMap,
    )
  },
  estimateSize: _cardTransactionEstimateSize,
  serialize: _cardTransactionSerialize,
  deserialize: _cardTransactionDeserialize,
  deserializeProp: _cardTransactionDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'card': LinkSchema(
      id: -9067577025407551221,
      name: r'card',
      target: r'CreditCard',
      single: true,
      linkName: r'transactions',
    )
  },
  embeddedSchemas: {},
  getId: _cardTransactionGetId,
  getLinks: _cardTransactionGetLinks,
  attach: _cardTransactionAttach,
  version: '3.1.0+1',
);

int _cardTransactionEstimateSize(
  CardTransaction object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.concept.length * 3;
  bytesCount += 3 + object.type.name.length * 3;
  return bytesCount;
}

void _cardTransactionSerialize(
  CardTransaction object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.amount);
  writer.writeString(offsets[1], object.concept);
  writer.writeDateTime(offsets[2], object.date);
  writer.writeLong(offsets[3], object.deferredCycles);
  writer.writeLong(offsets[4], object.installments);
  writer.writeBool(offsets[5], object.isDeleted);
  writer.writeString(offsets[6], object.type.name);
}

CardTransaction _cardTransactionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CardTransaction();
  object.amount = reader.readDouble(offsets[0]);
  object.concept = reader.readString(offsets[1]);
  object.date = reader.readDateTime(offsets[2]);
  object.deferredCycles = reader.readLong(offsets[3]);
  object.id = id;
  object.installments = reader.readLong(offsets[4]);
  object.isDeleted = reader.readBool(offsets[5]);
  object.type =
      _CardTransactiontypeValueEnumMap[reader.readStringOrNull(offsets[6])] ??
          TransactionType.purchase;
  return object;
}

P _cardTransactionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (_CardTransactiontypeValueEnumMap[
              reader.readStringOrNull(offset)] ??
          TransactionType.purchase) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _CardTransactiontypeEnumValueMap = {
  r'purchase': r'purchase',
  r'payment': r'payment',
  r'subscriptionCharge': r'subscriptionCharge',
};
const _CardTransactiontypeValueEnumMap = {
  r'purchase': TransactionType.purchase,
  r'payment': TransactionType.payment,
  r'subscriptionCharge': TransactionType.subscriptionCharge,
};

Id _cardTransactionGetId(CardTransaction object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _cardTransactionGetLinks(CardTransaction object) {
  return [object.card];
}

void _cardTransactionAttach(
    IsarCollection<dynamic> col, Id id, CardTransaction object) {
  object.id = id;
  object.card.attach(col, col.isar.collection<CreditCard>(), r'card', id);
}

extension CardTransactionQueryWhereSort
    on QueryBuilder<CardTransaction, CardTransaction, QWhere> {
  QueryBuilder<CardTransaction, CardTransaction, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CardTransactionQueryWhere
    on QueryBuilder<CardTransaction, CardTransaction, QWhereClause> {
  QueryBuilder<CardTransaction, CardTransaction, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<CardTransaction, CardTransaction, QAfterWhereClause>
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

  QueryBuilder<CardTransaction, CardTransaction, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CardTransaction, CardTransaction, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CardTransaction, CardTransaction, QAfterWhereClause> idBetween(
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

extension CardTransactionQueryFilter
    on QueryBuilder<CardTransaction, CardTransaction, QFilterCondition> {
  QueryBuilder<CardTransaction, CardTransaction, QAfterFilterCondition>
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

  QueryBuilder<CardTransaction, CardTransaction, QAfterFilterCondition>
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

  QueryBuilder<CardTransaction, CardTransaction, QAfterFilterCondition>
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

  QueryBuilder<CardTransaction, CardTransaction, QAfterFilterCondition>
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

  QueryBuilder<CardTransaction, CardTransaction, QAfterFilterCondition>
      conceptEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'concept',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardTransaction, CardTransaction, QAfterFilterCondition>
      conceptGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'concept',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardTransaction, CardTransaction, QAfterFilterCondition>
      conceptLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'concept',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardTransaction, CardTransaction, QAfterFilterCondition>
      conceptBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'concept',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardTransaction, CardTransaction, QAfterFilterCondition>
      conceptStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'concept',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardTransaction, CardTransaction, QAfterFilterCondition>
      conceptEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'concept',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardTransaction, CardTransaction, QAfterFilterCondition>
      conceptContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'concept',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardTransaction, CardTransaction, QAfterFilterCondition>
      conceptMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'concept',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardTransaction, CardTransaction, QAfterFilterCondition>
      conceptIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'concept',
        value: '',
      ));
    });
  }

  QueryBuilder<CardTransaction, CardTransaction, QAfterFilterCondition>
      conceptIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'concept',
        value: '',
      ));
    });
  }

  QueryBuilder<CardTransaction, CardTransaction, QAfterFilterCondition>
      dateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<CardTransaction, CardTransaction, QAfterFilterCondition>
      dateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<CardTransaction, CardTransaction, QAfterFilterCondition>
      dateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<CardTransaction, CardTransaction, QAfterFilterCondition>
      dateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'date',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CardTransaction, CardTransaction, QAfterFilterCondition>
      deferredCyclesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deferredCycles',
        value: value,
      ));
    });
  }

  QueryBuilder<CardTransaction, CardTransaction, QAfterFilterCondition>
      deferredCyclesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'deferredCycles',
        value: value,
      ));
    });
  }

  QueryBuilder<CardTransaction, CardTransaction, QAfterFilterCondition>
      deferredCyclesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'deferredCycles',
        value: value,
      ));
    });
  }

  QueryBuilder<CardTransaction, CardTransaction, QAfterFilterCondition>
      deferredCyclesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'deferredCycles',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CardTransaction, CardTransaction, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CardTransaction, CardTransaction, QAfterFilterCondition>
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

  QueryBuilder<CardTransaction, CardTransaction, QAfterFilterCondition>
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

  QueryBuilder<CardTransaction, CardTransaction, QAfterFilterCondition>
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

  QueryBuilder<CardTransaction, CardTransaction, QAfterFilterCondition>
      installmentsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'installments',
        value: value,
      ));
    });
  }

  QueryBuilder<CardTransaction, CardTransaction, QAfterFilterCondition>
      installmentsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'installments',
        value: value,
      ));
    });
  }

  QueryBuilder<CardTransaction, CardTransaction, QAfterFilterCondition>
      installmentsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'installments',
        value: value,
      ));
    });
  }

  QueryBuilder<CardTransaction, CardTransaction, QAfterFilterCondition>
      installmentsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'installments',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CardTransaction, CardTransaction, QAfterFilterCondition>
      isDeletedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isDeleted',
        value: value,
      ));
    });
  }

  QueryBuilder<CardTransaction, CardTransaction, QAfterFilterCondition>
      typeEqualTo(
    TransactionType value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardTransaction, CardTransaction, QAfterFilterCondition>
      typeGreaterThan(
    TransactionType value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardTransaction, CardTransaction, QAfterFilterCondition>
      typeLessThan(
    TransactionType value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardTransaction, CardTransaction, QAfterFilterCondition>
      typeBetween(
    TransactionType lower,
    TransactionType upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardTransaction, CardTransaction, QAfterFilterCondition>
      typeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardTransaction, CardTransaction, QAfterFilterCondition>
      typeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardTransaction, CardTransaction, QAfterFilterCondition>
      typeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardTransaction, CardTransaction, QAfterFilterCondition>
      typeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'type',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardTransaction, CardTransaction, QAfterFilterCondition>
      typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<CardTransaction, CardTransaction, QAfterFilterCondition>
      typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'type',
        value: '',
      ));
    });
  }
}

extension CardTransactionQueryObject
    on QueryBuilder<CardTransaction, CardTransaction, QFilterCondition> {}

extension CardTransactionQueryLinks
    on QueryBuilder<CardTransaction, CardTransaction, QFilterCondition> {
  QueryBuilder<CardTransaction, CardTransaction, QAfterFilterCondition> card(
      FilterQuery<CreditCard> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'card');
    });
  }

  QueryBuilder<CardTransaction, CardTransaction, QAfterFilterCondition>
      cardIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'card', 0, true, 0, true);
    });
  }
}

extension CardTransactionQuerySortBy
    on QueryBuilder<CardTransaction, CardTransaction, QSortBy> {
  QueryBuilder<CardTransaction, CardTransaction, QAfterSortBy> sortByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<CardTransaction, CardTransaction, QAfterSortBy>
      sortByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<CardTransaction, CardTransaction, QAfterSortBy> sortByConcept() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'concept', Sort.asc);
    });
  }

  QueryBuilder<CardTransaction, CardTransaction, QAfterSortBy>
      sortByConceptDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'concept', Sort.desc);
    });
  }

  QueryBuilder<CardTransaction, CardTransaction, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<CardTransaction, CardTransaction, QAfterSortBy>
      sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<CardTransaction, CardTransaction, QAfterSortBy>
      sortByDeferredCycles() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deferredCycles', Sort.asc);
    });
  }

  QueryBuilder<CardTransaction, CardTransaction, QAfterSortBy>
      sortByDeferredCyclesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deferredCycles', Sort.desc);
    });
  }

  QueryBuilder<CardTransaction, CardTransaction, QAfterSortBy>
      sortByInstallments() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'installments', Sort.asc);
    });
  }

  QueryBuilder<CardTransaction, CardTransaction, QAfterSortBy>
      sortByInstallmentsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'installments', Sort.desc);
    });
  }

  QueryBuilder<CardTransaction, CardTransaction, QAfterSortBy>
      sortByIsDeleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDeleted', Sort.asc);
    });
  }

  QueryBuilder<CardTransaction, CardTransaction, QAfterSortBy>
      sortByIsDeletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDeleted', Sort.desc);
    });
  }

  QueryBuilder<CardTransaction, CardTransaction, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<CardTransaction, CardTransaction, QAfterSortBy>
      sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension CardTransactionQuerySortThenBy
    on QueryBuilder<CardTransaction, CardTransaction, QSortThenBy> {
  QueryBuilder<CardTransaction, CardTransaction, QAfterSortBy> thenByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<CardTransaction, CardTransaction, QAfterSortBy>
      thenByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<CardTransaction, CardTransaction, QAfterSortBy> thenByConcept() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'concept', Sort.asc);
    });
  }

  QueryBuilder<CardTransaction, CardTransaction, QAfterSortBy>
      thenByConceptDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'concept', Sort.desc);
    });
  }

  QueryBuilder<CardTransaction, CardTransaction, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<CardTransaction, CardTransaction, QAfterSortBy>
      thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<CardTransaction, CardTransaction, QAfterSortBy>
      thenByDeferredCycles() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deferredCycles', Sort.asc);
    });
  }

  QueryBuilder<CardTransaction, CardTransaction, QAfterSortBy>
      thenByDeferredCyclesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deferredCycles', Sort.desc);
    });
  }

  QueryBuilder<CardTransaction, CardTransaction, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CardTransaction, CardTransaction, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CardTransaction, CardTransaction, QAfterSortBy>
      thenByInstallments() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'installments', Sort.asc);
    });
  }

  QueryBuilder<CardTransaction, CardTransaction, QAfterSortBy>
      thenByInstallmentsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'installments', Sort.desc);
    });
  }

  QueryBuilder<CardTransaction, CardTransaction, QAfterSortBy>
      thenByIsDeleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDeleted', Sort.asc);
    });
  }

  QueryBuilder<CardTransaction, CardTransaction, QAfterSortBy>
      thenByIsDeletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDeleted', Sort.desc);
    });
  }

  QueryBuilder<CardTransaction, CardTransaction, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<CardTransaction, CardTransaction, QAfterSortBy>
      thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension CardTransactionQueryWhereDistinct
    on QueryBuilder<CardTransaction, CardTransaction, QDistinct> {
  QueryBuilder<CardTransaction, CardTransaction, QDistinct> distinctByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amount');
    });
  }

  QueryBuilder<CardTransaction, CardTransaction, QDistinct> distinctByConcept(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'concept', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CardTransaction, CardTransaction, QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<CardTransaction, CardTransaction, QDistinct>
      distinctByDeferredCycles() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deferredCycles');
    });
  }

  QueryBuilder<CardTransaction, CardTransaction, QDistinct>
      distinctByInstallments() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'installments');
    });
  }

  QueryBuilder<CardTransaction, CardTransaction, QDistinct>
      distinctByIsDeleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isDeleted');
    });
  }

  QueryBuilder<CardTransaction, CardTransaction, QDistinct> distinctByType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type', caseSensitive: caseSensitive);
    });
  }
}

extension CardTransactionQueryProperty
    on QueryBuilder<CardTransaction, CardTransaction, QQueryProperty> {
  QueryBuilder<CardTransaction, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CardTransaction, double, QQueryOperations> amountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amount');
    });
  }

  QueryBuilder<CardTransaction, String, QQueryOperations> conceptProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'concept');
    });
  }

  QueryBuilder<CardTransaction, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<CardTransaction, int, QQueryOperations>
      deferredCyclesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deferredCycles');
    });
  }

  QueryBuilder<CardTransaction, int, QQueryOperations> installmentsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'installments');
    });
  }

  QueryBuilder<CardTransaction, bool, QQueryOperations> isDeletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isDeleted');
    });
  }

  QueryBuilder<CardTransaction, TransactionType, QQueryOperations>
      typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }
}
