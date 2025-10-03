import 'package:dompet/features/account/data/account_source.dart';
import 'package:dompet/features/account/domain/forms/account_create_form.dart';
import 'package:dompet/features/account/domain/forms/account_filter_form.dart';
import 'package:dompet/features/account/domain/model/account_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountRepository {
  final AccountSource _source;

  AccountRepository(this._source);

  Future<List<AccountModel>> getAccounts(AccountFilterForm form) async {
    final data = await _source.getAccounts(form);
    return data.map((e) => AccountModel.fromJson(e)).toList();
  }

  Future<AccountModel> create(AccountCreateForm form) async {
    final data = await _source.create(form);
    return AccountModel.fromJson(data);
  }
}

final accountRepositoryProvider =
    Provider.autoDispose<AccountRepository>((ref) {
  final source = ref.read(accountSourceProvider);
  return AccountRepository(source);
});
