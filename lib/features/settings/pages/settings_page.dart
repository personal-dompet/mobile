import 'package:auto_route/auto_route.dart';
import 'package:dompet_app/core/dependencies/init_dependency.dart';
import 'package:dompet_app/core/models/app_configuration.dart';
import 'package:dompet_app/core/network/connectivity_cubit.dart';
import 'package:dompet_app/core/states/action_state.dart';
import 'package:dompet_app/core/widgets/dompet_dialog.dart';
import 'package:dompet_app/core/widgets/dompet_snackbar.dart';
import 'package:dompet_app/core/widgets/loading_overlay.dart';
import 'package:dompet_app/features/app_configurations/cubits/app_configuration_cubit.dart';
import 'package:dompet_app/features/backup/cubits/backup_cubit.dart';
import 'package:dompet_app/features/backup/cubits/backup_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

@RoutePage()
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<BackupCubit>()..init(),
      child: const _SettingsView(),
    );
  }
}

class _SettingsView extends StatefulWidget {
  const _SettingsView();

  @override
  State<_SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<_SettingsView> {
  final _loadingOverlay = LoadingOverlay();

  String _formatBackupTime(DateTime? dt) {
    if (dt == null) return 'Belum ada backup';
    final fmt = DateFormat('d MMM yyyy, HH:mm', 'id');
    return fmt.format(dt);
  }

  String _formatSize(int? bytes) {
    if (bytes == null) return '-';
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }

  void _showSnack(String message, SnackBarType type) {
    ScaffoldMessenger.of(context).showSnackBar(
      DompetSnackbar(context, message: message, snackBarType: type),
    );
  }

  Future<bool> _confirmRestore() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => DompetDialog(
        title: 'Pulihkan Backup?',
        subtitle:
            'Data saat ini akan diganti dengan data dari Google Drive. Tindakan ini tidak dapat dibatalkan. Lanjutkan?',
        confirmationText: 'Pulihkan',
        cancellationText: 'Batal',
        onCancel: () => Navigator.of(ctx).pop(false),
        onConfirm: () => Navigator.of(ctx).pop(true),
      ),
    );
    return result == true;
  }

  Future<bool> _confirmOverwrite(String backupInfo) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => DompetDialog(
        title: 'Timpa Backup?',
        subtitle:
            'Backup yang ada di Google Drive ($backupInfo) akan diganti dengan data saat ini. Tindakan ini tidak dapat dibatalkan. Lanjutkan?',
        confirmationText: 'Cadangkan',
        cancellationText: 'Batal',
        onCancel: () => Navigator.of(ctx).pop(false),
        onConfirm: () => Navigator.of(ctx).pop(true),
      ),
    );
    return result == true;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BackupCubit, BackupState>(
      listenWhen: (prev, curr) => prev.action != curr.action,
      listener: (context, state) {
        state.action.whenOrNull(
          success: (msg) {
            _loadingOverlay.hide();
            _showSnack(msg, SnackBarType.success);
            context.read<BackupCubit>().resetAction();
          },
          error: (msg) {
            _loadingOverlay.hide();
            _showSnack(msg, SnackBarType.error);
            context.read<BackupCubit>().resetAction();
          },
          loading: () {
            _loadingOverlay.show(context, text: 'Memproses...');
          },
          initial: () {
            _loadingOverlay.hide();
          },
        );
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Pengaturan')),
        body: BlocBuilder<AppConfigurationCubit, AppConfiguration?>(
          builder: (context, config) {
            if (config == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return ListView(
              children: [
                // TAMPILAN
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(
                    'Tampilan',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.brightness_auto_rounded),
                  title: const Text('Tema'),
                  subtitle: Text(_labelFor(config.themeMode)),
                ),
                RadioGroup<AppThemeMode>(
                  groupValue: config.themeMode,
                  onChanged: (value) {
                    if (value == null) return;
                    context.read<AppConfigurationCubit>().update(
                      config.copyWith(themeMode: value),
                    );
                  },
                  child: Column(
                    children: [
                      RadioListTile<AppThemeMode>(
                        value: AppThemeMode.system,
                        title: const Text('Ikuti Sistem'),
                        subtitle: const Text('Mengikuti tema perangkat'),
                        secondary: const Icon(Icons.smartphone_rounded),
                      ),
                      RadioListTile<AppThemeMode>(
                        value: AppThemeMode.light,
                        title: const Text('Terang'),
                        secondary: const Icon(Icons.light_mode_rounded),
                      ),
                      RadioListTile<AppThemeMode>(
                        value: AppThemeMode.dark,
                        title: const Text('Gelap'),
                        secondary: const Icon(Icons.dark_mode_rounded),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Preferensi tema akan disimpan dan digunakan saat aplikasi dibuka kembali.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Divider(height: 1),
                // PENCADANGAN
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(
                    'Pencadangan',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                BlocBuilder<ConnectivityCubit, bool>(
                  builder: (context, isOnline) {
                    return BlocBuilder<BackupCubit, BackupState>(
                      builder: (context, backupState) {
                        final meta = backupState.lastBackup;
                        final isLoadingMeta = backupState.isLoadingMeta;
                        final isSignedIn = backupState.isSignedIn;
                        final email = backupState.accountEmail;
                        final isProcessing = backupState.action.maybeWhen(
                          loading: () => true,
                          orElse: () => false,
                        );
                        // Backup & restore need internet; keep sign-out enabled
                        // (local operation) but disable everything Drive-related.
                        final canUseDrive = isOnline && !isProcessing;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (!isOnline)
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  0,
                                  16,
                                  8,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.errorContainer,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    spacing: 12,
                                    children: [
                                      Icon(
                                        Icons.wifi_off_rounded,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onErrorContainer,
                                      ),
                                      Expanded(
                                        child: Text(
                                          'Tidak ada koneksi internet. Backup dan restore membutuhkan koneksi internet.',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.onErrorContainer,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ListTile(
                              leading: const Icon(Icons.cloud_rounded),
                              title: const Text('Google Drive'),
                              subtitle: Text(
                                isSignedIn
                                    ? (email ?? 'Terhubung')
                                    : 'Belum terhubung ke Google',
                              ),
                              trailing: isLoadingMeta
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : IconButton(
                                      tooltip: 'Segarkan',
                                      icon: const Icon(Icons.refresh_rounded),
                                      onPressed: !canUseDrive
                                          ? null
                                          : () => context
                                                .read<BackupCubit>()
                                                .refreshMeta(),
                                    ),
                            ),
                            ListTile(
                              leading: const Icon(Icons.history_rounded),
                              title: const Text('Backup terakhir'),
                              subtitle: Text(
                                !isOnline && meta == null
                                    ? 'Perlu koneksi internet untuk memeriksa'
                                    : isLoadingMeta
                                    ? 'Memuat...'
                                    : meta == null
                                    ? 'Belum ada backup'
                                    : '${_formatBackupTime(meta.updatedAt)} • ${_formatSize(meta.sizeBytes)}',
                              ),
                            ),
                            if (isSignedIn && email != null)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: TextButton.icon(
                                    onPressed: isProcessing
                                        ? null
                                        : () => context
                                              .read<BackupCubit>()
                                              .signOut(),
                                    icon: const Icon(
                                      Icons.logout_rounded,
                                      size: 18,
                                    ),
                                    label: const Text('Keluar dari Google'),
                                  ),
                                ),
                              ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: FilledButton.icon(
                                onPressed: !canUseDrive
                                    ? null
                                    : () async {
                                        if (meta != null) {
                                          final ok = await _confirmOverwrite(
                                            '${_formatBackupTime(meta.updatedAt)} • ${_formatSize(meta.sizeBytes)}',
                                          );
                                          if (!ok) return;
                                          if (!context.mounted) return;
                                        }
                                        context.read<BackupCubit>().backup();
                                      },
                                icon: const Icon(Icons.cloud_upload_rounded),
                                label: const Text('Cadangkan Sekarang'),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: OutlinedButton.icon(
                                onPressed: !canUseDrive
                                    ? null
                                    : () async {
                                        final ok = await _confirmRestore();
                                        if (!ok) return;
                                        if (!context.mounted) return;
                                        context.read<BackupCubit>().restore();
                                      },
                                icon: const Icon(Icons.cloud_download_rounded),
                                label: const Text('Pulihkan Backup'),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Text(
                                'Backup disimpan di folder privat aplikasi di Google Drive dari akun yang digunakan untuk login. Hanya 1 backup terbaru yang disimpan.',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withValues(alpha: 0.6),
                                    ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 24),
              ],
            );
          },
        ),
      ),
    );
  }

  String _labelFor(AppThemeMode mode) {
    return switch (mode) {
      AppThemeMode.system => 'Ikuti Sistem',
      AppThemeMode.light => 'Terang',
      AppThemeMode.dark => 'Gelap',
    };
  }
}
