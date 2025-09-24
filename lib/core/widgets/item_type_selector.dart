import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

class ItemTypeSelector<T> extends ConsumerWidget {
  final FormGroup formGroup;
  final List<T> types;
  final String Function(T) displayName;
  final Color Function(T) color;
  final IconData Function(T)? icon;
  final ValueChanged<T> onTypeChanged;

  const ItemTypeSelector({
    super.key,
    required this.formGroup,
    required this.types,
    required this.displayName,
    required this.color,
    this.icon,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ReactiveForm(
      formGroup: formGroup,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: types.length,
          itemBuilder: (context, index) {
            final type = types[index];
            return ReactiveFormConsumer(
              builder: (context, form, child) {
                final selectedType = _getTypeValue(form);
                return _ItemTypeSelectorItem(
                  type: type,
                  onPressed: () {
                    _setTypeValue(form, type);
                    onTypeChanged(type);
                  },
                  isSelected: selectedType == type,
                  displayName: displayName(type),
                  color: color(type),
                );
              },
            );
          },
          separatorBuilder: (context, index) => const SizedBox(width: 4),
        ),
      ),
    );
  }

  T? _getTypeValue(FormGroup form) {
    final value = form.value['type'];
    return value as T?;
  }

  void _setTypeValue(FormGroup form, T type) {
    final control = form.controls['type'];
    if (control != null) {
      control.value = type;
    }
  }
}

class _ItemTypeSelectorItem<T> extends StatelessWidget {
  final T type;
  final bool isSelected;
  final VoidCallback? onPressed;
  final String displayName;
  final Color color;

  const _ItemTypeSelectorItem({
    this.isSelected = false,
    required this.type,
    this.onPressed,
    required this.displayName,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = Theme.of(context).colorScheme.primary;
    final inactiveColor = Colors.transparent;
    return FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor:
            isSelected ? activeColor.withValues(alpha: 0.3) : inactiveColor,
        side: BorderSide(
            color: isSelected
                ? activeColor
                : Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: .5)),
      ),
      onPressed: onPressed,
      child: Text(
        displayName,
        style: TextStyle(
            color: isSelected
                ? activeColor
                : Theme.of(context).colorScheme.onSurface),
      ),
    );
  }
}