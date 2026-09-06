import 'package:dompet_app/core/dependencies/init_dependency.dart';
import 'package:dompet_app/core/enums/enum.dart';
import 'package:dompet_app/core/extensions/number.dart';
import 'package:dompet_app/features/accounts/models/account_filter.dart';
import 'package:dompet_app/features/accounts/repositories/account_repository.dart';
import 'package:dompet_app/features/dashboard/cubits/dashboard_cubit.dart';
import 'package:dompet_app/features/reports/models/report_period.dart';
import 'package:dompet_app/features/reports/repositories/report_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BalanceCard extends StatefulWidget {
  const BalanceCard({super.key});

  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return BlocBuilder<DashboardCubit, DashboardState>(
      buildWhen: (previous, current) {
        return previous.balanceStatus != current.balanceStatus;
      },
      builder: (context, state) {
        return Card(
          clipBehavior: .antiAlias,
          elevation: 1,
          child: InkWell(
            onTap: () {
              setState(() {
                _isObscure = !_isObscure;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: .start,
                spacing: 8,
                children: [
                  Row(
                    spacing: 8,
                    children: [
                      Icon(Icons.money_rounded),
                      Text(
                        'Total Uang',
                        style: themeData.textTheme.titleMedium,
                      ),
                      Spacer(),
                      Icon(
                        _isObscure
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded,
                      ),
                    ],
                  ),
                  Text(
                    _isObscure ? 'Rp••••••••••' : state.balance.currency,
                    style: themeData.textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: themeData.colorScheme.primary,
                    ),
                  ),
                  _BalanceSubtitle(isObscure: _isObscure),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Subtitle kecil di bawah Total Uang: jumlah dompet cair dan,
/// bila ada, nominal yang dialokasikan ke target bulan ini.
///
/// Tetap satu baris agar kartu ramping; nominal disamarkan saat obscure.
class _BalanceSubtitle extends StatelessWidget {
  final bool isObscure;
  const _BalanceSubtitle({required this.isObscure});

  Future<(int, int)> _load() async {
    final accounts = await getIt<AccountRepository>().getAccounts(
      filter: AccountFilter(
        isSystem: false,
        isLiqid: true,
        type: AccountType.asset,
      ),
    );
    final summary = await getIt<ReportRepository>().getMonthlySummary(
      ReportPeriod.currentMonth(),
    );
    return (accounts.length, summary.netSaving);
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return FutureBuilder<(int, int)>(
      future: _load(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();
        final (count, allocated) = snapshot.data!;
        final text = allocated > 0 && !isObscure
            ? '$count dompet • ${allocated.compactCurrency} dialokasikan ke target'
            : '$count dompet';
        return Text(
          text,
          style: themeData.textTheme.labelSmall?.copyWith(
            color: themeData.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          overflow: TextOverflow.ellipsis,
        );
      },
    );
  }
}
