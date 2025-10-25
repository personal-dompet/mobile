import 'package:dompet/features/account/data/account_source.dart';
import 'package:dompet/features/account/domain/model/account_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class _AccountRepository {
  final AccountSource source;

  _AccountRepository(this.source);

  Future<List<AccountModel>> getAccounts() async {
    final data = await source.getAccounts();
    return data.map((e) => AccountModel.fromJson(e)).toList();
  }

  Future<AccountModel> create() async {
    final data = await source.create();
    return AccountModel.fromJson(data);
  }

  Future<AccountModel> createDetail() async {
    final data = await source.createDetail();
    return AccountModel.fromJson(data);
  }
}

final accountRepositoryProvider =
    Provider.autoDispose<_AccountRepository>((ref) {
  final source = ref.read(accountSourceProvider);
  return _AccountRepository(source);
});
