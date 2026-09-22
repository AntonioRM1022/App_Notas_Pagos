// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_event.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetProfileEventCollection on Isar {
  IsarCollection<ProfileEvent> get profileEvents => this.collection();
}

const ProfileEventSchema = CollectionSchema(
  name: r'ProfileEvent',
  id: 3957387673338522964,
  properties: {
    r'eventDate': PropertySchema(
      id: 0,
      name: r'eventDate',
      type: IsarType.dateTime,
    ),
    r'eventType': PropertySchema(
      id: 1,
      name: r'eventType',
      type: IsarType.string,
    ),
    r'isRecurring': PropertySchema(
      id: 2,
      name: r'isRecurring',
      type: IsarType.bool,
    ),
    r'profileName': PropertySchema(
      id: 3,
      name: r'profileName',
      type: IsarType.string,
    )
  },
  estimateSize: _profileEventEstimateSize,
  serialize: _profileEventSerialize,
  deserialize: _profileEventDeserialize,
  deserializeProp: _profileEventDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'quickNotes': LinkSchema(
      id: -1524196130926786743,
      name: r'quickNotes',
      target: r'QuickNote',
      single: false,
    )
  },
  embeddedSchemas: {},
  getId: _profileEventGetId,
  getLinks: _profileEventGetLinks,
  attach: _profileEventAttach,
  version: '3.1.0+1',
);

int _profileEventEstimateSize(
  ProfileEvent object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.eventType.length * 3;
  bytesCount += 3 + object.profileName.length * 3;
  return bytesCount;
}

void _profileEventSerialize(
  ProfileEvent object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.eventDate);
  writer.writeString(offsets[1], object.eventType);
  writer.writeBool(offsets[2], object.isRecurring);
  writer.writeString(offsets[3], object.profileName);
}

ProfileEvent _profileEventDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ProfileEvent();
  object.eventDate = reader.readDateTime(offsets[0]);
  object.eventType = reader.readString(offsets[1]);
  object.id = id;
  object.isRecurring = reader.readBool(offsets[2]);
  object.profileName = reader.readString(offsets[3]);
  return object;
}

P _profileEventDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _profileEventGetId(ProfileEvent object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _profileEventGetLinks(ProfileEvent object) {
  return [object.quickNotes];
}

void _profileEventAttach(
    IsarCollection<dynamic> col, Id id, ProfileEvent object) {
  object.id = id;
  object.quickNotes
      .attach(col, col.isar.collection<QuickNote>(), r'quickNotes', id);
}

extension ProfileEventQueryWhereSort
    on QueryBuilder<ProfileEvent, ProfileEvent, QWhere> {
  QueryBuilder<ProfileEvent, ProfileEvent, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ProfileEventQueryWhere
    on QueryBuilder<ProfileEvent, ProfileEvent, QWhereClause> {
  QueryBuilder<ProfileEvent, ProfileEvent, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ProfileEvent, ProfileEvent, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<ProfileEvent, ProfileEvent, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ProfileEvent, ProfileEvent, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ProfileEvent, ProfileEvent, QAfterWhereClause> idBetween(
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

extension ProfileEventQueryFilter
    on QueryBuilder<ProfileEvent, ProfileEvent, QFilterCondition> {
  QueryBuilder<ProfileEvent, ProfileEvent, QAfterFilterCondition>
      eventDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'eventDate',
        value: value,
      ));
    });
  }

  QueryBuilder<ProfileEvent, ProfileEvent, QAfterFilterCondition>
      eventDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'eventDate',
        value: value,
      ));
    });
  }

  QueryBuilder<ProfileEvent, ProfileEvent, QAfterFilterCondition>
      eventDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'eventDate',
        value: value,
      ));
    });
  }

  QueryBuilder<ProfileEvent, ProfileEvent, QAfterFilterCondition>
      eventDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'eventDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ProfileEvent, ProfileEvent, QAfterFilterCondition>
      eventTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'eventType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProfileEvent, ProfileEvent, QAfterFilterCondition>
      eventTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'eventType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProfileEvent, ProfileEvent, QAfterFilterCondition>
      eventTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'eventType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProfileEvent, ProfileEvent, QAfterFilterCondition>
      eventTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'eventType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProfileEvent, ProfileEvent, QAfterFilterCondition>
      eventTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'eventType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProfileEvent, ProfileEvent, QAfterFilterCondition>
      eventTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'eventType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProfileEvent, ProfileEvent, QAfterFilterCondition>
      eventTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'eventType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProfileEvent, ProfileEvent, QAfterFilterCondition>
      eventTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'eventType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProfileEvent, ProfileEvent, QAfterFilterCondition>
      eventTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'eventType',
        value: '',
      ));
    });
  }

  QueryBuilder<ProfileEvent, ProfileEvent, QAfterFilterCondition>
      eventTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'eventType',
        value: '',
      ));
    });
  }

  QueryBuilder<ProfileEvent, ProfileEvent, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ProfileEvent, ProfileEvent, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<ProfileEvent, ProfileEvent, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<ProfileEvent, ProfileEvent, QAfterFilterCondition> idBetween(
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

  QueryBuilder<ProfileEvent, ProfileEvent, QAfterFilterCondition>
      isRecurringEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isRecurring',
        value: value,
      ));
    });
  }

  QueryBuilder<ProfileEvent, ProfileEvent, QAfterFilterCondition>
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

  QueryBuilder<ProfileEvent, ProfileEvent, QAfterFilterCondition>
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

  QueryBuilder<ProfileEvent, ProfileEvent, QAfterFilterCondition>
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

  QueryBuilder<ProfileEvent, ProfileEvent, QAfterFilterCondition>
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

  QueryBuilder<ProfileEvent, ProfileEvent, QAfterFilterCondition>
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

  QueryBuilder<ProfileEvent, ProfileEvent, QAfterFilterCondition>
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

  QueryBuilder<ProfileEvent, ProfileEvent, QAfterFilterCondition>
      profileNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'profileName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProfileEvent, ProfileEvent, QAfterFilterCondition>
      profileNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'profileName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProfileEvent, ProfileEvent, QAfterFilterCondition>
      profileNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'profileName',
        value: '',
      ));
    });
  }

  QueryBuilder<ProfileEvent, ProfileEvent, QAfterFilterCondition>
      profileNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'profileName',
        value: '',
      ));
    });
  }
}

