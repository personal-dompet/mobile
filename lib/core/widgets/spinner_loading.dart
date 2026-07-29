import 'package:flutter/material.dart';

class SpinnerLoading extends StatelessWidget {
  final String? text;
  const SpinnerLoading({super.key, this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16,
      mainAxisAlignment: .center,
      crossAxisAlignment: .center,
      mainAxisSize: .min,
      children: [
        CircularProgressIndicator(strokeWidth: 1),
        Flexible(child: Text(text ?? 'Memuat...', textAlign: .center)),
      ],
    );
  }
}
