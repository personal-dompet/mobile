import 'package:bloc/bloc.dart';
import 'package:dompet_app/core/states/action_state.dart';
import 'package:dompet_app/features/accounts/models/account.dart';
import 'package:dompet_app/features/accounts/repositories/account_repository.dart';
import 'package:dompet_app/features/assets/forms/asset_form.dart';
import 'package:dompet_app/features/assets/repositories/asset_repository.dart';
import 'package:dompet_app/features/categories/forms/category_form.dart';
import 'package:dompet_app/features/categories/repositories/category_repository.dart';

class AccountActionCubit extends Cubit<ActionState> {
  final AccountRepository _accountRepository;
  final AssetRepository _assetRepository;
  final CategoryRepository _categoryRepository;
  AccountActionCubit(
    this._accountRepository,
    this._assetRepository,
    this._categoryRepository,
  ) : super(const ActionState.initial());

  Future<void> createAsset(AssetForm form) async {
    emit(ActionState.loading());

    try {
      await _assetRepository.createAsset(form);
      emit(ActionState.success(message: 'Berhasil menambahkan ${form.name}.'));
    } catch (e) {
      emit(ActionState.error(message: e.toString()));
    }
  }

  Future<void> updateAccount({required AssetForm form, required int id}) async {
    emit(ActionState.loading());

    try {
      await _assetRepository.updateAsset(form: form, id: id);
      emit(ActionState.success(message: 'Berhasil memperbarui Dompet.'));
    } catch (e) {
      emit(ActionState.error(message: e.toString()));
    }
  }

  Future<Account?> createCategory({required CategoryForm form}) async {
    emit(ActionState.loading());

    try {
      final category = await _categoryRepository.createCategory(form: form);
      emit(
        ActionState.success(
          message: 'Berhasil menambah kategori ${form.name}.',
        ),
      );
      return category;
    } catch (e) {
      emit(ActionState.error(message: e.toString()));
      return null;
    }
  }

  Future<void> updateCategory({
    required CategoryForm form,
    required int id,
  }) async {
    emit(ActionState.loading());

    try {
      await _categoryRepository.updateCategory(form: form, id: id);
      emit(ActionState.success(message: 'Berhasil memperbarui Kategori.'));
    } catch (e) {
      emit(ActionState.error(message: e.toString()));
    }
  }

  Future<void> archiveAccount({required int id}) async {
    emit(ActionState.loading());

    try {
      await _accountRepository.archiveAccount(id);
      emit(ActionState.success(message: 'Berhasil mengarsip Dompet.'));
    } catch (e) {
      emit(ActionState.error(message: e.toString()));
    }
  }

  Future<void> unarchiveAccount({required int id}) async {
    emit(ActionState.loading());

    try {
      await _accountRepository.unarchiveAccount(id);
      emit(ActionState.success(message: 'Berhasil memulihkan Dompet.'));
    } catch (e) {
      emit(ActionState.error(message: e.toString()));
    }
  }
}
