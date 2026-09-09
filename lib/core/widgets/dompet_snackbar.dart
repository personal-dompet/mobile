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
         content: Row(
           spacing: 8,
           children: [
             Icon(
               switch (snackBarType) {
                 .error => Icons.error_rounded,
                 .info => Icons.info_rounded,
                 .success => Icons.check_circle_rounded,
               },
               size: 20,
               color: switch (snackBarType) {
                 .error => Theme.of(context).colorScheme.error,
                 .info => Theme.of(context).colorScheme.primary,
                 .success => Theme.of(context).colorScheme.tertiary,
               },
             ),
             Expanded(
               child: Text(
                 message,
                 style: TextStyle(
                   color: switch (snackBarType) {
                     .error => Theme.of(context).colorScheme.error,
                     .info => Theme.of(context).colorScheme.primary,
                     .success => Theme.of(context).colorScheme.tertiary,
                   },
                 ),
               ),
             ),
           ],
         ),
         // Background netral untuk semua tipe; pembeda hanya warna
         // teks + ikon per tipe. Behavior default Material (fixed bawah
         // full-width, tanpa margin) agar aman di ShellPage yang memakai
         // FAB centerDocked + BottomAppBar (floating + margin besar
         // memicu assertion "Floating SnackBar presented off screen").
         backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
         showCloseIcon: action != null,
         closeIconColor: switch (snackBarType) {
           .error => Theme.of(context).colorScheme.error,
           .info => Theme.of(context).colorScheme.primary,
           .success => Theme.of(context).colorScheme.tertiary,
         },
       );
}

enum SnackBarType { success, error, info }
