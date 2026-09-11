import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:dompet_app/core/dependencies/init_dependency.dart';
import 'package:dompet_app/core/extensions/date.dart';
import 'package:dompet_app/core/extensions/number.dart';
import 'package:dompet_app/core/router/router.gr.dart';
import 'package:dompet_app/core/states/action_state.dart';
import 'package:dompet_app/core/widgets/calculator.dart';
import 'package:dompet_app/core/widgets/widget.dart';
import 'package:dompet_app/features/accounts/models/account.dart';
import 'package:dompet_app/features/bills/cubits/bill_plan_action_cubit.dart';
import 'package:dompet_app/features/bills/cubits/bill_signal_cubit.dart';
import 'package:dompet_app/features/bills/enums/bill_plan_period_enum.dart';
import 'package:dompet_app/features/bills/forms/bill_plan_form.dart';
import 'package:dompet_app/features/bills/models/bill_plan.dart';
import 'package:dompet_app/features/bills/utils/bill_schedule.dart';
import 'package:dompet_app/features/bills/widgets/bill_schedule_field.dart';
import 'package:dompet_app/features/categories/cubits/category_cubit.dart';
import 'package:dompet_app/features/categories/widgets/category_field.dart';
import 'package:dompet_app/features/savings/cubits/saving_action_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';

@RoutePage()
class BillPlanFormPage extends StatefulWidget {
  final Account? account;
  final BillPlan? plan;
  const BillPlanFormPage({super.key, this.account, this.plan});

  @override
  State<BillPlanFormPage> createState() => _BillPlanFormPageState();
}

class _BillPlanFormPageState extends State<BillPlanFormPage> {
  final _loading = LoadingOverlay();

  late final BillPlanForm _form;
  late final int _refYear;
  late final StreamSubscription<String?> _periodSub;
  late final StreamSubscription<DateTime?> _endedAtSub;
  late final StreamSubscription<int?> _countSub;
  late final StreamSubscription<String?> _billedSub;
  late final StreamSubscription<String?> _dueSub;
  bool _syncing = false;

  bool get _isEdit => widget.plan != null;

  @override
  void initState() {
    super.initState();
    _form = BillPlanForm();
    _refYear = DateTime.now().year;

    final plan = widget.plan;
    final account = widget.account;
    if (account != null) {
      _form.accountIdControl.value = account.id;
      _form.categoryNameControl.value = account.name;
    }
    if (plan != null) {
      _form.accountIdControl.value = plan.accountId;
      _loadCategoryName(plan.accountId);
      _form.nameControl.value = plan.name;
      _form.amountControl.value = plan.amount;
      _form.referenceControl.value = plan.reference;
      _form.periodControl.value = plan.period;
      _form.billedScheduleControl.value = plan.billedSchedule;
      _form.dueDateScheduleControl.value = plan.dueDateSchedule;
      _form.reminderDaysControl.value = plan.reminderDays ?? 3;
      _form.endedAtControl.value = plan.endedAt == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(plan.endedAt! * 1000);
      _form.noteControl.value = plan.note;
      _form.billCountControl.value = _tryCountAfterPrefill(
        period: plan.period,
        billedSchedule: plan.billedSchedule,
        endedAt: _form.endedAtControl.value,
      );
      _clampReminder();
    }

    // Jadwal monthly & yearly tidak kompatibel → reset saat periode diganti.
    _periodSub = _form.periodControl.valueChanges.listen((_) {
      _form.billedScheduleControl.value = null;
      _form.dueDateScheduleControl.value = null;
      _clampReminder();
    });

    // Tanggal Berakhir ⇄ Banyak Tagihan saling mengisi (count hanya UI,
    // yang disimpan tetap endedAt).
    _endedAtSub = _form.endedAtControl.valueChanges.listen((_) {
      _refreshCount();
    });
    _billedSub = _form.billedScheduleControl.valueChanges.listen((_) {
      _refreshCount();
      _clampReminder();
    });
    _dueSub = _form.dueDateScheduleControl.valueChanges.listen((_) {
      _clampReminder();
    });
    _countSub = _form.billCountControl.valueChanges.listen((_) {
      _refreshEndedAt();
    });
  }

