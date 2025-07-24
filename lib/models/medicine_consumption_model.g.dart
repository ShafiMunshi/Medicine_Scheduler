// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicine_consumption_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMedicineConsumeLogModelCollection on Isar {
  IsarCollection<MedicineConsumeLogModel> get medicineConsumeLogModels =>
      this.collection();
}

const MedicineConsumeLogModelSchema = CollectionSchema(
  name: r'MedicineConsumeLogModel',
  id: 6542127843850000500,
  properties: {
    r'actualTakenTime': PropertySchema(
      id: 0,
      name: r'actualTakenTime',
      type: IsarType.dateTime,
    ),
    r'dosageTaken': PropertySchema(
      id: 1,
      name: r'dosageTaken',
      type: IsarType.long,
    ),
    r'medicineId': PropertySchema(
      id: 2,
      name: r'medicineId',
      type: IsarType.long,
    ),
    r'scheduledDateTime': PropertySchema(
      id: 3,
      name: r'scheduledDateTime',
      type: IsarType.dateTime,
    ),
    r'status': PropertySchema(
      id: 4,
      name: r'status',
      type: IsarType.byte,
      enumMap: _MedicineConsumeLogModelstatusEnumValueMap,
    )
  },
  estimateSize: _medicineConsumeLogModelEstimateSize,
  serialize: _medicineConsumeLogModelSerialize,
  deserialize: _medicineConsumeLogModelDeserialize,
  deserializeProp: _medicineConsumeLogModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _medicineConsumeLogModelGetId,
  getLinks: _medicineConsumeLogModelGetLinks,
  attach: _medicineConsumeLogModelAttach,
  version: '3.1.0+1',
);

int _medicineConsumeLogModelEstimateSize(
  MedicineConsumeLogModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _medicineConsumeLogModelSerialize(
  MedicineConsumeLogModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.actualTakenTime);
  writer.writeLong(offsets[1], object.dosageTaken);
  writer.writeLong(offsets[2], object.medicineId);
  writer.writeDateTime(offsets[3], object.scheduledDateTime);
  writer.writeByte(offsets[4], object.status.index);
}

MedicineConsumeLogModel _medicineConsumeLogModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MedicineConsumeLogModel(
    actualTakenTime: reader.readDateTimeOrNull(offsets[0]),
    dosageTaken: reader.readLongOrNull(offsets[1]),
    id: id,
    medicineId: reader.readLong(offsets[2]),
    scheduledDateTime: reader.readDateTime(offsets[3]),
    status: _MedicineConsumeLogModelstatusValueEnumMap[
            reader.readByteOrNull(offsets[4])] ??
        ConsumptionStatus.taken,
  );
  return object;
}

P _medicineConsumeLogModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (_MedicineConsumeLogModelstatusValueEnumMap[
              reader.readByteOrNull(offset)] ??
          ConsumptionStatus.taken) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _MedicineConsumeLogModelstatusEnumValueMap = {
  'taken': 0,
  'skipped': 1,
  'missed': 2,
};
const _MedicineConsumeLogModelstatusValueEnumMap = {
  0: ConsumptionStatus.taken,
  1: ConsumptionStatus.skipped,
  2: ConsumptionStatus.missed,
};

