import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:dompet_app/core/validators/dompet_amount_validators.dart';
import 'package:dompet_app/features/bills/enums/bill_plan_period_enum.dart';
import 'package:dompet_app/features/bills/utils/bill_schedule.dart';
import 'package:reactive_forms/reactive_forms.dart';

class BillPlanForm extends FormGroup {
  BillPlanForm()
    : super({
        BillPlanKey.accountId: FormControl<int>(
          validators: [Validators.required],
        ),
        _FieldKey.categoryName: FormControl<String>(
          validators: [Validators.required],
        ),
        BillPlanKey.name: FormControl<String>(
          validators: [Validators.required],
        ),
        BillPlanKey.reference: FormControl<String>(),
        BillPlanKey.amount: FormControl<int>(
          validators: DompetAmountValidators.min1(),
        ),
        BillPlanKey.period: FormControl<String>(
          value: BillPlanPeriodEnum.monthly.name,
          validators: [Validators.required],
        ),
        BillPlanKey.billedSchedule: FormControl<String>(
          validators: [Validators.required],
        ),
        BillPlanKey.dueDateSchedule: FormControl<String>(
          validators: [Validators.required],
        ),
        BillPlanKey.reminderDays: FormControl<int>(
          value: 3,
          validators: [Validators.required, Validators.min(0)],
        ),
        BillPlanKey.endedAt: FormControl<DateTime>(),
        _FieldKey.billCount: FormControl<int>(
          validators: [
            Validators.delegate((control) {
              final value = control.value as int?;
              if (value == null) return null;
              return value >= 1 ? null : {'minCount': true};
            }),
          ],
        ),
        BillPlanKey.note: FormControl<String>(),
        _FieldKey.bulkCreate: FormControl<bool>(value: false),
      }, validators: [
        Validators.delegate(_scheduleOrderValidator),
        Validators.delegate(_reminderRangeValidator),
      ]);

  FormControl<int> get accountIdControl =>
      control(BillPlanKey.accountId) as FormControl<int>;
  FormControl<String> get categoryNameControl =>
      control(_FieldKey.categoryName) as FormControl<String>;
  FormControl<String> get nameControl =>
      control(BillPlanKey.name) as FormControl<String>;
  FormControl<String> get referenceControl =>
      control(BillPlanKey.reference) as FormControl<String>;
  FormControl<int> get amountControl =>
      control(BillPlanKey.amount) as FormControl<int>;
  FormControl<String> get periodControl =>
      control(BillPlanKey.period) as FormControl<String>;
  FormControl<String> get billedScheduleControl =>
      control(BillPlanKey.billedSchedule) as FormControl<String>;
  FormControl<String> get dueDateScheduleControl =>
      control(BillPlanKey.dueDateSchedule) as FormControl<String>;
  FormControl<int> get reminderDaysControl =>
      control(BillPlanKey.reminderDays) as FormControl<int>;
  FormControl<DateTime> get endedAtControl =>
      control(BillPlanKey.endedAt) as FormControl<DateTime>;
  FormControl<int> get billCountControl =>
      control(_FieldKey.billCount) as FormControl<int>;
  FormControl<String> get noteControl =>
      control(BillPlanKey.note) as FormControl<String>;
  FormControl<bool> get bulkCreateControl =>
      control(_FieldKey.bulkCreate) as FormControl<bool>;

  int? get accountId => accountIdControl.value;
  String get name => nameControl.value?.trim() ?? '';
  int get amount => amountControl.value ?? 0;
  String get period =>
      periodControl.value ?? BillPlanPeriodEnum.monthly.name;
  int get reminderDays => reminderDaysControl.value ?? 0;
  bool get bulkCreate => bulkCreateControl.value ?? false;
}

/// Monthly: billed harus sebelum due (cermin CHECK di schema).
/// Yearly bebas (due boleh jatuh di tahun berikutnya).
Map<String, dynamic>? _scheduleOrderValidator(
  AbstractControl<dynamic> control,
) {
  final form = control as FormGroup;
  final period = form.control(BillPlanKey.period).value as String?;
  if (period != BillPlanPeriodEnum.monthly.name) return null;
  final billed = form.control(BillPlanKey.billedSchedule).value as String?;
  final due = form.control(BillPlanKey.dueDateSchedule).value as String?;
  if (billed == null || due == null) return null;
  if (BillSchedule.monthlyDayOrder(billed) >=
      BillSchedule.monthlyDayOrder(due)) {
    return {'scheduleOrder': true};
  }
  return null;
}

/// Reminder H-n tidak boleh mendahului tanggal ditagih.
Map<String, dynamic>? _reminderRangeValidator(
  AbstractControl<dynamic> control,
) {
  final form = control as FormGroup;
  final period =
      form.control(BillPlanKey.period).value as String? ??
      BillPlanPeriodEnum.monthly.name;
  final billed = form.control(BillPlanKey.billedSchedule).value as String?;
  final due = form.control(BillPlanKey.dueDateSchedule).value as String?;
  final reminder = form.control(BillPlanKey.reminderDays).value as int?;
  if (reminder == null) return null;
  final max = BillSchedule.maxReminderDays(
    period: period,
    billedSchedule: billed,
    dueDateSchedule: due,
  );
  if (max == null) return null;
  if (reminder > max) return {'reminderRange': true};
  return null;
}

abstract class _FieldKey {
  static const categoryName = 'category_name';
  static const bulkCreate = 'bulk_create';
  static const billCount = 'bill_count';
}
