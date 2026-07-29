import 'package:bloc/bloc.dart';
import 'package:dompet_app/core/models/pagination.dart';
import 'package:dompet_app/features/accounts/repositories/account_repository.dart';
import 'package:dompet_app/features/assets/models/asset_detail.dart';
import 'package:dompet_app/features/journals/models/journal_filter.dart';
import 'package:dompet_app/features/journals/repositories/journal_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'asset_detail_cubit.freezed.dart';

@freezed
sealed class AssetDetailState with _$AssetDetailState {
  const factory AssetDetailState.initial() = _AssetDetailInitial;
  const factory AssetDetailState.loading() = _AssetDetailLoading;
  const factory AssetDetailState.loaded({required AssetDetail accountDetail}) =
      _AssetDetailLoaded;
  const factory AssetDetailState.error({required String message}) =
      _AssetDetailError;
}

class AssetDetailCubit extends Cubit<AssetDetailState> {
  final AccountRepository _accountRepository;
  final JournalRepository _journalRepository;

  AssetDetailCubit(this._accountRepository, this._journalRepository)
    : super(const AssetDetailState.initial());

  Future<void> init({required int id}) async {
    emit(AssetDetailState.loading());

    final pagination = Pagination(page: 1, limit: 5);
    final filter = JournalFilter(accountId: id);

    try {
      final account = await _accountRepository.getAccount(id);

      if (account == null) {
        emit(AssetDetailState.error(message: 'Dompet tidak ditemukan.'));
        return;
      }

      final recentActivitiesResult = await _journalRepository.getJournals(
        pagination: pagination,
        filter: filter,
      );
      final recentActivities = recentActivitiesResult.items;

      final accountDetail = AssetDetail(
        account: account,
        recentActivities: recentActivities,
      );

      emit(AssetDetailState.loaded(accountDetail: accountDetail));
    } catch (e) {
      emit(AssetDetailState.error(message: e.toString()));
    }
  }
}
