import 'package:flutter/material.dart';

class ItemCard<T> extends StatefulWidget {
  final T item;
  final int Function(T) id;
  final String Function(T) name;
  final String Function(T) balance;
  final Color? Function(T)? color;
  final IconData? Function(T)? icon;
  final String Function(T) displayName;
  final bool isSelected;
  final VoidCallback? onTap;

  const ItemCard({
    super.key,
    required this.item,
    required this.id,
    required this.name,
    required this.balance,
    this.color,
    this.icon,
    required this.displayName,
    this.isSelected = false,
    this.onTap,
  });

  @override
  State<ItemCard<T>> createState() => _ItemCardState<T>();
}

class _ItemCardState<T> extends State<ItemCard<T>>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.5, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Only animate if item.id equals -1 (new item)
    if (widget.id(widget.item) < 0) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant ItemCard<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Restart animation if the item id changed to -1
    if (widget.id(widget.item) < 0 && oldWidget.id(oldWidget.item) > 0) {
      _controller.repeat(reverse: true);
    } else if (widget.id(widget.item) > 0 && oldWidget.id(oldWidget.item) < 0) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = widget.color?.call(widget.item) ?? theme.colorScheme.primary;
    final icon = widget.icon?.call(widget.item) ?? Icons.question_mark;

    // If item.id equals -1, wrap with animated container
    if (widget.id(widget.item) < 0) {
      return AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Opacity(
            opacity: _animation.value,
            child: _buildContainer(theme, color, icon),
          );
        },
      );
    }

    // Regular item card without animation
    return _buildContainer(theme, color, icon);
  }

  Widget _buildContainer(ThemeData theme, Color color, IconData icon) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: (widget.isSelected) ? color : color.withValues(alpha: 0.3),
            width: (widget.isSelected) ? 2.0 : 1.5,
          ),
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            if (widget.isSelected)
              BoxShadow(
                color: color.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: _buildCardContent(theme, color, icon),
      ),
    );
  }

  Widget _buildCardContent(ThemeData theme, Color color, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 56,
          width: 56,
          decoration: BoxDecoration(
            color:
                widget.isSelected ? color.withValues(alpha: 0.2) : Colors.black,
            shape: BoxShape.circle,
            border: Border.all(
              color: color.withValues(alpha: 0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.3),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Center(
            child: Icon(
              icon,
              color: color,
              size: 36,
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Item name with enhanced styling
        Text(
          widget.name(widget.item),
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
            fontSize: 20,
            height: 1.2,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        // Balance information with enhanced styling
        Text(
          widget.balance(widget.item),
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: theme.colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 12),
        // Item type with enhanced styling
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: color.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Text(
            widget.displayName(widget.item),
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
