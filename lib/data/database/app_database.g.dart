// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $MedicinesTable extends Medicines
    with TableInfo<$MedicinesTable, Medicine> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _medicineNameMeta =
      const VerificationMeta('medicineName');
  @override
  late final GeneratedColumn<String> medicineName = GeneratedColumn<String>(
      'medicine_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _imagePathMeta =
      const VerificationMeta('imagePath');
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
      'image_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dosageMeta = const VerificationMeta('dosage');
  @override
  late final GeneratedColumn<int> dosage = GeneratedColumn<int>(
      'dosage', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _dosageUnitMeta =
      const VerificationMeta('dosageUnit');
  @override
  late final GeneratedColumn<String> dosageUnit = GeneratedColumn<String>(
      'dosage_unit', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _availableQuantityMeta =
      const VerificationMeta('availableQuantity');
  @override
  late final GeneratedColumn<int> availableQuantity = GeneratedColumn<int>(
      'available_quantity', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _mealTimingMeta =
      const VerificationMeta('mealTiming');
  @override
  late final GeneratedColumn<String> mealTiming = GeneratedColumn<String>(
      'meal_timing', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _repeatVariationMeta =
      const VerificationMeta('repeatVariation');
  @override
  late final GeneratedColumn<String> repeatVariation = GeneratedColumn<String>(
      'repeat_variation', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _repeatDaysMeta =
      const VerificationMeta('repeatDays');
  @override
  late final GeneratedColumn<int> repeatDays = GeneratedColumn<int>(
      'repeat_days', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _repeatWeekDaysMeta =
      const VerificationMeta('repeatWeekDays');
  @override
  late final GeneratedColumn<String> repeatWeekDays = GeneratedColumn<String>(
      'repeat_week_days', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _repeatMonthDaysMeta =
      const VerificationMeta('repeatMonthDays');
  @override
  late final GeneratedColumn<String> repeatMonthDays = GeneratedColumn<String>(
      'repeat_month_days', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _startDateMeta =
      const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
      'start_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _endDateMeta =
      const VerificationMeta('endDate');
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
      'end_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _medicineTakenCountMeta =
      const VerificationMeta('medicineTakenCount');
  @override
  late final GeneratedColumn<int> medicineTakenCount = GeneratedColumn<int>(
      'medicine_taken_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _modifiedAtMeta =
      const VerificationMeta('modifiedAt');
  @override
  late final GeneratedColumn<DateTime> modifiedAt = GeneratedColumn<DateTime>(
      'modified_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        medicineName,
        imagePath,
        dosage,
        dosageUnit,
        availableQuantity,
        mealTiming,
        repeatVariation,
        repeatDays,
        repeatWeekDays,
        repeatMonthDays,
        startDate,
        endDate,
        medicineTakenCount,
        createdAt,
        modifiedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medicines';
  @override
  VerificationContext validateIntegrity(Insertable<Medicine> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('medicine_name')) {
      context.handle(
          _medicineNameMeta,
          medicineName.isAcceptableOrUnknown(
              data['medicine_name']!, _medicineNameMeta));
    } else if (isInserting) {
      context.missing(_medicineNameMeta);
    }
    if (data.containsKey('image_path')) {
      context.handle(_imagePathMeta,
          imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta));
    }
    if (data.containsKey('dosage')) {
      context.handle(_dosageMeta,
          dosage.isAcceptableOrUnknown(data['dosage']!, _dosageMeta));
    }
    if (data.containsKey('dosage_unit')) {
      context.handle(
          _dosageUnitMeta,
          dosageUnit.isAcceptableOrUnknown(
              data['dosage_unit']!, _dosageUnitMeta));
    } else if (isInserting) {
      context.missing(_dosageUnitMeta);
    }
    if (data.containsKey('available_quantity')) {
      context.handle(
          _availableQuantityMeta,
          availableQuantity.isAcceptableOrUnknown(
              data['available_quantity']!, _availableQuantityMeta));
    }
    if (data.containsKey('meal_timing')) {
      context.handle(
          _mealTimingMeta,
          mealTiming.isAcceptableOrUnknown(
              data['meal_timing']!, _mealTimingMeta));
    } else if (isInserting) {
      context.missing(_mealTimingMeta);
    }
    if (data.containsKey('repeat_variation')) {
      context.handle(
          _repeatVariationMeta,
          repeatVariation.isAcceptableOrUnknown(
              data['repeat_variation']!, _repeatVariationMeta));
    } else if (isInserting) {
      context.missing(_repeatVariationMeta);
    }
    if (data.containsKey('repeat_days')) {
      context.handle(
          _repeatDaysMeta,
          repeatDays.isAcceptableOrUnknown(
              data['repeat_days']!, _repeatDaysMeta));
    }
    if (data.containsKey('repeat_week_days')) {
      context.handle(
          _repeatWeekDaysMeta,
          repeatWeekDays.isAcceptableOrUnknown(
              data['repeat_week_days']!, _repeatWeekDaysMeta));
    }
    if (data.containsKey('repeat_month_days')) {
      context.handle(
          _repeatMonthDaysMeta,
          repeatMonthDays.isAcceptableOrUnknown(
              data['repeat_month_days']!, _repeatMonthDaysMeta));
    }
    if (data.containsKey('start_date')) {
      context.handle(_startDateMeta,
          startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta));
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(_endDateMeta,
          endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta));
    } else if (isInserting) {
      context.missing(_endDateMeta);
    }
    if (data.containsKey('medicine_taken_count')) {
      context.handle(
          _medicineTakenCountMeta,
          medicineTakenCount.isAcceptableOrUnknown(
              data['medicine_taken_count']!, _medicineTakenCountMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('modified_at')) {
      context.handle(
          _modifiedAtMeta,
          modifiedAt.isAcceptableOrUnknown(
              data['modified_at']!, _modifiedAtMeta));
    } else if (isInserting) {
      context.missing(_modifiedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Medicine map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Medicine(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      medicineName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}medicine_name'])!,
      imagePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_path']),
      dosage: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}dosage'])!,
      dosageUnit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}dosage_unit'])!,
      availableQuantity: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}available_quantity'])!,
      mealTiming: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}meal_timing'])!,
      repeatVariation: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}repeat_variation'])!,
      repeatDays: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}repeat_days']),
      repeatWeekDays: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}repeat_week_days']),
      repeatMonthDays: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}repeat_month_days']),
      startDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_date'])!,
      endDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}end_date'])!,
      medicineTakenCount: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}medicine_taken_count'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      modifiedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}modified_at'])!,
    );
  }

  @override
  $MedicinesTable createAlias(String alias) {
    return $MedicinesTable(attachedDatabase, alias);
  }
}

class Medicine extends DataClass implements Insertable<Medicine> {
  final int id;
  final String medicineName;
  final String? imagePath;
  final int dosage;
  final String dosageUnit;
  final int availableQuantity;
  final String mealTiming;
  final String repeatVariation;
  final int? repeatDays;
  final String? repeatWeekDays;
  final String? repeatMonthDays;
  final DateTime startDate;
  final DateTime endDate;
  final int medicineTakenCount;
  final DateTime createdAt;
  final DateTime modifiedAt;
  const Medicine(
      {required this.id,
      required this.medicineName,
      this.imagePath,
      required this.dosage,
      required this.dosageUnit,
      required this.availableQuantity,
      required this.mealTiming,
      required this.repeatVariation,
      this.repeatDays,
      this.repeatWeekDays,
      this.repeatMonthDays,
      required this.startDate,
      required this.endDate,
      required this.medicineTakenCount,
      required this.createdAt,
      required this.modifiedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['medicine_name'] = Variable<String>(medicineName);
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = Variable<String>(imagePath);
    }
    map['dosage'] = Variable<int>(dosage);
    map['dosage_unit'] = Variable<String>(dosageUnit);
    map['available_quantity'] = Variable<int>(availableQuantity);
    map['meal_timing'] = Variable<String>(mealTiming);
    map['repeat_variation'] = Variable<String>(repeatVariation);
    if (!nullToAbsent || repeatDays != null) {
      map['repeat_days'] = Variable<int>(repeatDays);
    }
    if (!nullToAbsent || repeatWeekDays != null) {
      map['repeat_week_days'] = Variable<String>(repeatWeekDays);
    }
    if (!nullToAbsent || repeatMonthDays != null) {
      map['repeat_month_days'] = Variable<String>(repeatMonthDays);
    }
    map['start_date'] = Variable<DateTime>(startDate);
    map['end_date'] = Variable<DateTime>(endDate);
    map['medicine_taken_count'] = Variable<int>(medicineTakenCount);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['modified_at'] = Variable<DateTime>(modifiedAt);
    return map;
  }