extension ProfileEventQueryObject
    on QueryBuilder<ProfileEvent, ProfileEvent, QFilterCondition> {}

extension ProfileEventQueryLinks
    on QueryBuilder<ProfileEvent, ProfileEvent, QFilterCondition> {
  QueryBuilder<ProfileEvent, ProfileEvent, QAfterFilterCondition> quickNotes(
      FilterQuery<QuickNote> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'quickNotes');
    });
  }

  QueryBuilder<ProfileEvent, ProfileEvent, QAfterFilterCondition>
      quickNotesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'quickNotes', length, true, length, true);
    });
  }

  QueryBuilder<ProfileEvent, ProfileEvent, QAfterFilterCondition>
      quickNotesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'quickNotes', 0, true, 0, true);
    });
  }

  QueryBuilder<ProfileEvent, ProfileEvent, QAfterFilterCondition>
      quickNotesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'quickNotes', 0, false, 999999, true);
    });
  }

  QueryBuilder<ProfileEvent, ProfileEvent, QAfterFilterCondition>
      quickNotesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'quickNotes', 0, true, length, include);
    });
  }

  QueryBuilder<ProfileEvent, ProfileEvent, QAfterFilterCondition>
      quickNotesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'quickNotes', length, include, 999999, true);
    });
  }

  QueryBuilder<ProfileEvent, ProfileEvent, QAfterFilterCondition>
      quickNotesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'quickNotes', lower, includeLower, upper, includeUpper);
    });
  }
}

extension ProfileEventQuerySortBy
    on QueryBuilder<ProfileEvent, ProfileEvent, QSortBy> {
  QueryBuilder<ProfileEvent, ProfileEvent, QAfterSortBy> sortByEventDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventDate', Sort.asc);
    });
  }

  QueryBuilder<ProfileEvent, ProfileEvent, QAfterSortBy> sortByEventDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventDate', Sort.desc);
    });
  }

  QueryBuilder<ProfileEvent, ProfileEvent, QAfterSortBy> sortByEventType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventType', Sort.asc);
    });
  }

  QueryBuilder<ProfileEvent, ProfileEvent, QAfterSortBy> sortByEventTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventType', Sort.desc);
    });
  }

  QueryBuilder<ProfileEvent, ProfileEvent, QAfterSortBy> sortByIsRecurring() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRecurring', Sort.asc);
    });
  }

  QueryBuilder<ProfileEvent, ProfileEvent, QAfterSortBy>
      sortByIsRecurringDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRecurring', Sort.desc);
    });
  }

  QueryBuilder<ProfileEvent, ProfileEvent, QAfterSortBy> sortByProfileName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profileName', Sort.asc);
    });
  }

  QueryBuilder<ProfileEvent, ProfileEvent, QAfterSortBy>
      sortByProfileNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profileName', Sort.desc);
    });
  }
}

