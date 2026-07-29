import 'package:dompet_app/core/enums/periodic_time.dart';
import 'package:dompet_app/core/extensions/date.dart';
import 'package:dompet_app/features/activities/enums/activity_type.dart';
import 'package:dompet_app/features/journals/models/journal_filter.dart';
import 'package:reactive_forms/reactive_forms.dart';

class ActivityFilterForm extends FormGroup {
  ActivityFilterForm()
    : super({
        _FieldKey.description: FormControl<String>(),
        _FieldKey.type: FormControl<ActivityType>(value: .all),
        _FieldKey.periode: FormControl<PeriodicTime>(value: .all),
      });

  FormControl<String> get descriptionControl =>
      control(_FieldKey.description) as FormControl<String>;
  FormControl<ActivityType> get typeControl =>
      control(_FieldKey.type) as FormControl<ActivityType>;
  FormControl<PeriodicTime> get periodeControl =>
      control(_FieldKey.periode) as FormControl<PeriodicTime>;

  String? get description => descriptionControl.value;
  ActivityType? get type => typeControl.value;
  PeriodicTime? get periode => periodeControl.value;

  JournalFilter get filter {
    final now = DateTime.now();
    final (DateTime, DateTime)? dates = switch (periode) {
      .today => (now.startOfDay, now.endOfDay),
      .last7Days => (now.subtract(Duration(days: 6)).startOfDay, now.endOfDay),
      .last30Days => (
        now.subtract(Duration(days: 29)).startOfDay,
        now.endOfDay,
      ),
      .thisMonth => (now.startOfMonth, now.endOfMonth),
      _ => null,
    };
    return JournalFilter(description: description, type: type, dates: dates);
  }
}

abstract class _FieldKey {
  static const description = 'description';
  static const type = 'type';
  static const periode = 'preiode';
}
