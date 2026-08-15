import 'package:dompet_app/core/extensions/icon_data.dart';
import 'package:dompet_app/core/extensions/number.dart';
import 'package:dompet_app/core/widgets/widget.dart';
import 'package:dompet_app/features/accounts/models/account.dart';
import 'package:flutter/material.dart';

class AssetCard extends StatelessWidget {
  final Account account;
  final VoidCallback? onTap;
  final Color? activeColor;
  final bool hideBalance;
  const AssetCard({
    super.key,
    required this.account,
    this.onTap,
    this.activeColor,
    this.hideBalance = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: .antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: .center,
          crossAxisAlignment: .center,
          spacing: 4,
          children: [
            Icon(
              account.iconCode == null
                  ? Icons.wallet_rounded
                  : MaterialIconData.fromCode(account.iconCode!),
              color: activeColor,
            ),
            AutoScrollText(
              text: account.name,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: activeColor),
            ),
            if (!hideBalance)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: AutoScrollText(
                  text: account.balance.currency,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: .w600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
