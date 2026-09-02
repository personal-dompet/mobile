import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

enum CloseChoice { closeOnly, closeAndCreate }

Future<CloseChoice?> showCloseChoiceDialog(
  BuildContext context, {
  required String categoryName,
  required String periode,
}) {
  return showDialog<CloseChoice>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Tutup Anggaran'),
      content: Text(
        'Anggaran "$categoryName" untuk periode $periode akan ditutup. Apakah Anda ingin membuka anggaran baru untuk bulan ini?',
      ),
      actions: [
        TextButton(
          onPressed: () => dialogContext.router.maybePop(CloseChoice.closeOnly),
          child: const Text('Tutup saja'),
        ),
        FilledButton(
          onPressed: () => dialogContext.router.maybePop(CloseChoice.closeAndCreate),
          child: const Text('Tutup & Buka Baru'),
        ),
      ],
    ),
  );
}
