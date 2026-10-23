// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_profile.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetBudgetProfileCollection on Isar {
  IsarCollection<BudgetProfile> get budgetProfiles => this.collection();
}

const BudgetProfileSchema = CollectionSchema(
  name: r'BudgetProfile',
  id: -2685555096098057569,
  properties: {
    r'biweeklyIncome': PropertySchema(
      id: 0,
      name: r'biweeklyIncome',
      type: IsarType.double,
    ),
    r'fixedExpenses': PropertySchema(
      id: 1,
      name: r'fixedExpenses',
      type: IsarType.double,
    ),
    r'lastUpdated': PropertySchema(
      id: 2,
      name: r'lastUpdated',
      type: IsarType.dateTime,
    ),
    r'targetSavingsPerQuincena': PropertySchema(
      id: 3,
      name: r'targetSavingsPerQuincena',
      type: IsarType.double,
    )
  },
  estimateSize: _budgetProfileEstimateSize,
  serialize: _budgetProfileSerialize,
  deserialize: _budgetProfileDeserialize,
  deserializeProp: _budgetProfileDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _budgetProfileGetId,
  getLinks: _budgetProfileGetLinks,
  attach: _budgetProfileAttach,
  version: '3.1.0+1',
);

int _budgetProfileEstimateSize(
  BudgetProfile object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _budgetProfileSerialize(
  BudgetProfile object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.biweeklyIncome);
  writer.writeDouble(offsets[1], object.fixedExpenses);
  writer.writeDateTime(offsets[2], object.lastUpdated);
  writer.writeDouble(offsets[3], object.targetSavingsPerQuincena);
}

BudgetProfile _budgetProfileDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = BudgetProfile();
  object.biweeklyIncome = reader.readDouble(offsets[0]);
  object.fixedExpenses = reader.readDouble(offsets[1]);
  object.id = id;
  object.lastUpdated = reader.readDateTimeOrNull(offsets[2]);
  object.targetSavingsPerQuincena = reader.readDouble(offsets[3]);
  return object;
}

P _budgetProfileDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 3:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _budgetProfileGetId(BudgetProfile object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _budgetProfileGetLinks(BudgetProfile object) {
  return [];
}

void _budgetProfileAttach(
    IsarCollection<dynamic> col, Id id, BudgetProfile object) {
  object.id = id;
}

extension BudgetProfileQueryWhereSort
    on QueryBuilder<BudgetProfile, BudgetProfile, QWhere> {
  QueryBuilder<BudgetProfile, BudgetProfile, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension BudgetProfileQueryWhere
    on QueryBuilder<BudgetProfile, BudgetProfile, QWhereClause> {
  QueryBuilder<BudgetProfile, BudgetProfile, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<BudgetProfile, BudgetProfile, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<BudgetProfile, BudgetProfile, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<BudgetProfile, BudgetProfile, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<BudgetProfile, BudgetProfile, QAfterWhereClause> idBetween(
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

extension BudgetProfileQueryFilter
    on QueryBuilder<BudgetProfile, BudgetProfile, QFilterCondition> {
  QueryBuilder<BudgetProfile, BudgetProfile, QAfterFilterCondition>
      biweeklyIncomeEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'biweeklyIncome',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BudgetProfile, BudgetProfile, QAfterFilterCondition>
      biweeklyIncomeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'biweeklyIncome',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BudgetProfile, BudgetProfile, QAfterFilterCondition>
      biweeklyIncomeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'biweeklyIncome',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BudgetProfile, BudgetProfile, QAfterFilterCondition>
      biweeklyIncomeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'biweeklyIncome',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BudgetProfile, BudgetProfile, QAfterFilterCondition>
      fixedExpensesEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fixedExpenses',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BudgetProfile, BudgetProfile, QAfterFilterCondition>
      fixedExpensesGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fixedExpenses',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BudgetProfile, BudgetProfile, QAfterFilterCondition>
      fixedExpensesLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fixedExpenses',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BudgetProfile, BudgetProfile, QAfterFilterCondition>
      fixedExpensesBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fixedExpenses',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BudgetProfile, BudgetProfile, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<BudgetProfile, BudgetProfile, QAfterFilterCondition>
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

  QueryBuilder<BudgetProfile, BudgetProfile, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<BudgetProfile, BudgetProfile, QAfterFilterCondition> idBetween(
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

  QueryBuilder<BudgetProfile, BudgetProfile, QAfterFilterCondition>
      lastUpdatedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastUpdated',
      ));
    });
  }

  QueryBuilder<BudgetProfile, BudgetProfile, QAfterFilterCondition>
      lastUpdatedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastUpdated',
      ));
    });
  }

  QueryBuilder<BudgetProfile, BudgetProfile, QAfterFilterCondition>
      lastUpdatedEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastUpdated',
        value: value,
      ));
    });
  }

  QueryBuilder<BudgetProfile, BudgetProfile, QAfterFilterCondition>
      lastUpdatedGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastUpdated',
        value: value,
      ));
    });
  }

  QueryBuilder<BudgetProfile, BudgetProfile, QAfterFilterCondition>
      lastUpdatedLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastUpdated',
        value: value,
      ));
    });
  }

  QueryBuilder<BudgetProfile, BudgetProfile, QAfterFilterCondition>
      lastUpdatedBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastUpdated',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BudgetProfile, BudgetProfile, QAfterFilterCondition>
      targetSavingsPerQuincenaEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'targetSavingsPerQuincena',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BudgetProfile, BudgetProfile, QAfterFilterCondition>
      targetSavingsPerQuincenaGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'targetSavingsPerQuincena',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BudgetProfile, BudgetProfile, QAfterFilterCondition>
      targetSavingsPerQuincenaLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'targetSavingsPerQuincena',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BudgetProfile, BudgetProfile, QAfterFilterCondition>
      targetSavingsPerQuincenaBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'targetSavingsPerQuincena',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension BudgetProfileQueryObject
    on QueryBuilder<BudgetProfile, BudgetProfile, QFilterCondition> {}

