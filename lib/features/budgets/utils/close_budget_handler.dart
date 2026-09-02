import 'package:flutter/material.dart';
import 'package:dompet_app/features/budgets/utils/show_close_choice_dialog.dart';
import 'package:dompet_app/features/budgets/utils/show_rollover_bottom_sheet.dart';

class CloseDecision {
  final CloseChoice choice;
  final int carryAmount;
  const CloseDecision({required this.choice, required this.carryAmount});
}

Future<CloseDecision?> getCloseDecision({
  required BuildContext context,
  required int remaining,
  required String categoryName,
  required String periode,
  required int planAmount,
}) async {
  final choice = await showCloseChoiceDialog(
    context,
    categoryName: categoryName,
    periode: periode,
  );
  if (!context.mounted) return null;
  if (choice == null) return null;

  if (choice == CloseChoice.closeOnly) {
    return const CloseDecision(choice: CloseChoice.closeOnly, carryAmount: 0);
  }

  // closeAndCreate
  if (remaining <= 0) {
    return const CloseDecision(choice: CloseChoice.closeAndCreate, carryAmount: 0);
  }

  final withRollover = await showRolloverBottomSheet(
    context,
    sisa: remaining,
    planAmount: planAmount,
    categoryName: categoryName,
  );
  if (!context.mounted) return null;
  if (withRollover == null) return null;
  return CloseDecision(
    choice: CloseChoice.closeAndCreate,
    carryAmount: withRollover ? remaining : 0,
  );
}
