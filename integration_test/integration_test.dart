import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_application/main.dart';
import 'package:gym_application/models/workout_set.dart';
import 'package:gym_application/widgets/workout.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    final directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();

    isar = await Isar.open(
      [WorkoutSetSchema],
      directory: directory!.path,
    );
  });

  tearDown(() async {
    await isar.writeTxn(() async {
      await isar.workoutSets.clear();
    });
  });

  testWidgets('Adding a set should persist in the Isar database',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Workout(workoutSetList: [], index: null),
        ),
      ),
    );

    // Simulate user input
    await tester.enterText(find.byKey(const Key('weight')), '70.0');
    await tester.enterText(find.byKey(const Key('repetitions')), '15');
    await tester.tap(find.text('Save'));

    // Wait for the UI to update
    await tester.pumpAndSettle();

    // Verify the set is saved in the database
    final savedSets = await isar.workoutSets.where().findAll();
    expect(savedSets.length, 1);
    expect(savedSets.first.weight, 70.0);
    expect(savedSets.first.repetitions, 15);
  });
}
