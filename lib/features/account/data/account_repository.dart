import 'package:dompet/features/account/data/account_source.dart';
import 'package:dompet/features/account/domain/forms/create_account_detail_form.dart';
import 'package:dompet/features/account/domain/forms/create_account_form.dart';
import 'package:dompet/features/account/domain/model/account_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountRepository {
  final AccountSource _source;

  AccountRepository(this._source);

  Future<List<AccountModel>> getAccounts() async {
    final data = await _source.getAccounts();
    return data.map((e) => AccountModel.fromJson(e)).toList();
  }

  Future<AccountModel> create(CreateAccountForm form) async {
    final data = await _source.create(form);
    return AccountModel.fromJson(data);
  }

  Future<AccountModel> createDetail(
      CreateAccountForm form, CreateAccountDetailForm detailForm) async {
    final data = await _source.createDetail(form, detailForm);
    return AccountModel.fromJson(data);
  }
}

final accountRepositoryProvider =
    Provider.autoDispose<AccountRepository>((ref) {
  final source = ref.read(accountSourceProvider);
  return AccountRepository(source);
});
