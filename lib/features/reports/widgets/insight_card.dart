import 'package:dompet_app/features/reports/models/report_insight.dart';
import 'package:flutter/material.dart';

/// Daftar insight otomatis: ringkasan "pintar" di atas angka laporan.
///
/// Murni presentasi — logika aturan ada di [ReportInsight.generate].
class InsightCard extends StatelessWidget {
  const InsightCard({super.key, required this.insights});

  final List<ReportInsight> insights;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 12,
          children: [
            Text(
              'Insight',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            ...insights.map((insight) => _InsightRow(insight: insight)),
          ],
        ),
      ),
    );
  }
}

class _InsightRow extends StatelessWidget {
  const _InsightRow({required this.insight});

  final ReportInsight insight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (icon, color) = switch (insight.kind) {
      InsightKind.positive => (
        Icons.check_circle_rounded,
        theme.colorScheme.tertiary,
      ),
      InsightKind.negative => (
        Icons.warning_rounded,
        theme.colorScheme.error,
      ),
      InsightKind.info => (Icons.info_rounded, theme.colorScheme.primary),
    };
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Icon(icon, color: color, size: 20),
        Expanded(
          child: Text(insight.message, style: theme.textTheme.bodyMedium),
        ),
      ],
    );
  }
}