Id _medicineConsumeLogModelGetId(MedicineConsumeLogModel object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _medicineConsumeLogModelGetLinks(
    MedicineConsumeLogModel object) {
  return [];
}

void _medicineConsumeLogModelAttach(
    IsarCollection<dynamic> col, Id id, MedicineConsumeLogModel object) {
  object.id = id;
}

extension MedicineConsumeLogModelQueryWhereSort
    on QueryBuilder<MedicineConsumeLogModel, MedicineConsumeLogModel, QWhere> {
  QueryBuilder<MedicineConsumeLogModel, MedicineConsumeLogModel, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension MedicineConsumeLogModelQueryWhere on QueryBuilder<
    MedicineConsumeLogModel, MedicineConsumeLogModel, QWhereClause> {
  QueryBuilder<MedicineConsumeLogModel, MedicineConsumeLogModel,
      QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<MedicineConsumeLogModel, MedicineConsumeLogModel,
      QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<MedicineConsumeLogModel, MedicineConsumeLogModel,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<MedicineConsumeLogModel, MedicineConsumeLogModel,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<MedicineConsumeLogModel, MedicineConsumeLogModel,
      QAfterWhereClause> idBetween(
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

extension MedicineConsumeLogModelQueryFilter on QueryBuilder<
    MedicineConsumeLogModel, MedicineConsumeLogModel, QFilterCondition> {
  QueryBuilder<MedicineConsumeLogModel, MedicineConsumeLogModel,
      QAfterFilterCondition> actualTakenTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'actualTakenTime',
      ));
    });
  }

  QueryBuilder<MedicineConsumeLogModel, MedicineConsumeLogModel,
      QAfterFilterCondition> actualTakenTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'actualTakenTime',
      ));
    });
  }

  QueryBuilder<MedicineConsumeLogModel, MedicineConsumeLogModel,
      QAfterFilterCondition> actualTakenTimeEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'actualTakenTime',
        value: value,
      ));
    });
  }

  QueryBuilder<MedicineConsumeLogModel, MedicineConsumeLogModel,
      QAfterFilterCondition> actualTakenTimeGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'actualTakenTime',
        value: value,
      ));
    });
  }

  QueryBuilder<MedicineConsumeLogModel, MedicineConsumeLogModel,
      QAfterFilterCondition> actualTakenTimeLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'actualTakenTime',
        value: value,
      ));
    });
  }

  QueryBuilder<MedicineConsumeLogModel, MedicineConsumeLogModel,
      QAfterFilterCondition> actualTakenTimeBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'actualTakenTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MedicineConsumeLogModel, MedicineConsumeLogModel,
      QAfterFilterCondition> dosageTakenIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dosageTaken',
      ));
    });
  }

  QueryBuilder<MedicineConsumeLogModel, MedicineConsumeLogModel,
      QAfterFilterCondition> dosageTakenIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dosageTaken',
      ));
    });
  }

  QueryBuilder<MedicineConsumeLogModel, MedicineConsumeLogModel,
      QAfterFilterCondition> dosageTakenEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dosageTaken',
        value: value,
      ));
    });
  }

  QueryBuilder<MedicineConsumeLogModel, MedicineConsumeLogModel,
      QAfterFilterCondition> dosageTakenGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dosageTaken',
        value: value,
      ));
    });
  }

  QueryBuilder<MedicineConsumeLogModel, MedicineConsumeLogModel,
      QAfterFilterCondition> dosageTakenLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dosageTaken',
        value: value,
      ));
    });
  }

  QueryBuilder<MedicineConsumeLogModel, MedicineConsumeLogModel,
      QAfterFilterCondition> dosageTakenBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dosageTaken',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MedicineConsumeLogModel, MedicineConsumeLogModel,
      QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<MedicineConsumeLogModel, MedicineConsumeLogModel,
      QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<MedicineConsumeLogModel, MedicineConsumeLogModel,
      QAfterFilterCondition> idEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MedicineConsumeLogModel, MedicineConsumeLogModel,
      QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<MedicineConsumeLogModel, MedicineConsumeLogModel,
      QAfterFilterCondition> idLessThan(
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

  QueryBuilder<MedicineConsumeLogModel, MedicineConsumeLogModel,
      QAfterFilterCondition> idBetween(
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

  QueryBuilder<MedicineConsumeLogModel, MedicineConsumeLogModel,
      QAfterFilterCondition> medicineIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'medicineId',
        value: value,
      ));
    });
  }

  QueryBuilder<MedicineConsumeLogModel, MedicineConsumeLogModel,
      QAfterFilterCondition> medicineIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'medicineId',
        value: value,
      ));
    });
  }

  QueryBuilder<MedicineConsumeLogModel, MedicineConsumeLogModel,
      QAfterFilterCondition> medicineIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'medicineId',
        value: value,
      ));
    });
  }

  QueryBuilder<MedicineConsumeLogModel, MedicineConsumeLogModel,
      QAfterFilterCondition> medicineIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'medicineId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MedicineConsumeLogModel, MedicineConsumeLogModel,
      QAfterFilterCondition> scheduledDateTimeEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'scheduledDateTime',
        value: value,
      ));
    });
  }

  QueryBuilder<MedicineConsumeLogModel, MedicineConsumeLogModel,
      QAfterFilterCondition> scheduledDateTimeGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'scheduledDateTime',
        value: value,
      ));
    });
  }

  QueryBuilder<MedicineConsumeLogModel, MedicineConsumeLogModel,
      QAfterFilterCondition> scheduledDateTimeLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'scheduledDateTime',
        value: value,
      ));
    });
  }

  QueryBuilder<MedicineConsumeLogModel, MedicineConsumeLogModel,
      QAfterFilterCondition> scheduledDateTimeBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'scheduledDateTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MedicineConsumeLogModel, MedicineConsumeLogModel,
      QAfterFilterCondition> statusEqualTo(ConsumptionStatus value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<MedicineConsumeLogModel, MedicineConsumeLogModel,
      QAfterFilterCondition> statusGreaterThan(
    ConsumptionStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<MedicineConsumeLogModel, MedicineConsumeLogModel,
      QAfterFilterCondition> statusLessThan(
    ConsumptionStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<MedicineConsumeLogModel, MedicineConsumeLogModel,
      QAfterFilterCondition> statusBetween(
    ConsumptionStatus lower,
    ConsumptionStatus upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'status',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension MedicineConsumeLogModelQueryObject on QueryBuilder<
    MedicineConsumeLogModel, MedicineConsumeLogModel, QFilterCondition> {}

extension MedicineConsumeLogModelQueryLinks on QueryBuilder<
    MedicineConsumeLogModel, MedicineConsumeLogModel, QFilterCondition> {}

extension MedicineConsumeLogModelQuerySortBy
    on QueryBuilder<MedicineConsumeLogModel, MedicineConsumeLogModel, QSortBy> {
  QueryBuilder<MedicineConsumeLogModel, MedicineConsumeLogModel, QAfterSortBy>
      sortByActualTakenTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actualTakenTime', Sort.asc);
    });
  }

  QueryBuilder<MedicineConsumeLogModel, MedicineConsumeLogModel, QAfterSortBy>
      sortByActualTakenTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actualTakenTime', Sort.desc);
    });
  }

  QueryBuilder<MedicineConsumeLogModel, MedicineConsumeLogModel, QAfterSortBy>
      sortByDosageTaken() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dosageTaken', Sort.asc);
    });
  }

  QueryBuilder<MedicineConsumeLogModel, MedicineConsumeLogModel, QAfterSortBy>
      sortByDosageTakenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dosageTaken', Sort.desc);
    });
  }

  QueryBuilder<MedicineConsumeLogModel, MedicineConsumeLogModel, QAfterSortBy>
      sortByMedicineId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'medicineId', Sort.asc);
    });
  }

  QueryBuilder<MedicineConsumeLogModel, MedicineConsumeLogModel, QAfterSortBy>
      sortByMedicineIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'medicineId', Sort.desc);
    });
  }

  QueryBuilder<MedicineConsumeLogModel, MedicineConsumeLogModel, QAfterSortBy>
      sortByScheduledDateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledDateTime', Sort.asc);
    });
  }

  QueryBuilder<MedicineConsumeLogModel, MedicineConsumeLogModel, QAfterSortBy>
      sortByScheduledDateTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledDateTime', Sort.desc);
    });
  }

  QueryBuilder<MedicineConsumeLogModel, MedicineConsumeLogModel, QAfterSortBy>
      sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<MedicineConsumeLogModel, MedicineConsumeLogModel, QAfterSortBy>
      sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }
}

