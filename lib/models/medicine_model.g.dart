// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicine_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMedicineModelCollection on Isar {
  IsarCollection<MedicineModel> get medicineModels => this.collection();
}

const MedicineModelSchema = CollectionSchema(
  name: r'MedicineModel',
  id: 2197460021641310300,
  properties: {
    r'availableQuantity': PropertySchema(
      id: 0,
      name: r'availableQuantity',
      type: IsarType.long,
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'dosage': PropertySchema(
      id: 2,
      name: r'dosage',
      type: IsarType.long,
    ),
    r'dosageUnit': PropertySchema(
      id: 3,
      name: r'dosageUnit',
      type: IsarType.byte,
      enumMap: _MedicineModeldosageUnitEnumValueMap,
    ),
    r'endDate': PropertySchema(
      id: 4,
      name: r'endDate',
      type: IsarType.dateTime,
    ),
    r'finalScheduleDates': PropertySchema(
      id: 5,
      name: r'finalScheduleDates',
      type: IsarType.dateTimeList,
    ),
    r'imagePath': PropertySchema(
      id: 6,
      name: r'imagePath',
      type: IsarType.string,
    ),
    r'mealTiming': PropertySchema(
      id: 7,
      name: r'mealTiming',
      type: IsarType.byte,
      enumMap: _MedicineModelmealTimingEnumValueMap,
    ),
    r'medicineName': PropertySchema(
      id: 8,
      name: r'medicineName',
      type: IsarType.string,
    ),
    r'medicineScheduleList': PropertySchema(
      id: 9,
      name: r'medicineScheduleList',
      type: IsarType.objectList,
      target: r'ScheduleDayTime',
    ),
    r'modifiedAt': PropertySchema(
      id: 10,
      name: r'modifiedAt',
      type: IsarType.dateTime,
    ),
    r'repeatVariation': PropertySchema(
      id: 11,
      name: r'repeatVariation',
      type: IsarType.byte,
      enumMap: _MedicineModelrepeatVariationEnumValueMap,
    ),
    r'repeatVariationDays': PropertySchema(
      id: 12,
      name: r'repeatVariationDays',
      type: IsarType.object,
      target: r'RepeatVariationDays',
    ),
    r'repeatVariationMonth': PropertySchema(
      id: 13,
      name: r'repeatVariationMonth',
      type: IsarType.object,
      target: r'RepeatVariationMonth',
    ),
    r'repeatVariationTime': PropertySchema(
      id: 14,
      name: r'repeatVariationTime',
      type: IsarType.object,
      target: r'RepeatVariationTimes',
    ),
    r'repeatVariationWeek': PropertySchema(
      id: 15,
      name: r'repeatVariationWeek',
      type: IsarType.object,
      target: r'RepeatVariationWeek',
    ),
    r'startDate': PropertySchema(
      id: 16,
      name: r'startDate',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _medicineModelEstimateSize,
  serialize: _medicineModelSerialize,
  deserialize: _medicineModelDeserialize,
  deserializeProp: _medicineModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {
    r'RepeatVariationDays': RepeatVariationDaysSchema,
    r'RepeatVariationWeek': RepeatVariationWeekSchema,
    r'RepeatVariationMonth': RepeatVariationMonthSchema,
    r'RepeatVariationTimes': RepeatVariationTimesSchema,
    r'ScheduleDayTime': ScheduleDayTimeSchema
  },
  getId: _medicineModelGetId,
  getLinks: _medicineModelGetLinks,
  attach: _medicineModelAttach,
  version: '3.1.0+1',
);

int _medicineModelEstimateSize(
  MedicineModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.finalScheduleDates;
    if (value != null) {
      bytesCount += 3 + value.length * 8;
    }
  }
  {
    final value = object.imagePath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.medicineName.length * 3;
  {
    final list = object.medicineScheduleList;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[ScheduleDayTime]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount +=
              ScheduleDayTimeSchema.estimateSize(value, offsets, allOffsets);
        }
      }
    }
  }
  {
    final value = object.repeatVariationDays;
    if (value != null) {
      bytesCount += 3 +
          RepeatVariationDaysSchema.estimateSize(
              value, allOffsets[RepeatVariationDays]!, allOffsets);
    }
  }
  {
    final value = object.repeatVariationMonth;
    if (value != null) {
      bytesCount += 3 +
          RepeatVariationMonthSchema.estimateSize(
              value, allOffsets[RepeatVariationMonth]!, allOffsets);
    }
  }
  {
    final value = object.repeatVariationTime;
    if (value != null) {
      bytesCount += 3 +
          RepeatVariationTimesSchema.estimateSize(
              value, allOffsets[RepeatVariationTimes]!, allOffsets);
    }
  }
  {
    final value = object.repeatVariationWeek;
    if (value != null) {
      bytesCount += 3 +
          RepeatVariationWeekSchema.estimateSize(
              value, allOffsets[RepeatVariationWeek]!, allOffsets);
    }
  }
  return bytesCount;
}

