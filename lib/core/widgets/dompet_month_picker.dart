import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<DateTime?> showMonthPicker(
  BuildContext context, {
  required DateTime initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
}) async {
  return showDialog<DateTime>(
    context: context,
    builder: (context) => _DompetMonthPicker(
      initialDate: initialDate,
      firstDate: firstDate ?? DateTime(1970, 1, 1),
      lastDate: lastDate ?? DateTime.now().add(Duration(days: 365 * 100)),
    ),
  );
}

class _DompetMonthPicker extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  const _DompetMonthPicker({
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
  });

  @override
  State<_DompetMonthPicker> createState() => __DompetMonthPickerState();
}

class __DompetMonthPickerState extends State<_DompetMonthPicker> {
  late DateTime _selectedDate;
  double _dragDistance = 0;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  bool get _canGoToPreviousYear => _selectedDate.year > widget.firstDate.year;

  bool get _canGoToNextYear => _selectedDate.year < widget.lastDate.year;

  void _previousYear() {
    if (!_canGoToPreviousYear) return;
    HapticFeedback.mediumImpact();
    setState(() {
      _selectedDate = DateTime(_selectedDate.year - 1, _selectedDate.month);
    });
  }

  void _nextYear() {
    if (!_canGoToNextYear) return;
    HapticFeedback.mediumImpact();
    setState(() {
      _selectedDate = DateTime(_selectedDate.year + 1, _selectedDate.month);
    });
  }

  void _onDragUpdate(DragUpdateDetails details) {
    _dragDistance += details.delta.dx;
  }

  void _onDragEnd(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;
    if (velocity < -200 || _dragDistance <= -48) {
      _nextYear();
    } else if (velocity > 200 || _dragDistance >= 48) {
      _previousYear();
    }
    _dragDistance = 0;
  }

  void _onDragCancel() {
    _dragDistance = 0;
  }

  bool _isSelectable(DateTime date) {
    final isWithinRange =
        date.isAfter(widget.firstDate) &&
        date.isBefore(widget.lastDate.add(const Duration(days: 31)));
    final isFirstMonth =
        date.month == widget.firstDate.month &&
        date.year == widget.firstDate.year;
    final isLastMonth =
        date.month == widget.lastDate.month &&
        date.year == widget.lastDate.year;
    return isWithinRange || isFirstMonth || isLastMonth;
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Dialog(
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Pilih Bulan',
                      style: themeData.textTheme.titleMedium,
                    ),
                  ),
                  IconButton(
                    onPressed: _canGoToPreviousYear ? _previousYear : null,
                    icon: const Icon(Icons.chevron_left_rounded),
                    color: themeData.colorScheme.onSurfaceVariant,
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Text(
                      _selectedDate.year.toString(),
                      key: ValueKey(_selectedDate.year),
                      style: themeData.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _canGoToNextYear ? _nextYear : null,
                    icon: const Icon(Icons.chevron_right_rounded),
                    color: themeData.colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onHorizontalDragUpdate: _onDragUpdate,
                onHorizontalDragEnd: _onDragEnd,
                onHorizontalDragCancel: _onDragCancel,
                child: GridView.count(
                  crossAxisCount: 4,
                  shrinkWrap: true,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  children: List.generate(12, (index) {
                    final month = index + 1;
                    final date = DateTime(_selectedDate.year, month);
                    final isSelectable = _isSelectable(date);
                    final isSelected = date.isAtSameMomentAs(_selectedDate);

                    return Material(
                      color: isSelected
                          ? themeData.colorScheme.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: isSelectable
                            ? () {
                                setState(() {
                                  _selectedDate = DateTime(
                                    _selectedDate.year,
                                    month,
                                  );
                                });
                              }
                            : null,
                        child: Center(
                          child: Opacity(
                            opacity: isSelectable ? 1 : 0.3,
                            child: Text(
                              _monthName(month),
                              style: themeData.textTheme.bodyMedium?.copyWith(
                                color: isSelected
                                    ? themeData.colorScheme.onPrimary
                                    : themeData.colorScheme.onSurface,
                                fontWeight: isSelected ? FontWeight.bold : null,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).dividerColor,
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Batal'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: () => Navigator.pop(context, _selectedDate),
                    child: const Text('Simpan'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return months[month - 1];
  }
}
