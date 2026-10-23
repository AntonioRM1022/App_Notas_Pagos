// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loan_record.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetLoanRecordCollection on Isar {
  IsarCollection<LoanRecord> get loanRecords => this.collection();
}

const LoanRecordSchema = CollectionSchema(
  name: r'LoanRecord',
  id: -784674316702428842,
  properties: {
    r'concept': PropertySchema(
      id: 0,
      name: r'concept',
      type: IsarType.string,
    ),
    r'date': PropertySchema(
      id: 1,
      name: r'date',
      type: IsarType.dateTime,
    ),
    r'dueDate': PropertySchema(
      id: 2,
      name: r'dueDate',
      type: IsarType.dateTime,
    ),
    r'isDeleted': PropertySchema(
      id: 3,
      name: r'isDeleted',
      type: IsarType.bool,
    ),
    r'isSettled': PropertySchema(
      id: 4,
      name: r'isSettled',
      type: IsarType.bool,
    ),
    r'originalAmount': PropertySchema(
      id: 5,
      name: r'originalAmount',
      type: IsarType.double,
    ),
    r'personName': PropertySchema(
      id: 6,
      name: r'personName',
      type: IsarType.string,
    ),
    r'remainingAmount': PropertySchema(
      id: 7,
      name: r'remainingAmount',
      type: IsarType.double,
    ),
    r'type': PropertySchema(
      id: 8,
      name: r'type',
      type: IsarType.string,
      enumMap: _LoanRecordtypeEnumValueMap,
    )
  },
  estimateSize: _loanRecordEstimateSize,
  serialize: _loanRecordSerialize,
  deserialize: _loanRecordDeserialize,
  deserializeProp: _loanRecordDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'payments': LinkSchema(
      id: -8001522917923602478,
      name: r'payments',
      target: r'LoanPayment',
      single: false,
    )
  },
  embeddedSchemas: {},
  getId: _loanRecordGetId,
  getLinks: _loanRecordGetLinks,
  attach: _loanRecordAttach,
  version: '3.1.0+1',
);

int _loanRecordEstimateSize(
  LoanRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.concept.length * 3;
  bytesCount += 3 + object.personName.length * 3;
  bytesCount += 3 + object.type.name.length * 3;
  return bytesCount;
}

void _loanRecordSerialize(
  LoanRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.concept);
  writer.writeDateTime(offsets[1], object.date);
  writer.writeDateTime(offsets[2], object.dueDate);
  writer.writeBool(offsets[3], object.isDeleted);
  writer.writeBool(offsets[4], object.isSettled);
  writer.writeDouble(offsets[5], object.originalAmount);
  writer.writeString(offsets[6], object.personName);
  writer.writeDouble(offsets[7], object.remainingAmount);
  writer.writeString(offsets[8], object.type.name);
}

LoanRecord _loanRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LoanRecord();
  object.concept = reader.readString(offsets[0]);
  object.date = reader.readDateTime(offsets[1]);
  object.dueDate = reader.readDateTimeOrNull(offsets[2]);
  object.id = id;
  object.isDeleted = reader.readBool(offsets[3]);
  object.isSettled = reader.readBool(offsets[4]);
  object.originalAmount = reader.readDouble(offsets[5]);
  object.personName = reader.readString(offsets[6]);
  object.remainingAmount = reader.readDouble(offsets[7]);
  object.type =
      _LoanRecordtypeValueEnumMap[reader.readStringOrNull(offsets[8])] ??
          LoanType.lent;
  return object;
}

P _loanRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readDouble(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readDouble(offset)) as P;
    case 8:
      return (_LoanRecordtypeValueEnumMap[reader.readStringOrNull(offset)] ??
          LoanType.lent) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _LoanRecordtypeEnumValueMap = {
  r'lent': r'lent',
  r'borrowed': r'borrowed',
};
const _LoanRecordtypeValueEnumMap = {
  r'lent': LoanType.lent,
  r'borrowed': LoanType.borrowed,
};

