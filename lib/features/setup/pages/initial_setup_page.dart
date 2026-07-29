import 'package:auto_route/auto_route.dart';
import 'package:dompet_app/core/constants/keys/key.dart';
import 'package:dompet_app/core/router/router.gr.dart';
import 'package:flutter/material.dart';

@RoutePage()
class InitialSetupPage extends StatelessWidget {
  const InitialSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Scaffold(
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
                    'Dompet membantu mencatat pemasukan, pengeluaran, dan budget harian dengan cara yang sederhana.',
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
                    'Pemasukan dan pengeluaran dicatat tanpa proses yang membingungkan.',
              ),

              _featurePreview(
                context,
                headline: 'Pantau pengeluaranmu',
                icon: Icons.line_axis_rounded,
                subtext: 'Lihat ke mana uangmu digunakan dari waktu ke waktu.',
              ),

              _featurePreview(
                context,
                headline: 'Mulai dari dompet utamamu',
                icon: Icons.wallet,
                subtext:
                    'Tambahkan rekening, e-wallet, atau uang tunai yang biasa kamu gunakan.',
                hasAction: true,
              ),
            ],
          ),
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
