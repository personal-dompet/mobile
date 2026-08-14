import 'package:bloc/bloc.dart';
import 'package:dompet_app/core/enums/account_type.dart';
import 'package:dompet_app/features/accounts/model/account_filter.dart';
import 'package:dompet_app/features/accounts/repositories/account_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'splash_cubit.freezed.dart';

@freezed
sealed class SplashState with _$SplashState {
  const factory SplashState.initial() = _SplashInitial;
  const factory SplashState.loading() = _SplashLoading;
  const factory SplashState.error({required String message}) = _SplashError;
  const factory SplashState.needToBeSet() = _SplashNeedToBeSet;
  const factory SplashState.alreadySet() = _SplashAlreadySet;
}

class SplashCubit extends Cubit<SplashState> {
  final AccountRepository _accountRepository;

  SplashCubit(this._accountRepository) : super(const SplashState.initial());

  Future<void> check() async {
    emit(SplashState.loading());
    final accountFilter = AccountFilter(
      isSystem: false,
      type: AccountType.asset,
    );

    try {
      final result = await _accountRepository.getAccounts(accountFilter);

      if (result.isEmpty) {
        emit(SplashState.needToBeSet());
        return;
      }
      emit(SplashState.alreadySet());
    } catch (e) {
      emit(SplashState.error(message: e.toString()));
    }
  }
}
