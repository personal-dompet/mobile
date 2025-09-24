import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SpeedDialFab extends StatefulWidget {
  const SpeedDialFab({super.key});

  @override
  State<SpeedDialFab> createState() => _SpeedDialFabState();
}

class _SpeedDialFabState extends State<SpeedDialFab>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _isOpen = false;

  void _toggle() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _FabButton(
          animation: _animation,
          delay: 0.2,
          icon: Icons.call_made_rounded,
          color: Theme.of(context).colorScheme.primary,
          onPressed: () {
            context.push('/transfers');
            _toggle();
          },
          isOpen: _isOpen,
          label: 'Transfer',
        ),
        _FabButton(
          animation: _animation,
          delay: 0.1,
          icon: Icons.remove_circle_outline_rounded,
          color: Theme.of(context).colorScheme.error,
          onPressed: () {
            // Navigate to expense page
            // For now, we'll just show a snackbar as a placeholder
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Expense action tapped')),
            );
            _toggle();
          },
          isOpen: _isOpen,
          label: 'Expense',
        ),
        _FabButton(
          animation: _animation,
          delay: 0.0,
          icon: Icons.add_circle_outline_rounded,
          color: Theme.of(context).colorScheme.tertiary,
          onPressed: () {
            // Navigate to income page
            // For now, we'll just show a snackbar as a placeholder
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Income action tapped')),
            );
            _toggle();
          },
          isOpen: _isOpen,
          label: 'Income',
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
            onPressed: _toggle,
            child: AnimatedIcon(
              icon: AnimatedIcons.menu_close,
              progress: _controller,
            ),
          ),
        ),
      ],
    );
  }
}

class _FabButton extends StatelessWidget {
  final Animation<double> animation;
  final double delay;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
  final bool isOpen;
  final String label;

  const _FabButton({
    required this.animation,
    required this.delay,
    required this.icon,
    required this.color,
    required this.onPressed,
    required this.isOpen,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.scale(
          scale: isOpen ? 1 : 0,
          child: Opacity(
            opacity: animation.value,
            child: Container(
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
                    child: Icon(icon, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
