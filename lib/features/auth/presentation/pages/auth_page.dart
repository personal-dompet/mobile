import 'package:dompet/features/auth/presentation/widgets/unauthenticated.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Unauthenticated(),
    );
  }
}
