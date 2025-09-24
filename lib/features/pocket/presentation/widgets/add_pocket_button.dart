import 'package:dompet/features/pocket/domain/enum/pocket_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AddPocketButton extends ConsumerStatefulWidget {
  const AddPocketButton({super.key});

  @override
  ConsumerState<AddPocketButton> createState() => _AddPocketButtonState();
}

class _AddPocketButtonState extends ConsumerState<AddPocketButton> {
  bool _isOpen = false;

  void _toggle() {
    setState(() {
      _isOpen = !_isOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Only show menu items when the menu is open
        if (_isOpen) ...[
          _FabButton(
            icon: PocketType.saving.icon,
            color: Theme.of(context).colorScheme.primary,
            onPressed: () {
              _toggle();
              // TODO: Navigate to saving pocket creation screen
            },
            label: 'Saving Pocket',
          ),
          _FabButton(
            icon: PocketType.recurring.icon,
            color: Theme.of(context).colorScheme.secondary,
            onPressed: () {
              _toggle();
              // TODO: Navigate to recurring pocket creation screen
            },
            label: 'Recurring Pocket',
          ),
          _FabButton(
            icon: PocketType.spending.icon,
            color: Theme.of(context).colorScheme.tertiary,
            onPressed: () {
              _toggle();
              context.push('/pockets/spendings/create');
            },
            label: 'Spending Pocket',
          ),
        ],
        Align(
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
            onPressed: _toggle,
            heroTag: 'pocket_fab_main', // Add unique hero tag
            child: Icon(
              _isOpen ? Icons.close : Icons.add,
            ),
          ),
        ),
      ],
    );
  }
}

class _FabButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
  final String label;

  const _FabButton({
    required this.icon,
    required this.color,
    required this.onPressed,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
          FloatingActionButton(
            mini: true,
            backgroundColor: color,
            onPressed: onPressed,
            heroTag: label, // Add unique hero tag
            child: Icon(icon, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
