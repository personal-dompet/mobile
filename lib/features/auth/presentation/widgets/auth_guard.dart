import 'package:dompet/features/auth/presentation/providers/user_provider.dart';
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
          return _UnauthenticatedWidget();
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

class _UnauthenticatedWidget extends ConsumerWidget {
  const _UnauthenticatedWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lock_rounded,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 24),
            const Text(
              'Authentication Required',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Please log in to access this feature',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () async {
                // Execute login function directly
                final userNotifier = ref.read(userProvider.notifier);

                await userNotifier.signIn();
              },
              icon: const Icon(Icons.login_rounded),
              label: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
