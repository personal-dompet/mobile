import 'package:flutter/material.dart';

class WalletSetupHero extends StatelessWidget {
  final String title;
  final String subtitle;
  const WalletSetupHero({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        Text(subtitle),
      ],
    );
  }
}