extension MedicineConsumeLogModelQuerySortThenBy on QueryBuilder<
    MedicineConsumeLogModel, MedicineConsumeLogModel, QSortThenBy> {
  QueryBuilder<MedicineConsumeLogModel, MedicineConsumeLogModel, QAfterSortBy>
      thenByActualTakenTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actualTakenTime', Sort.asc);
    });
  }

  QueryBuilder<MedicineConsumeLogModel, MedicineConsumeLogModel, QAfterSortBy>
      thenByActualTakenTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actualTakenTime', Sort.desc);
    });
  }

  QueryBuilder<MedicineConsumeLogModel, MedicineConsumeLogModel, QAfterSortBy>
      thenByDosageTaken() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dosageTaken', Sort.asc);
    });
  }

  QueryBuilder<MedicineConsumeLogModel, MedicineConsumeLogModel, QAfterSortBy>
      thenByDosageTakenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dosageTaken', Sort.desc);
    });
  }

  QueryBuilder<MedicineConsumeLogModel, MedicineConsumeLogModel, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MedicineConsumeLogModel, MedicineConsumeLogModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MedicineConsumeLogModel, MedicineConsumeLogModel, QAfterSortBy>
      thenByMedicineId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'medicineId', Sort.asc);
    });
  }

  QueryBuilder<MedicineConsumeLogModel, MedicineConsumeLogModel, QAfterSortBy>
      thenByMedicineIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'medicineId', Sort.desc);
    });
  }

  QueryBuilder<MedicineConsumeLogModel, MedicineConsumeLogModel, QAfterSortBy>
      thenByScheduledDateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledDateTime', Sort.asc);
    });
  }

  QueryBuilder<MedicineConsumeLogModel, MedicineConsumeLogModel, QAfterSortBy>
      thenByScheduledDateTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledDateTime', Sort.desc);
    });
  }

  QueryBuilder<MedicineConsumeLogModel, MedicineConsumeLogModel, QAfterSortBy>
      thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<MedicineConsumeLogModel, MedicineConsumeLogModel, QAfterSortBy>
      thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }
}

