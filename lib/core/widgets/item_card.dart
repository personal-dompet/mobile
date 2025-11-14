import 'package:dompet/core/enum/transfer_static_subject.dart';
import 'package:dompet/core/utils/helpers/scaffold_snackbar_helper.dart';
import 'package:dompet/theme_data.dart';
import 'package:flutter/material.dart';

class ItemCard<T> extends StatefulWidget {
  final T item;
  final int Function(T) id;
  final String Function(T) name;
  final String Function(T) balance;
  final Color? Function(T)? color;
  final IconData? Function(T)? icon;
  final String Function(T) displayName;
  final TransferStaticSubject? transferRole;
  final bool isSelected;
  final VoidCallback? onTap;
  final bool isDisabled;

  const ItemCard({
    super.key,
    required this.item,
    required this.id,
    required this.name,
    required this.balance,
    this.color,
    this.icon,
    required this.displayName,
    this.transferRole,
    this.isSelected = false,
    this.onTap,
    this.isDisabled = false,
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
    final color = widget.color?.call(widget.item) ?? AppTheme.primaryColor;
    final icon = widget.icon?.call(widget.item) ?? Icons.question_mark;

    // If item.id equals -1, wrap with animated container
    if (widget.id(widget.item) < 0) {
      return AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Opacity(
            opacity: _animation.value,
            child: _buildContainer(color, icon),
          );
        },
      );
    }

    // Regular item card without animation
    return _buildContainer(color, icon);
  }

  Widget _buildContainer(Color color, IconData icon) {
    // Disable tap if card has a transfer role
    final balance = widget.balance(widget.item);
    final bool isDisabled =
        widget.transferRole != null || (widget.isDisabled && balance == 'Rp0');
    final bool isSelected = widget.isSelected;
    final VoidCallback? effectiveOnTap = isDisabled
        ? () {
            final optionType =
                T.toString() == 'PocketModel' ? 'pocket' : 'account';
            if (widget.isDisabled) {
              context.showErrorSnackbar(
                  'Not enough balance. Please select different $optionType that has sufficient balance.');
              return;
            }
            final text = widget.transferRole! == TransferStaticSubject.source
                ? 'source'
                : 'destination';

            context.showErrorSnackbar(
                'Already selected as $text $optionType. Please select different $optionType or create new one.');
            return;
          }
        : widget.onTap;

    return InkWell(
      onTap: effectiveOnTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDisabled
                ? color
                : (isSelected ? color : color.withValues(alpha: 0.3)),
            width: isDisabled ? 2.0 : (isSelected ? 2.0 : 1.5),
          ),
          color: AppTheme.surfaceColor,
          boxShadow: [
            if (isDisabled || isSelected)
              BoxShadow(
                color: color.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Stack(
          children: [
            // Main content wrapped in a centered container to preserve original layout
            Center(
              child: _buildCardContent(color, icon, isDisabled),
            ),
            // Add source/destination indicator if applicable
            if (isDisabled && !widget.isDisabled)
              Positioned(
                top: 16,
                right: 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: color,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    _getTransferRoleText(widget.transferRole!),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardContent(Color color, IconData icon, bool isDisabled) {
    final bool isSelected = widget.isSelected;
    return Opacity(
      opacity: isDisabled ? 0.5 : 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 56,
            width: 56,
            decoration: BoxDecoration(
              color: AppTheme.backgroundColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: color.withValues(alpha: 0.3),
                width: 1.5,
              ),
              boxShadow: [
                if (isSelected)
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
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
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textColorPrimary,
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
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textColorPrimary,
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
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  String _getTransferRoleText(TransferStaticSubject role) {
    switch (role) {
      case TransferStaticSubject.source:
        return 'S';
      case TransferStaticSubject.destination:
        return 'D';
    }
  }
}
