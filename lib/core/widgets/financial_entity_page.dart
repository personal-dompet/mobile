import 'package:dompet/core/widgets/search_field.dart';
import 'package:flutter/material.dart';

class FinancialEntityPage extends StatelessWidget {
  final Widget child;
  final Widget typeSelector;
  final void Function({String? keyword}) onSearch;
  const FinancialEntityPage({
    super.key,
    required this.child,
    required this.typeSelector,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SearchField(
                onSearch: onSearch,
              ),
            ),
            const SizedBox(height: 16),
            typeSelector,
            const SizedBox(height: 16),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}