extension ProfileEventQuerySortThenBy
    on QueryBuilder<ProfileEvent, ProfileEvent, QSortThenBy> {
  QueryBuilder<ProfileEvent, ProfileEvent, QAfterSortBy> thenByEventDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventDate', Sort.asc);
    });
  }

  QueryBuilder<ProfileEvent, ProfileEvent, QAfterSortBy> thenByEventDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventDate', Sort.desc);
    });
  }

  QueryBuilder<ProfileEvent, ProfileEvent, QAfterSortBy> thenByEventType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventType', Sort.asc);
    });
  }

  QueryBuilder<ProfileEvent, ProfileEvent, QAfterSortBy> thenByEventTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventType', Sort.desc);
    });
  }

  QueryBuilder<ProfileEvent, ProfileEvent, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ProfileEvent, ProfileEvent, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ProfileEvent, ProfileEvent, QAfterSortBy> thenByIsRecurring() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRecurring', Sort.asc);
    });
  }

  QueryBuilder<ProfileEvent, ProfileEvent, QAfterSortBy>
      thenByIsRecurringDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRecurring', Sort.desc);
    });
  }

  QueryBuilder<ProfileEvent, ProfileEvent, QAfterSortBy> thenByProfileName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profileName', Sort.asc);
    });
  }

  QueryBuilder<ProfileEvent, ProfileEvent, QAfterSortBy>
      thenByProfileNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profileName', Sort.desc);
    });
  }
}

extension ProfileEventQueryWhereDistinct
    on QueryBuilder<ProfileEvent, ProfileEvent, QDistinct> {
  QueryBuilder<ProfileEvent, ProfileEvent, QDistinct> distinctByEventDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'eventDate');
    });
  }

  QueryBuilder<ProfileEvent, ProfileEvent, QDistinct> distinctByEventType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'eventType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProfileEvent, ProfileEvent, QDistinct> distinctByIsRecurring() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isRecurring');
    });
  }

  QueryBuilder<ProfileEvent, ProfileEvent, QDistinct> distinctByProfileName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'profileName', caseSensitive: caseSensitive);
    });
  }
}

extension ProfileEventQueryProperty
    on QueryBuilder<ProfileEvent, ProfileEvent, QQueryProperty> {
  QueryBuilder<ProfileEvent, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ProfileEvent, DateTime, QQueryOperations> eventDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'eventDate');
    });
  }

  QueryBuilder<ProfileEvent, String, QQueryOperations> eventTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'eventType');
    });
  }

  QueryBuilder<ProfileEvent, bool, QQueryOperations> isRecurringProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isRecurring');
    });
  }

  QueryBuilder<ProfileEvent, String, QQueryOperations> profileNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'profileName');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetQuickNoteCollection on Isar {
  IsarCollection<QuickNote> get quickNotes => this.collection();
}

const QuickNoteSchema = CollectionSchema(
  name: r'QuickNote',
  id: -7428646308382683025,
  properties: {
    r'content': PropertySchema(
      id: 0,
      name: r'content',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _quickNoteEstimateSize,
  serialize: _quickNoteSerialize,
  deserialize: _quickNoteDeserialize,
  deserializeProp: _quickNoteDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'event': LinkSchema(
      id: 2191079712292441862,
      name: r'event',
      target: r'ProfileEvent',
      single: true,
      linkName: r'quickNotes',
    )
  },
  embeddedSchemas: {},
  getId: _quickNoteGetId,
  getLinks: _quickNoteGetLinks,
  attach: _quickNoteAttach,
  version: '3.1.0+1',
);

int _quickNoteEstimateSize(
  QuickNote object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.content.length * 3;
  return bytesCount;
}

void _quickNoteSerialize(
  QuickNote object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.content);
  writer.writeDateTime(offsets[1], object.createdAt);
}

QuickNote _quickNoteDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = QuickNote();
  object.content = reader.readString(offsets[0]);
  object.createdAt = reader.readDateTime(offsets[1]);
  object.id = id;
  return object;
}