  int? _tryCount() {
    try {
      final billed = _form.billedScheduleControl.value;
      final endedAt = _form.endedAtControl.value;
      if (billed == null || endedAt == null) return null;
      return BillSchedule.countDrafts(
        period: _form.period,
        billedSchedule: billed,
        endedAt: endedAt,
      );
    } catch (_) {
      return null;
    }
  }

  DateTime? _tryNthDate(int count) {
    try {
      final billed = _form.billedScheduleControl.value;
      if (billed == null || count < 1) return null;
      return BillSchedule.nthBilledDate(
        period: _form.period,
        billedSchedule: billed,
        n: count,
      );
    } catch (_) {
      return null;
    }
  }

  void _refreshCount() {
    if (_syncing) return;
    _syncing = true;
    try {
      final count = _tryCount();
      if (count != _form.billCountControl.value) {
        _form.billCountControl.updateValue(count);
      }
    } finally {
      _syncing = false;
    }
  }

  void _refreshEndedAt() {
    if (_syncing) return;
    _syncing = true;
    try {
      final count = _form.billCountControl.value;
      final date = count == null ? null : _tryNthDate(count);
      if (date != _form.endedAtControl.value) {
        _form.endedAtControl.updateValue(date);
      }
    } finally {
      _syncing = false;
    }
  }

  /// Maks reminder kontekstual (null → jadwal belum lengkap, fallback 27).
  int? _reminderMax() {
    return BillSchedule.maxReminderDays(
      period: _form.period,
      billedSchedule: _form.billedScheduleControl.value,
      dueDateSchedule: _form.dueDateScheduleControl.value,
      refYear: _refYear,
    );
  }

  /// Turunkan reminder bila melebihi selisih tagih–tempo (negatif → 0 = mati).
  void _clampReminder() {
    final max = (_reminderMax() ?? 27).clamp(0, 1 << 30);
    final value = _form.reminderDaysControl.value ?? 0;
    if (value > max) _form.reminderDaysControl.updateValue(max);
  }

  @override
  void dispose() {
    _periodSub.cancel();
    _endedAtSub.cancel();
    _countSub.cancel();
    _billedSub.cancel();
    _dueSub.cancel();
    _form.dispose();
    super.dispose();
  }

  Future<void> _loadCategoryName(int accountId) async {
    final account = await getIt<CategoryCubit>().getCategoryById(accountId);
    if (!mounted) return;
    _form.categoryNameControl.updateValue(account?.name);
  }

  /// Hitung count awal mode ubah (listener belum aktif saat prefill).
  int? _tryCountAfterPrefill({
    required String period,
    required String billedSchedule,
    required DateTime? endedAt,
  }) {
    try {
      if (endedAt == null) return null;
      return BillSchedule.countDrafts(
        period: period,
        billedSchedule: billedSchedule,
        endedAt: endedAt,
      );
    } catch (_) {
      return null;
    }
  }

  void _showValidationMessage() {
    final message = !_form.amountControl.valid
        ? 'Nominal tagihan belum diisi'
        : !_form.accountIdControl.valid
        ? 'Pilih kategori terlebih dahulu'
        : !_form.nameControl.valid
        ? 'Masukkan nama tagihan terlebih dahulu'
        : !_form.billedScheduleControl.valid
        ? 'Pilih jadwal tagih dahulu'
        : !_form.dueDateScheduleControl.valid
        ? 'Pilih jadwal jatuh tempo dahulu'
        : !_form.billCountControl.valid
        ? 'Minimal 1 tagihan'
        : _form.hasError('scheduleOrder')
        ? 'Jadwal tagih harus sebelum jatuh tempo'
        : _form.hasError('reminderRange')
        ? 'Pengingat melebihi selisih tanggal tagih'
        : null;
    if (message == null) return;
    ScaffoldMessenger.of(context).showSnackBar(
      DompetSnackbar(context, message: message, snackBarType: .error),
    );
  }

