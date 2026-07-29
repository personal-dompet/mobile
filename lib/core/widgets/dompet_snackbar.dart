import 'package:flutter/material.dart';

class DompetSnackbar extends SnackBar {
  final String message;
  final SnackBarType snackBarType;
  DompetSnackbar(
    BuildContext context, {
    super.key,
    super.action,
    required this.message,
    this.snackBarType = .info,
  }) : super(
         content: Text(
           message,
           style: TextStyle(
             color: switch (snackBarType) {
               .error => Theme.of(context).colorScheme.onError,
               .info => Theme.of(context).colorScheme.onPrimary,
               .success => Theme.of(context).colorScheme.onTertiary,
             },
           ),
         ),
         backgroundColor: switch (snackBarType) {
           .error => Theme.of(context).colorScheme.error,
           .info => Theme.of(context).colorScheme.primary,
           .success => Theme.of(context).colorScheme.tertiary,
         },
         showCloseIcon: action != null,
         closeIconColor: switch (snackBarType) {
           .error => Theme.of(context).colorScheme.onError,
           .info => Theme.of(context).colorScheme.onPrimary,
           .success => Theme.of(context).colorScheme.onTertiary,
         },
       );
}

enum SnackBarType { success, error, info }
