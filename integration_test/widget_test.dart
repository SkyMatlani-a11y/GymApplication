import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_application/main.dart';
import 'package:gym_application/models/workout_set.dart';
import 'package:gym_application/utills/constants.dart';
import 'package:gym_application/widgets/workout.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  final directory = Platform.isAndroid
      ? await getExternalStorageDirectory()
      : await getApplicationDocumentsDirectory();
  isar = await Isar.open(
    [WorkoutSetSchema],
    directory: directory!.path,
  );

  // Helper function to create the AddSet widget
  Widget createAddSet({List<dynamic> workoutSetList = const [], int? index}) {
    return ProviderScope(
      child: MaterialApp(
        home: Workout(workoutSetList: workoutSetList, index: index),
      ),
    );
  }

  // Sample workout sets for testing
  List<WorkoutSet> sampleWorkoutSetList = [
    WorkoutSet()
      ..id = 1
      ..exercise = kExercises[0]
      ..weight = 20.0
      ..repetitions = 10
      ..dateTime = DateTime.now(),
    WorkoutSet()
      ..id = 2
      ..exercise = kExercises[1]
      ..weight = 25.0
      ..repetitions = 8
      ..dateTime = DateTime.now(),
  ];

  group('AddSet Widget Tests', () {
    testWidgets('Renders AddSet widget correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createAddSet());
      await tester.pumpAndSettle();
      expect(find.text('Workout'), findsOneWidget);
      expect(find.text('Select Exercise'), findsOneWidget);
      expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
    });

    testWidgets('Form input fields accept values', (WidgetTester tester) async {
      await tester.pumpWidget(createAddSet());
      // Input text into the weight field
      await tester.enterText(find.byKey(const Key('weight')), '50.0');
      await tester.enterText(find.byKey(const Key('repetitions')), '12');
      expect(find.text('50.0'), findsOneWidget);
      expect(find.text('12'), findsOneWidget);
    });

    testWidgets('Displays error when trying to save with empty fields',
        (WidgetTester tester) async {
      await tester.pumpWidget(createAddSet());
      // Attempt to save with empty fields
      await tester.tap(find.text('Save'));
      await tester.pump();
      // Check for error snackbar
      expect(find.text('Weight cannot be empty'), findsOneWidget);
    });

    testWidgets('Adding a new set works correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(createAddSet());
      await tester.enterText(find.byKey(const Key('weight')), '50.0');
      await tester.enterText(find.byKey(const Key('repetitions')), '12');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save'));
      await tester.pump(const Duration(seconds: 1));
      // successful save shows a snackbar
      expect(find.text('Set added successfully.'), findsOneWidget);
    });

    testWidgets('Updating an existing set works correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
          createAddSet(workoutSetList: sampleWorkoutSetList, index: 0));

      expect(
          find.text(sampleWorkoutSetList[0].weight.toString()), findsOneWidget);
      expect(find.text(sampleWorkoutSetList[0].repetitions.toString()),
          findsOneWidget);

      await tester.enterText(find.byKey(const Key('weight')), '60.0');
      await tester.enterText(find.byKey(const Key('repetitions')), '15');

      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Save'));
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Set updated successfully.'), findsOneWidget);
    });
  });
}
