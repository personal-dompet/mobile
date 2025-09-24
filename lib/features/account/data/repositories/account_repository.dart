import 'package:dompet/features/account/data/sources/account_source.dart';
import 'package:dompet/features/account/domain/forms/account_create_form.dart';
import 'package:dompet/features/account/domain/forms/account_filter_form.dart';
import 'package:dompet/features/account/domain/model/simple_account_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountRepository {
  final AccountSource _source;

  AccountRepository(this._source);

  Future<List<SimpleAccountModel>> getAccounts(AccountFilterForm form) async {
    final data = await _source.getAccounts(form);
    return data.map((e) => SimpleAccountModel.fromJson(e)).toList();
  }

  Future<SimpleAccountModel> create(AccountCreateForm form) async {
    final data = await _source.create(form);
    return SimpleAccountModel.fromJson(data);
  }
}

final accountRepositoryProvider = Provider.autoDispose<AccountRepository>((ref) {
  final source = ref.read(accountSourceProvider);
  return AccountRepository(source);
});