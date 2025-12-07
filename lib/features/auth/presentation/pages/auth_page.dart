import 'package:auto_route/auto_route.dart';
import 'package:dompet/features/auth/presentation/widgets/unauthenticated.dart';
import 'package:flutter/material.dart';

@RoutePage()
class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Unauthenticated(),
    );
  }
}
