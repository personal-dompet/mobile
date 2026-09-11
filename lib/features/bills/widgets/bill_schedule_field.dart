import 'package:dompet_app/core/constants/last_day.dart';
import 'package:dompet_app/core/widgets/dompet_text_field.dart';
import 'package:dompet_app/features/bills/enums/bill_plan_period_enum.dart';
import 'package:dompet_app/features/bills/utils/bill_schedule.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// Field pemilih jadwal tagih / jatuh tempo.
///
/// - monthly: dialog grid kalender 1-28 (+ "Hari Terakhir" bila
///   [allowLastDay], mis. untuk jatuh tempo).
/// - yearly: dialog dua tahap (grid bulan 3 kolom → grid tanggal penuh sesuai
///   bulan, Februari dibatasi 28, tanpa "Hari Terakhir").
class BillScheduleField extends StatefulWidget {
  final FormControl<String> valueControl;
  final String period;
  final String label;
  final String? placeholder;
  final Map<String, String Function(Object)>? validationMessages;
  final bool allowLastDay;

  const BillScheduleField({
    super.key,
    required this.valueControl,
    required this.period,
    required this.label,
    this.placeholder,
    this.validationMessages,
    this.allowLastDay = true,
  });

  @override
  State<BillScheduleField> createState() => _BillScheduleFieldState();
}

class _BillScheduleFieldState extends State<BillScheduleField> {
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.addListener(() {
        if (focusNode.hasFocus) _openPicker(context);
      });
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  Future<void> _openPicker(BuildContext context) async {
    widget.valueControl.unfocus();

    final result = await showDialog<String>(
      context: context,
      builder: (context) => _SchedulePickerDialog(
        period: widget.period,
        initial: widget.valueControl.value,
        allowLastDay: widget.allowLastDay,
      ),
    );
    if (!context.mounted || result == null) return;

    final control = widget.valueControl;
    control
      ..updateValue(result)
      ..markAsDirty()
      ..markAsTouched();
  }

  @override
  Widget build(BuildContext context) {
    return DompetTextField<String>(
      label: widget.label,
      formControl: widget.valueControl,
      placeholder: widget.placeholder,
      validationMessages: widget.validationMessages,
      readOnly: true,
      focusNode: focusNode,
      suffixIcon: const Icon(Icons.calendar_month_rounded),
      hidePrefixOnEmpty: true,
      valueAccessor: _ScheduleValueAccessor(widget.period),
    );
  }
}

/// Menampilkan label jadwal, menyimpan string mentah schedule.
class _ScheduleValueAccessor extends ControlValueAccessor<String, String> {
  final String period;
  _ScheduleValueAccessor(this.period);

  @override
  String? modelToViewValue(String? modelValue) {
    if (modelValue == null || modelValue.isEmpty) return null;
    return BillSchedule.format(period, modelValue);
  }

  @override
  String? viewToModelValue(String? viewValue) => viewValue;
}

class _SchedulePickerDialog extends StatefulWidget {
  final String period;
  final String? initial;
  final bool allowLastDay;

  const _SchedulePickerDialog({
    required this.period,
    this.initial,
    required this.allowLastDay,
  });

  @override
  State<_SchedulePickerDialog> createState() => _SchedulePickerDialogState();
}

class _SchedulePickerDialogState extends State<_SchedulePickerDialog> {
  int? _month;

  bool get _isYearly => widget.period == BillPlanPeriodEnum.yearly.name;

  int? get _initialDay {
    final initial = widget.initial;
    if (initial == null || initial == lastDay) return null;
    if (_isYearly) {
      if (!initial.contains('-')) return null;
      if (_month != null &&
          int.tryParse(initial.split('-')[0]) == _month) {
        return int.tryParse(initial.split('-')[1]);
      }
      return null;
    }
    return int.tryParse(initial);
  }

  int? get _initialMonth {
    final initial = widget.initial;
    if (!_isYearly || initial == null || !initial.contains('-')) return null;
    return int.tryParse(initial.split('-')[0]);
  }

  @override
  void initState() {
    super.initState();
    _month = _initialMonth;
  }

  /// Maksimal tanggal: Februari selalu 28, lainnya ikut kalender.
  int _maxDay(int month) {
    if (month == 2) return 28;
    return BillSchedule.daysInMonth(2001, month);
  }

