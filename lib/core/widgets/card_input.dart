import 'package:flutter/material.dart';

class CardInput extends StatelessWidget {
  final String? label;
  final Widget child;

  const CardInput({
    super.key,
    this.label,
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
          ],
        ),
      ),
    );
  }
}
