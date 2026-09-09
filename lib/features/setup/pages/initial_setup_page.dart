import 'package:auto_route/auto_route.dart';
import 'package:dompet_app/core/constants/keys/key.dart';
import 'package:dompet_app/core/dependencies/init_dependency.dart';
import 'package:dompet_app/core/network/connectivity_cubit.dart';
import 'package:dompet_app/core/router/router.gr.dart';
import 'package:dompet_app/core/states/action_state.dart';
import 'package:dompet_app/core/widgets/dompet_dialog.dart';
import 'package:dompet_app/core/widgets/dompet_snackbar.dart';
import 'package:dompet_app/core/widgets/loading_overlay.dart';
import 'package:dompet_app/features/backup/cubits/backup_cubit.dart';
import 'package:dompet_app/features/backup/cubits/backup_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

@RoutePage()
class InitialSetupPage extends StatelessWidget {
  const InitialSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Passive init: never triggers interactive Google Sign-In on page load.
      // Login happens via the explicit button in the restore section.
      create: (_) => getIt<BackupCubit>()..init(promptSignIn: false),
      child: const _InitialSetupView(),
    );
  }
}

class _InitialSetupView extends StatefulWidget {
  const _InitialSetupView();

  @override
  State<_InitialSetupView> createState() => _InitialSetupViewState();
}

class _InitialSetupViewState extends State<_InitialSetupView> {
  final _loadingOverlay = LoadingOverlay();

