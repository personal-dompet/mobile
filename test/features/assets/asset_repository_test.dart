import 'package:dompet_app/core/enums/enum.dart';
import 'package:dompet_app/features/assets/forms/asset_form.dart';
import 'package:dompet_app/features/assets/repositories/asset_repository.dart';
import 'package:dompet_app/core/database/db_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_db.dart';

void main() {
  late DbService dbService;
  late AssetRepository repository;

  setUp(() async {
    dbService = await createTestDbService();
    repository = AssetRepository(dbService);
  });

  tearDown(() async {
    await disposeTestDbService(dbService);
  });

  AssetForm form({required String name}) {
    return AssetForm()
      ..nameControl.updateValue(name)
      ..codeControl.updateValue(AccountPreset.cash.code);
  }

  test('buat beruntun dari preset sama menghasilkan kode unik monotonik',
      () async {
    final first = await repository.createAsset(form(name: 'Dompet A'));
    final second = await repository.createAsset(form(name: 'Dompet B'));

    expect(first.id, isNot(second.id));
    expect(first.code, '101.0001.0001');
    expect(second.code, '101.0001.0002');
  });
}