Id _loanRecordGetId(LoanRecord object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _loanRecordGetLinks(LoanRecord object) {
  return [object.payments];
}

void _loanRecordAttach(IsarCollection<dynamic> col, Id id, LoanRecord object) {
  object.id = id;
  object.payments
      .attach(col, col.isar.collection<LoanPayment>(), r'payments', id);
}

extension LoanRecordQueryWhereSort
    on QueryBuilder<LoanRecord, LoanRecord, QWhere> {
  QueryBuilder<LoanRecord, LoanRecord, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension LoanRecordQueryWhere
    on QueryBuilder<LoanRecord, LoanRecord, QWhereClause> {
  QueryBuilder<LoanRecord, LoanRecord, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<LoanRecord, LoanRecord, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterWhereClause> idBetween(
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

extension LoanRecordQueryFilter
    on QueryBuilder<LoanRecord, LoanRecord, QFilterCondition> {
  QueryBuilder<LoanRecord, LoanRecord, QAfterFilterCondition> conceptEqualTo(
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

  QueryBuilder<LoanRecord, LoanRecord, QAfterFilterCondition>
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

  QueryBuilder<LoanRecord, LoanRecord, QAfterFilterCondition> conceptLessThan(
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

  QueryBuilder<LoanRecord, LoanRecord, QAfterFilterCondition> conceptBetween(
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

  QueryBuilder<LoanRecord, LoanRecord, QAfterFilterCondition> conceptStartsWith(
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

  QueryBuilder<LoanRecord, LoanRecord, QAfterFilterCondition> conceptEndsWith(
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

  QueryBuilder<LoanRecord, LoanRecord, QAfterFilterCondition> conceptContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'concept',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterFilterCondition> conceptMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'concept',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterFilterCondition> conceptIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'concept',
        value: '',
      ));
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterFilterCondition>
      conceptIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'concept',
        value: '',
      ));
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterFilterCondition> dateEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterFilterCondition> dateGreaterThan(
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

  QueryBuilder<LoanRecord, LoanRecord, QAfterFilterCondition> dateLessThan(
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

  QueryBuilder<LoanRecord, LoanRecord, QAfterFilterCondition> dateBetween(
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

  QueryBuilder<LoanRecord, LoanRecord, QAfterFilterCondition> dueDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dueDate',
      ));
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterFilterCondition>
      dueDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dueDate',
      ));
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterFilterCondition> dueDateEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dueDate',
        value: value,
      ));
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterFilterCondition>
      dueDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dueDate',
        value: value,
      ));
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterFilterCondition> dueDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dueDate',
        value: value,
      ));
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterFilterCondition> dueDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dueDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<LoanRecord, LoanRecord, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<LoanRecord, LoanRecord, QAfterFilterCondition> idBetween(
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

  QueryBuilder<LoanRecord, LoanRecord, QAfterFilterCondition> isDeletedEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isDeleted',
        value: value,
      ));
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterFilterCondition> isSettledEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isSettled',
        value: value,
      ));
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterFilterCondition>
      originalAmountEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'originalAmount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterFilterCondition>
      originalAmountGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'originalAmount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterFilterCondition>
      originalAmountLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'originalAmount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterFilterCondition>
      originalAmountBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'originalAmount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterFilterCondition> personNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'personName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterFilterCondition>
      personNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'personName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterFilterCondition>
      personNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'personName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterFilterCondition> personNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'personName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterFilterCondition>
      personNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'personName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterFilterCondition>
      personNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'personName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterFilterCondition>
      personNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'personName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterFilterCondition> personNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'personName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterFilterCondition>
      personNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'personName',
        value: '',
      ));
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterFilterCondition>
      personNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'personName',
        value: '',
      ));
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterFilterCondition>
      remainingAmountEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'remainingAmount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterFilterCondition>
      remainingAmountGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'remainingAmount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterFilterCondition>
      remainingAmountLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'remainingAmount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterFilterCondition>
      remainingAmountBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'remainingAmount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterFilterCondition> typeEqualTo(
    LoanType value, {
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

  QueryBuilder<LoanRecord, LoanRecord, QAfterFilterCondition> typeGreaterThan(
    LoanType value, {
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

  QueryBuilder<LoanRecord, LoanRecord, QAfterFilterCondition> typeLessThan(
    LoanType value, {
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

  QueryBuilder<LoanRecord, LoanRecord, QAfterFilterCondition> typeBetween(
    LoanType lower,
    LoanType upper, {
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

  QueryBuilder<LoanRecord, LoanRecord, QAfterFilterCondition> typeStartsWith(
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

  QueryBuilder<LoanRecord, LoanRecord, QAfterFilterCondition> typeEndsWith(
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

  QueryBuilder<LoanRecord, LoanRecord, QAfterFilterCondition> typeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterFilterCondition> typeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'type',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterFilterCondition> typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterFilterCondition> typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'type',
        value: '',
      ));
    });
  }
}

extension LoanRecordQueryObject
    on QueryBuilder<LoanRecord, LoanRecord, QFilterCondition> {}

extension LoanRecordQueryLinks
    on QueryBuilder<LoanRecord, LoanRecord, QFilterCondition> {
  QueryBuilder<LoanRecord, LoanRecord, QAfterFilterCondition> payments(
      FilterQuery<LoanPayment> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'payments');
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterFilterCondition>
      paymentsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'payments', length, true, length, true);
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterFilterCondition>
      paymentsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'payments', 0, true, 0, true);
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterFilterCondition>
      paymentsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'payments', 0, false, 999999, true);
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterFilterCondition>
      paymentsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'payments', 0, true, length, include);
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterFilterCondition>
      paymentsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'payments', length, include, 999999, true);
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterFilterCondition>
      paymentsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'payments', lower, includeLower, upper, includeUpper);
    });
  }
}

