import 'package:dompet/features/auth/presentation/providers/user_provider.dart';
import 'package:dompet/features/auth/presentation/widgets/unauthenticated.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthGuard extends ConsumerWidget {
  final Widget child;

  const AuthGuard({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);

    return userAsync.when(
      data: (user) {
        if (user != null) {
          // User is authenticated, show the child widget
          return child;
        } else {
          // User is not authenticated, show the login prompt
          return Unauthenticated();
        }
      },
      loading: () => const Center(
          child: SizedBox(
        width: 48,
        height: 48,
        child: CircularProgressIndicator(
          strokeWidth: 1,
        ),
      )),
      error: (error, stack) => Center(
        child: Text('Error: $error'),
      ),
    );
  }
}
