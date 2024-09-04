import 'package:flutter_test/flutter_test.dart';
import 'unit_validation.dart';

void main() {
  group('WorkoutSet Validation', () {
    test('Valid input should return true', () {
      expect(validateWorkoutSet('50.0', '12'), isTrue);
    });

    test('Empty weight should return false', () {
      expect(validateWorkoutSet('', '12'), isFalse);
    });

    test('Empty repetitions should return false', () {
      expect(validateWorkoutSet('50.0', ''), isFalse);
    });

    test('Non-numeric weight should return false', () {
      expect(validateWorkoutSet('abc', '12'), isFalse);
    });

    test('Non-numeric repetitions should return false', () {
      expect(validateWorkoutSet('50.0', 'abc'), isFalse);
    });

    test('Negative weight should return false', () {
      expect(validateWorkoutSet('-10.0', '12'), isFalse);
    });

    test('Negative repetitions should return false', () {
      expect(validateWorkoutSet('50.0', '-5'), isFalse);
    });
  });
}
