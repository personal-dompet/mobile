import 'package:dompet/core/enum/creation_type.dart';
import 'package:dompet/core/enum/list_type.dart';
import 'package:dompet/features/account/domain/enum/account_type.dart';
import 'package:dompet/features/account/domain/forms/create_account_detail_form.dart';
import 'package:dompet/features/account/domain/forms/create_account_form.dart';
import 'package:dompet/features/account/presentation/provider/account_filter_provider.dart';
import 'package:dompet/features/account/presentation/provider/account_list_provider.dart';
import 'package:dompet/features/account/presentation/widgets/account_type_selector_bottom_sheet.dart';
import 'package:dompet/routes/create_account_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class _AccountService {
  final Ref _ref;
  final ListType _listType;

  _AccountService(this._ref, this._listType);

  Future execute(
    BuildContext context, {
    ValueChanged<CreateAccountForm>? onFormCreated,
  }) async {
    try {
      final type = await _selectAccountType(context);
      if (type == null || !context.mounted) return;

      final creationType = await _navigateToCreateAccount(context, type);

      if (creationType == null || !context.mounted) return;
      await _saveCreatedAccount(context, creationType, onFormCreated);
    } finally {
      _ref.invalidateSelf();
      _ref.invalidate(createAccountFormProvider);
      _ref.invalidate(createAccountDetailFormProvider);
    }
  }

  Future<AccountType?> _selectAccountType(BuildContext context) async {
    final filter = _ref.read(accountFilterProvider);

    if (_listType == ListType.option || filter.type == AccountType.all) {
      return await showModalBottomSheet<AccountType>(
        context: context,
        isScrollControlled: true,
        useRootNavigator: true,
        builder: (context) => const AccountTypeSelectorBottomSheet(),
      );
    }

    return filter.type;
  }

  Future<CreationType?> _navigateToCreateAccount(
    BuildContext context,
    AccountType type,
  ) async {
    final form = _ref.read(createAccountFormProvider);
    form.type.value = type;

    return await CreateAccountRoute().push<CreationType>(context);
  }

  Future<void> _saveCreatedAccount(
    BuildContext context,
    CreationType creationType, [
    ValueChanged<CreateAccountForm>? onFormCreated,
  ]) async {
    final pocketForm = _ref.read(createAccountFormProvider);
    onFormCreated?.call(pocketForm);
    if (creationType == CreationType.basic) {
      await _ref.read(accountListProvider.notifier).create(pocketForm);
      return;
    }

    final detailForm = _ref.read(createAccountDetailFormProvider);
    await _ref
        .read(accountListProvider.notifier)
        .create(pocketForm, detailForm: detailForm);
  }
}

final accountProvider = Provider.family<_AccountService, ListType>(
  (ref, listType) {
    return _AccountService(ref, listType);
  },
);
