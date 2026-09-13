import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:medicine_app/models/domain_models.dart';

part 'app_database.g.dart';

class Medicines extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get medicineName => text()();
  TextColumn get imagePath => text().nullable()();
  RealColumn get dosage => real().withDefault(const Constant(1.0))();
  TextColumn get dosageUnit => text()(); // 'pcs' or 'cup'
  RealColumn get availableQuantity => real().withDefault(const Constant(0.0))();
  TextColumn get mealTiming => text()(); // 'before' or 'after'
  TextColumn get repeatVariation => text()(); // 'day', 'weekly', 'monthly', 'timely'
  IntColumn get repeatDays => integer().nullable()();
  TextColumn get repeatWeekDays => text().nullable()(); // JSON string e.g. ["Mon","Wed"]
  TextColumn get repeatMonthDays => text().nullable()(); // JSON string e.g. [1,15]
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  IntColumn get medicineTakenCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get modifiedAt => dateTime()();
}

class MedicineSchedules extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get medicineId => integer().references(Medicines, #id, onDelete: KeyAction.cascade)();
  TextColumn get dayTimeName => text()(); // 'Morning', 'Noon', etc.
  TextColumn get timeString => text()(); // '08:00'
  IntColumn get hour => integer()();
  IntColumn get minute => integer()();
}

class MedicineLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get medicineId => integer().references(Medicines, #id, onDelete: KeyAction.cascade)();
  IntColumn get scheduleId => integer().nullable().references(MedicineSchedules, #id, onDelete: KeyAction.setNull)();
  DateTimeColumn get scheduledDateTime => dateTime()();
  DateTimeColumn get actualTakenTime => dateTime().nullable()();
  TextColumn get status => text()(); // 'taken', 'skipped', 'missed'
  RealColumn get dosageTaken => real().withDefault(const Constant(1.0))();
}

class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get age => integer().withDefault(const Constant(25))();
  TextColumn get gender => text().nullable()();
  TextColumn get imagePath => text().nullable()();
  TextColumn get email => text().nullable()();
}

class MedicineWithSchedules {
  final Medicine medicine;
  final List<MedicineSchedule> schedules;
  final List<MedicineLog> todayLogs;

  const MedicineWithSchedules({
    required this.medicine,
    required this.schedules,
    this.todayLogs = const [],
  });

  MealTiming get mealTimingEnum =>
      medicine.mealTiming == 'before' ? MealTiming.before : MealTiming.after;

  DosageUnit get dosageUnitEnum =>
      medicine.dosageUnit == 'cup' ? DosageUnit.cup : DosageUnit.pcs;

  RepeatVariation get repeatVariationEnum {
    switch (medicine.repeatVariation) {
      case 'weekly':
        return RepeatVariation.weekly;
      case 'monthly':
        return RepeatVariation.monthly;
      case 'timely':
        return RepeatVariation.timely;
      case 'day':
      default:
        return RepeatVariation.day;
    }
  }

  List<String> get weekDaysList {
    if (medicine.repeatWeekDays == null) return [];
    try {
      final decoded = jsonDecode(medicine.repeatWeekDays!);
      if (decoded is List) return decoded.cast<String>();
    } catch (_) {}
    return [];
  }

  List<int> get monthDaysList {
    if (medicine.repeatMonthDays == null) return [];
    try {
      final decoded = jsonDecode(medicine.repeatMonthDays!);
      if (decoded is List) return decoded.cast<int>();
    } catch (_) {}
    return [];
  }

  List<MedicineScheduleItem> get scheduleItems {
    return schedules
        .map((s) => MedicineScheduleItem(
              id: s.id,
              medicineId: s.medicineId,
              dayTimeName: s.dayTimeName,
              timeString: s.timeString,
              hour: s.hour,
              minute: s.minute,
            ))
        .toList();
  }
}

@DriftDatabase(tables: [Medicines, MedicineSchedules, MedicineLogs, Users])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'medicine_app_drift');
  }

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      beforeOpen: (details) async {
        // Enable foreign key constraints in SQLite
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }
}