void _medicineModelSerialize(
  MedicineModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.availableQuantity);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeLong(offsets[2], object.dosage);
  writer.writeByte(offsets[3], object.dosageUnit.index);
  writer.writeDateTime(offsets[4], object.endDate);
  writer.writeDateTimeList(offsets[5], object.finalScheduleDates);
  writer.writeString(offsets[6], object.imagePath);
  writer.writeByte(offsets[7], object.mealTiming.index);
  writer.writeString(offsets[8], object.medicineName);
  writer.writeObjectList<ScheduleDayTime>(
    offsets[9],
    allOffsets,
    ScheduleDayTimeSchema.serialize,
    object.medicineScheduleList,
  );
  writer.writeDateTime(offsets[10], object.modifiedAt);
  writer.writeByte(offsets[11], object.repeatVariation.index);
  writer.writeObject<RepeatVariationDays>(
    offsets[12],
    allOffsets,
    RepeatVariationDaysSchema.serialize,
    object.repeatVariationDays,
  );
  writer.writeObject<RepeatVariationMonth>(
    offsets[13],
    allOffsets,
    RepeatVariationMonthSchema.serialize,
    object.repeatVariationMonth,
  );
  writer.writeObject<RepeatVariationTimes>(
    offsets[14],
    allOffsets,
    RepeatVariationTimesSchema.serialize,
    object.repeatVariationTime,
  );
  writer.writeObject<RepeatVariationWeek>(
    offsets[15],
    allOffsets,
    RepeatVariationWeekSchema.serialize,
    object.repeatVariationWeek,
  );
  writer.writeDateTime(offsets[16], object.startDate);
}

MedicineModel _medicineModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MedicineModel(
    availableQuantity: reader.readLong(offsets[0]),
    createdAt: reader.readDateTime(offsets[1]),
    dosage: reader.readLong(offsets[2]),
    dosageUnit: _MedicineModeldosageUnitValueEnumMap[
            reader.readByteOrNull(offsets[3])] ??
        DosageUnit.pcs,
    endDate: reader.readDateTimeOrNull(offsets[4]),
    finalScheduleDates: reader.readDateTimeList(offsets[5]),
    id: id,
    imagePath: reader.readStringOrNull(offsets[6]),
    mealTiming: _MedicineModelmealTimingValueEnumMap[
            reader.readByteOrNull(offsets[7])] ??
        MealTiming.before,
    medicineName: reader.readString(offsets[8]),
    medicineScheduleList: reader.readObjectList<ScheduleDayTime>(
      offsets[9],
      ScheduleDayTimeSchema.deserialize,
      allOffsets,
      ScheduleDayTime(),
    ),
    modifiedAt: reader.readDateTime(offsets[10]),
    repeatVariation: _MedicineModelrepeatVariationValueEnumMap[
            reader.readByteOrNull(offsets[11])] ??
        RepeatVariation.timely,
    repeatVariationDays: reader.readObjectOrNull<RepeatVariationDays>(
      offsets[12],
      RepeatVariationDaysSchema.deserialize,
      allOffsets,
    ),
    repeatVariationMonth: reader.readObjectOrNull<RepeatVariationMonth>(
      offsets[13],
      RepeatVariationMonthSchema.deserialize,
      allOffsets,
    ),
    repeatVariationTime: reader.readObjectOrNull<RepeatVariationTimes>(
      offsets[14],
      RepeatVariationTimesSchema.deserialize,
      allOffsets,
    ),
    repeatVariationWeek: reader.readObjectOrNull<RepeatVariationWeek>(
      offsets[15],
      RepeatVariationWeekSchema.deserialize,
      allOffsets,
    ),
    startDate: reader.readDateTime(offsets[16]),
  );
  return object;
}

