bool validateWorkoutSet(String weight, String repetitions) {
  if (weight.isEmpty) {
    return false;
  }
  if (repetitions.isEmpty) {
    return false;
  }
  final weightValue = double.tryParse(weight);
  final repetitionsValue = int.tryParse(repetitions);

  if (weightValue == null || weightValue <= 0) {
    return false;
  }
  if (repetitionsValue == null || repetitionsValue <= 0) {
    return false;
  }
  return true;
}
