import 'package:isar/isar.dart';

part 'testing_model.g.dart';
@collection
class TestingModel {
  Id? id = Isar.autoIncrement;
  final String name;

  TestingModel({required this.name});
}