extension BudgetProfileQueryLinks
    on QueryBuilder<BudgetProfile, BudgetProfile, QFilterCondition> {}

extension BudgetProfileQuerySortBy
    on QueryBuilder<BudgetProfile, BudgetProfile, QSortBy> {
  QueryBuilder<BudgetProfile, BudgetProfile, QAfterSortBy>
      sortByBiweeklyIncome() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'biweeklyIncome', Sort.asc);
    });
  }

  QueryBuilder<BudgetProfile, BudgetProfile, QAfterSortBy>
      sortByBiweeklyIncomeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'biweeklyIncome', Sort.desc);
    });
  }

  QueryBuilder<BudgetProfile, BudgetProfile, QAfterSortBy>
      sortByFixedExpenses() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fixedExpenses', Sort.asc);
    });
  }

  QueryBuilder<BudgetProfile, BudgetProfile, QAfterSortBy>
      sortByFixedExpensesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fixedExpenses', Sort.desc);
    });
  }

  QueryBuilder<BudgetProfile, BudgetProfile, QAfterSortBy> sortByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.asc);
    });
  }

  QueryBuilder<BudgetProfile, BudgetProfile, QAfterSortBy>
      sortByLastUpdatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.desc);
    });
  }

  QueryBuilder<BudgetProfile, BudgetProfile, QAfterSortBy>
      sortByTargetSavingsPerQuincena() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetSavingsPerQuincena', Sort.asc);
    });
  }

  QueryBuilder<BudgetProfile, BudgetProfile, QAfterSortBy>
      sortByTargetSavingsPerQuincenaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetSavingsPerQuincena', Sort.desc);
    });
  }
}

extension BudgetProfileQuerySortThenBy
    on QueryBuilder<BudgetProfile, BudgetProfile, QSortThenBy> {
  QueryBuilder<BudgetProfile, BudgetProfile, QAfterSortBy>
      thenByBiweeklyIncome() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'biweeklyIncome', Sort.asc);
    });
  }

  QueryBuilder<BudgetProfile, BudgetProfile, QAfterSortBy>
      thenByBiweeklyIncomeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'biweeklyIncome', Sort.desc);
    });
  }

  QueryBuilder<BudgetProfile, BudgetProfile, QAfterSortBy>
      thenByFixedExpenses() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fixedExpenses', Sort.asc);
    });
  }

  QueryBuilder<BudgetProfile, BudgetProfile, QAfterSortBy>
      thenByFixedExpensesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fixedExpenses', Sort.desc);
    });
  }

  QueryBuilder<BudgetProfile, BudgetProfile, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<BudgetProfile, BudgetProfile, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<BudgetProfile, BudgetProfile, QAfterSortBy> thenByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.asc);
    });
  }

  QueryBuilder<BudgetProfile, BudgetProfile, QAfterSortBy>
      thenByLastUpdatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.desc);
    });
  }

  QueryBuilder<BudgetProfile, BudgetProfile, QAfterSortBy>
      thenByTargetSavingsPerQuincena() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetSavingsPerQuincena', Sort.asc);
    });
  }

  QueryBuilder<BudgetProfile, BudgetProfile, QAfterSortBy>
      thenByTargetSavingsPerQuincenaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetSavingsPerQuincena', Sort.desc);
    });
  }
}

extension BudgetProfileQueryWhereDistinct
    on QueryBuilder<BudgetProfile, BudgetProfile, QDistinct> {
  QueryBuilder<BudgetProfile, BudgetProfile, QDistinct>
      distinctByBiweeklyIncome() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'biweeklyIncome');
    });
  }

  QueryBuilder<BudgetProfile, BudgetProfile, QDistinct>
      distinctByFixedExpenses() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fixedExpenses');
    });
  }

  QueryBuilder<BudgetProfile, BudgetProfile, QDistinct>
      distinctByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastUpdated');
    });
  }

  QueryBuilder<BudgetProfile, BudgetProfile, QDistinct>
      distinctByTargetSavingsPerQuincena() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'targetSavingsPerQuincena');
    });
  }
}

extension BudgetProfileQueryProperty
    on QueryBuilder<BudgetProfile, BudgetProfile, QQueryProperty> {
  QueryBuilder<BudgetProfile, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<BudgetProfile, double, QQueryOperations>
      biweeklyIncomeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'biweeklyIncome');
    });
  }

  QueryBuilder<BudgetProfile, double, QQueryOperations>
      fixedExpensesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fixedExpenses');
    });
  }

  QueryBuilder<BudgetProfile, DateTime?, QQueryOperations>
      lastUpdatedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastUpdated');
    });
  }

  QueryBuilder<BudgetProfile, double, QQueryOperations>
      targetSavingsPerQuincenaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'targetSavingsPerQuincena');
    });
  }
}