P _medicineModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (_MedicineModeldosageUnitValueEnumMap[
              reader.readByteOrNull(offset)] ??
          DosageUnit.pcs) as P;
    case 4:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 5:
      return (reader.readDateTimeList(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (_MedicineModelmealTimingValueEnumMap[
              reader.readByteOrNull(offset)] ??
          MealTiming.before) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readObjectList<ScheduleDayTime>(
        offset,
        ScheduleDayTimeSchema.deserialize,
        allOffsets,
        ScheduleDayTime(),
      )) as P;
    case 10:
      return (reader.readDateTime(offset)) as P;
    case 11:
      return (_MedicineModelrepeatVariationValueEnumMap[
              reader.readByteOrNull(offset)] ??
          RepeatVariation.timely) as P;
    case 12:
      return (reader.readObjectOrNull<RepeatVariationDays>(
        offset,
        RepeatVariationDaysSchema.deserialize,
        allOffsets,
      )) as P;
    case 13:
      return (reader.readObjectOrNull<RepeatVariationMonth>(
        offset,
        RepeatVariationMonthSchema.deserialize,
        allOffsets,
      )) as P;
    case 14:
      return (reader.readObjectOrNull<RepeatVariationTimes>(
        offset,
        RepeatVariationTimesSchema.deserialize,
        allOffsets,
      )) as P;
    case 15:
      return (reader.readObjectOrNull<RepeatVariationWeek>(
        offset,
        RepeatVariationWeekSchema.deserialize,
        allOffsets,
      )) as P;
    case 16:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _MedicineModeldosageUnitEnumValueMap = {
  'pcs': 0,
  'cup': 1,
};
const _MedicineModeldosageUnitValueEnumMap = {
  0: DosageUnit.pcs,
  1: DosageUnit.cup,
};
const _MedicineModelmealTimingEnumValueMap = {
  'before': 0,
  'after': 1,
};
const _MedicineModelmealTimingValueEnumMap = {
  0: MealTiming.before,
  1: MealTiming.after,
};
const _MedicineModelrepeatVariationEnumValueMap = {
  'timely': 0,
  'day': 1,
  'weekly': 2,
  'monthly': 3,
};
const _MedicineModelrepeatVariationValueEnumMap = {
  0: RepeatVariation.timely,
  1: RepeatVariation.day,
  2: RepeatVariation.weekly,
  3: RepeatVariation.monthly,
};

Id _medicineModelGetId(MedicineModel object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _medicineModelGetLinks(MedicineModel object) {
  return [];
}

void _medicineModelAttach(
    IsarCollection<dynamic> col, Id id, MedicineModel object) {
  object.id = id;
}

extension MedicineModelQueryWhereSort
    on QueryBuilder<MedicineModel, MedicineModel, QWhere> {
  QueryBuilder<MedicineModel, MedicineModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension MedicineModelQueryWhere
    on QueryBuilder<MedicineModel, MedicineModel, QWhereClause> {
  QueryBuilder<MedicineModel, MedicineModel, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<MedicineModel, MedicineModel, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterWhereClause> idBetween(
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

extension MedicineModelQueryFilter
    on QueryBuilder<MedicineModel, MedicineModel, QFilterCondition> {
  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      availableQuantityEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'availableQuantity',
        value: value,
      ));
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      availableQuantityGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'availableQuantity',
        value: value,
      ));
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      availableQuantityLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'availableQuantity',
        value: value,
      ));
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      availableQuantityBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'availableQuantity',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
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

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      createdAtLessThan(
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

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      createdAtBetween(
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

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      dosageEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dosage',
        value: value,
      ));
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      dosageGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dosage',
        value: value,
      ));
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      dosageLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dosage',
        value: value,
      ));
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      dosageBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dosage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      dosageUnitEqualTo(DosageUnit value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dosageUnit',
        value: value,
      ));
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      dosageUnitGreaterThan(
    DosageUnit value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dosageUnit',
        value: value,
      ));
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      dosageUnitLessThan(
    DosageUnit value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dosageUnit',
        value: value,
      ));
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      dosageUnitBetween(
    DosageUnit lower,
    DosageUnit upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dosageUnit',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      endDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'endDate',
      ));
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      endDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'endDate',
      ));
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      endDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endDate',
        value: value,
      ));
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      endDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'endDate',
        value: value,
      ));
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      endDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'endDate',
        value: value,
      ));
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      endDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'endDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      finalScheduleDatesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'finalScheduleDates',
      ));
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      finalScheduleDatesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'finalScheduleDates',
      ));
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      finalScheduleDatesElementEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'finalScheduleDates',
        value: value,
      ));
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      finalScheduleDatesElementGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'finalScheduleDates',
        value: value,
      ));
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      finalScheduleDatesElementLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'finalScheduleDates',
        value: value,
      ));
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      finalScheduleDatesElementBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'finalScheduleDates',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      finalScheduleDatesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'finalScheduleDates',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      finalScheduleDatesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'finalScheduleDates',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      finalScheduleDatesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'finalScheduleDates',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      finalScheduleDatesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'finalScheduleDates',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      finalScheduleDatesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'finalScheduleDates',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      finalScheduleDatesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'finalScheduleDates',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition> idEqualTo(
      Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      idGreaterThan(
    Id? value, {
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

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition> idLessThan(
    Id? value, {
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

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition> idBetween(
    Id? lower,
    Id? upper, {
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

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      imagePathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'imagePath',
      ));
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      imagePathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'imagePath',
      ));
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      imagePathEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      imagePathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      imagePathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      imagePathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'imagePath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      imagePathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      imagePathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      imagePathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      imagePathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'imagePath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      imagePathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imagePath',
        value: '',
      ));
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      imagePathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'imagePath',
        value: '',
      ));
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      mealTimingEqualTo(MealTiming value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mealTiming',
        value: value,
      ));
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      mealTimingGreaterThan(
    MealTiming value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mealTiming',
        value: value,
      ));
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      mealTimingLessThan(
    MealTiming value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mealTiming',
        value: value,
      ));
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      mealTimingBetween(
    MealTiming lower,
    MealTiming upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mealTiming',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      medicineNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'medicineName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      medicineNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'medicineName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      medicineNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'medicineName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      medicineNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'medicineName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      medicineNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'medicineName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      medicineNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'medicineName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      medicineNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'medicineName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      medicineNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'medicineName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      medicineNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'medicineName',
        value: '',
      ));
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      medicineNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'medicineName',
        value: '',
      ));
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      medicineScheduleListIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'medicineScheduleList',
      ));
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      medicineScheduleListIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'medicineScheduleList',
      ));
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      medicineScheduleListLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'medicineScheduleList',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      medicineScheduleListIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'medicineScheduleList',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      medicineScheduleListIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'medicineScheduleList',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      medicineScheduleListLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'medicineScheduleList',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      medicineScheduleListLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'medicineScheduleList',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      medicineScheduleListLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'medicineScheduleList',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      modifiedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'modifiedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      modifiedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'modifiedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      modifiedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'modifiedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      modifiedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'modifiedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      repeatVariationEqualTo(RepeatVariation value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'repeatVariation',
        value: value,
      ));
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      repeatVariationGreaterThan(
    RepeatVariation value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'repeatVariation',
        value: value,
      ));
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      repeatVariationLessThan(
    RepeatVariation value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'repeatVariation',
        value: value,
      ));
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      repeatVariationBetween(
    RepeatVariation lower,
    RepeatVariation upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'repeatVariation',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      repeatVariationDaysIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'repeatVariationDays',
      ));
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      repeatVariationDaysIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'repeatVariationDays',
      ));
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      repeatVariationMonthIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'repeatVariationMonth',
      ));
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      repeatVariationMonthIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'repeatVariationMonth',
      ));
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      repeatVariationTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'repeatVariationTime',
      ));
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      repeatVariationTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'repeatVariationTime',
      ));
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      repeatVariationWeekIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'repeatVariationWeek',
      ));
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      repeatVariationWeekIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'repeatVariationWeek',
      ));
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      startDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startDate',
        value: value,
      ));
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      startDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startDate',
        value: value,
      ));
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      startDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startDate',
        value: value,
      ));
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      startDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension MedicineModelQueryObject
    on QueryBuilder<MedicineModel, MedicineModel, QFilterCondition> {
  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      medicineScheduleListElement(FilterQuery<ScheduleDayTime> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'medicineScheduleList');
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      repeatVariationDays(FilterQuery<RepeatVariationDays> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'repeatVariationDays');
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      repeatVariationMonth(FilterQuery<RepeatVariationMonth> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'repeatVariationMonth');
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      repeatVariationTime(FilterQuery<RepeatVariationTimes> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'repeatVariationTime');
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterFilterCondition>
      repeatVariationWeek(FilterQuery<RepeatVariationWeek> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'repeatVariationWeek');
    });
  }
}

