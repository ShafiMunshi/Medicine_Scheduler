import 'dart:convert';

class UserModels {
  String name;
  int age;
  String profilePhotoUrl;
  DateTime createdAt;
  DateTime modifiedAt;
  UserModels({
    required this.name,
    required this.age,
    required this.profilePhotoUrl,
    required this.createdAt,
    required this.modifiedAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'age': age,
      'profilePhotoUrl': profilePhotoUrl,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'modifiedAt': modifiedAt.millisecondsSinceEpoch,
    };
  }

  factory UserModels.fromMap(Map<String, dynamic> map) {
    return UserModels(
      name: map['name'] as String,
      age: map['age'] as int,
      profilePhotoUrl: map['profilePhotoUrl'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      modifiedAt: DateTime.fromMillisecondsSinceEpoch(map['modifiedAt'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModels.fromJson(String source) =>
      UserModels.fromMap(json.decode(source) as Map<String, dynamic>);
}
