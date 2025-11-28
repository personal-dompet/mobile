import 'package:dompet/core/enum/list_type.dart';
import 'package:dompet/core/widgets/financial_entity_empty.dart';
import 'package:dompet/core/widgets/financial_entity_grid.dart';
import 'package:dompet/features/pocket/domain/model/pocket_model.dart';
import 'package:dompet/features/pocket/presentation/provider/pocket_filter_provider.dart';
import 'package:dompet/features/pocket/presentation/provider/pocket_flow_provider.dart';
import 'package:dompet/features/pocket/presentation/provider/pocket_option_provider.dart';
import 'package:dompet/features/transfer/domain/forms/pocket_transfer_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectPocketPage extends ConsumerWidget {
  final int? selectedPocketId;
  final SelectPocketTitle title;
  final bool disableEmpty;
  final bool? hideWallet;
  const SelectPocketPage({
    super.key,
    this.selectedPocketId,
    this.title = SelectPocketTitle.general,
    this.disableEmpty = false,
    this.hideWallet = false,
  });

  bool get _disableEmpty => disableEmpty || title == SelectPocketTitle.source;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pocketsAsync = ref.watch(pocketOptionProvider);
    final transferForm = ref.watch(pocketTransferFormProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(title.label),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: pocketsAsync.when(
        data: (data) {
          List<PocketModel> pockets = [...data];
          if (hideWallet == true) {
            pockets.removeAt(0);
          }
          if (pockets.isEmpty) {
            return FinancialEntityEmpty(
              onCreate: () async {
                await ref.read(pocketFlowProvider(ListType.option)).beginCreate(
                  context,
                  onFormCreated: (pocketForm) {
                    Navigator.of(context).pop<PocketModel>(
                      pocketForm.toPocketModel(),
                    );
                  },
                );
              },
              filter: ref.watch(pocketFilterProvider),
              listType: ListType.filtered,
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                Expanded(
                  child: FinancialEntityGrid<PocketModel>(
                    data: pockets,
                    selectedId: selectedPocketId,
                    listType: ListType.option,
                    destination: transferForm.toPocketValue,
                    source: transferForm.fromPocketValue,
                    disableEmpty: _disableEmpty,
                    onCreate: () async {
                      await ref
                          .read(pocketFlowProvider(ListType.option))
                          .beginCreate(
                        context,
                        onFormCreated: (pocketForm) {
                          Navigator.of(context).pop<PocketModel>(
                            pocketForm.toPocketModel(),
                          );
                        },
                      );
                    },
                    onTap: (pocket) {
                      Navigator.of(context).pop<PocketModel>(pocket);
                    },
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error loading pockets: $error'),
        ),
      ),
    );
  }
}

enum SelectPocketTitle {
  destination('destination', 'Select Destination Pocket'),
  source('source', 'Select Source Pocket'),
  general('general', 'Select Pocket');

  final String value;
  final String label;

  const SelectPocketTitle(this.value, this.label);

  static SelectPocketTitle? fromValue(String value) {
    try {
      return SelectPocketTitle.values.firstWhere(
        (status) => status.value.toLowerCase() == value.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }
}
