import 'package:dompet_app/core/extensions/number.dart';
import 'package:dompet_app/features/dashboard/cubits/dashboard_cubit.dart';
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