  Future<void> _submit(BuildContext actionContext) async {
    _form.markAllAsTouched();

    if (!_form.valid) {
      _showValidationMessage();
      return;
    }

    final plan = await actionContext.read<BillPlanActionCubit>().savePlan(
      form: _form,
      planId: widget.plan?.id,
      successMessage: _isEdit
          ? 'Tagihan rutin berhasil diubah'
          : 'Tagihan rutin berhasil disimpan',
    );

    if (!actionContext.mounted) return;

    if (plan != null) {
      actionContext.read<BillSignalCubit>().created();
      final goTarget =
          !_isEdit &&
          plan.period == BillPlanPeriodEnum.yearly.name &&
          await _offerSinkingFund(plan);
      if (!actionContext.mounted) return;
      if (goTarget) {
        // Ganti halaman form dengan form target terisi + ter-link.
        // Back kembali ke list (bukan ke form basi).
        actionContext.router.replace(
          SavingFormRoute(
            prefillName: 'Dana ${plan.name}',
            prefillAmount: plan.amount,
            prefillDate: _upcomingDueDate(plan),
            prefillNote: 'Sisihan ${plan.name}',
            linkBillPlanId: plan.id,
            linkBillPeriod: _upcomingPeriodLabel(plan),
          ),
        );
        return;
      }
      // Tujuan detail plan menyusul di halaman BillPlanPage.
      actionContext.router.maybePop(true);
    }
  }

  /// Label kemunculan billed terdekat (untuk yearly: tahun "2026").
  String _upcomingPeriodLabel(BillPlan plan) {
    final billed = BillSchedule.nextBilled(
      DateTime.now(),
      plan.period,
      plan.billedSchedule,
    );
    return BillSchedule.billPeriodFor(billed, plan.period);
  }

  /// Jatuh tempo kemunculan billed terdekat (prefill tanggal target).
  DateTime _upcomingDueDate(BillPlan plan) {
    final billed = BillSchedule.nextBilled(
      DateTime.now(),
      plan.period,
      plan.billedSchedule,
    );
    return BillSchedule.dueDateFor(billed, plan.period, plan.dueDateSchedule);
  }

