import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicine_app/data/database/app_database.dart';
import 'package:medicine_app/data/repositories/medicine_log_repository.dart';
import 'package:medicine_app/data/repositories/medicine_repository.dart';
import 'package:medicine_app/data/repositories/user_repository.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

final medicineRepositoryProvider = Provider<MedicineRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return DriftMedicineRepository(db);
});

final medicineLogRepositoryProvider = Provider<MedicineLogRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return DriftMedicineLogRepository(db);
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return DriftUserRepository(db);
});
