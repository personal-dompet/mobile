import 'package:flutter/material.dart';

class AccountPocketSelector<T> extends StatelessWidget {
  final String label;
  final String placeholder;
  final Color? color;
  final IconData? icon;
  final String? name;
  final String? balance;
  final String? formattedNewBalance;
  final bool showBalanceChange;
  final VoidCallback onTap;
  final bool isDisabled;

  const AccountPocketSelector({
    super.key,
    required this.label,
    required this.placeholder,
    this.color,
    this.icon,
    this.name,
    this.balance,
    this.formattedNewBalance,
    this.showBalanceChange = false,
    required this.onTap,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorToUse =
        color?.withValues(alpha: 0.15) ?? Colors.grey.withValues(alpha: 0.2);
    final iconToUse = icon ?? Icons.wallet_outlined;
    final nameToUse = name ?? placeholder;
    final colorForIcon = color ?? Colors.grey;
    final chevronColor = name != null ? colorForIcon : Colors.grey;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              color?.withValues(alpha: 0.5) ?? Theme.of(context).dividerColor,
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: isDisabled ? null : onTap,
        child: Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 64,
                decoration: BoxDecoration(
                  color: colorToUse,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(11),
                    bottomLeft: Radius.circular(11),
                  ),
                ),
                child: Center(
                  child: Icon(
                    iconToUse,
                    color: colorForIcon,
                    size: 32,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      nameToUse,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (balance != null)
                      Text.rich(
                        overflow: TextOverflow.ellipsis,
                        TextSpan(
                          text: balance,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                          children:
                              showBalanceChange && formattedNewBalance != null
                                  ? [
                                      TextSpan(
                                        text: '  →  ',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      TextSpan(
                                        text: formattedNewBalance,
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ]
                                  : [],
                        ),
                      ),
                  ],
                ),
              ),
              if (!isDisabled)
                Icon(
                  Icons.chevron_right,
                  color: chevronColor,
                ),
              if (isDisabled)
                Icon(
                  Icons.lock,
                  color: Colors.grey,
                  size: 24,
                ),
              const SizedBox(width: 4),
            ],
          ),
        ),
      ),
    );
  }
}