  MedicinesCompanion toCompanion(bool nullToAbsent) {
    return MedicinesCompanion(
      id: Value(id),
      medicineName: Value(medicineName),
      imagePath: imagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagePath),
      dosage: Value(dosage),
      dosageUnit: Value(dosageUnit),
      availableQuantity: Value(availableQuantity),
      mealTiming: Value(mealTiming),
      repeatVariation: Value(repeatVariation),
      repeatDays: repeatDays == null && nullToAbsent
          ? const Value.absent()
          : Value(repeatDays),
      repeatWeekDays: repeatWeekDays == null && nullToAbsent
          ? const Value.absent()
          : Value(repeatWeekDays),
      repeatMonthDays: repeatMonthDays == null && nullToAbsent
          ? const Value.absent()
          : Value(repeatMonthDays),
      startDate: Value(startDate),
      endDate: Value(endDate),
      medicineTakenCount: Value(medicineTakenCount),
      createdAt: Value(createdAt),
      modifiedAt: Value(modifiedAt),
    );
  }

  factory Medicine.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Medicine(
      id: serializer.fromJson<int>(json['id']),
      medicineName: serializer.fromJson<String>(json['medicineName']),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
      dosage: serializer.fromJson<int>(json['dosage']),
      dosageUnit: serializer.fromJson<String>(json['dosageUnit']),
      availableQuantity: serializer.fromJson<int>(json['availableQuantity']),
      mealTiming: serializer.fromJson<String>(json['mealTiming']),
      repeatVariation: serializer.fromJson<String>(json['repeatVariation']),
      repeatDays: serializer.fromJson<int?>(json['repeatDays']),
      repeatWeekDays: serializer.fromJson<String?>(json['repeatWeekDays']),
      repeatMonthDays: serializer.fromJson<String?>(json['repeatMonthDays']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime>(json['endDate']),
      medicineTakenCount: serializer.fromJson<int>(json['medicineTakenCount']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      modifiedAt: serializer.fromJson<DateTime>(json['modifiedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'medicineName': serializer.toJson<String>(medicineName),
      'imagePath': serializer.toJson<String?>(imagePath),
      'dosage': serializer.toJson<int>(dosage),
      'dosageUnit': serializer.toJson<String>(dosageUnit),
      'availableQuantity': serializer.toJson<int>(availableQuantity),
      'mealTiming': serializer.toJson<String>(mealTiming),
      'repeatVariation': serializer.toJson<String>(repeatVariation),
      'repeatDays': serializer.toJson<int?>(repeatDays),
      'repeatWeekDays': serializer.toJson<String?>(repeatWeekDays),
      'repeatMonthDays': serializer.toJson<String?>(repeatMonthDays),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime>(endDate),
      'medicineTakenCount': serializer.toJson<int>(medicineTakenCount),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'modifiedAt': serializer.toJson<DateTime>(modifiedAt),
    };
  }

  Medicine copyWith(
          {int? id,
          String? medicineName,
          Value<String?> imagePath = const Value.absent(),
          int? dosage,
          String? dosageUnit,
          int? availableQuantity,
          String? mealTiming,
          String? repeatVariation,
          Value<int?> repeatDays = const Value.absent(),
          Value<String?> repeatWeekDays = const Value.absent(),
          Value<String?> repeatMonthDays = const Value.absent(),
          DateTime? startDate,
          DateTime? endDate,
          int? medicineTakenCount,
          DateTime? createdAt,
          DateTime? modifiedAt}) =>
      Medicine(
        id: id ?? this.id,
        medicineName: medicineName ?? this.medicineName,
        imagePath: imagePath.present ? imagePath.value : this.imagePath,
        dosage: dosage ?? this.dosage,
        dosageUnit: dosageUnit ?? this.dosageUnit,
        availableQuantity: availableQuantity ?? this.availableQuantity,
        mealTiming: mealTiming ?? this.mealTiming,
        repeatVariation: repeatVariation ?? this.repeatVariation,
        repeatDays: repeatDays.present ? repeatDays.value : this.repeatDays,
        repeatWeekDays:
            repeatWeekDays.present ? repeatWeekDays.value : this.repeatWeekDays,
        repeatMonthDays: repeatMonthDays.present
            ? repeatMonthDays.value
            : this.repeatMonthDays,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        medicineTakenCount: medicineTakenCount ?? this.medicineTakenCount,
        createdAt: createdAt ?? this.createdAt,
        modifiedAt: modifiedAt ?? this.modifiedAt,
      );
  Medicine copyWithCompanion(MedicinesCompanion data) {
    return Medicine(
      id: data.id.present ? data.id.value : this.id,
      medicineName: data.medicineName.present
          ? data.medicineName.value
          : this.medicineName,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      dosage: data.dosage.present ? data.dosage.value : this.dosage,
      dosageUnit:
          data.dosageUnit.present ? data.dosageUnit.value : this.dosageUnit,
      availableQuantity: data.availableQuantity.present
          ? data.availableQuantity.value
          : this.availableQuantity,
      mealTiming:
          data.mealTiming.present ? data.mealTiming.value : this.mealTiming,
      repeatVariation: data.repeatVariation.present
          ? data.repeatVariation.value
          : this.repeatVariation,
      repeatDays:
          data.repeatDays.present ? data.repeatDays.value : this.repeatDays,
      repeatWeekDays: data.repeatWeekDays.present
          ? data.repeatWeekDays.value
          : this.repeatWeekDays,
      repeatMonthDays: data.repeatMonthDays.present
          ? data.repeatMonthDays.value
          : this.repeatMonthDays,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      medicineTakenCount: data.medicineTakenCount.present
          ? data.medicineTakenCount.value
          : this.medicineTakenCount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      modifiedAt:
          data.modifiedAt.present ? data.modifiedAt.value : this.modifiedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Medicine(')
          ..write('id: $id, ')
          ..write('medicineName: $medicineName, ')
          ..write('imagePath: $imagePath, ')
          ..write('dosage: $dosage, ')
          ..write('dosageUnit: $dosageUnit, ')
          ..write('availableQuantity: $availableQuantity, ')
          ..write('mealTiming: $mealTiming, ')
          ..write('repeatVariation: $repeatVariation, ')
          ..write('repeatDays: $repeatDays, ')
          ..write('repeatWeekDays: $repeatWeekDays, ')
          ..write('repeatMonthDays: $repeatMonthDays, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('medicineTakenCount: $medicineTakenCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('modifiedAt: $modifiedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      medicineName,
      imagePath,
      dosage,
      dosageUnit,
      availableQuantity,
      mealTiming,
      repeatVariation,
      repeatDays,
      repeatWeekDays,
      repeatMonthDays,
      startDate,
      endDate,
      medicineTakenCount,
      createdAt,
      modifiedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Medicine &&
          other.id == this.id &&
          other.medicineName == this.medicineName &&
          other.imagePath == this.imagePath &&
          other.dosage == this.dosage &&
          other.dosageUnit == this.dosageUnit &&
          other.availableQuantity == this.availableQuantity &&
          other.mealTiming == this.mealTiming &&
          other.repeatVariation == this.repeatVariation &&
          other.repeatDays == this.repeatDays &&
          other.repeatWeekDays == this.repeatWeekDays &&
          other.repeatMonthDays == this.repeatMonthDays &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.medicineTakenCount == this.medicineTakenCount &&
          other.createdAt == this.createdAt &&
          other.modifiedAt == this.modifiedAt);
}

class MedicinesCompanion extends UpdateCompanion<Medicine> {
  final Value<int> id;
  final Value<String> medicineName;
  final Value<String?> imagePath;
  final Value<int> dosage;
  final Value<String> dosageUnit;
  final Value<int> availableQuantity;
  final Value<String> mealTiming;
  final Value<String> repeatVariation;
  final Value<int?> repeatDays;
  final Value<String?> repeatWeekDays;
  final Value<String?> repeatMonthDays;
  final Value<DateTime> startDate;
  final Value<DateTime> endDate;
  final Value<int> medicineTakenCount;
  final Value<DateTime> createdAt;
  final Value<DateTime> modifiedAt;
  const MedicinesCompanion({
    this.id = const Value.absent(),
    this.medicineName = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.dosage = const Value.absent(),
    this.dosageUnit = const Value.absent(),
    this.availableQuantity = const Value.absent(),
    this.mealTiming = const Value.absent(),
    this.repeatVariation = const Value.absent(),
    this.repeatDays = const Value.absent(),
    this.repeatWeekDays = const Value.absent(),
    this.repeatMonthDays = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.medicineTakenCount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.modifiedAt = const Value.absent(),
  });
  MedicinesCompanion.insert({
    this.id = const Value.absent(),
    required String medicineName,
    this.imagePath = const Value.absent(),
    this.dosage = const Value.absent(),
    required String dosageUnit,
    this.availableQuantity = const Value.absent(),
    required String mealTiming,
    required String repeatVariation,
    this.repeatDays = const Value.absent(),
    this.repeatWeekDays = const Value.absent(),
    this.repeatMonthDays = const Value.absent(),
    required DateTime startDate,
    required DateTime endDate,
    this.medicineTakenCount = const Value.absent(),
    required DateTime createdAt,
    required DateTime modifiedAt,
  })  : medicineName = Value(medicineName),
        dosageUnit = Value(dosageUnit),
        mealTiming = Value(mealTiming),
        repeatVariation = Value(repeatVariation),
        startDate = Value(startDate),
        endDate = Value(endDate),
        createdAt = Value(createdAt),
        modifiedAt = Value(modifiedAt);
  static Insertable<Medicine> custom({
    Expression<int>? id,
    Expression<String>? medicineName,
    Expression<String>? imagePath,
    Expression<int>? dosage,
    Expression<String>? dosageUnit,
    Expression<int>? availableQuantity,
    Expression<String>? mealTiming,
    Expression<String>? repeatVariation,
    Expression<int>? repeatDays,
    Expression<String>? repeatWeekDays,
    Expression<String>? repeatMonthDays,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<int>? medicineTakenCount,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? modifiedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (medicineName != null) 'medicine_name': medicineName,
      if (imagePath != null) 'image_path': imagePath,
      if (dosage != null) 'dosage': dosage,
      if (dosageUnit != null) 'dosage_unit': dosageUnit,
      if (availableQuantity != null) 'available_quantity': availableQuantity,
      if (mealTiming != null) 'meal_timing': mealTiming,
      if (repeatVariation != null) 'repeat_variation': repeatVariation,
      if (repeatDays != null) 'repeat_days': repeatDays,
      if (repeatWeekDays != null) 'repeat_week_days': repeatWeekDays,
      if (repeatMonthDays != null) 'repeat_month_days': repeatMonthDays,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (medicineTakenCount != null)
        'medicine_taken_count': medicineTakenCount,
      if (createdAt != null) 'created_at': createdAt,
      if (modifiedAt != null) 'modified_at': modifiedAt,
    });
  }

  MedicinesCompanion copyWith(
      {Value<int>? id,
      Value<String>? medicineName,
      Value<String?>? imagePath,
      Value<int>? dosage,
      Value<String>? dosageUnit,
      Value<int>? availableQuantity,
      Value<String>? mealTiming,
      Value<String>? repeatVariation,
      Value<int?>? repeatDays,
      Value<String?>? repeatWeekDays,
      Value<String?>? repeatMonthDays,
      Value<DateTime>? startDate,
      Value<DateTime>? endDate,
      Value<int>? medicineTakenCount,
      Value<DateTime>? createdAt,
      Value<DateTime>? modifiedAt}) {
    return MedicinesCompanion(
      id: id ?? this.id,
      medicineName: medicineName ?? this.medicineName,
      imagePath: imagePath ?? this.imagePath,
      dosage: dosage ?? this.dosage,
      dosageUnit: dosageUnit ?? this.dosageUnit,
      availableQuantity: availableQuantity ?? this.availableQuantity,
      mealTiming: mealTiming ?? this.mealTiming,
      repeatVariation: repeatVariation ?? this.repeatVariation,
      repeatDays: repeatDays ?? this.repeatDays,
      repeatWeekDays: repeatWeekDays ?? this.repeatWeekDays,
      repeatMonthDays: repeatMonthDays ?? this.repeatMonthDays,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      medicineTakenCount: medicineTakenCount ?? this.medicineTakenCount,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (medicineName.present) {
      map['medicine_name'] = Variable<String>(medicineName.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (dosage.present) {
      map['dosage'] = Variable<int>(dosage.value);
    }
    if (dosageUnit.present) {
      map['dosage_unit'] = Variable<String>(dosageUnit.value);
    }
    if (availableQuantity.present) {
      map['available_quantity'] = Variable<int>(availableQuantity.value);
    }
    if (mealTiming.present) {
      map['meal_timing'] = Variable<String>(mealTiming.value);
    }
    if (repeatVariation.present) {
      map['repeat_variation'] = Variable<String>(repeatVariation.value);
    }
    if (repeatDays.present) {
      map['repeat_days'] = Variable<int>(repeatDays.value);
    }
    if (repeatWeekDays.present) {
      map['repeat_week_days'] = Variable<String>(repeatWeekDays.value);
    }
    if (repeatMonthDays.present) {
      map['repeat_month_days'] = Variable<String>(repeatMonthDays.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (medicineTakenCount.present) {
      map['medicine_taken_count'] = Variable<int>(medicineTakenCount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (modifiedAt.present) {
      map['modified_at'] = Variable<DateTime>(modifiedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicinesCompanion(')
          ..write('id: $id, ')
          ..write('medicineName: $medicineName, ')
          ..write('imagePath: $imagePath, ')
          ..write('dosage: $dosage, ')
          ..write('dosageUnit: $dosageUnit, ')
          ..write('availableQuantity: $availableQuantity, ')
          ..write('mealTiming: $mealTiming, ')
          ..write('repeatVariation: $repeatVariation, ')
          ..write('repeatDays: $repeatDays, ')
          ..write('repeatWeekDays: $repeatWeekDays, ')
          ..write('repeatMonthDays: $repeatMonthDays, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('medicineTakenCount: $medicineTakenCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('modifiedAt: $modifiedAt')
          ..write(')'))
        .toString();
  }
}

class $MedicineSchedulesTable extends MedicineSchedules
    with TableInfo<$MedicineSchedulesTable, MedicineSchedule> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicineSchedulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _medicineIdMeta =
      const VerificationMeta('medicineId');
  @override
  late final GeneratedColumn<int> medicineId = GeneratedColumn<int>(
      'medicine_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES medicines (id) ON DELETE CASCADE'));
  static const VerificationMeta _dayTimeNameMeta =
      const VerificationMeta('dayTimeName');
  @override
  late final GeneratedColumn<String> dayTimeName = GeneratedColumn<String>(
      'day_time_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _timeStringMeta =
      const VerificationMeta('timeString');
  @override
  late final GeneratedColumn<String> timeString = GeneratedColumn<String>(
      'time_string', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _hourMeta = const VerificationMeta('hour');
  @override
  late final GeneratedColumn<int> hour = GeneratedColumn<int>(
      'hour', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _minuteMeta = const VerificationMeta('minute');
  @override
  late final GeneratedColumn<int> minute = GeneratedColumn<int>(
      'minute', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, medicineId, dayTimeName, timeString, hour, minute];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medicine_schedules';
  @override
  VerificationContext validateIntegrity(Insertable<MedicineSchedule> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('medicine_id')) {
      context.handle(
          _medicineIdMeta,
          medicineId.isAcceptableOrUnknown(
              data['medicine_id']!, _medicineIdMeta));
    } else if (isInserting) {
      context.missing(_medicineIdMeta);
    }
    if (data.containsKey('day_time_name')) {
      context.handle(
          _dayTimeNameMeta,
          dayTimeName.isAcceptableOrUnknown(
              data['day_time_name']!, _dayTimeNameMeta));
    } else if (isInserting) {
      context.missing(_dayTimeNameMeta);
    }
    if (data.containsKey('time_string')) {
      context.handle(
          _timeStringMeta,
          timeString.isAcceptableOrUnknown(
              data['time_string']!, _timeStringMeta));
    } else if (isInserting) {
      context.missing(_timeStringMeta);
    }
    if (data.containsKey('hour')) {
      context.handle(
          _hourMeta, hour.isAcceptableOrUnknown(data['hour']!, _hourMeta));
    } else if (isInserting) {
      context.missing(_hourMeta);
    }
    if (data.containsKey('minute')) {
      context.handle(_minuteMeta,
          minute.isAcceptableOrUnknown(data['minute']!, _minuteMeta));
    } else if (isInserting) {
      context.missing(_minuteMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MedicineSchedule map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MedicineSchedule(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      medicineId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}medicine_id'])!,
      dayTimeName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}day_time_name'])!,
      timeString: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}time_string'])!,
      hour: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}hour'])!,
      minute: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}minute'])!,
    );
  }

  @override
  $MedicineSchedulesTable createAlias(String alias) {
    return $MedicineSchedulesTable(attachedDatabase, alias);
  }
}

class MedicineSchedule extends DataClass
    implements Insertable<MedicineSchedule> {
  final int id;
  final int medicineId;
  final String dayTimeName;
  final String timeString;
  final int hour;
  final int minute;
  const MedicineSchedule(
      {required this.id,
      required this.medicineId,
      required this.dayTimeName,
      required this.timeString,
      required this.hour,
      required this.minute});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['medicine_id'] = Variable<int>(medicineId);
    map['day_time_name'] = Variable<String>(dayTimeName);
    map['time_string'] = Variable<String>(timeString);
    map['hour'] = Variable<int>(hour);
    map['minute'] = Variable<int>(minute);
    return map;
  }

  MedicineSchedulesCompanion toCompanion(bool nullToAbsent) {
    return MedicineSchedulesCompanion(
      id: Value(id),
      medicineId: Value(medicineId),
      dayTimeName: Value(dayTimeName),
      timeString: Value(timeString),
      hour: Value(hour),
      minute: Value(minute),
    );
  }

  factory MedicineSchedule.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MedicineSchedule(
      id: serializer.fromJson<int>(json['id']),
      medicineId: serializer.fromJson<int>(json['medicineId']),
      dayTimeName: serializer.fromJson<String>(json['dayTimeName']),
      timeString: serializer.fromJson<String>(json['timeString']),
      hour: serializer.fromJson<int>(json['hour']),
      minute: serializer.fromJson<int>(json['minute']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'medicineId': serializer.toJson<int>(medicineId),
      'dayTimeName': serializer.toJson<String>(dayTimeName),
      'timeString': serializer.toJson<String>(timeString),
      'hour': serializer.toJson<int>(hour),
      'minute': serializer.toJson<int>(minute),
    };
  }

  MedicineSchedule copyWith(
          {int? id,
          int? medicineId,
          String? dayTimeName,
          String? timeString,
          int? hour,
          int? minute}) =>
      MedicineSchedule(
        id: id ?? this.id,
        medicineId: medicineId ?? this.medicineId,
        dayTimeName: dayTimeName ?? this.dayTimeName,
        timeString: timeString ?? this.timeString,
        hour: hour ?? this.hour,
        minute: minute ?? this.minute,
      );
  MedicineSchedule copyWithCompanion(MedicineSchedulesCompanion data) {
    return MedicineSchedule(
      id: data.id.present ? data.id.value : this.id,
      medicineId:
          data.medicineId.present ? data.medicineId.value : this.medicineId,
      dayTimeName:
          data.dayTimeName.present ? data.dayTimeName.value : this.dayTimeName,
      timeString:
          data.timeString.present ? data.timeString.value : this.timeString,
      hour: data.hour.present ? data.hour.value : this.hour,
      minute: data.minute.present ? data.minute.value : this.minute,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MedicineSchedule(')
          ..write('id: $id, ')
          ..write('medicineId: $medicineId, ')
          ..write('dayTimeName: $dayTimeName, ')
          ..write('timeString: $timeString, ')
          ..write('hour: $hour, ')
          ..write('minute: $minute')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, medicineId, dayTimeName, timeString, hour, minute);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MedicineSchedule &&
          other.id == this.id &&
          other.medicineId == this.medicineId &&
          other.dayTimeName == this.dayTimeName &&
          other.timeString == this.timeString &&
          other.hour == this.hour &&
          other.minute == this.minute);
}

class MedicineSchedulesCompanion extends UpdateCompanion<MedicineSchedule> {
  final Value<int> id;
  final Value<int> medicineId;
  final Value<String> dayTimeName;
  final Value<String> timeString;
  final Value<int> hour;
  final Value<int> minute;
  const MedicineSchedulesCompanion({
    this.id = const Value.absent(),
    this.medicineId = const Value.absent(),
    this.dayTimeName = const Value.absent(),
    this.timeString = const Value.absent(),
    this.hour = const Value.absent(),
    this.minute = const Value.absent(),
  });
  MedicineSchedulesCompanion.insert({
    this.id = const Value.absent(),
    required int medicineId,
    required String dayTimeName,
    required String timeString,
    required int hour,
    required int minute,
  })  : medicineId = Value(medicineId),
        dayTimeName = Value(dayTimeName),
        timeString = Value(timeString),
        hour = Value(hour),
        minute = Value(minute);
  static Insertable<MedicineSchedule> custom({
    Expression<int>? id,
    Expression<int>? medicineId,
    Expression<String>? dayTimeName,
    Expression<String>? timeString,
    Expression<int>? hour,
    Expression<int>? minute,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (medicineId != null) 'medicine_id': medicineId,
      if (dayTimeName != null) 'day_time_name': dayTimeName,
      if (timeString != null) 'time_string': timeString,
      if (hour != null) 'hour': hour,
      if (minute != null) 'minute': minute,
    });
  }

  MedicineSchedulesCompanion copyWith(
      {Value<int>? id,
      Value<int>? medicineId,
      Value<String>? dayTimeName,
      Value<String>? timeString,
      Value<int>? hour,
      Value<int>? minute}) {
    return MedicineSchedulesCompanion(
      id: id ?? this.id,
      medicineId: medicineId ?? this.medicineId,
      dayTimeName: dayTimeName ?? this.dayTimeName,
      timeString: timeString ?? this.timeString,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (medicineId.present) {
      map['medicine_id'] = Variable<int>(medicineId.value);
    }
    if (dayTimeName.present) {
      map['day_time_name'] = Variable<String>(dayTimeName.value);
    }
    if (timeString.present) {
      map['time_string'] = Variable<String>(timeString.value);
    }
    if (hour.present) {
      map['hour'] = Variable<int>(hour.value);
    }
    if (minute.present) {
      map['minute'] = Variable<int>(minute.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicineSchedulesCompanion(')
          ..write('id: $id, ')
          ..write('medicineId: $medicineId, ')
          ..write('dayTimeName: $dayTimeName, ')
          ..write('timeString: $timeString, ')
          ..write('hour: $hour, ')
          ..write('minute: $minute')
          ..write(')'))
        .toString();
  }
}

class $MedicineLogsTable extends MedicineLogs
    with TableInfo<$MedicineLogsTable, MedicineLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicineLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _medicineIdMeta =
      const VerificationMeta('medicineId');
  @override
  late final GeneratedColumn<int> medicineId = GeneratedColumn<int>(
      'medicine_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES medicines (id) ON DELETE CASCADE'));
  static const VerificationMeta _scheduleIdMeta =
      const VerificationMeta('scheduleId');
  @override
  late final GeneratedColumn<int> scheduleId = GeneratedColumn<int>(
      'schedule_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES medicine_schedules (id) ON DELETE SET NULL'));
  static const VerificationMeta _scheduledDateTimeMeta =
      const VerificationMeta('scheduledDateTime');
  @override
  late final GeneratedColumn<DateTime> scheduledDateTime =
      GeneratedColumn<DateTime>('scheduled_date_time', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _actualTakenTimeMeta =
      const VerificationMeta('actualTakenTime');
  @override
  late final GeneratedColumn<DateTime> actualTakenTime =
      GeneratedColumn<DateTime>('actual_taken_time', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dosageTakenMeta =
      const VerificationMeta('dosageTaken');
  @override
  late final GeneratedColumn<int> dosageTaken = GeneratedColumn<int>(
      'dosage_taken', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        medicineId,
        scheduleId,
        scheduledDateTime,
        actualTakenTime,
        status,
        dosageTaken
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medicine_logs';
  @override
  VerificationContext validateIntegrity(Insertable<MedicineLog> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('medicine_id')) {
      context.handle(
          _medicineIdMeta,
          medicineId.isAcceptableOrUnknown(
              data['medicine_id']!, _medicineIdMeta));
    } else if (isInserting) {
      context.missing(_medicineIdMeta);
    }
    if (data.containsKey('schedule_id')) {
      context.handle(
          _scheduleIdMeta,
          scheduleId.isAcceptableOrUnknown(
              data['schedule_id']!, _scheduleIdMeta));
    }
    if (data.containsKey('scheduled_date_time')) {
      context.handle(
          _scheduledDateTimeMeta,
          scheduledDateTime.isAcceptableOrUnknown(
              data['scheduled_date_time']!, _scheduledDateTimeMeta));
    } else if (isInserting) {
      context.missing(_scheduledDateTimeMeta);
    }
    if (data.containsKey('actual_taken_time')) {
      context.handle(
          _actualTakenTimeMeta,
          actualTakenTime.isAcceptableOrUnknown(
              data['actual_taken_time']!, _actualTakenTimeMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('dosage_taken')) {
      context.handle(
          _dosageTakenMeta,
          dosageTaken.isAcceptableOrUnknown(
              data['dosage_taken']!, _dosageTakenMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MedicineLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MedicineLog(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      medicineId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}medicine_id'])!,
      scheduleId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}schedule_id']),
      scheduledDateTime: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}scheduled_date_time'])!,
      actualTakenTime: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}actual_taken_time']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      dosageTaken: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}dosage_taken'])!,
    );
  }

  @override
  $MedicineLogsTable createAlias(String alias) {
    return $MedicineLogsTable(attachedDatabase, alias);
  }
}

class MedicineLog extends DataClass implements Insertable<MedicineLog> {
  final int id;
  final int medicineId;
  final int? scheduleId;
  final DateTime scheduledDateTime;
  final DateTime? actualTakenTime;
  final String status;
  final int dosageTaken;
  const MedicineLog(
      {required this.id,
      required this.medicineId,
      this.scheduleId,
      required this.scheduledDateTime,
      this.actualTakenTime,
      required this.status,
      required this.dosageTaken});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['medicine_id'] = Variable<int>(medicineId);
    if (!nullToAbsent || scheduleId != null) {
      map['schedule_id'] = Variable<int>(scheduleId);
    }
    map['scheduled_date_time'] = Variable<DateTime>(scheduledDateTime);
    if (!nullToAbsent || actualTakenTime != null) {
      map['actual_taken_time'] = Variable<DateTime>(actualTakenTime);
    }
    map['status'] = Variable<String>(status);
    map['dosage_taken'] = Variable<int>(dosageTaken);
    return map;
  }

  MedicineLogsCompanion toCompanion(bool nullToAbsent) {
    return MedicineLogsCompanion(
      id: Value(id),
      medicineId: Value(medicineId),
      scheduleId: scheduleId == null && nullToAbsent
          ? const Value.absent()
          : Value(scheduleId),
      scheduledDateTime: Value(scheduledDateTime),
      actualTakenTime: actualTakenTime == null && nullToAbsent
          ? const Value.absent()
          : Value(actualTakenTime),
      status: Value(status),
      dosageTaken: Value(dosageTaken),
    );
  }

  factory MedicineLog.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MedicineLog(
      id: serializer.fromJson<int>(json['id']),
      medicineId: serializer.fromJson<int>(json['medicineId']),
      scheduleId: serializer.fromJson<int?>(json['scheduleId']),
      scheduledDateTime:
          serializer.fromJson<DateTime>(json['scheduledDateTime']),
      actualTakenTime: serializer.fromJson<DateTime?>(json['actualTakenTime']),
      status: serializer.fromJson<String>(json['status']),
      dosageTaken: serializer.fromJson<int>(json['dosageTaken']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'medicineId': serializer.toJson<int>(medicineId),
      'scheduleId': serializer.toJson<int?>(scheduleId),
      'scheduledDateTime': serializer.toJson<DateTime>(scheduledDateTime),
      'actualTakenTime': serializer.toJson<DateTime?>(actualTakenTime),
      'status': serializer.toJson<String>(status),
      'dosageTaken': serializer.toJson<int>(dosageTaken),
    };
  }

  MedicineLog copyWith(
          {int? id,
          int? medicineId,
          Value<int?> scheduleId = const Value.absent(),
          DateTime? scheduledDateTime,
          Value<DateTime?> actualTakenTime = const Value.absent(),
          String? status,
          int? dosageTaken}) =>
      MedicineLog(
        id: id ?? this.id,
        medicineId: medicineId ?? this.medicineId,
        scheduleId: scheduleId.present ? scheduleId.value : this.scheduleId,
        scheduledDateTime: scheduledDateTime ?? this.scheduledDateTime,
        actualTakenTime: actualTakenTime.present
            ? actualTakenTime.value
            : this.actualTakenTime,
        status: status ?? this.status,
        dosageTaken: dosageTaken ?? this.dosageTaken,
      );
  MedicineLog copyWithCompanion(MedicineLogsCompanion data) {
    return MedicineLog(
      id: data.id.present ? data.id.value : this.id,
      medicineId:
          data.medicineId.present ? data.medicineId.value : this.medicineId,
      scheduleId:
          data.scheduleId.present ? data.scheduleId.value : this.scheduleId,
      scheduledDateTime: data.scheduledDateTime.present
          ? data.scheduledDateTime.value
          : this.scheduledDateTime,
      actualTakenTime: data.actualTakenTime.present
          ? data.actualTakenTime.value
          : this.actualTakenTime,
      status: data.status.present ? data.status.value : this.status,
      dosageTaken:
          data.dosageTaken.present ? data.dosageTaken.value : this.dosageTaken,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MedicineLog(')
          ..write('id: $id, ')
          ..write('medicineId: $medicineId, ')
          ..write('scheduleId: $scheduleId, ')
          ..write('scheduledDateTime: $scheduledDateTime, ')
          ..write('actualTakenTime: $actualTakenTime, ')
          ..write('status: $status, ')
          ..write('dosageTaken: $dosageTaken')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, medicineId, scheduleId, scheduledDateTime,
      actualTakenTime, status, dosageTaken);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MedicineLog &&
          other.id == this.id &&
          other.medicineId == this.medicineId &&
          other.scheduleId == this.scheduleId &&
          other.scheduledDateTime == this.scheduledDateTime &&
          other.actualTakenTime == this.actualTakenTime &&
          other.status == this.status &&
          other.dosageTaken == this.dosageTaken);
}

class MedicineLogsCompanion extends UpdateCompanion<MedicineLog> {
  final Value<int> id;
  final Value<int> medicineId;
  final Value<int?> scheduleId;
  final Value<DateTime> scheduledDateTime;
  final Value<DateTime?> actualTakenTime;
  final Value<String> status;
  final Value<int> dosageTaken;
  const MedicineLogsCompanion({
    this.id = const Value.absent(),
    this.medicineId = const Value.absent(),
    this.scheduleId = const Value.absent(),
    this.scheduledDateTime = const Value.absent(),
    this.actualTakenTime = const Value.absent(),
    this.status = const Value.absent(),
    this.dosageTaken = const Value.absent(),
  });
  MedicineLogsCompanion.insert({
    this.id = const Value.absent(),
    required int medicineId,
    this.scheduleId = const Value.absent(),
    required DateTime scheduledDateTime,
    this.actualTakenTime = const Value.absent(),
    required String status,
    this.dosageTaken = const Value.absent(),
  })  : medicineId = Value(medicineId),
        scheduledDateTime = Value(scheduledDateTime),
        status = Value(status);
  static Insertable<MedicineLog> custom({
    Expression<int>? id,
    Expression<int>? medicineId,
    Expression<int>? scheduleId,
    Expression<DateTime>? scheduledDateTime,
    Expression<DateTime>? actualTakenTime,
    Expression<String>? status,
    Expression<int>? dosageTaken,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (medicineId != null) 'medicine_id': medicineId,
      if (scheduleId != null) 'schedule_id': scheduleId,
      if (scheduledDateTime != null) 'scheduled_date_time': scheduledDateTime,
      if (actualTakenTime != null) 'actual_taken_time': actualTakenTime,
      if (status != null) 'status': status,
      if (dosageTaken != null) 'dosage_taken': dosageTaken,
    });
  }

  MedicineLogsCompanion copyWith(
      {Value<int>? id,
      Value<int>? medicineId,
      Value<int?>? scheduleId,
      Value<DateTime>? scheduledDateTime,
      Value<DateTime?>? actualTakenTime,
      Value<String>? status,
      Value<int>? dosageTaken}) {
    return MedicineLogsCompanion(
      id: id ?? this.id,
      medicineId: medicineId ?? this.medicineId,
      scheduleId: scheduleId ?? this.scheduleId,
      scheduledDateTime: scheduledDateTime ?? this.scheduledDateTime,
      actualTakenTime: actualTakenTime ?? this.actualTakenTime,
      status: status ?? this.status,
      dosageTaken: dosageTaken ?? this.dosageTaken,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (medicineId.present) {
      map['medicine_id'] = Variable<int>(medicineId.value);
    }
    if (scheduleId.present) {
      map['schedule_id'] = Variable<int>(scheduleId.value);
    }
    if (scheduledDateTime.present) {
      map['scheduled_date_time'] = Variable<DateTime>(scheduledDateTime.value);
    }
    if (actualTakenTime.present) {
      map['actual_taken_time'] = Variable<DateTime>(actualTakenTime.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (dosageTaken.present) {
      map['dosage_taken'] = Variable<int>(dosageTaken.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicineLogsCompanion(')
          ..write('id: $id, ')
          ..write('medicineId: $medicineId, ')
          ..write('scheduleId: $scheduleId, ')
          ..write('scheduledDateTime: $scheduledDateTime, ')
          ..write('actualTakenTime: $actualTakenTime, ')
          ..write('status: $status, ')
          ..write('dosageTaken: $dosageTaken')
          ..write(')'))
        .toString();
  }
}

class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ageMeta = const VerificationMeta('age');
  @override
  late final GeneratedColumn<int> age = GeneratedColumn<int>(
      'age', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(25));
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
      'gender', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _imagePathMeta =
      const VerificationMeta('imagePath');
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
      'image_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, age, gender, imagePath, email];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(Insertable<User> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('age')) {
      context.handle(
          _ageMeta, age.isAcceptableOrUnknown(data['age']!, _ageMeta));
    }
    if (data.containsKey('gender')) {
      context.handle(_genderMeta,
          gender.isAcceptableOrUnknown(data['gender']!, _genderMeta));
    }
    if (data.containsKey('image_path')) {
      context.handle(_imagePathMeta,
          imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      age: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}age'])!,
      gender: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}gender']),
      imagePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_path']),
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final int id;
  final String name;
  final int age;
  final String? gender;
  final String? imagePath;
  final String? email;
  const User(
      {required this.id,
      required this.name,
      required this.age,
      this.gender,
      this.imagePath,
      this.email});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['age'] = Variable<int>(age);
    if (!nullToAbsent || gender != null) {
      map['gender'] = Variable<String>(gender);
    }
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = Variable<String>(imagePath);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      name: Value(name),
      age: Value(age),
      gender:
          gender == null && nullToAbsent ? const Value.absent() : Value(gender),
      imagePath: imagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagePath),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
    );
  }

  factory User.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      age: serializer.fromJson<int>(json['age']),
      gender: serializer.fromJson<String?>(json['gender']),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
      email: serializer.fromJson<String?>(json['email']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'age': serializer.toJson<int>(age),
      'gender': serializer.toJson<String?>(gender),
      'imagePath': serializer.toJson<String?>(imagePath),
      'email': serializer.toJson<String?>(email),
    };
  }

  User copyWith(
          {int? id,
          String? name,
          int? age,
          Value<String?> gender = const Value.absent(),
          Value<String?> imagePath = const Value.absent(),
          Value<String?> email = const Value.absent()}) =>
      User(
        id: id ?? this.id,
        name: name ?? this.name,
        age: age ?? this.age,
        gender: gender.present ? gender.value : this.gender,
        imagePath: imagePath.present ? imagePath.value : this.imagePath,
        email: email.present ? email.value : this.email,
      );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      age: data.age.present ? data.age.value : this.age,
      gender: data.gender.present ? data.gender.value : this.gender,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      email: data.email.present ? data.email.value : this.email,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('age: $age, ')
          ..write('gender: $gender, ')
          ..write('imagePath: $imagePath, ')
          ..write('email: $email')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, age, gender, imagePath, email);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.name == this.name &&
          other.age == this.age &&
          other.gender == this.gender &&
          other.imagePath == this.imagePath &&
          other.email == this.email);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> age;
  final Value<String?> gender;
  final Value<String?> imagePath;
  final Value<String?> email;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.age = const Value.absent(),
    this.gender = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.email = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.age = const Value.absent(),
    this.gender = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.email = const Value.absent(),
  }) : name = Value(name);
  static Insertable<User> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? age,
    Expression<String>? gender,
    Expression<String>? imagePath,
    Expression<String>? email,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (age != null) 'age': age,
      if (gender != null) 'gender': gender,
      if (imagePath != null) 'image_path': imagePath,
      if (email != null) 'email': email,
    });
  }

  UsersCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<int>? age,
      Value<String?>? gender,
      Value<String?>? imagePath,
      Value<String?>? email}) {
    return UsersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      imagePath: imagePath ?? this.imagePath,
      email: email ?? this.email,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (age.present) {
      map['age'] = Variable<int>(age.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('age: $age, ')
          ..write('gender: $gender, ')
          ..write('imagePath: $imagePath, ')
          ..write('email: $email')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $MedicinesTable medicines = $MedicinesTable(this);
  late final $MedicineSchedulesTable medicineSchedules =
      $MedicineSchedulesTable(this);
  late final $MedicineLogsTable medicineLogs = $MedicineLogsTable(this);
  late final $UsersTable users = $UsersTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [medicines, medicineSchedules, medicineLogs, users];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('medicines',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('medicine_schedules', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('medicines',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('medicine_logs', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('medicine_schedules',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('medicine_logs', kind: UpdateKind.update),
            ],
          ),
        ],
      );
}

typedef $$MedicinesTableCreateCompanionBuilder = MedicinesCompanion Function({
  Value<int> id,
  required String medicineName,
  Value<String?> imagePath,
  Value<int> dosage,
  required String dosageUnit,
  Value<int> availableQuantity,
  required String mealTiming,
  required String repeatVariation,
  Value<int?> repeatDays,
  Value<String?> repeatWeekDays,
  Value<String?> repeatMonthDays,
  required DateTime startDate,
  required DateTime endDate,
  Value<int> medicineTakenCount,
  required DateTime createdAt,
  required DateTime modifiedAt,
});
typedef $$MedicinesTableUpdateCompanionBuilder = MedicinesCompanion Function({
  Value<int> id,
  Value<String> medicineName,
  Value<String?> imagePath,
  Value<int> dosage,
  Value<String> dosageUnit,
  Value<int> availableQuantity,
  Value<String> mealTiming,
  Value<String> repeatVariation,
  Value<int?> repeatDays,
  Value<String?> repeatWeekDays,
  Value<String?> repeatMonthDays,
  Value<DateTime> startDate,
  Value<DateTime> endDate,
  Value<int> medicineTakenCount,
  Value<DateTime> createdAt,
  Value<DateTime> modifiedAt,
});

final class $$MedicinesTableReferences
    extends BaseReferences<_$AppDatabase, $MedicinesTable, Medicine> {
  $$MedicinesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MedicineSchedulesTable, List<MedicineSchedule>>
      _medicineSchedulesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.medicineSchedules,
              aliasName: $_aliasNameGenerator(
                  db.medicines.id, db.medicineSchedules.medicineId));

  $$MedicineSchedulesTableProcessedTableManager get medicineSchedulesRefs {
    final manager =
        $$MedicineSchedulesTableTableManager($_db, $_db.medicineSchedules)
            .filter((f) => f.medicineId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_medicineSchedulesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$MedicineLogsTable, List<MedicineLog>>
      _medicineLogsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.medicineLogs,
              aliasName: $_aliasNameGenerator(
                  db.medicines.id, db.medicineLogs.medicineId));

  $$MedicineLogsTableProcessedTableManager get medicineLogsRefs {
    final manager = $$MedicineLogsTableTableManager($_db, $_db.medicineLogs)
        .filter((f) => f.medicineId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_medicineLogsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$MedicinesTableFilterComposer
    extends Composer<_$AppDatabase, $MedicinesTable> {
  $$MedicinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get medicineName => $composableBuilder(
      column: $table.medicineName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imagePath => $composableBuilder(
      column: $table.imagePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get dosage => $composableBuilder(
      column: $table.dosage, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dosageUnit => $composableBuilder(
      column: $table.dosageUnit, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get availableQuantity => $composableBuilder(
      column: $table.availableQuantity,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mealTiming => $composableBuilder(
      column: $table.mealTiming, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get repeatVariation => $composableBuilder(
      column: $table.repeatVariation,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get repeatDays => $composableBuilder(
      column: $table.repeatDays, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get repeatWeekDays => $composableBuilder(
      column: $table.repeatWeekDays,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get repeatMonthDays => $composableBuilder(
      column: $table.repeatMonthDays,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get medicineTakenCount => $composableBuilder(
      column: $table.medicineTakenCount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get modifiedAt => $composableBuilder(
      column: $table.modifiedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> medicineSchedulesRefs(
      Expression<bool> Function($$MedicineSchedulesTableFilterComposer f) f) {
    final $$MedicineSchedulesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.medicineSchedules,
        getReferencedColumn: (t) => t.medicineId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MedicineSchedulesTableFilterComposer(
              $db: $db,
              $table: $db.medicineSchedules,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> medicineLogsRefs(
      Expression<bool> Function($$MedicineLogsTableFilterComposer f) f) {
    final $$MedicineLogsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.medicineLogs,
        getReferencedColumn: (t) => t.medicineId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MedicineLogsTableFilterComposer(
              $db: $db,
              $table: $db.medicineLogs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$MedicinesTableOrderingComposer
    extends Composer<_$AppDatabase, $MedicinesTable> {
  $$MedicinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get medicineName => $composableBuilder(
      column: $table.medicineName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imagePath => $composableBuilder(
      column: $table.imagePath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get dosage => $composableBuilder(
      column: $table.dosage, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dosageUnit => $composableBuilder(
      column: $table.dosageUnit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get availableQuantity => $composableBuilder(
      column: $table.availableQuantity,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mealTiming => $composableBuilder(
      column: $table.mealTiming, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get repeatVariation => $composableBuilder(
      column: $table.repeatVariation,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get repeatDays => $composableBuilder(
      column: $table.repeatDays, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get repeatWeekDays => $composableBuilder(
      column: $table.repeatWeekDays,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get repeatMonthDays => $composableBuilder(
      column: $table.repeatMonthDays,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get medicineTakenCount => $composableBuilder(
      column: $table.medicineTakenCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get modifiedAt => $composableBuilder(
      column: $table.modifiedAt, builder: (column) => ColumnOrderings(column));
}

class $$MedicinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MedicinesTable> {
  $$MedicinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get medicineName => $composableBuilder(
      column: $table.medicineName, builder: (column) => column);

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<int> get dosage =>
      $composableBuilder(column: $table.dosage, builder: (column) => column);

  GeneratedColumn<String> get dosageUnit => $composableBuilder(
      column: $table.dosageUnit, builder: (column) => column);

  GeneratedColumn<int> get availableQuantity => $composableBuilder(
      column: $table.availableQuantity, builder: (column) => column);

  GeneratedColumn<String> get mealTiming => $composableBuilder(
      column: $table.mealTiming, builder: (column) => column);

  GeneratedColumn<String> get repeatVariation => $composableBuilder(
      column: $table.repeatVariation, builder: (column) => column);

  GeneratedColumn<int> get repeatDays => $composableBuilder(
      column: $table.repeatDays, builder: (column) => column);

  GeneratedColumn<String> get repeatWeekDays => $composableBuilder(
      column: $table.repeatWeekDays, builder: (column) => column);

  GeneratedColumn<String> get repeatMonthDays => $composableBuilder(
      column: $table.repeatMonthDays, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<int> get medicineTakenCount => $composableBuilder(
      column: $table.medicineTakenCount, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get modifiedAt => $composableBuilder(
      column: $table.modifiedAt, builder: (column) => column);

  Expression<T> medicineSchedulesRefs<T extends Object>(
      Expression<T> Function($$MedicineSchedulesTableAnnotationComposer a) f) {
    final $$MedicineSchedulesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.medicineSchedules,
            getReferencedColumn: (t) => t.medicineId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$MedicineSchedulesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.medicineSchedules,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> medicineLogsRefs<T extends Object>(
      Expression<T> Function($$MedicineLogsTableAnnotationComposer a) f) {
    final $$MedicineLogsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.medicineLogs,
        getReferencedColumn: (t) => t.medicineId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MedicineLogsTableAnnotationComposer(
              $db: $db,
              $table: $db.medicineLogs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$MedicinesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MedicinesTable,
    Medicine,
    $$MedicinesTableFilterComposer,
    $$MedicinesTableOrderingComposer,
    $$MedicinesTableAnnotationComposer,
    $$MedicinesTableCreateCompanionBuilder,
    $$MedicinesTableUpdateCompanionBuilder,
    (Medicine, $$MedicinesTableReferences),
    Medicine,
    PrefetchHooks Function(
        {bool medicineSchedulesRefs, bool medicineLogsRefs})> {
  $$MedicinesTableTableManager(_$AppDatabase db, $MedicinesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MedicinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MedicinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MedicinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> medicineName = const Value.absent(),
            Value<String?> imagePath = const Value.absent(),
            Value<int> dosage = const Value.absent(),
            Value<String> dosageUnit = const Value.absent(),
            Value<int> availableQuantity = const Value.absent(),
            Value<String> mealTiming = const Value.absent(),
            Value<String> repeatVariation = const Value.absent(),
            Value<int?> repeatDays = const Value.absent(),
            Value<String?> repeatWeekDays = const Value.absent(),
            Value<String?> repeatMonthDays = const Value.absent(),
            Value<DateTime> startDate = const Value.absent(),
            Value<DateTime> endDate = const Value.absent(),
            Value<int> medicineTakenCount = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> modifiedAt = const Value.absent(),
          }) =>
              MedicinesCompanion(
            id: id,
            medicineName: medicineName,
            imagePath: imagePath,
            dosage: dosage,
            dosageUnit: dosageUnit,
            availableQuantity: availableQuantity,
            mealTiming: mealTiming,
            repeatVariation: repeatVariation,
            repeatDays: repeatDays,
            repeatWeekDays: repeatWeekDays,
            repeatMonthDays: repeatMonthDays,
            startDate: startDate,
            endDate: endDate,
            medicineTakenCount: medicineTakenCount,
            createdAt: createdAt,
            modifiedAt: modifiedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String medicineName,
            Value<String?> imagePath = const Value.absent(),
            Value<int> dosage = const Value.absent(),
            required String dosageUnit,
            Value<int> availableQuantity = const Value.absent(),
            required String mealTiming,
            required String repeatVariation,
            Value<int?> repeatDays = const Value.absent(),
            Value<String?> repeatWeekDays = const Value.absent(),
            Value<String?> repeatMonthDays = const Value.absent(),
            required DateTime startDate,
            required DateTime endDate,
            Value<int> medicineTakenCount = const Value.absent(),
            required DateTime createdAt,
            required DateTime modifiedAt,
          }) =>
              MedicinesCompanion.insert(
            id: id,
            medicineName: medicineName,
            imagePath: imagePath,
            dosage: dosage,
            dosageUnit: dosageUnit,
            availableQuantity: availableQuantity,
            mealTiming: mealTiming,
            repeatVariation: repeatVariation,
            repeatDays: repeatDays,
            repeatWeekDays: repeatWeekDays,
            repeatMonthDays: repeatMonthDays,
            startDate: startDate,
            endDate: endDate,
            medicineTakenCount: medicineTakenCount,
            createdAt: createdAt,
            modifiedAt: modifiedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$MedicinesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {medicineSchedulesRefs = false, medicineLogsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (medicineSchedulesRefs) db.medicineSchedules,
                if (medicineLogsRefs) db.medicineLogs
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (medicineSchedulesRefs)
                    await $_getPrefetchedData<Medicine, $MedicinesTable,
                            MedicineSchedule>(
                        currentTable: table,
                        referencedTable: $$MedicinesTableReferences
                            ._medicineSchedulesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MedicinesTableReferences(db, table, p0)
                                .medicineSchedulesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.medicineId == item.id),
                        typedResults: items),
                  if (medicineLogsRefs)
                    await $_getPrefetchedData<Medicine, $MedicinesTable,
                            MedicineLog>(
                        currentTable: table,
                        referencedTable: $$MedicinesTableReferences
                            ._medicineLogsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MedicinesTableReferences(db, table, p0)
                                .medicineLogsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.medicineId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$MedicinesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MedicinesTable,
    Medicine,
    $$MedicinesTableFilterComposer,
    $$MedicinesTableOrderingComposer,
    $$MedicinesTableAnnotationComposer,
    $$MedicinesTableCreateCompanionBuilder,
    $$MedicinesTableUpdateCompanionBuilder,
    (Medicine, $$MedicinesTableReferences),
    Medicine,
    PrefetchHooks Function(
        {bool medicineSchedulesRefs, bool medicineLogsRefs})>;
typedef $$MedicineSchedulesTableCreateCompanionBuilder
    = MedicineSchedulesCompanion Function({
  Value<int> id,
  required int medicineId,
  required String dayTimeName,
  required String timeString,
  required int hour,
  required int minute,
});
typedef $$MedicineSchedulesTableUpdateCompanionBuilder
    = MedicineSchedulesCompanion Function({
  Value<int> id,
  Value<int> medicineId,
  Value<String> dayTimeName,
  Value<String> timeString,
  Value<int> hour,
  Value<int> minute,
});

final class $$MedicineSchedulesTableReferences extends BaseReferences<
    _$AppDatabase, $MedicineSchedulesTable, MedicineSchedule> {
  $$MedicineSchedulesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $MedicinesTable _medicineIdTable(_$AppDatabase db) =>
      db.medicines.createAlias($_aliasNameGenerator(
          db.medicineSchedules.medicineId, db.medicines.id));

  $$MedicinesTableProcessedTableManager get medicineId {
    final $_column = $_itemColumn<int>('medicine_id')!;

    final manager = $$MedicinesTableTableManager($_db, $_db.medicines)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_medicineIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$MedicineLogsTable, List<MedicineLog>>
      _medicineLogsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.medicineLogs,
              aliasName: $_aliasNameGenerator(
                  db.medicineSchedules.id, db.medicineLogs.scheduleId));

  $$MedicineLogsTableProcessedTableManager get medicineLogsRefs {
    final manager = $$MedicineLogsTableTableManager($_db, $_db.medicineLogs)
        .filter((f) => f.scheduleId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_medicineLogsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$MedicineSchedulesTableFilterComposer
    extends Composer<_$AppDatabase, $MedicineSchedulesTable> {
  $$MedicineSchedulesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dayTimeName => $composableBuilder(
      column: $table.dayTimeName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get timeString => $composableBuilder(
      column: $table.timeString, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get hour => $composableBuilder(
      column: $table.hour, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get minute => $composableBuilder(
      column: $table.minute, builder: (column) => ColumnFilters(column));

  $$MedicinesTableFilterComposer get medicineId {
    final $$MedicinesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.medicineId,
        referencedTable: $db.medicines,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MedicinesTableFilterComposer(
              $db: $db,
              $table: $db.medicines,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> medicineLogsRefs(
      Expression<bool> Function($$MedicineLogsTableFilterComposer f) f) {
    final $$MedicineLogsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.medicineLogs,
        getReferencedColumn: (t) => t.scheduleId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MedicineLogsTableFilterComposer(
              $db: $db,
              $table: $db.medicineLogs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$MedicineSchedulesTableOrderingComposer
    extends Composer<_$AppDatabase, $MedicineSchedulesTable> {
  $$MedicineSchedulesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dayTimeName => $composableBuilder(
      column: $table.dayTimeName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get timeString => $composableBuilder(
      column: $table.timeString, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get hour => $composableBuilder(
      column: $table.hour, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get minute => $composableBuilder(
      column: $table.minute, builder: (column) => ColumnOrderings(column));

  $$MedicinesTableOrderingComposer get medicineId {
    final $$MedicinesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.medicineId,
        referencedTable: $db.medicines,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MedicinesTableOrderingComposer(
              $db: $db,
              $table: $db.medicines,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MedicineSchedulesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MedicineSchedulesTable> {
  $$MedicineSchedulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get dayTimeName => $composableBuilder(
      column: $table.dayTimeName, builder: (column) => column);

  GeneratedColumn<String> get timeString => $composableBuilder(
      column: $table.timeString, builder: (column) => column);

  GeneratedColumn<int> get hour =>
      $composableBuilder(column: $table.hour, builder: (column) => column);

  GeneratedColumn<int> get minute =>
      $composableBuilder(column: $table.minute, builder: (column) => column);

  $$MedicinesTableAnnotationComposer get medicineId {
    final $$MedicinesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.medicineId,
        referencedTable: $db.medicines,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MedicinesTableAnnotationComposer(
              $db: $db,
              $table: $db.medicines,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> medicineLogsRefs<T extends Object>(
      Expression<T> Function($$MedicineLogsTableAnnotationComposer a) f) {
    final $$MedicineLogsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.medicineLogs,
        getReferencedColumn: (t) => t.scheduleId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MedicineLogsTableAnnotationComposer(
              $db: $db,
              $table: $db.medicineLogs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$MedicineSchedulesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MedicineSchedulesTable,
    MedicineSchedule,
    $$MedicineSchedulesTableFilterComposer,
    $$MedicineSchedulesTableOrderingComposer,
    $$MedicineSchedulesTableAnnotationComposer,
    $$MedicineSchedulesTableCreateCompanionBuilder,
    $$MedicineSchedulesTableUpdateCompanionBuilder,
    (MedicineSchedule, $$MedicineSchedulesTableReferences),
    MedicineSchedule,
    PrefetchHooks Function({bool medicineId, bool medicineLogsRefs})> {
  $$MedicineSchedulesTableTableManager(
      _$AppDatabase db, $MedicineSchedulesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MedicineSchedulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MedicineSchedulesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MedicineSchedulesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> medicineId = const Value.absent(),
            Value<String> dayTimeName = const Value.absent(),
            Value<String> timeString = const Value.absent(),
            Value<int> hour = const Value.absent(),
            Value<int> minute = const Value.absent(),
          }) =>
              MedicineSchedulesCompanion(
            id: id,
            medicineId: medicineId,
            dayTimeName: dayTimeName,
            timeString: timeString,
            hour: hour,
            minute: minute,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int medicineId,
            required String dayTimeName,
            required String timeString,
            required int hour,
            required int minute,
          }) =>
              MedicineSchedulesCompanion.insert(
            id: id,
            medicineId: medicineId,
            dayTimeName: dayTimeName,
            timeString: timeString,
            hour: hour,
            minute: minute,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$MedicineSchedulesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {medicineId = false, medicineLogsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (medicineLogsRefs) db.medicineLogs],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (medicineId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.medicineId,
                    referencedTable:
                        $$MedicineSchedulesTableReferences._medicineIdTable(db),
                    referencedColumn: $$MedicineSchedulesTableReferences
                        ._medicineIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (medicineLogsRefs)
                    await $_getPrefetchedData<MedicineSchedule,
                            $MedicineSchedulesTable, MedicineLog>(
                        currentTable: table,
                        referencedTable: $$MedicineSchedulesTableReferences
                            ._medicineLogsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MedicineSchedulesTableReferences(db, table, p0)
                                .medicineLogsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.scheduleId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$MedicineSchedulesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MedicineSchedulesTable,
    MedicineSchedule,
    $$MedicineSchedulesTableFilterComposer,
    $$MedicineSchedulesTableOrderingComposer,
    $$MedicineSchedulesTableAnnotationComposer,
    $$MedicineSchedulesTableCreateCompanionBuilder,
    $$MedicineSchedulesTableUpdateCompanionBuilder,
    (MedicineSchedule, $$MedicineSchedulesTableReferences),
    MedicineSchedule,
    PrefetchHooks Function({bool medicineId, bool medicineLogsRefs})>;
typedef $$MedicineLogsTableCreateCompanionBuilder = MedicineLogsCompanion
    Function({
  Value<int> id,
  required int medicineId,
  Value<int?> scheduleId,
  required DateTime scheduledDateTime,
  Value<DateTime?> actualTakenTime,
  required String status,
  Value<int> dosageTaken,
});
typedef $$MedicineLogsTableUpdateCompanionBuilder = MedicineLogsCompanion
    Function({
  Value<int> id,
  Value<int> medicineId,
  Value<int?> scheduleId,
  Value<DateTime> scheduledDateTime,
  Value<DateTime?> actualTakenTime,
  Value<String> status,
  Value<int> dosageTaken,
});

final class $$MedicineLogsTableReferences
    extends BaseReferences<_$AppDatabase, $MedicineLogsTable, MedicineLog> {
  $$MedicineLogsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MedicinesTable _medicineIdTable(_$AppDatabase db) =>
      db.medicines.createAlias(
          $_aliasNameGenerator(db.medicineLogs.medicineId, db.medicines.id));

  $$MedicinesTableProcessedTableManager get medicineId {
    final $_column = $_itemColumn<int>('medicine_id')!;

    final manager = $$MedicinesTableTableManager($_db, $_db.medicines)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_medicineIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $MedicineSchedulesTable _scheduleIdTable(_$AppDatabase db) =>
      db.medicineSchedules.createAlias($_aliasNameGenerator(
          db.medicineLogs.scheduleId, db.medicineSchedules.id));

  $$MedicineSchedulesTableProcessedTableManager? get scheduleId {
    final $_column = $_itemColumn<int>('schedule_id');
    if ($_column == null) return null;
    final manager =
        $$MedicineSchedulesTableTableManager($_db, $_db.medicineSchedules)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_scheduleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$MedicineLogsTableFilterComposer
    extends Composer<_$AppDatabase, $MedicineLogsTable> {
  $$MedicineLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get scheduledDateTime => $composableBuilder(
      column: $table.scheduledDateTime,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get actualTakenTime => $composableBuilder(
      column: $table.actualTakenTime,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get dosageTaken => $composableBuilder(
      column: $table.dosageTaken, builder: (column) => ColumnFilters(column));

  $$MedicinesTableFilterComposer get medicineId {
    final $$MedicinesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.medicineId,
        referencedTable: $db.medicines,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MedicinesTableFilterComposer(
              $db: $db,
              $table: $db.medicines,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$MedicineSchedulesTableFilterComposer get scheduleId {
    final $$MedicineSchedulesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.scheduleId,
        referencedTable: $db.medicineSchedules,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MedicineSchedulesTableFilterComposer(
              $db: $db,
              $table: $db.medicineSchedules,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MedicineLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $MedicineLogsTable> {
  $$MedicineLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get scheduledDateTime => $composableBuilder(
      column: $table.scheduledDateTime,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get actualTakenTime => $composableBuilder(
      column: $table.actualTakenTime,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get dosageTaken => $composableBuilder(
      column: $table.dosageTaken, builder: (column) => ColumnOrderings(column));

  $$MedicinesTableOrderingComposer get medicineId {
    final $$MedicinesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.medicineId,
        referencedTable: $db.medicines,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MedicinesTableOrderingComposer(
              $db: $db,
              $table: $db.medicines,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$MedicineSchedulesTableOrderingComposer get scheduleId {
    final $$MedicineSchedulesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.scheduleId,
        referencedTable: $db.medicineSchedules,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MedicineSchedulesTableOrderingComposer(
              $db: $db,
              $table: $db.medicineSchedules,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MedicineLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MedicineLogsTable> {
  $$MedicineLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get scheduledDateTime => $composableBuilder(
      column: $table.scheduledDateTime, builder: (column) => column);

  GeneratedColumn<DateTime> get actualTakenTime => $composableBuilder(
      column: $table.actualTakenTime, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get dosageTaken => $composableBuilder(
      column: $table.dosageTaken, builder: (column) => column);

  $$MedicinesTableAnnotationComposer get medicineId {
    final $$MedicinesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.medicineId,
        referencedTable: $db.medicines,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MedicinesTableAnnotationComposer(
              $db: $db,
              $table: $db.medicines,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$MedicineSchedulesTableAnnotationComposer get scheduleId {
    final $$MedicineSchedulesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.scheduleId,
            referencedTable: $db.medicineSchedules,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$MedicineSchedulesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.medicineSchedules,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }
}

class $$MedicineLogsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MedicineLogsTable,
    MedicineLog,
    $$MedicineLogsTableFilterComposer,
    $$MedicineLogsTableOrderingComposer,
    $$MedicineLogsTableAnnotationComposer,
    $$MedicineLogsTableCreateCompanionBuilder,
    $$MedicineLogsTableUpdateCompanionBuilder,
    (MedicineLog, $$MedicineLogsTableReferences),
    MedicineLog,
    PrefetchHooks Function({bool medicineId, bool scheduleId})> {
  $$MedicineLogsTableTableManager(_$AppDatabase db, $MedicineLogsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MedicineLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MedicineLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MedicineLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> medicineId = const Value.absent(),
            Value<int?> scheduleId = const Value.absent(),
            Value<DateTime> scheduledDateTime = const Value.absent(),
            Value<DateTime?> actualTakenTime = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> dosageTaken = const Value.absent(),
          }) =>
              MedicineLogsCompanion(
            id: id,
            medicineId: medicineId,
            scheduleId: scheduleId,
            scheduledDateTime: scheduledDateTime,
            actualTakenTime: actualTakenTime,
            status: status,
            dosageTaken: dosageTaken,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int medicineId,
            Value<int?> scheduleId = const Value.absent(),
            required DateTime scheduledDateTime,
            Value<DateTime?> actualTakenTime = const Value.absent(),
            required String status,
            Value<int> dosageTaken = const Value.absent(),
          }) =>
              MedicineLogsCompanion.insert(
            id: id,
            medicineId: medicineId,
            scheduleId: scheduleId,
            scheduledDateTime: scheduledDateTime,
            actualTakenTime: actualTakenTime,
            status: status,
            dosageTaken: dosageTaken,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$MedicineLogsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({medicineId = false, scheduleId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (medicineId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.medicineId,
                    referencedTable:
                        $$MedicineLogsTableReferences._medicineIdTable(db),
                    referencedColumn:
                        $$MedicineLogsTableReferences._medicineIdTable(db).id,
                  ) as T;
                }
                if (scheduleId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.scheduleId,
                    referencedTable:
                        $$MedicineLogsTableReferences._scheduleIdTable(db),
                    referencedColumn:
                        $$MedicineLogsTableReferences._scheduleIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$MedicineLogsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MedicineLogsTable,
    MedicineLog,
    $$MedicineLogsTableFilterComposer,
    $$MedicineLogsTableOrderingComposer,
    $$MedicineLogsTableAnnotationComposer,
    $$MedicineLogsTableCreateCompanionBuilder,
    $$MedicineLogsTableUpdateCompanionBuilder,
    (MedicineLog, $$MedicineLogsTableReferences),
    MedicineLog,
    PrefetchHooks Function({bool medicineId, bool scheduleId})>;
typedef $$UsersTableCreateCompanionBuilder = UsersCompanion Function({
  Value<int> id,
  required String name,
  Value<int> age,
  Value<String?> gender,
  Value<String?> imagePath,
  Value<String?> email,
});
typedef $$UsersTableUpdateCompanionBuilder = UsersCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<int> age,
  Value<String?> gender,
  Value<String?> imagePath,
  Value<String?> email,
});

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get age => $composableBuilder(
      column: $table.age, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get gender => $composableBuilder(
      column: $table.gender, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imagePath => $composableBuilder(
      column: $table.imagePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get age => $composableBuilder(
      column: $table.age, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get gender => $composableBuilder(
      column: $table.gender, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imagePath => $composableBuilder(
      column: $table.imagePath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get age =>
      $composableBuilder(column: $table.age, builder: (column) => column);

  GeneratedColumn<String> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);
}

class $$UsersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
    User,
    PrefetchHooks Function()> {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> age = const Value.absent(),
            Value<String?> gender = const Value.absent(),
            Value<String?> imagePath = const Value.absent(),
            Value<String?> email = const Value.absent(),
          }) =>
              UsersCompanion(
            id: id,
            name: name,
            age: age,
            gender: gender,
            imagePath: imagePath,
            email: email,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<int> age = const Value.absent(),
            Value<String?> gender = const Value.absent(),
            Value<String?> imagePath = const Value.absent(),
            Value<String?> email = const Value.absent(),
          }) =>
              UsersCompanion.insert(
            id: id,
            name: name,
            age: age,
            gender: gender,
            imagePath: imagePath,
            email: email,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UsersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
    User,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$MedicinesTableTableManager get medicines =>
      $$MedicinesTableTableManager(_db, _db.medicines);
  $$MedicineSchedulesTableTableManager get medicineSchedules =>
      $$MedicineSchedulesTableTableManager(_db, _db.medicineSchedules);
  $$MedicineLogsTableTableManager get medicineLogs =>
      $$MedicineLogsTableTableManager(_db, _db.medicineLogs);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
}
