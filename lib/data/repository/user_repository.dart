import 'dart:developer';

import 'package:isar/isar.dart';
import 'package:medicine_app/data/source/local_db_source.dart';
import 'package:medicine_app/models/user_model.dart';

class UserRepository {
  final LocalDatabaseService db;
  UserRepository(this.db);

  Future<int> insertUser(UserModel userData) async {
    try {
      final user = userData.copyWith(id: 1); // Ensure single user with id 1
      final rowId = await db.isar.writeTxn(() async {
        return await db.isar.userModels.put(user);
      });

      log("Inserted User with rowId: $rowId");
      return rowId;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<UserModel?> getUserData() async {
    try {
      return await db.isar.userModels.where().findFirst();
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }

  Future<void> updateUserData(UserModel userData) async {
    try {
      await db.isar.writeTxn(() async {
        await db.isar.userModels.put(userData);
      });
      log("User data updated successfully.");
    } catch (e) {
      throw Exception(e);
    }
  }
}
