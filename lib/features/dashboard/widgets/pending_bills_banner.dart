import 'package:auto_route/auto_route.dart';
import 'package:dompet_app/core/dependencies/init_dependency.dart';
import 'package:dompet_app/core/extensions/number.dart';
import 'package:dompet_app/core/router/router.gr.dart';
import 'package:dompet_app/features/bills/cubits/bill_signal_cubit.dart';
import 'package:dompet_app/features/bills/repositories/bill_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Info ramping beban tagihan aktif di bawah Total Uang.
/// Hanya tampil bila ada; tap menuju daftar tagihan.
/// Total dashboard tidak dikurangi (akrual: kas berkurang saat bayar).
class PendingBillsBanner extends StatefulWidget {
  const PendingBillsBanner({super.key});

  @override
  State<PendingBillsBanner> createState() => _PendingBillsBannerState();
}

class _PendingBillsBannerState extends State<PendingBillsBanner> {
  late Future<int> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<int> _load() => getIt<BillRepository>().getPendingTotal();

  void _reload() {
    setState(() {
      _future = _load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocListener<BillSignalCubit, int>(
      listener: (context, state) => _reload(),
      child: FutureBuilder<int>(
        future: _future,
        builder: (context, snapshot) {
          final total = snapshot.data ?? 0;
          if (total <= 0) return const SizedBox.shrink();
          return Card(
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => context.router.push(const BillRoute()),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  spacing: 12,
                  children: [
                    Icon(
                      Icons.pending_actions_rounded,
                      color: theme.colorScheme.primary,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 2,
                        children: [
                          Text(
                            'Tagihan tertunda',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${total.currency} menunggu dibayar',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.6,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
