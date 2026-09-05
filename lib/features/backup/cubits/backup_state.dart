import 'package:dompet_app/core/states/action_state.dart';
import 'package:dompet_app/features/backup/models/backup_meta.dart';

class BackupState {
  final ActionState action;
  final BackupMeta? lastBackup;
  final String? accountEmail;
  final bool isSignedIn;
  final bool isLoadingMeta;

  const BackupState({
    this.action = const ActionState.initial(),
    this.lastBackup,
    this.accountEmail,
    this.isSignedIn = false,
    this.isLoadingMeta = false,
  });

  BackupState copyWith({
    ActionState? action,
    BackupMeta? lastBackup,
    bool clearLastBackup = false,
    String? accountEmail,
    bool clearAccountEmail = false,
    bool? isSignedIn,
    bool? isLoadingMeta,
  }) {
    return BackupState(
      action: action ?? this.action,
      lastBackup: clearLastBackup ? null : (lastBackup ?? this.lastBackup),
      accountEmail: clearAccountEmail ? null : (accountEmail ?? this.accountEmail),
      isSignedIn: isSignedIn ?? this.isSignedIn,
      isLoadingMeta: isLoadingMeta ?? this.isLoadingMeta,
    );
  }
}
