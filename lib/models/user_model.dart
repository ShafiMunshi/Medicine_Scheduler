// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:isar/isar.dart';

part 'user_model.g.dart';

@collection
class UserModel {
  Id? id = Isar.autoIncrement;
  final String name;
  final String email;
  final String? imagePath;
  final int age;
  UserModel({
    this.id,
    required this.name,
    required this.email,
    this.imagePath,
    required this.age,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      imagePath: json['imagePath'],
      age: json['age'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'imagePath': imagePath,
      'age': age,
    };
  }

  static UserModel getSampleUser() {
    return UserModel(
      name: 'John Doe',
      email: 'john.doe@example.com',
      age: 30,
    );
  }

  UserModel copyWith({
    Id? id,
    String? name,
    String? email,
    String? imagePath,
    int? age,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      imagePath: imagePath ?? this.imagePath,
      age: age ?? this.age,
    );
  }
}
