import 'package:dompet/features/auth/presentation/providers/user_provider.dart';
import 'package:dompet/core/utils/helpers/scaffold_snackbar_helper.dart';
import 'package:dompet/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginButton extends ConsumerWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);

    final user = userAsync.value;
    final isLoading = userAsync.isLoading;

    final userNotifier = ref.read(userProvider.notifier);

    if (!isLoading && user == null) {
      return IconButton(
        onPressed: () async {
          await userNotifier.signIn();
        },
        icon: Icon(Icons.login_rounded,
            color: AppTheme.primaryColor),
      );
    }

    if (!isLoading && user != null) {
      // Format the UID to show first 4 and last 4 characters with "..." in between
      String formattedUid = user.uid;
      if (user.uid.length > 8) {
        formattedUid =
            '${user.uid.substring(0, 4)}...${user.uid.substring(user.uid.length - 4)}';
      }

      return PopupMenuButton<String>(
        onSelected: (value) {
          if (value == 'logout') {
            ref.read(userProvider.notifier).signOut();
          } else if (value == 'copy_uid') {
            Clipboard.setData(ClipboardData(text: user.uid));
            context.showSuccessSnackbar('User ID copied to clipboard');
          }
        },
        itemBuilder: (BuildContext context) => [
          PopupMenuItem<String>(
            enabled: false,
            child: Row(
              children: [
                const Text(
                  'User ID: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  formattedUid,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          const PopupMenuDivider(),
          PopupMenuItem<String>(
            value: 'copy_uid',
            child: Row(
              children: [
                Icon(
                  Icons.copy_rounded,
                  size: 20,
                  color: AppTheme.primaryColor,
                ),
                const SizedBox(width: 8),
                const Text('Copy ID'),
              ],
            ),
          ),
          PopupMenuItem<String>(
            value: 'logout',
            child: Row(
              children: [
                Icon(
                  Icons.logout_rounded,
                  size: 20,
                  color: AppTheme.errorColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'Logout',
                  style: TextStyle(color: AppTheme.errorColor),
                ),
              ],
            ),
          ),
        ],
        child: user.photoURL != null
            ? CircleAvatar(
                backgroundColor: AppTheme.primaryColor,
                radius: 24,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(user.photoURL!),
                  radius: 23,
                ),
              )
            : Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person_rounded,
                  size: 30,
                  color: AppTheme.backgroundColor,
                ),
              ),
      );
    }

    return SizedBox(
      width: 48,
      height: 48,
      child: const CircularProgressIndicator(
        strokeWidth: 1,
      ),
    );
  }
}
