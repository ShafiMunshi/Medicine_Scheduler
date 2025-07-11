// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repeat_variation.dart';

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const RepeatVariationDaysSchema = Schema(
  name: r'RepeatVariationDays',
  id: -1494091411996334077,
  properties: {
    r'day': PropertySchema(
      id: 0,
      name: r'day',
      type: IsarType.string,
    )
  },
  estimateSize: _repeatVariationDaysEstimateSize,
  serialize: _repeatVariationDaysSerialize,
  deserialize: _repeatVariationDaysDeserialize,
  deserializeProp: _repeatVariationDaysDeserializeProp,
);

int _repeatVariationDaysEstimateSize(
  RepeatVariationDays object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.day;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _repeatVariationDaysSerialize(
  RepeatVariationDays object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.day);
}

RepeatVariationDays _repeatVariationDaysDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = RepeatVariationDays(
    day: reader.readStringOrNull(offsets[0]),
  );
  return object;
}

P _repeatVariationDaysDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension RepeatVariationDaysQueryFilter on QueryBuilder<RepeatVariationDays,
    RepeatVariationDays, QFilterCondition> {
  QueryBuilder<RepeatVariationDays, RepeatVariationDays, QAfterFilterCondition>
      dayIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'day',
      ));
    });
  }

  QueryBuilder<RepeatVariationDays, RepeatVariationDays, QAfterFilterCondition>
      dayIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'day',
      ));
    });
  }

  QueryBuilder<RepeatVariationDays, RepeatVariationDays, QAfterFilterCondition>
      dayEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'day',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RepeatVariationDays, RepeatVariationDays, QAfterFilterCondition>
      dayGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'day',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RepeatVariationDays, RepeatVariationDays, QAfterFilterCondition>
      dayLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'day',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RepeatVariationDays, RepeatVariationDays, QAfterFilterCondition>
      dayBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'day',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RepeatVariationDays, RepeatVariationDays, QAfterFilterCondition>
      dayStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'day',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RepeatVariationDays, RepeatVariationDays, QAfterFilterCondition>
      dayEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'day',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RepeatVariationDays, RepeatVariationDays, QAfterFilterCondition>
      dayContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'day',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RepeatVariationDays, RepeatVariationDays, QAfterFilterCondition>
      dayMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'day',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RepeatVariationDays, RepeatVariationDays, QAfterFilterCondition>
      dayIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'day',
        value: '',
      ));
    });
  }

  QueryBuilder<RepeatVariationDays, RepeatVariationDays, QAfterFilterCondition>
      dayIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'day',
        value: '',
      ));
    });
  }
}

extension RepeatVariationDaysQueryObject on QueryBuilder<RepeatVariationDays,
    RepeatVariationDays, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const RepeatVariationTimesSchema = Schema(
  name: r'RepeatVariationTimes',
  id: 7490877538859948694,
  properties: {
    r'dayTime': PropertySchema(
      id: 0,
      name: r'dayTime',
      type: IsarType.string,
    )
  },
  estimateSize: _repeatVariationTimesEstimateSize,
  serialize: _repeatVariationTimesSerialize,
  deserialize: _repeatVariationTimesDeserialize,
  deserializeProp: _repeatVariationTimesDeserializeProp,
);

int _repeatVariationTimesEstimateSize(
  RepeatVariationTimes object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.dayTime;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _repeatVariationTimesSerialize(
  RepeatVariationTimes object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.dayTime);
}

RepeatVariationTimes _repeatVariationTimesDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = RepeatVariationTimes(
    dayTime: reader.readStringOrNull(offsets[0]),
  );
  return object;
}

