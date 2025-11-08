import 'package:dompet/features/auth/presentation/providers/user_provider.dart';
import 'package:dompet/routes/routes.dart';
import 'package:dompet/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Unauthenticated extends ConsumerWidget {
  const Unauthenticated({super.key});

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
              color: AppTheme.primaryColor,
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

                if (!context.mounted) return;

                SplashRoute().go(context);
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
