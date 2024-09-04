import 'package:gym_application/main.dart';
import 'package:gym_application/models/workout_set.dart';
import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'workout_set_list.g.dart';

@riverpod
class WorkoutSetList extends _$WorkoutSetList {
  @override
  Future<List<WorkoutSet>> build() async {
    final workoutSetCollection = isar.collection<WorkoutSet>();
    List<WorkoutSet> workoutSets = await workoutSetCollection.where().findAll();
    return workoutSets;
  }

  Future<void> addSet(
      WorkoutSet workoutSet, List<WorkoutSet> workoutSets) async {
    await isar.writeTxn(() async {
      await isar.workoutSets.put(workoutSet);
    });
    workoutSets.add(workoutSet);
    state = AsyncData(workoutSets);
  }

  Future<void> updateSet(
    int id,
    int index,
    List<WorkoutSet> workoutSets, {
    required int repetitions,
    required double weight,
    required String exercise,
  }) async {
    final set = await isar.workoutSets.get(id);
    set!.exercise = exercise;
    set.repetitions = repetitions;
    set.weight = weight;

    await isar.writeTxn(() async {
      await isar.workoutSets.put(set);
    });
    workoutSets.removeAt(index);
    workoutSets.insert(index, set);
    state = AsyncData(workoutSets);
  }

  Future<void> deleteSet(int index, List<WorkoutSet> workoutSets) async {
    await isar.writeTxn(() async {
      await isar.workoutSets.delete(workoutSets[index].id);
    });
    workoutSets.removeAt(index);
    state = AsyncData(workoutSets);
  }
}