P _repeatVariationTimesDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension RepeatVariationTimesQueryFilter on QueryBuilder<RepeatVariationTimes,
    RepeatVariationTimes, QFilterCondition> {
  QueryBuilder<RepeatVariationTimes, RepeatVariationTimes,
      QAfterFilterCondition> dayTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dayTime',
      ));
    });
  }

  QueryBuilder<RepeatVariationTimes, RepeatVariationTimes,
      QAfterFilterCondition> dayTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dayTime',
      ));
    });
  }

  QueryBuilder<RepeatVariationTimes, RepeatVariationTimes,
      QAfterFilterCondition> dayTimeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dayTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RepeatVariationTimes, RepeatVariationTimes,
      QAfterFilterCondition> dayTimeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dayTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RepeatVariationTimes, RepeatVariationTimes,
      QAfterFilterCondition> dayTimeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dayTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RepeatVariationTimes, RepeatVariationTimes,
      QAfterFilterCondition> dayTimeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dayTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RepeatVariationTimes, RepeatVariationTimes,
      QAfterFilterCondition> dayTimeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'dayTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RepeatVariationTimes, RepeatVariationTimes,
      QAfterFilterCondition> dayTimeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'dayTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RepeatVariationTimes, RepeatVariationTimes,
          QAfterFilterCondition>
      dayTimeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'dayTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RepeatVariationTimes, RepeatVariationTimes,
          QAfterFilterCondition>
      dayTimeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'dayTime',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RepeatVariationTimes, RepeatVariationTimes,
      QAfterFilterCondition> dayTimeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dayTime',
        value: '',
      ));
    });
  }

  QueryBuilder<RepeatVariationTimes, RepeatVariationTimes,
      QAfterFilterCondition> dayTimeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'dayTime',
        value: '',
      ));
    });
  }
}

extension RepeatVariationTimesQueryObject on QueryBuilder<RepeatVariationTimes,
    RepeatVariationTimes, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const RepeatVariationWeekSchema = Schema(
  name: r'RepeatVariationWeek',
  id: -2059248272879264652,
  properties: {
    r'weekDays': PropertySchema(
      id: 0,
      name: r'weekDays',
      type: IsarType.stringList,
    )
  },
  estimateSize: _repeatVariationWeekEstimateSize,
  serialize: _repeatVariationWeekSerialize,
  deserialize: _repeatVariationWeekDeserialize,
  deserializeProp: _repeatVariationWeekDeserializeProp,
);

int _repeatVariationWeekEstimateSize(
  RepeatVariationWeek object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final list = object.weekDays;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  return bytesCount;
}

void _repeatVariationWeekSerialize(
  RepeatVariationWeek object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeStringList(offsets[0], object.weekDays);
}

RepeatVariationWeek _repeatVariationWeekDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = RepeatVariationWeek(
    weekDays: reader.readStringList(offsets[0]),
  );
  return object;
}

P _repeatVariationWeekDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringList(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension RepeatVariationWeekQueryFilter on QueryBuilder<RepeatVariationWeek,
    RepeatVariationWeek, QFilterCondition> {
  QueryBuilder<RepeatVariationWeek, RepeatVariationWeek, QAfterFilterCondition>
      weekDaysIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'weekDays',
      ));
    });
  }

  QueryBuilder<RepeatVariationWeek, RepeatVariationWeek, QAfterFilterCondition>
      weekDaysIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'weekDays',
      ));
    });
  }

  QueryBuilder<RepeatVariationWeek, RepeatVariationWeek, QAfterFilterCondition>
      weekDaysElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weekDays',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RepeatVariationWeek, RepeatVariationWeek, QAfterFilterCondition>
      weekDaysElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'weekDays',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RepeatVariationWeek, RepeatVariationWeek, QAfterFilterCondition>
      weekDaysElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'weekDays',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RepeatVariationWeek, RepeatVariationWeek, QAfterFilterCondition>
      weekDaysElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'weekDays',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RepeatVariationWeek, RepeatVariationWeek, QAfterFilterCondition>
      weekDaysElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'weekDays',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RepeatVariationWeek, RepeatVariationWeek, QAfterFilterCondition>
      weekDaysElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'weekDays',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RepeatVariationWeek, RepeatVariationWeek, QAfterFilterCondition>
      weekDaysElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'weekDays',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RepeatVariationWeek, RepeatVariationWeek, QAfterFilterCondition>
      weekDaysElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'weekDays',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RepeatVariationWeek, RepeatVariationWeek, QAfterFilterCondition>
      weekDaysElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weekDays',
        value: '',
      ));
    });
  }

  QueryBuilder<RepeatVariationWeek, RepeatVariationWeek, QAfterFilterCondition>
      weekDaysElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'weekDays',
        value: '',
      ));
    });
  }

  QueryBuilder<RepeatVariationWeek, RepeatVariationWeek, QAfterFilterCondition>
      weekDaysLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'weekDays',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<RepeatVariationWeek, RepeatVariationWeek, QAfterFilterCondition>
      weekDaysIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'weekDays',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<RepeatVariationWeek, RepeatVariationWeek, QAfterFilterCondition>
      weekDaysIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'weekDays',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<RepeatVariationWeek, RepeatVariationWeek, QAfterFilterCondition>
      weekDaysLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'weekDays',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<RepeatVariationWeek, RepeatVariationWeek, QAfterFilterCondition>
      weekDaysLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'weekDays',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<RepeatVariationWeek, RepeatVariationWeek, QAfterFilterCondition>
      weekDaysLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'weekDays',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension RepeatVariationWeekQueryObject on QueryBuilder<RepeatVariationWeek,
    RepeatVariationWeek, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const RepeatVariationMonthSchema = Schema(
  name: r'RepeatVariationMonth',
  id: 6044871637931404053,
  properties: {
    r'days': PropertySchema(
      id: 0,
      name: r'days',
      type: IsarType.longList,
    )
  },
  estimateSize: _repeatVariationMonthEstimateSize,
  serialize: _repeatVariationMonthSerialize,
  deserialize: _repeatVariationMonthDeserialize,
  deserializeProp: _repeatVariationMonthDeserializeProp,
);

