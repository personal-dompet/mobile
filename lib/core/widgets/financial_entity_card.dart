import 'package:dompet/core/enum/transfer_static_subject.dart';
import 'package:dompet/core/models/financial_entity_model.dart';
import 'package:dompet/core/utils/helpers/scaffold_snackbar_helper.dart';
import 'package:dompet/features/account/domain/model/account_model.dart';
import 'package:dompet/features/pocket/domain/model/pocket_model.dart';
import 'package:dompet/theme_data.dart';
import 'package:flutter/material.dart';

class FinancialEntityCard<T extends FinancialEntityModel>
    extends StatefulWidget {
  final T item;
  final TransferStaticSubject? transferRole;
  final bool isSelected;
  final VoidCallback? onTap;
  final bool isDisabled;

  const FinancialEntityCard({
    super.key,
    required this.item,
    this.transferRole,
    this.isSelected = false,
    this.onTap,
    this.isDisabled = false,
  });

  @override
  State<FinancialEntityCard<T>> createState() => _ItemCardState<T>();
}

class _ItemCardState<T extends FinancialEntityModel>
    extends State<FinancialEntityCard<T>> with SingleTickerProviderStateMixin {
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
    if (widget.item.id < 0) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant FinancialEntityCard<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Restart animation if the item id changed to -1
    if (widget.item.id < 0 && oldWidget.item.id > 0) {
      _controller.repeat(reverse: true);
    } else if (widget.item.id > 0 && oldWidget.item.id < 0) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  IconData get _icon {
    if (widget.item is PocketModel) {
      final item = widget.item as PocketModel;
      return item.icon?.icon ?? Icons.wallet_outlined;
    }

    final item = widget.item as AccountModel;
    return item.type.icon;
  }

  String get _displayName {
    if (widget.item is PocketModel) {
      final item = widget.item as PocketModel;
      return item.type.displayName;
    }

    final item = widget.item as AccountModel;
    return item.type.displayName;
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.item.color ?? AppTheme.primaryColor;

    // If item.id equals -1, wrap with animated container
    if (widget.item.id < 0) {
      return AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Opacity(
            opacity: _animation.value,
            child: _buildContainer(color, _icon),
          );
        },
      );
    }

    // Regular item card without animation
    return _buildContainer(color, _icon);
  }

  Widget _buildContainer(Color color, IconData icon) {
    // Disable tap if card has a transfer role
    final balance = widget.item.formattedBalance;
    final bool isDisabled =
        widget.transferRole != null || (widget.isDisabled && balance == 'Rp0');
    final bool isSelected = widget.isSelected;
    final VoidCallback? effectiveOnTap = isDisabled
        ? () {
            final optionType =
                T.toString() == 'PocketModel' ? 'pocket' : 'account';
            if (widget.isDisabled && balance == 'Rp0') {
              context.showErrorSnackbar(
                  'Not enough balance. Please select different $optionType that has sufficient balance.');
              return;
            }
            if (widget.transferRole != null) {
              final text = widget.transferRole! == TransferStaticSubject.source
                  ? 'source'
                  : 'destination';

              context.showErrorSnackbar(
                  'Already selected as $text $optionType. Please select different $optionType or create new one.');
              return;
            }
          }
        : widget.onTap;

    return InkWell(
      onTap: effectiveOnTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDisabled || !isSelected
                ? color.withValues(alpha: 0.3)
                : color,
            width: isSelected && !isDisabled ? 2.0 : 1.5,
          ),
          color: AppTheme.surfaceColor,
          boxShadow: [
            if (isSelected)
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
            if (isDisabled && widget.transferRole != null)
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
            widget.item.name,
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
            widget.item.formattedBalance,
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
              _displayName,
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
