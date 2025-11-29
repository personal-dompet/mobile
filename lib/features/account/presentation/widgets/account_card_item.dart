import 'package:dompet/core/enum/transfer_static_subject.dart';
import 'package:dompet/core/widgets/financial_entity_card.dart';
import 'package:dompet/features/account/domain/model/account_model.dart';
import 'package:flutter/material.dart';

class AccountCardItem extends StatelessWidget {
  final AccountModel account;
  final TransferStaticSubject? transferRole;
  final bool isSelected;
  final VoidCallback? onTap;
  final bool isDisabled;

  const AccountCardItem({
    super.key,
    required this.account,
    this.transferRole,
    this.isSelected = false,
    this.onTap,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return FinancialEntityCard<AccountModel>(
      item: account,
      transferRole: transferRole,
      isSelected: isSelected,
      isDisabled: isDisabled,
      onTap: onTap,
    );
  }
}