extension MedicineModelQueryLinks
    on QueryBuilder<MedicineModel, MedicineModel, QFilterCondition> {}

extension MedicineModelQuerySortBy
    on QueryBuilder<MedicineModel, MedicineModel, QSortBy> {
  QueryBuilder<MedicineModel, MedicineModel, QAfterSortBy>
      sortByAvailableQuantity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'availableQuantity', Sort.asc);
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterSortBy>
      sortByAvailableQuantityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'availableQuantity', Sort.desc);
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterSortBy> sortByDosage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dosage', Sort.asc);
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterSortBy> sortByDosageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dosage', Sort.desc);
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterSortBy> sortByDosageUnit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dosageUnit', Sort.asc);
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterSortBy>
      sortByDosageUnitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dosageUnit', Sort.desc);
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterSortBy> sortByEndDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endDate', Sort.asc);
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterSortBy> sortByEndDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endDate', Sort.desc);
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterSortBy> sortByImagePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagePath', Sort.asc);
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterSortBy>
      sortByImagePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagePath', Sort.desc);
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterSortBy> sortByMealTiming() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mealTiming', Sort.asc);
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterSortBy>
      sortByMealTimingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mealTiming', Sort.desc);
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterSortBy>
      sortByMedicineName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'medicineName', Sort.asc);
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterSortBy>
      sortByMedicineNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'medicineName', Sort.desc);
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterSortBy> sortByModifiedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modifiedAt', Sort.asc);
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterSortBy>
      sortByModifiedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modifiedAt', Sort.desc);
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterSortBy>
      sortByRepeatVariation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repeatVariation', Sort.asc);
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterSortBy>
      sortByRepeatVariationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repeatVariation', Sort.desc);
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterSortBy> sortByStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.asc);
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterSortBy>
      sortByStartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.desc);
    });
  }
}