P _quickNoteDeserializeProp<P>(
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
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _quickNoteGetId(QuickNote object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _quickNoteGetLinks(QuickNote object) {
  return [object.event];
}

void _quickNoteAttach(IsarCollection<dynamic> col, Id id, QuickNote object) {
  object.id = id;
  object.event.attach(col, col.isar.collection<ProfileEvent>(), r'event', id);
}

extension QuickNoteQueryWhereSort
    on QueryBuilder<QuickNote, QuickNote, QWhere> {
  QueryBuilder<QuickNote, QuickNote, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension QuickNoteQueryWhere
    on QueryBuilder<QuickNote, QuickNote, QWhereClause> {
  QueryBuilder<QuickNote, QuickNote, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<QuickNote, QuickNote, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<QuickNote, QuickNote, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<QuickNote, QuickNote, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<QuickNote, QuickNote, QAfterWhereClause> idBetween(
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

extension QuickNoteQueryFilter
    on QueryBuilder<QuickNote, QuickNote, QFilterCondition> {
  QueryBuilder<QuickNote, QuickNote, QAfterFilterCondition> contentEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuickNote, QuickNote, QAfterFilterCondition> contentGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuickNote, QuickNote, QAfterFilterCondition> contentLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuickNote, QuickNote, QAfterFilterCondition> contentBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'content',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuickNote, QuickNote, QAfterFilterCondition> contentStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuickNote, QuickNote, QAfterFilterCondition> contentEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuickNote, QuickNote, QAfterFilterCondition> contentContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuickNote, QuickNote, QAfterFilterCondition> contentMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'content',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuickNote, QuickNote, QAfterFilterCondition> contentIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'content',
        value: '',
      ));
    });
  }

  QueryBuilder<QuickNote, QuickNote, QAfterFilterCondition>
      contentIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'content',
        value: '',
      ));
    });
  }

  QueryBuilder<QuickNote, QuickNote, QAfterFilterCondition> createdAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<QuickNote, QuickNote, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<QuickNote, QuickNote, QAfterFilterCondition> createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<QuickNote, QuickNote, QAfterFilterCondition> createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<QuickNote, QuickNote, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<QuickNote, QuickNote, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<QuickNote, QuickNote, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<QuickNote, QuickNote, QAfterFilterCondition> idBetween(
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
}

extension QuickNoteQueryObject
    on QueryBuilder<QuickNote, QuickNote, QFilterCondition> {}

extension QuickNoteQueryLinks
    on QueryBuilder<QuickNote, QuickNote, QFilterCondition> {
  QueryBuilder<QuickNote, QuickNote, QAfterFilterCondition> event(
      FilterQuery<ProfileEvent> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'event');
    });
  }

  QueryBuilder<QuickNote, QuickNote, QAfterFilterCondition> eventIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'event', 0, true, 0, true);
    });
  }
}

extension QuickNoteQuerySortBy on QueryBuilder<QuickNote, QuickNote, QSortBy> {
  QueryBuilder<QuickNote, QuickNote, QAfterSortBy> sortByContent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.asc);
    });
  }

  QueryBuilder<QuickNote, QuickNote, QAfterSortBy> sortByContentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.desc);
    });
  }

  QueryBuilder<QuickNote, QuickNote, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<QuickNote, QuickNote, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }
}

extension QuickNoteQuerySortThenBy
    on QueryBuilder<QuickNote, QuickNote, QSortThenBy> {
  QueryBuilder<QuickNote, QuickNote, QAfterSortBy> thenByContent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.asc);
    });
  }

  QueryBuilder<QuickNote, QuickNote, QAfterSortBy> thenByContentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.desc);
    });
  }

  QueryBuilder<QuickNote, QuickNote, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<QuickNote, QuickNote, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<QuickNote, QuickNote, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<QuickNote, QuickNote, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension QuickNoteQueryWhereDistinct
    on QueryBuilder<QuickNote, QuickNote, QDistinct> {
  QueryBuilder<QuickNote, QuickNote, QDistinct> distinctByContent(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'content', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<QuickNote, QuickNote, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }
}

extension QuickNoteQueryProperty
    on QueryBuilder<QuickNote, QuickNote, QQueryProperty> {
  QueryBuilder<QuickNote, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<QuickNote, String, QQueryOperations> contentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'content');
    });
  }

  QueryBuilder<QuickNote, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }
}
