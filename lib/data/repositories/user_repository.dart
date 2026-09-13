import 'package:drift/drift.dart';
import 'package:medicine_app/data/database/app_database.dart';

abstract class UserRepository {
  Future<User?> getUser();
  Future<void> saveUser(UsersCompanion user);
  Future<void> updateProfileImage(String imagePath);
  Stream<User?> watchUser();
  Future<void> syncFromProfileModel(UsersCompanion companion);
}

class DriftUserRepository implements UserRepository {
  final AppDatabase db;

  DriftUserRepository(this.db);

  @override
  Stream<User?> watchUser() {
    return (db.select(db.users)..limit(1)).watchSingleOrNull();
  }

  @override
  Future<User?> getUser() async {
    final users = await (db.select(db.users)..limit(1)).get();
    if (users.isEmpty) {
      // Seed default user if none exists
      final defaultUser = UsersCompanion(
        name: const Value('Shafi Munshi'),
        age: const Value(24),
        gender: const Value('Male'),
      );
      final id = await db.into(db.users).insert(defaultUser);
      return (db.select(db.users)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
    }
    return users.first;
  }

  @override
  Future<void> saveUser(UsersCompanion user) async {
    final existing = await getUser();
    if (existing != null) {
      await (db.update(db.users)..where((tbl) => tbl.id.equals(existing.id))).write(user);
    } else {
      await db.into(db.users).insert(user);
    }
  }

  @override
  Future<void> syncFromProfileModel(UsersCompanion companion) async {
    final existing = await getUser();
    if (existing != null) {
      await (db.update(db.users)..where((tbl) => tbl.id.equals(existing.id))).write(companion);
    } else {
      await db.into(db.users).insert(companion);
    }
  }

  @override
  Future<void> updateProfileImage(String imagePath) async {
    final existing = await getUser();
    if (existing != null) {
      await (db.update(db.users)..where((tbl) => tbl.id.equals(existing.id))).write(
        UsersCompanion(imagePath: Value(imagePath)),
      );
    }
  }
}