extension MedicineModelQuerySortThenBy
    on QueryBuilder<MedicineModel, MedicineModel, QSortThenBy> {
  QueryBuilder<MedicineModel, MedicineModel, QAfterSortBy>
      thenByAvailableQuantity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'availableQuantity', Sort.asc);
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterSortBy>
      thenByAvailableQuantityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'availableQuantity', Sort.desc);
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterSortBy> thenByDosage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dosage', Sort.asc);
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterSortBy> thenByDosageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dosage', Sort.desc);
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterSortBy> thenByDosageUnit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dosageUnit', Sort.asc);
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterSortBy>
      thenByDosageUnitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dosageUnit', Sort.desc);
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterSortBy> thenByEndDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endDate', Sort.asc);
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterSortBy> thenByEndDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endDate', Sort.desc);
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterSortBy> thenByImagePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagePath', Sort.asc);
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterSortBy>
      thenByImagePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagePath', Sort.desc);
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterSortBy> thenByMealTiming() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mealTiming', Sort.asc);
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterSortBy>
      thenByMealTimingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mealTiming', Sort.desc);
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterSortBy>
      thenByMedicineName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'medicineName', Sort.asc);
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterSortBy>
      thenByMedicineNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'medicineName', Sort.desc);
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterSortBy> thenByModifiedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modifiedAt', Sort.asc);
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterSortBy>
      thenByModifiedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modifiedAt', Sort.desc);
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterSortBy>
      thenByRepeatVariation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repeatVariation', Sort.asc);
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterSortBy>
      thenByRepeatVariationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repeatVariation', Sort.desc);
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterSortBy> thenByStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.asc);
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QAfterSortBy>
      thenByStartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.desc);
    });
  }
}

