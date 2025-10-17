import 'package:flutter/material.dart';

class CardInput extends StatelessWidget {
  final String? label;
  final String? info;
  final Widget child;

  const CardInput({
    super.key,
    this.label,
    this.info,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            if (label != null)
              Text(
                label!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            child,
            if (info != null)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  color: Theme.of(context)
                      .colorScheme
                      .secondary
                      .withValues(alpha: 0.3),
                ),
                child: Text(
                  info!,
                  style: TextStyle(color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
