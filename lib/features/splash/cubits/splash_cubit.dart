import 'package:bloc/bloc.dart';
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
    try {
      final hasAssetAccount = await _accountRepository.checkUserAssetAccount();

      if (!hasAssetAccount) {
        emit(SplashState.needToBeSet());
        return;
      }
      emit(SplashState.alreadySet());
    } catch (e) {
      emit(SplashState.error(message: e.toString()));
    }
  }
}