extension MedicineModelQueryWhereDistinct
    on QueryBuilder<MedicineModel, MedicineModel, QDistinct> {
  QueryBuilder<MedicineModel, MedicineModel, QDistinct>
      distinctByAvailableQuantity() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'availableQuantity');
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QDistinct> distinctByDosage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dosage');
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QDistinct> distinctByDosageUnit() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dosageUnit');
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QDistinct> distinctByEndDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'endDate');
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QDistinct>
      distinctByFinalScheduleDates() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'finalScheduleDates');
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QDistinct> distinctByImagePath(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'imagePath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QDistinct> distinctByMealTiming() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mealTiming');
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QDistinct> distinctByMedicineName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'medicineName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QDistinct> distinctByModifiedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'modifiedAt');
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QDistinct>
      distinctByRepeatVariation() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'repeatVariation');
    });
  }

  QueryBuilder<MedicineModel, MedicineModel, QDistinct> distinctByStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startDate');
    });
  }
}

extension MedicineModelQueryProperty
    on QueryBuilder<MedicineModel, MedicineModel, QQueryProperty> {
  QueryBuilder<MedicineModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<MedicineModel, int, QQueryOperations>
      availableQuantityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'availableQuantity');
    });
  }

  QueryBuilder<MedicineModel, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<MedicineModel, int, QQueryOperations> dosageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dosage');
    });
  }

  QueryBuilder<MedicineModel, DosageUnit, QQueryOperations>
      dosageUnitProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dosageUnit');
    });
  }

  QueryBuilder<MedicineModel, DateTime?, QQueryOperations> endDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'endDate');
    });
  }

  QueryBuilder<MedicineModel, List<DateTime>?, QQueryOperations>
      finalScheduleDatesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'finalScheduleDates');
    });
  }

  QueryBuilder<MedicineModel, String?, QQueryOperations> imagePathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'imagePath');
    });
  }

  QueryBuilder<MedicineModel, MealTiming, QQueryOperations>
      mealTimingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mealTiming');
    });
  }

  QueryBuilder<MedicineModel, String, QQueryOperations> medicineNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'medicineName');
    });
  }

  QueryBuilder<MedicineModel, List<ScheduleDayTime>?, QQueryOperations>
      medicineScheduleListProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'medicineScheduleList');
    });
  }

  QueryBuilder<MedicineModel, DateTime, QQueryOperations> modifiedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'modifiedAt');
    });
  }

  QueryBuilder<MedicineModel, RepeatVariation, QQueryOperations>
      repeatVariationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'repeatVariation');
    });
  }

  QueryBuilder<MedicineModel, RepeatVariationDays?, QQueryOperations>
      repeatVariationDaysProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'repeatVariationDays');
    });
  }

  QueryBuilder<MedicineModel, RepeatVariationMonth?, QQueryOperations>
      repeatVariationMonthProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'repeatVariationMonth');
    });
  }

  QueryBuilder<MedicineModel, RepeatVariationTimes?, QQueryOperations>
      repeatVariationTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'repeatVariationTime');
    });
  }

  QueryBuilder<MedicineModel, RepeatVariationWeek?, QQueryOperations>
      repeatVariationWeekProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'repeatVariationWeek');
    });
  }

  QueryBuilder<MedicineModel, DateTime, QQueryOperations> startDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startDate');
    });
  }
}
