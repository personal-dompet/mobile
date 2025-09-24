import 'package:reactive_forms/reactive_forms.dart';

class NumberComparisonValidator extends Validator<dynamic> {
  final String subjectControlName;
  final Comparator comparator;
  final String targetControlName;

  NumberComparisonValidator(
      this.subjectControlName, this.comparator, this.targetControlName);

  @override
  Map<String, dynamic>? validate(AbstractControl control) {
    final form = control as FormGroup;

    final subjectControl = form.control(subjectControlName);
    final targetControl = form.control(targetControlName);

    switch (comparator) {
      case Comparator.equal:
        if (subjectControl.value == null || targetControl.value == null) {
          return null;
        }
        if (subjectControl.value! != targetControl.value!) {
          subjectControl.setErrors({'equal': true});
        }
        break;
      case Comparator.notEqual:
        if (subjectControl.value == null || targetControl.value == null) {
          return null;
        }
        if (subjectControl.value! == targetControl.value!) {
          subjectControl.setErrors({'notEqual': true});
        }
        break;
      case Comparator.lessThan:
        if (subjectControl.value == null || targetControl.value == null) {
          return null;
        }
        if (subjectControl.value! < targetControl.value!) {
          subjectControl.setErrors({'lessThan': true});
        }
        break;
      case Comparator.lessThanOrEqual:
        if (subjectControl.value == null || targetControl.value == null) {
          return null;
        }
        if (subjectControl.value! <= targetControl.value!) {
          subjectControl.setErrors({'lessThanOrEqual': true});
        }
        break;
      case Comparator.greaterThan:
        if (subjectControl.value == null || targetControl.value == null) {
          return null;
        }
        if (subjectControl.value! > targetControl.value!) {
          subjectControl.setErrors({'greaterThan': true});
        }
        break;
      case Comparator.greaterThanOrEqual:
        if (subjectControl.value == null || targetControl.value == null) {
          return null;
        }
        if (subjectControl.value! >= targetControl.value!) {
          subjectControl.setErrors({'greaterThanOrEqual': true});
        }
        break;
      default:
        null;
    }

    return null;
  }
}

enum Comparator {
  lessThan,
  lessThanOrEqual,
  greaterThan,
  greaterThanOrEqual,
  equal,
  notEqual,
}
