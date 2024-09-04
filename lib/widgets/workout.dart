import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_application/models/workout_set.dart';
import 'package:gym_application/provider/workout_set_list.dart';
import 'package:gym_application/utills/constants.dart';

class Workout extends ConsumerStatefulWidget {
  const Workout({
    super.key,
    required this.workoutSetList,
    this.index,
  });

  final int? index;
  final List<dynamic> workoutSetList;

  @override
  ConsumerState<Workout> createState() => _WorkOutAddSetState();
}

class _WorkOutAddSetState extends ConsumerState<Workout> {
  final exerciseProvider = StateProvider<String>((ref) => kExercises.first);

  final TextEditingController weightController = TextEditingController();
  final TextEditingController repetitionController = TextEditingController();

  List<WorkoutSet> workoutSetList = [];

  @override
  void initState() {
    for (var workoutSet in widget.workoutSetList) {
      workoutSetList.add(workoutSet as WorkoutSet);
    }
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.index != null) {
        ref.read(exerciseProvider.notifier).state =
            workoutSetList[widget.index!].exercise;
      }
    });
  }

  @override
  void didChangeDependencies() {
    if (widget.index != null) {
      weightController.text = workoutSetList[widget.index!].weight.toString();
      repetitionController.text =
          workoutSetList[widget.index!].repetitions.toString();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final selectedExercise = ref.watch(exerciseProvider);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Workout', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.blue[200],
          elevation: 2,
          leading: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_ios, color: Colors.white),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Select Exercise",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  elevation: 20,
                  isDense: true,
                  isExpanded: true,
                  value: selectedExercise,
                  items: kExercises.map((exercise) {
                    return DropdownMenuItem(
                      value: exercise,
                      child: Text(exercise),
                    );
                  }).toList(),
                  onChanged: (value) {
                    ref.read(exerciseProvider.notifier).state = value ?? '';
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  key: const Key("weight"),
                  controller: weightController,
                  decoration: InputDecoration(
                    labelText: 'Weight (kg)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                      signed: false, decimal: true),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  key: const Key("repetitions"),
                  controller: repetitionController,
                  decoration: InputDecoration(
                    labelText: 'Repetitions',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton(
                      onPressed: () => context.pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child:
                          const Text("Close", style: TextStyle(fontSize: 16)),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          if (widget.index == null) {
                            await addSet(selectedExercise);
                          } else {
                            await updateSet(selectedExercise, widget.index!,
                                workoutSetList[widget.index!].id);
                          }
                          context.pop();
                        } catch (e) {
                          String errorText = 'Please fill in valid details';
                          if (weightController.text.trim().isEmpty) {
                            errorText = "Weight cannot be empty";
                          } else if (repetitionController.text.trim().isEmpty) {
                            errorText = "Repetitions cannot be empty";
                          }
                          final snackBar = SnackBar(content: Text(errorText));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Colors.blue[200],
                        elevation: 5,
                      ),
                      child: const Text("Save",
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> addSet(String exercise) async {
    WorkoutSet set = WorkoutSet()
      ..dateTime = DateTime.now()
      ..exercise = exercise
      ..repetitions = int.parse(repetitionController.text)
      ..weight = double.parse(weightController.text);
    await ref.read(workoutSetListProvider.notifier).addSet(set, workoutSetList);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      const snackBar = SnackBar(content: Text('Set added successfully.'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  Future<void> updateSet(String exercise, int index, int id) async {
    await ref.read(workoutSetListProvider.notifier).updateSet(
          id,
          index,
          workoutSetList,
          exercise: exercise,
          repetitions: int.parse(repetitionController.text),
          weight: double.parse(weightController.text),
        );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      const snackBar = SnackBar(content: Text('Set updated successfully.'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }
}
