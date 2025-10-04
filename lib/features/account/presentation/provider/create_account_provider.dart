import 'package:dompet/features/account/data/account_repository.dart';
import 'package:dompet/features/account/domain/enum/account_type.dart';
import 'package:dompet/features/account/domain/forms/account_create_form.dart';
import 'package:dompet/features/account/domain/forms/account_filter_form.dart';
import 'package:dompet/features/account/domain/model/account_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateAccountProvider {
  final AccountRepository _accountRepository;

  CreateAccountProvider(this._accountRepository);

  Future<List<AccountModel>> execute(
    AccountCreateForm form,
    List<AccountModel>? previousState, [
    AccountFilterForm? filter,
  ]) async {
    final filterType = filter?.type.value ?? AccountType.all;

    List<AccountModel> newState = previousState ?? [];

    if (previousState != null &&
        (filterType == form.typeValue || filterType == AccountType.all)) {
      newState = [
        AccountModel.placeholder(
          name: form.nameValue,
          type: form.typeValue!,
          color: form.colorValue!,
        ),
        ...previousState,
      ];
    }

    try {
      final result = await _accountRepository.create(form);

      List<AccountModel> updatedState = [];
      if (filterType == result.type || filterType == AccountType.all) {
        updatedState = [result];
      }

      newState = [
        ...updatedState,
        ...(previousState
                ?.where((account) => account.id != result.id)
                .toList() ??
            []),
      ];
    } catch (e) {
      // Return previous state if there's an error
      return previousState ?? [];
    }

    return newState;
  }
}

final createAccountProvider =
    Provider.autoDispose<CreateAccountProvider>((ref) {
  final accountRepository = ref.read(accountRepositoryProvider);
  return CreateAccountProvider(accountRepository);
});