int _repeatVariationMonthEstimateSize(
  RepeatVariationMonth object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.days;
    if (value != null) {
      bytesCount += 3 + value.length * 8;
    }
  }
  return bytesCount;
}

void _repeatVariationMonthSerialize(
  RepeatVariationMonth object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLongList(offsets[0], object.days);
}

RepeatVariationMonth _repeatVariationMonthDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = RepeatVariationMonth(
    days: reader.readLongList(offsets[0]),
  );
  return object;
}

P _repeatVariationMonthDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongList(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension RepeatVariationMonthQueryFilter on QueryBuilder<RepeatVariationMonth,
    RepeatVariationMonth, QFilterCondition> {
  QueryBuilder<RepeatVariationMonth, RepeatVariationMonth,
      QAfterFilterCondition> daysIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'days',
      ));
    });
  }

  QueryBuilder<RepeatVariationMonth, RepeatVariationMonth,
      QAfterFilterCondition> daysIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'days',
      ));
    });
  }

  QueryBuilder<RepeatVariationMonth, RepeatVariationMonth,
      QAfterFilterCondition> daysElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'days',
        value: value,
      ));
    });
  }

  QueryBuilder<RepeatVariationMonth, RepeatVariationMonth,
      QAfterFilterCondition> daysElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'days',
        value: value,
      ));
    });
  }

  QueryBuilder<RepeatVariationMonth, RepeatVariationMonth,
      QAfterFilterCondition> daysElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'days',
        value: value,
      ));
    });
  }

  QueryBuilder<RepeatVariationMonth, RepeatVariationMonth,
      QAfterFilterCondition> daysElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'days',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RepeatVariationMonth, RepeatVariationMonth,
      QAfterFilterCondition> daysLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'days',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<RepeatVariationMonth, RepeatVariationMonth,
      QAfterFilterCondition> daysIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'days',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<RepeatVariationMonth, RepeatVariationMonth,
      QAfterFilterCondition> daysIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'days',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<RepeatVariationMonth, RepeatVariationMonth,
      QAfterFilterCondition> daysLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'days',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<RepeatVariationMonth, RepeatVariationMonth,
      QAfterFilterCondition> daysLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'days',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<RepeatVariationMonth, RepeatVariationMonth,
      QAfterFilterCondition> daysLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'days',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension RepeatVariationMonthQueryObject on QueryBuilder<RepeatVariationMonth,
    RepeatVariationMonth, QFilterCondition> {}