  void _pick(String value) => Navigator.pop(context, value);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final showMonthStep = _isYearly && _month == null;

    return AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      title: Text(
        showMonthStep
            ? 'Pilih Bulan'
            : _isYearly
            ? DateFormat(
                'MMMM yyyy',
                'id',
              ).format(DateTime(DateTime.now().year, _month!))
            : 'Pilih Tanggal',
        style: themeData.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: showMonthStep
            ? _MonthGrid(
                selected: _initialMonth,
                onPick: (month) => setState(() => _month = month),
              )
            : _DayStep(
                isYearly: _isYearly,
                maxDay: _isYearly ? _maxDay(_month!) : 28,
                selectedDay: _initialDay,
                showLastDay:
                    !_isYearly &&
                    widget.allowLastDay &&
                    widget.initial == lastDay,
                allowLastDay: widget.allowLastDay,
                onBack: _isYearly
                    ? () => setState(() => _month = null)
                    : null,
                onPickDay: (day) {
                  if (_isYearly) {
                    final mm = _month.toString().padLeft(2, '0');
                    final dd = day.toString().padLeft(2, '0');
                    _pick('$mm-$dd');
                  } else {
                    _pick(day.toString());
                  }
                },
                onPickLastDay: () => _pick(lastDay),
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
      ],
    );
  }
}

/// Grid bulan 3 kolom, nama 3 huruf, gaya borderless seperti grid tanggal.
class _MonthGrid extends StatelessWidget {
  final int? selected;
  final void Function(int month) onPick;

  const _MonthGrid({required this.selected, required this.onPick});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
      ),
      itemCount: 12,
      itemBuilder: (context, index) {
        final month = index + 1;
        final label = DateFormat(
          'MMM',
          'id',
        ).format(DateTime(2000, month));
        if (selected == month) {
          return FilledButton(
            style: FilledButton.styleFrom(
              minimumSize: Size.zero,
              padding: EdgeInsets.zero,
              tapTargetSize: .shrinkWrap,
            ),
            onPressed: () => onPick(month),
            child: Text(label),
          );
        }
        return TextButton(
          style: TextButton.styleFrom(
            minimumSize: Size.zero,
            padding: EdgeInsets.zero,
            tapTargetSize: .shrinkWrap,
          ),
          onPressed: () => onPick(month),
          child: Text(label),
        );
      },
    );
  }
}

class _DayStep extends StatelessWidget {
  final bool isYearly;
  final int maxDay;
  final int? selectedDay;
  final bool showLastDay;
  final bool allowLastDay;
  final VoidCallback? onBack;
  final void Function(int day) onPickDay;
  final VoidCallback onPickLastDay;

  const _DayStep({
    required this.isYearly,
    required this.maxDay,
    required this.selectedDay,
    required this.showLastDay,
    required this.allowLastDay,
    required this.onBack,
    required this.onPickDay,
    required this.onPickLastDay,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (onBack != null)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back_rounded),
              label: const Text('Ganti bulan'),
            ),
          ),
        Flexible(
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
            ),
            itemCount: isYearly ? maxDay : 28,
            itemBuilder: (context, index) {
              final day = index + 1;
              final style = TextButton.styleFrom(
                minimumSize: Size.zero,
                padding: EdgeInsets.zero,
                tapTargetSize: .shrinkWrap,
              );
              if (selectedDay == day) {
                return FilledButton(
                  style: FilledButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: EdgeInsets.zero,
                    tapTargetSize: .shrinkWrap,
                  ),
                  onPressed: () => onPickDay(day),
                  child: Text('$day'),
                );
              }
              return TextButton(
                style: style,
                onPressed: () => onPickDay(day),
                child: Text('$day'),
              );
            },
          ),
        ),
        if (!isYearly && allowLastDay) ...[
          const SizedBox(height: 8),
          showLastDay
              ? FilledButton.tonal(
                  onPressed: onPickLastDay,
                  child: const Text('Hari Terakhir'),
                )
              : OutlinedButton(
                  onPressed: onPickLastDay,
                  child: const Text('Hari Terakhir'),
                ),
        ],
      ],
    );
  }
}
