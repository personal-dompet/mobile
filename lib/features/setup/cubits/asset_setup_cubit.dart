import 'package:bloc/bloc.dart';
import 'package:dompet_app/features/accounts/models/account.dart';
import 'package:dompet_app/features/accounts/models/account_filter.dart';
import 'package:dompet_app/features/accounts/repositories/account_repository.dart';
import 'package:dompet_app/features/assets/forms/asset_form.dart';
import 'package:dompet_app/features/assets/repositories/asset_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'asset_setup_cubit.freezed.dart';

@freezed
sealed class AssetSetupState with _$AssetSetupState {
  const factory AssetSetupState.initial() = _AssetSetupInitial;
  const factory AssetSetupState.loading() = _AssetSetupLoading;
  const factory AssetSetupState.ready({
    required List<Account> accounts,
    required List<Account> presetAccounts,
    @Default(false) bool fromCreate,
  }) = _AssetSetupReady;
  const factory AssetSetupState.awaitingSetup({
    required List<Account> presetAccounts,
    @Default(false) bool fromCreate,
  }) = _AssetSetupAwaitingSetup;
  const factory AssetSetupState.selectedPreset({
    required List<Account> accounts,
    required int selectedAccountId,
  }) = _AssetSetupSelectedPreset;
  const factory AssetSetupState.error({required String message}) =
      _AssetSetupError;
}

class AssetSetupCubit extends Cubit<AssetSetupState> {
  final AccountRepository _accountRepository;
  final AssetRepository _assetRepository;

  AssetSetupCubit(this._accountRepository, this._assetRepository)
    : super(const AssetSetupState.initial());

  Future<void> init([
    bool fromCreate = false,
    List<Account> presetAccounts = const <Account>[],
  ]) async {
    emit(AssetSetupState.loading());

    try {
      final userAssetFilter = AccountFilter(
        isSystem: false,
        type: .asset,
        isLiqid: true,
      );
      final userAssets = await _accountRepository.getAccounts(
        filter: userAssetFilter,
      );

      if (userAssets.isNotEmpty) {
        emit(
          AssetSetupState.ready(
            accounts: userAssets,
            presetAccounts: presetAccounts,
            fromCreate: fromCreate,
          ),
        );
        return;
      }

      final presetAssetFilter = AccountFilter(
        type: .asset,
        isSystem: true,
        isLiqid: true,
      );
      final presetAssets = await _accountRepository.getAccounts(
        filter: presetAssetFilter,
      );

      emit(AssetSetupState.awaitingSetup(presetAccounts: presetAssets));
    } catch (e) {
      emit(AssetSetupState.error(message: e.toString()));
    }
  }

  Future<void> createNewAssetAccount(AssetForm form) async {
    final presetAccounts = state.maybeWhen(
      orElse: () => <Account>[],
      awaitingSetup: (presetAccounts, _) => presetAccounts,
      ready: (_, presetAccounts, _) => presetAccounts,
    );

    emit(AssetSetupState.loading());

    try {
      await _assetRepository.createAsset(form);

      await init(true, presetAccounts);
    } catch (e) {
      emit(AssetSetupState.error(message: e.toString()));
    }
  }

  void selectPreset(int id) {
    final accounts = state.maybeWhen(
      orElse: () => <Account>[],
      awaitingSetup: (accounts, _) => accounts,
      selectedPreset: (accounts, _) => accounts,
    );
    emit(
      AssetSetupState.selectedPreset(accounts: accounts, selectedAccountId: id),
    );
  }

  void removeSelectedPreset() {
    final accounts = state.maybeWhen(
      orElse: () => <Account>[],
      awaitingSetup: (accounts, _) => accounts,
      selectedPreset: (accounts, _) => accounts,
    );

    emit(AssetSetupState.awaitingSetup(presetAccounts: accounts));
  }
}
