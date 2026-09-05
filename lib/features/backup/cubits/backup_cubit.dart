import 'package:bloc/bloc.dart';
import 'package:dompet_app/core/states/action_state.dart';
import 'package:dompet_app/features/accounts/cubits/account_signal_cubit.dart';
import 'package:dompet_app/features/activities/cubits/activity_signal_cubit.dart';
import 'package:dompet_app/features/backup/cubits/backup_state.dart';
import 'package:dompet_app/features/backup/repositories/backup_repository.dart';
import 'package:dompet_app/features/backup/services/backup_auth_service.dart';
import 'package:dompet_app/features/budgets/cubits/budget_signal_cubit.dart';
import 'package:dompet_app/features/savings/cubits/saving_signal_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class BackupCubit extends Cubit<BackupState> {
  final BackupRepository _repository;
  final BackupAuthService _authService;
  final AccountSignalCubit _accountSignal;
  final ActivitySignalCubit _activitySignal;
  final BudgetSignalCubit _budgetSignal;
  final SavingSignalCubit _savingSignal;

  BackupCubit(
    this._repository,
    this._authService,
    this._accountSignal,
    this._activitySignal,
    this._budgetSignal,
    this._savingSignal,
  ) : super(const BackupState());

  Future<void> init() async {
    emit(state.copyWith(isLoadingMeta: true));
    try {
      await _authService.ensureInitialized();
    } catch (_) {}

    final email = _authService.currentAccount?.email;
    emit(
      state.copyWith(
        isSignedIn: _authService.isSignedIn,
        accountEmail: email,
        clearAccountEmail: email == null,
      ),
    );

    try {
      final meta = await _repository.getLastBackupMeta();
      emit(
        state.copyWith(
          lastBackup: meta,
          clearLastBackup: meta == null,
          isLoadingMeta: false,
        ),
      );
    } catch (_) {
      emit(state.copyWith(isLoadingMeta: false));
    }
  }

  Future<void> refreshMeta() async {
    emit(state.copyWith(isLoadingMeta: true));
    try {
      final meta = await _repository.getLastBackupMeta();
      emit(
        state.copyWith(
          lastBackup: meta,
          clearLastBackup: meta == null,
          isLoadingMeta: false,
        ),
      );
    } catch (_) {
      emit(state.copyWith(isLoadingMeta: false));
    }
  }

  Future<void> backup() async {
    emit(state.copyWith(action: const ActionState.loading()));
    try {
      // Ensure signed in (interactive if needed)
      if (!_authService.isSignedIn) {
        final acc = await _authService.authenticate();
        emit(state.copyWith(isSignedIn: true, accountEmail: acc.email));
      }

      final meta = await _repository.backup();
      emit(
        state.copyWith(
          action: const ActionState.success(message: 'Backup berhasil'),
          lastBackup: meta,
          isLoadingMeta: false,
        ),
      );
      // Allow snackbar to show success, then reset to initial after delay?
      // Keep success state until next action; UI will handle.
    } on GoogleSignInException catch (e) {
      debugPrint('[GoogleSignInException] $e');
      final msg = _mapSignInError(e);
      // Canceled is not an error to show as failure snackbar maybe
      if (e.code == GoogleSignInExceptionCode.canceled) {
        emit(state.copyWith(action: const ActionState.initial()));
        return;
      }
      emit(state.copyWith(action: ActionState.error(message: msg)));
    } catch (e) {
      debugPrint(e.toString());
      emit(
        state.copyWith(action: ActionState.error(message: _friendlyError(e))),
      );
    }
  }

  Future<void> restore() async {
    emit(state.copyWith(action: const ActionState.loading()));
    try {
      if (!_authService.isSignedIn) {
        final acc = await _authService.authenticate();
        emit(state.copyWith(isSignedIn: true, accountEmail: acc.email));
      }

      final meta = await _repository.restore();

      // Notify all signal cubits to refresh UI without restart
      _accountSignal.created();
      _activitySignal.created();
      _budgetSignal.created();
      _savingSignal.created();

      emit(
        state.copyWith(
          action: const ActionState.success(
            message: 'Restore berhasil. Data telah dipulihkan.',
          ),
          lastBackup: meta ?? state.lastBackup,
          isLoadingMeta: false,
        ),
      );
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        emit(state.copyWith(action: const ActionState.initial()));
        return;
      }
      emit(
        state.copyWith(action: ActionState.error(message: _mapSignInError(e))),
      );
    } catch (e) {
      emit(
        state.copyWith(action: ActionState.error(message: _friendlyError(e))),
      );
    }
  }

  Future<void> signOut() async {
    try {
      await _authService.signOut();
    } catch (_) {}
    emit(
      state.copyWith(
        isSignedIn: false,
        clearAccountEmail: true,
        action: const ActionState.initial(),
      ),
    );
  }

  void resetAction() {
    emit(state.copyWith(action: const ActionState.initial()));
  }

  String _mapSignInError(GoogleSignInException e) {
    final detail = e.description;
    return switch (e.code) {
      GoogleSignInExceptionCode.canceled => 'Login dibatalkan',
      GoogleSignInExceptionCode.interrupted => 'Login terputus, coba lagi',
      GoogleSignInExceptionCode.clientConfigurationError =>
        detail != null && detail.isNotEmpty
            ? 'Konfigurasi Google Sign-In salah: $detail'
            : 'Konfigurasi Google Sign-In salah. Periksa SHA-1 & package name.',
      _ => detail ?? 'Gagal login Google: ${e.code.name}',
    };
  }

  String _friendlyError(Object e) {
    final msg = e.toString();
    // Strip "StateError: " or "Exception: " prefix for cleaner UI
    if (msg.startsWith('StateError: ')) return msg.substring(11);
    if (msg.startsWith('Exception: ')) return msg.substring(11);
    // googleapis errors
    if (msg.contains('DetailedApiRequestError')) {
      if (msg.contains('403')) {
        return 'Akses ditolak. Pastikan akun ada di Test users dan Drive API aktif.';
      }
      if (msg.contains('401')) {
        return 'Sesi login kadaluarsa, silakan login ulang.';
      }
    }
    return msg.replaceFirst('Exception: ', '');
  }
}
