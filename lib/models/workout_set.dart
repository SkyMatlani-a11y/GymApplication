import 'package:isar/isar.dart';

part 'workout_set.g.dart';

@collection
class WorkoutSet {
  late Id id = Isar.autoIncrement;

  late DateTime dateTime;

  late String exercise;

  late double weight;

  late int repetitions;
}
