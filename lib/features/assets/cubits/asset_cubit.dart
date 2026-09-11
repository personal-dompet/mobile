import 'package:bloc/bloc.dart';
import 'package:dompet_app/features/accounts/models/account.dart';
import 'package:dompet_app/features/accounts/models/account_filter.dart';
import 'package:dompet_app/features/accounts/repositories/account_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'asset_cubit.freezed.dart';

@freezed
sealed class AssetState with _$AssetState {
  const factory AssetState.initial() = _AssetInitial;
  const factory AssetState.loading() = _AssetLoading;
  const factory AssetState.loaded({
    @Default([]) List<Account> assets,
    @Default([]) List<Account> presetAssets,
  }) = _AssetLoaded;
  const factory AssetState.error({required String message}) = _AssetError;
}

class AssetCubit extends Cubit<AssetState> {
  final AccountRepository _repository;
  AssetCubit(this._repository) : super(const AssetState.initial());

  Future<void> fetch({AccountFilter? filter}) async {
    emit(AssetState.loading());

    try {
      final assetFilter = filter != null
          ? filter.copyWith(isSystem: false, isLiqid: true, type: .asset)
          : AccountFilter(isSystem: false, isLiqid: true, type: .asset);
      final assets = await _repository.getAccounts(filter: assetFilter);

      emit(AssetState.loaded(assets: assets));
    } catch (e) {
      emit(AssetState.error(message: e.toString()));
    }
  }

  /// FIX-14 (IMP-2): grid arsip mirror grid aktif.
  Future<void> fetchArchived({AccountFilter? filter}) async {
    emit(AssetState.loading());

    try {
      final assetFilter = filter != null
          ? filter.copyWith(isSystem: false, isLiqid: true, type: .asset)
          : AccountFilter(isSystem: false, isLiqid: true, type: .asset);
      final assets = await _repository.getArchivedAccounts(
        filter: assetFilter,
      );

      emit(AssetState.loaded(assets: assets));
    } catch (e) {
      emit(AssetState.error(message: e.toString()));
    }
  }

  Future<void> getPresetAssets() async {
    emit(AssetState.loading());

    try {
      final filter = AccountFilter(isSystem: true, isLiqid: true, type: .asset);
      final assets = await _repository.getAccounts(filter: filter);

      emit(AssetState.loaded(assets: assets));
    } catch (e) {
      emit(AssetState.error(message: e.toString()));
    }
  }

  /// Satu flow untuk QuickAction (aturan 5): dompet aktif + preset
  /// dimuat bersama dalam satu state.
  Future<void> fetchTransferInfo() async {
    emit(AssetState.loading());

    try {
      const activeFilter = AccountFilter(
        isSystem: false,
        isLiqid: true,
        type: .asset,
      );
      const presetFilter = AccountFilter(
        isSystem: true,
        isLiqid: true,
        type: .asset,
      );
      final results = await Future.wait([
        _repository.getAccounts(filter: activeFilter),
        _repository.getAccounts(filter: presetFilter),
      ]);

      emit(
        AssetState.loaded(assets: results[0], presetAssets: results[1]),
      );
    } catch (e) {
      emit(AssetState.error(message: e.toString()));
    }
  }
}
