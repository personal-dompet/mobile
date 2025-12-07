import 'package:auto_route/auto_route.dart';
import 'package:dompet/core/utils/helpers/hero_tag.dart';
import 'package:dompet/core/widgets/financial_entity_icon_container.dart';
import 'package:dompet/features/pocket/domain/model/pocket_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class PocketDetailPage extends ConsumerWidget {
  final PocketModel pocket;

  const PocketDetailPage({super.key, required this.pocket});

  String get iconTag {
    return createHeroTag(
      data: 'poket-icon',
      id: pocket.id,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pocket.name),
        backgroundColor: pocket.color?.background,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: pocket.color?.background,
              child: Column(
                spacing: 12,
                children: [
                  Hero(
                    tag: iconTag,
                    child: FinancialEntityIconContainer(
                      color: pocket.color!,
                      icon: pocket.icon!.icon,
                      size: 96,
                      iconSize: 52,
                    ),
                  ),
                  Text(
                    pocket.formattedBalance,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