  /// Tawarkan pembuatan target sisihan. False bila sudah ada target
  /// untuk kemunculan ini atau user menolak.
  Future<bool> _offerSinkingFund(BillPlan plan) async {
    final label = _upcomingPeriodLabel(plan);
    final existing = await getIt<SavingActionCubit>().getLinkedTarget(
      plan.id,
      label,
    );
    if (existing != null) return false;
    if (!mounted) return false;

    final due = _upcomingDueDate(plan);
    final now = DateTime.now();
    final months = ((due.year - now.year) * 12 + (due.month - now.month)).clamp(
      1,
      120,
    );
    final perMonth = (plan.amount / months).ceil();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Sisihkan dana bulanan?'),
        content: Text(
          '"${plan.name}" ${plan.amount.currency} jatuh tempo '
          '${due.format(includeDay: true)}. Buat target sisihan '
          'sekitar ${perMonth.currency}/bulan dan pantau di fitur Target?',
        ),
        actions: [
          TextButton(
            onPressed: () => dialogContext.router.maybePop(false),
            child: const Text('Nanti'),
          ),
          FilledButton(
            onPressed: () => dialogContext.router.maybePop(true),
            child: const Text('Buat Target'),
          ),
        ],
      ),
    );
    return confirmed == true;
  }

  @override
  Widget build(BuildContext context) {
    return ReactiveForm(
      formGroup: _form,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _isEdit ? 'Ubah Tagihan Rutin' : 'Buat Tagihan Rutin',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        bottomNavigationBar: BlocProvider(
          create: (context) => getIt<BillPlanActionCubit>(),
          child: BlocListener<BillPlanActionCubit, ActionState>(
            listener: (context, state) {
              state.maybeWhen(
                orElse: () {
                  _loading.hide();
                },
                loading: () {
                  _loading.show(context, text: 'Menyimpan tagihan rutin...');
                },
                error: (message) {
                  _loading.hide();
                  ScaffoldMessenger.of(context).showSnackBar(
                    DompetSnackbar(
                      context,
                      message: message,
                      snackBarType: .error,
                    ),
                  );
                },
                success: (message) {
                  _loading.hide();
                  ScaffoldMessenger.of(context).showSnackBar(
                    DompetSnackbar(
                      context,
                      message: message,
                      snackBarType: .success,
                    ),
                  );
                },
              );
            },
            child: Builder(
              builder: (providedContext) {
                return Padding(
                  padding: const EdgeInsets.all(16).copyWith(bottom: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      FilledButton(
                        onPressed: () => _submit(providedContext),
                        child: Text(_isEdit ? 'Simpan Perubahan' : 'Simpan'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              spacing: 16,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      fit: FlexFit.loose,
                      child: AmountInput(
                        formControl: _form.amountControl,
                        errorMessage: 'Masukkan nominalnya dulu',
                      ),
                    ),
                    const SizedBox(width: 8),
                    CalculatorTriggerButton(
                      initialValue: _form.amountControl.value,
                      onValueApplied: (value) {
                        final control = _form.amountControl;
                        control
                          ..updateValue(value)
                          ..markAsDirty()
                          ..markAsTouched();
                      },
                    ),
                  ],
                ),

                DompetTextField(
                  label: 'Nama Tagihan',
                  formControl: _form.nameControl,
                  placeholder: 'Contoh: Listrik rumah',
                  textInputAction: .next,
                  validationMessages: {
                    ValidationMessage.required: (_) =>
                        'Masukkan nama tagihan terlebih dahulu',
                  },
                ),

                CategoryField(
                  valueControl: _form.accountIdControl,
                  nameControl: _form.categoryNameControl,
                  type: .expense,
                  required: true,
                  readOnly: _isEdit,
                  validationMessages: {
                    ValidationMessage.required: (_) =>
                        'Pilih kategori terlebih dahulu',
                  },
                ),

                DompetTextField(
                  label: 'Penanda (Opsional)',
                  formControl: _form.referenceControl,
                  placeholder: 'Contoh: No. listrik 123456...',
                ),

                DompetDropdownField<String>(
                  label: 'Periode',
                  formControl: _form.periodControl,
                  items: const [
                    DropdownMenuItem(value: 'monthly', child: Text('Bulanan')),
                    DropdownMenuItem(value: 'yearly', child: Text('Tahunan')),
                  ],
                ),

                ReactiveValueListenableBuilder<String>(
                  formControl: _form.periodControl,
                  builder: (context, control, child) {
                    final period =
                        control.value ?? BillPlanPeriodEnum.monthly.name;
                    return Column(
                      spacing: 16,
                      children: [
                        Column(
                          spacing: 6,
                          children: [
                            BillScheduleField(
                              valueControl: _form.billedScheduleControl,
                              period: period,
                              label: 'Jadwal Ditagih',
                              placeholder: 'Pilih tanggal',
                              validationMessages: {
                                ValidationMessage.required: (_) =>
                                    'Pilih jadwal tagih dahulu',
                              },
                              allowLastDay: false,
                            ),
                            if (period == BillPlanPeriodEnum.yearly.name)
                              const _YearlyTipBox(),
                          ],
                        ),
                        BillScheduleField(
                          valueControl: _form.dueDateScheduleControl,
                          period: period,
                          label: 'Jadwal Jatuh Tempo',
                          placeholder: 'Pilih tanggal',
                          validationMessages: {
                            ValidationMessage.required: (_) =>
                                'Pilih jadwal jatuh tempo dahulu',
                          },
                        ),
                      ],
                    );
                  },
                ),

                Column(
                  spacing: 4,
                  children: [
                    Row(
                      spacing: 12,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: DompetDatePicker(
                            formControl: _form.endedAtControl,
                            label: 'Tanggal Berakhir (Opsional)',
                            placeholder: 'Pilih tanggal',
                            firstDate: DateTime.now(),
                            showClearIcon: true,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: DompetTextField<int>(
                            label: 'Banyak Tagihan',
                            formControl: _form.billCountControl,
                            placeholder: 'Contoh: 12',
                            keyboardType: TextInputType.number,
                            validationMessages: {
                              'minCount': (_) => 'Minimal 1 tagihan',
                            },
                            valueAccessor: _IntValueAccessor(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                DompetTextField(
                  label: 'Keterangan (Opsional)',
                  formControl: _form.noteControl,
                  keyboardType: TextInputType.multiline,
                  placeholder: 'Contoh: Listrik rumah, pajak motor...',
                ),

                _ReminderStepper(form: _form, refYear: _refYear),

                ReactiveFormConsumer(
                  builder: (context, form, child) {
                    final endedAt = _form.endedAtControl.value;
                    if (endedAt == null) return const SizedBox.shrink();
                    final count = _previewCount();
                    return CheckboxListTile(
                      value: _form.bulkCreate,
                      onChanged: (value) {
                        _form.bulkCreateControl.updateValue(value ?? false);
                      },
                      title: const Text('Buat semua tagihan sekaligus'),
                      subtitle: Text(
                        count > 0
                            ? 'Akan dibuat $count tagihan (draft)'
                            : 'Lengkapi jadwal dulu untuk melihat jumlah',
                      ),
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: .leading,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  int _previewCount() {
    try {
      final billed = _form.billedScheduleControl.value;
      if (billed == null) return 0;
      final endedAt = _form.endedAtControl.value;
      if (endedAt == null) return 0;
      return BillSchedule.countDrafts(
        period: _form.period,
        billedSchedule: billed,
        endedAt: endedAt,
      );
    } catch (_) {
      return 0;
    }
  }
}

/// Jembatan angka ⇄ teks untuk field Banyak Tagihan.
class _IntValueAccessor extends ControlValueAccessor<int, String> {
  @override
  String? modelToViewValue(int? modelValue) {
    return modelValue?.toString();
  }

  @override
  int? viewToModelValue(String? viewValue) {
    if (viewValue == null || viewValue.isEmpty) return null;
    return int.tryParse(viewValue);
  }
}

/// Tips kecil di bawah Jadwal Ditagih khusus periode tahunan.
class _YearlyTipBox extends StatelessWidget {
  const _YearlyTipBox();

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: themeData.colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lightbulb_outline_rounded,
            size: 18,
            color: themeData.colorScheme.primary,
          ),
          Expanded(
            child: Text(
              'Tips: pilih awal bulan dari tanggal jatuh tempo supaya tidak mengganggu keuangan bulan lainnya.',
              style: themeData.textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

/// Switch + stepper pengingat (aktif: H-1 s.d. selisih tagih–tempo,
/// mati: 0 = tanpa pengingat; selisih 0 → dipaksa mati).
class _ReminderStepper extends StatelessWidget {
  final BillPlanForm form;
  final int refYear;
  const _ReminderStepper({required this.form, required this.refYear});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return ReactiveFormConsumer(
      builder: (context, formGroup, child) {
        final value = form.reminderDaysControl.value ?? 0;
        final enabled = value > 0;
        final max = (BillSchedule.maxReminderDays(
                  period: form.period,
                  billedSchedule: form.billedScheduleControl.value,
                  dueDateSchedule: form.dueDateScheduleControl.value,
                  refYear: refYear,
                ) ??
                27)
            .clamp(0, 1 << 30);
        final canEnable = max > 0;
        final defaultOn = canEnable ? (3 <= max ? 3 : max) : 0;
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 4,
          ).copyWith(top: 0),
          decoration: BoxDecoration(
            border: Border.all(color: themeData.colorScheme.outlineVariant),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: !canEnable
                          ? null
                          : () {
                              form.reminderDaysControl.updateValue(
                                enabled ? 0 : defaultOn,
                              );
                            },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text('Aktifkan Pengingat'),
                      ),
                    ),
                  ),
                  Switch(
                    value: enabled,
                    onChanged: !canEnable
                        ? null
                        : (on) {
                            form.reminderDaysControl.updateValue(
                              on ? defaultOn : 0,
                            );
                          },
                  ),
                ],
              ),
              Opacity(
                opacity: enabled ? 1 : 0.4,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Ingatkan Sebelum Jatuh Tempo'),
                          Text(
                            !enabled
                                ? (canEnable
                                      ? 'Tanpa pengingat • maks H-$max'
                                      : 'Tidak tersedia untuk jadwal ini')
                                : 'H-$value sebelum jatuh tempo • maks H-$max',
                            style: themeData.textTheme.bodySmall?.copyWith(
                              color: themeData.textTheme.bodySmall?.color
                                  ?.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: !enabled || value <= 1
                          ? null
                          : () =>
                                form.reminderDaysControl.updateValue(value - 1),
                      icon: const Icon(Icons.remove_circle_outline_rounded),
                    ),
                    Text('$value', style: themeData.textTheme.titleMedium),
                    IconButton(
                      onPressed: !enabled || value >= max
                          ? null
                          : () =>
                                form.reminderDaysControl.updateValue(value + 1),
                      icon: const Icon(Icons.add_circle_outline_rounded),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
