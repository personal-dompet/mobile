import 'package:auto_route/auto_route.dart';
import 'package:dompet/core/utils/helpers/hero_tag.dart';
import 'package:dompet/core/widgets/financial_entity_icon_container.dart';
import 'package:dompet/features/pocket/domain/model/pocket_model.dart';
import 'package:dompet/features/pocket/presentation/widgets/pocket_type_card.dart';
import 'package:flutter/material.dart';

@RoutePage()
class PocketDetailPage extends StatelessWidget {
  final PocketModel pocket;

  const PocketDetailPage({super.key, required this.pocket});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pocket.name),
      ),
      body: SingleChildScrollView(
        child: _DetailContent(pocket: pocket),
        // child: pocketAsync.when(
        //   data: (data) {
        //     return _DetailContent(pocket: data);
        //   },
        //   error: (error, stackTrace) {
        //     return Text.rich(
        //       TextSpan(
        //         text: 'Error: $error\n',
        //         children: [
        //           TextSpan(
        //             text: 'stackTrace: $stackTrace',
        //           ),
        //         ],
        //       ),
        //     );
        //   },
        // loading: () {
        //   PocketModel detailPocket = PocketModel.placeholder();
        //   if (pocket.type == PocketType.recurring) {
        //     detailPocket = RecurringPocketModel.placeholder().copyWith(
        //       name: pocket.name,
        //       balance: pocket.balance,
        //       icon: pocket.icon,
        //       color: pocket.color,
        //     );
        //   }
        //   if (pocket.type == PocketType.saving) {
        //     detailPocket = SavingPocketModel.placeholder().copyWith(
        //       name: pocket.name,
        //       balance: pocket.balance,
        //       icon: pocket.icon,
        //       color: pocket.color,
        //     );
        //   }
        //   if (pocket.type == PocketType.spending) {
        //     detailPocket = SpendingPocketModel.placeholder().copyWith(
        //       name: pocket.name,
        //       balance: pocket.balance,
        //       icon: pocket.icon,
        //       color: pocket.color,
        //     );
        //   }
        //   return Skeletonizer(
        //       enabled: true, child: _DetailContent(pocket: detailPocket));
        // },
        // ),
      ),
    );
  }
}

class _DetailContent extends StatelessWidget {
  final PocketModel pocket;
  const _DetailContent({required this.pocket});

  String get iconTag {
    return createHeroTag(
      data: 'poket-icon',
      id: pocket.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        spacing: 16,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
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
          ),
          PocketTypeCard(pocket: pocket),
        ],
      ),
    );
  }
}