  String _formatBackupTime(DateTime? dt) {
    if (dt == null) return 'Belum ada cadangan';
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
        title: 'Pulihkan Cadangan?',
        subtitle:
            'Data dari Google Drive akan dipulihkan ke perangkat ini dan setup akan dilewati. Lanjutkan?',
        confirmationText: 'Pulihkan',
        cancellationText: 'Batal',
        onCancel: () => Navigator.of(ctx).pop(false),
        onConfirm: () => Navigator.of(ctx).pop(true),
      ),
    );
    return result == true;
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final isDark = themeData.brightness == Brightness.dark;
    return BlocListener<BackupCubit, BackupState>(
      listenWhen: (prev, curr) => prev.action != curr.action,
      listener: (context, state) {
        state.action.whenOrNull(
          success: (msg) {
            _loadingOverlay.hide();
            _showSnack(msg, SnackBarType.success);
            context.read<BackupCubit>().resetAction();
            // Restored data already contains asset accounts, so setup
            // can be skipped entirely.
            context.router.replaceAll([ShellRoute()]);
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
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
          statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
        ),
        child: Scaffold(
          key: initialSetupKey,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 48),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mulai rapikan keuanganmu',
                        style: themeData.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: themeData.colorScheme.primary,
                        ),
                      ),
                      Text(
                        'Dompet membantu mencatat pemasukan, pengeluaran, dan mengatur anggaran dengan cara yang sederhana.',
                        style: themeData.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  _featurePreview(
                    context,
                    headline: 'Catat dengan sederhana',
                    icon: Icons.receipt_rounded,
                    subtext:
                        'Catat pemasukan dan pengeluaran tanpa langkah yang rumit.',
                  ),

                  _featurePreview(
                    context,
                    headline: 'Pantau pengeluaranmu',
                    icon: Icons.line_axis_rounded,
                    subtext:
                        'Lihat ke mana uangmu digunakan dari waktu ke waktu.',
                  ),

                  _featurePreview(
                    context,
                    headline: 'Mulai dari dompet utamamu',
                    icon: Icons.wallet,
                    subtext:
                        'Tambahkan rekening, e-wallet, atau uang tunai yang biasa kamu gunakan.',
                    hasAction: true,
                  ),

                  // Restore section: only when online. Progressive content —
                  // login CTA when signed out, restore CTA when a backup exists.
                  // Divider "ATAU" hanya muncul bersama card cadangan (saat online).
                  BlocBuilder<ConnectivityCubit, bool>(
                    builder: (context, isOnline) {
                      if (!isOnline) return const SizedBox.shrink();
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 16,
                        children: [
                          _orDivider(context),
                          BlocBuilder<BackupCubit, BackupState>(
                            builder: (context, backupState) {
                              if (backupState.isLoadingMeta) {
                                return _restoreCard(
                                  context,
                                  headline: 'Memeriksa cadangan...',
                                  subtext:
                                      'Menghubungkan ke Google Drive untuk mencari cadangan Dompet.',
                                  trailing: const SizedBox(
                                    width: double.infinity,
                                    child: Center(
                                      child: SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }

                              if (!backupState.isSignedIn) {
                                return _restoreCard(
                                  context,
                                  headline: 'Punya data sebelumnya?',
                                  subtext:
                                      'Hubungkan akun Google untuk memeriksa cadangan Dompet di Google Drive dan lewati setup.',
                                  trailing: SizedBox(
                                    width: double.infinity,
                                    child: FilledButton.icon(
                                      onPressed: _isProcessing(backupState)
                                          ? null
                                          : () => context
                                                .read<BackupCubit>()
                                                .signInAndRefreshMeta(),
                                      icon: const Icon(Icons.login_rounded),
                                      label: const Text('Hubungkan Google'),
                                    ),
                                  ),
                                );
                              }

                              final meta = backupState.lastBackup;
                              if (meta == null) {
                                return _restoreCard(
                                  context,
                                  headline: 'Tidak ada cadangan ditemukan',
                                  subtext:
                                      'Akun ${backupState.accountEmail ?? 'ini'} belum memiliki cadangan Dompet di Google Drive.',
                                  trailing: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      OutlinedButton.icon(
                                        onPressed: _isProcessing(backupState)
                                            ? null
                                            : () => context
                                                  .read<BackupCubit>()
                                                  .refreshMeta(),
                                        icon: const Icon(Icons.refresh_rounded),
                                        label: const Text('Periksa Lagi'),
                                      ),
                                      TextButton.icon(
                                        onPressed: _isProcessing(backupState)
                                            ? null
                                            : () => context
                                                  .read<BackupCubit>()
                                                  .signOut(),
                                        icon: const Icon(
                                          Icons.logout_rounded,
                                          size: 18,
                                        ),
                                        label: const Text('Ganti Akun Google'),
                                      ),
                                    ],
                                  ),
                                );
                              }

                              // FIX-02/ISSUE 1: show the actual signed-in email
                              // instead of the generic "akun Google ini" text.
                              final restoreEmail =
                                  backupState.accountEmail ?? 'akun ini';
                              return _restoreCard(
                                context,
                                headline: 'Pulihkan cadangan',
                                subtext:
                                    '$restoreEmail\n${_formatBackupTime(meta.updatedAt)} • ${_formatSize(meta.sizeBytes)}',
                                trailing: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    FilledButton.icon(
                                      onPressed: _isProcessing(backupState)
                                          ? null
                                          : () async {
                                              final ok =
                                                  await _confirmRestore();
                                              if (!ok) return;
                                              if (!context.mounted) return;
                                              context
                                                  .read<BackupCubit>()
                                                  .restore();
                                            },
                                      icon: const Icon(
                                        Icons.cloud_download_rounded,
                                      ),
                                      label: const Text('Pulihkan'),
                                    ),
                                    TextButton.icon(
                                      onPressed: _isProcessing(backupState)
                                          ? null
                                          : () => context
                                                .read<BackupCubit>()
                                                .signOut(),
                                      icon: const Icon(
                                        Icons.logout_rounded,
                                        size: 18,
                                      ),
                                      label: const Text('Ganti Akun Google'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _isProcessing(BackupState state) {
    return state.action.maybeWhen(loading: () => true, orElse: () => false);
  }

  /// Pemisah "---- ATAU ----" di antara card cadangan dan card mulai.
  Widget _orDivider(BuildContext context) {
    final themeData = Theme.of(context);
    return Row(
      spacing: 12,
      children: [
        const Expanded(child: Divider()),
        Text(
          'ATAU',
          style: themeData.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: themeData.colorScheme.outline,
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }

  /// Restore card styled like [_featurePreview] for visual consistency.
  Widget _restoreCard(
    BuildContext context, {
    required String headline,
    required String subtext,
    required Widget trailing,
  }) {
    final themeData = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.cloud_download_rounded,
              size: 28,
              color: themeData.colorScheme.primary,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    headline,
                    style: themeData.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Text(subtext, style: Theme.of(context).textTheme.bodyMedium),
                  SizedBox(height: 8),
                  trailing,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _featurePreview(
    BuildContext context, {
    required String headline,
    required String subtext,
    required IconData icon,
    bool hasAction = false,
  }) {
    final themeData = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 28, color: themeData.colorScheme.primary),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    headline,
                    style: themeData.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Text(subtext, style: Theme.of(context).textTheme.bodyMedium),
                  if (hasAction) ...[
                    SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {
                          context.router.push(WalletSetupRoute());
                        },
                        child: Text('Mulai'),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
