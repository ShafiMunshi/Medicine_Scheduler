// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicine_time_schedule.dart';

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const ScheduleDayTimeSchema = Schema(
  name: r'ScheduleDayTime',
  id: 7104214254484627930,
  properties: {
    r'dayTimeName': PropertySchema(
      id: 0,
      name: r'dayTimeName',
      type: IsarType.string,
    ),
    r'timeString': PropertySchema(
      id: 1,
      name: r'timeString',
      type: IsarType.string,
    )
  },
  estimateSize: _scheduleDayTimeEstimateSize,
  serialize: _scheduleDayTimeSerialize,
  deserialize: _scheduleDayTimeDeserialize,
  deserializeProp: _scheduleDayTimeDeserializeProp,
);

int _scheduleDayTimeEstimateSize(
  ScheduleDayTime object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.dayTimeName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.timeString;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _scheduleDayTimeSerialize(
  ScheduleDayTime object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.dayTimeName);
  writer.writeString(offsets[1], object.timeString);
}

ScheduleDayTime _scheduleDayTimeDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ScheduleDayTime(
    dayTimeName: reader.readStringOrNull(offsets[0]),
    timeString: reader.readStringOrNull(offsets[1]),
  );
  return object;
}

P _scheduleDayTimeDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension ScheduleDayTimeQueryFilter
    on QueryBuilder<ScheduleDayTime, ScheduleDayTime, QFilterCondition> {
  QueryBuilder<ScheduleDayTime, ScheduleDayTime, QAfterFilterCondition>
      dayTimeNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dayTimeName',
      ));
    });
  }

  QueryBuilder<ScheduleDayTime, ScheduleDayTime, QAfterFilterCondition>
      dayTimeNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dayTimeName',
      ));
    });
  }

  QueryBuilder<ScheduleDayTime, ScheduleDayTime, QAfterFilterCondition>
      dayTimeNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dayTimeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduleDayTime, ScheduleDayTime, QAfterFilterCondition>
      dayTimeNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dayTimeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduleDayTime, ScheduleDayTime, QAfterFilterCondition>
      dayTimeNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dayTimeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduleDayTime, ScheduleDayTime, QAfterFilterCondition>
      dayTimeNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dayTimeName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduleDayTime, ScheduleDayTime, QAfterFilterCondition>
      dayTimeNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'dayTimeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduleDayTime, ScheduleDayTime, QAfterFilterCondition>
      dayTimeNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'dayTimeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduleDayTime, ScheduleDayTime, QAfterFilterCondition>
      dayTimeNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'dayTimeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduleDayTime, ScheduleDayTime, QAfterFilterCondition>
      dayTimeNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'dayTimeName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduleDayTime, ScheduleDayTime, QAfterFilterCondition>
      dayTimeNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dayTimeName',
        value: '',
      ));
    });
  }

  QueryBuilder<ScheduleDayTime, ScheduleDayTime, QAfterFilterCondition>
      dayTimeNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'dayTimeName',
        value: '',
      ));
    });
  }

  QueryBuilder<ScheduleDayTime, ScheduleDayTime, QAfterFilterCondition>
      timeStringIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'timeString',
      ));
    });
  }

  QueryBuilder<ScheduleDayTime, ScheduleDayTime, QAfterFilterCondition>
      timeStringIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'timeString',
      ));
    });
  }

  QueryBuilder<ScheduleDayTime, ScheduleDayTime, QAfterFilterCondition>
      timeStringEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timeString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduleDayTime, ScheduleDayTime, QAfterFilterCondition>
      timeStringGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'timeString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduleDayTime, ScheduleDayTime, QAfterFilterCondition>
      timeStringLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'timeString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduleDayTime, ScheduleDayTime, QAfterFilterCondition>
      timeStringBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'timeString',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduleDayTime, ScheduleDayTime, QAfterFilterCondition>
      timeStringStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'timeString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduleDayTime, ScheduleDayTime, QAfterFilterCondition>
      timeStringEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'timeString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduleDayTime, ScheduleDayTime, QAfterFilterCondition>
      timeStringContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'timeString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduleDayTime, ScheduleDayTime, QAfterFilterCondition>
      timeStringMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'timeString',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduleDayTime, ScheduleDayTime, QAfterFilterCondition>
      timeStringIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timeString',
        value: '',
      ));
    });
  }

  QueryBuilder<ScheduleDayTime, ScheduleDayTime, QAfterFilterCondition>
      timeStringIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'timeString',
        value: '',
      ));
    });
  }
}

extension ScheduleDayTimeQueryObject
    on QueryBuilder<ScheduleDayTime, ScheduleDayTime, QFilterCondition> {}