extension MedicineConsumeLogModelQueryWhereDistinct on QueryBuilder<
    MedicineConsumeLogModel, MedicineConsumeLogModel, QDistinct> {
  QueryBuilder<MedicineConsumeLogModel, MedicineConsumeLogModel, QDistinct>
      distinctByActualTakenTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'actualTakenTime');
    });
  }

  QueryBuilder<MedicineConsumeLogModel, MedicineConsumeLogModel, QDistinct>
      distinctByDosageTaken() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dosageTaken');
    });
  }

  QueryBuilder<MedicineConsumeLogModel, MedicineConsumeLogModel, QDistinct>
      distinctByMedicineId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'medicineId');
    });
  }

  QueryBuilder<MedicineConsumeLogModel, MedicineConsumeLogModel, QDistinct>
      distinctByScheduledDateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'scheduledDateTime');
    });
  }

  QueryBuilder<MedicineConsumeLogModel, MedicineConsumeLogModel, QDistinct>
      distinctByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status');
    });
  }
}

extension MedicineConsumeLogModelQueryProperty on QueryBuilder<
    MedicineConsumeLogModel, MedicineConsumeLogModel, QQueryProperty> {
  QueryBuilder<MedicineConsumeLogModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<MedicineConsumeLogModel, DateTime?, QQueryOperations>
      actualTakenTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'actualTakenTime');
    });
  }

  QueryBuilder<MedicineConsumeLogModel, int?, QQueryOperations>
      dosageTakenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dosageTaken');
    });
  }

  QueryBuilder<MedicineConsumeLogModel, int, QQueryOperations>
      medicineIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'medicineId');
    });
  }

  QueryBuilder<MedicineConsumeLogModel, DateTime, QQueryOperations>
      scheduledDateTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'scheduledDateTime');
    });
  }

  QueryBuilder<MedicineConsumeLogModel, ConsumptionStatus, QQueryOperations>
      statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }
}