extension LoanRecordQuerySortBy
    on QueryBuilder<LoanRecord, LoanRecord, QSortBy> {
  QueryBuilder<LoanRecord, LoanRecord, QAfterSortBy> sortByConcept() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'concept', Sort.asc);
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterSortBy> sortByConceptDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'concept', Sort.desc);
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterSortBy> sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterSortBy> sortByDueDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dueDate', Sort.asc);
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterSortBy> sortByDueDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dueDate', Sort.desc);
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterSortBy> sortByIsDeleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDeleted', Sort.asc);
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterSortBy> sortByIsDeletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDeleted', Sort.desc);
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterSortBy> sortByIsSettled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSettled', Sort.asc);
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterSortBy> sortByIsSettledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSettled', Sort.desc);
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterSortBy> sortByOriginalAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalAmount', Sort.asc);
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterSortBy>
      sortByOriginalAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalAmount', Sort.desc);
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterSortBy> sortByPersonName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'personName', Sort.asc);
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterSortBy> sortByPersonNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'personName', Sort.desc);
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterSortBy> sortByRemainingAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remainingAmount', Sort.asc);
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterSortBy>
      sortByRemainingAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remainingAmount', Sort.desc);
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterSortBy> sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension LoanRecordQuerySortThenBy
    on QueryBuilder<LoanRecord, LoanRecord, QSortThenBy> {
  QueryBuilder<LoanRecord, LoanRecord, QAfterSortBy> thenByConcept() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'concept', Sort.asc);
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterSortBy> thenByConceptDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'concept', Sort.desc);
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterSortBy> thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterSortBy> thenByDueDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dueDate', Sort.asc);
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterSortBy> thenByDueDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dueDate', Sort.desc);
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterSortBy> thenByIsDeleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDeleted', Sort.asc);
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterSortBy> thenByIsDeletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDeleted', Sort.desc);
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterSortBy> thenByIsSettled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSettled', Sort.asc);
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterSortBy> thenByIsSettledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSettled', Sort.desc);
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterSortBy> thenByOriginalAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalAmount', Sort.asc);
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterSortBy>
      thenByOriginalAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalAmount', Sort.desc);
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterSortBy> thenByPersonName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'personName', Sort.asc);
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterSortBy> thenByPersonNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'personName', Sort.desc);
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterSortBy> thenByRemainingAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remainingAmount', Sort.asc);
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterSortBy>
      thenByRemainingAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remainingAmount', Sort.desc);
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QAfterSortBy> thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension LoanRecordQueryWhereDistinct
    on QueryBuilder<LoanRecord, LoanRecord, QDistinct> {
  QueryBuilder<LoanRecord, LoanRecord, QDistinct> distinctByConcept(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'concept', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QDistinct> distinctByDueDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dueDate');
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QDistinct> distinctByIsDeleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isDeleted');
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QDistinct> distinctByIsSettled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isSettled');
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QDistinct> distinctByOriginalAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'originalAmount');
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QDistinct> distinctByPersonName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'personName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QDistinct> distinctByRemainingAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'remainingAmount');
    });
  }

  QueryBuilder<LoanRecord, LoanRecord, QDistinct> distinctByType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type', caseSensitive: caseSensitive);
    });
  }
}

extension LoanRecordQueryProperty
    on QueryBuilder<LoanRecord, LoanRecord, QQueryProperty> {
  QueryBuilder<LoanRecord, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<LoanRecord, String, QQueryOperations> conceptProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'concept');
    });
  }

  QueryBuilder<LoanRecord, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<LoanRecord, DateTime?, QQueryOperations> dueDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dueDate');
    });
  }

  QueryBuilder<LoanRecord, bool, QQueryOperations> isDeletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isDeleted');
    });
  }

  QueryBuilder<LoanRecord, bool, QQueryOperations> isSettledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isSettled');
    });
  }

  QueryBuilder<LoanRecord, double, QQueryOperations> originalAmountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'originalAmount');
    });
  }

  QueryBuilder<LoanRecord, String, QQueryOperations> personNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'personName');
    });
  }

  QueryBuilder<LoanRecord, double, QQueryOperations> remainingAmountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'remainingAmount');
    });
  }

  QueryBuilder<LoanRecord, LoanType, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }
}
