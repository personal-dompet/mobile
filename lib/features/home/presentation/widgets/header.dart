import 'package:dompet/features/auth/presentation/widgets/login_button.dart';
import 'package:dompet/theme_data.dart';
import 'package:flutter/material.dart';

class HeaderAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const HeaderAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .headlineLarge
            ?.copyWith(color: AppTheme.primaryColor),
      ),
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 16.0),
          child: LoginButton(),
        ),
      ],
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
