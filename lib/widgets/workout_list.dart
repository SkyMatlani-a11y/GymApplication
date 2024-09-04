import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_application/models/workout_set.dart';
import 'package:gym_application/provider/workout_set_list.dart';

class WorkOutList extends ConsumerStatefulWidget {
  const WorkOutList({super.key});

  @override
  ConsumerState<WorkOutList> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends ConsumerState<WorkOutList> {
  @override
  Widget build(BuildContext context) {
    final setAsyncValue = ref.watch(workoutSetListProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text('Workout List', style: TextStyle(color: Colors.white))),
        backgroundColor: Colors.blue[200],
        elevation: 0,
      ),
      body: setAsyncValue.when(
        data: (sets) => ListView.builder(
          itemCount: sets.length,
          itemBuilder: (context, index) {
            WorkoutSet workoutSet = sets[index];
            return GestureDetector(
              onTap: () {
                addWorkout(sets, index: index);
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                elevation: 4,
                shadowColor: Colors.blue[200],
                child: Dismissible(
                  key: Key('${workoutSet.id}'),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    padding: const EdgeInsets.only(right: 20),
                    alignment: Alignment.centerRight,
                    color: Colors.redAccent,
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  onDismissed: (direction) {
                    ref
                        .read(workoutSetListProvider.notifier)
                        .deleteSet(index, setAsyncValue.value ?? []);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Deleted ${workoutSet.exercise} set.'),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                  },
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(15),
                    title: Text(
                      "Set ${index + 1} : ${workoutSet.exercise}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Weight: ${workoutSet.weight}kg \nRepetitions: ${workoutSet.repetitions}',
                        style: const TextStyle(fontSize: 14, height: 1.5),
                      ),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: Colors.blue[200],
                        ),
                        Text(
                          '${workoutSet.dateTime.day.toString().padLeft(2, "0")}-${workoutSet.dateTime.month.toString().padLeft(2, "0")}-${workoutSet.dateTime.year}',
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text(
            'Error: $error',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addWorkout(setAsyncValue.value ?? []),
        backgroundColor: Colors.blue[200],
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  void addWorkout(List<WorkoutSet> workoutSetList, {int? index}) {
    Map<String, dynamic> params = {
      "workoutId": 0,
      "workoutSetList": workoutSetList,
    };
    if (index != null) {
      params["index"] = index;
    }
    context.pushNamed(
      '/add_set',
      extra: params,
    );
  }
}
