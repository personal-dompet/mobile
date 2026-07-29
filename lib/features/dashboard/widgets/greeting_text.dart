import 'package:flutter/material.dart';

class GreetingText extends StatelessWidget {
  const GreetingText({super.key});

  String get greeting {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 11) {
      return 'Selamat Pagi';
    } else if (hour >= 11 && hour < 15) {
      return 'Selamat Siang';
    } else if (hour >= 15 && hour < 18) {
      return 'Selamat Sore';
    } else {
      return 'Selamat Malam';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      greeting,
      style: Theme.of(
        context,
      ).textTheme.titleLarge?.copyWith(fontWeight: .w600),
    );
  }
}
