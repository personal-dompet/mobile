import 'package:auto_route/auto_route.dart';
import 'package:dompet_app/core/cubits/pagination_cubit.dart';
import 'package:dompet_app/core/dependencies/init_dependency.dart';
import 'package:dompet_app/core/widgets/page_view.dart';
import 'package:dompet_app/features/bills/cubits/bill_signal_cubit.dart';
import 'package:dompet_app/features/bills/models/bill.dart';
import 'package:dompet_app/features/bills/models/bill_filter.dart';
import 'package:dompet_app/features/bills/widgets/bill_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Seluruh tagihan satu tagihan rutin (paginasi).
@RoutePage()
class BillPlanBillsPage extends StatefulWidget {
  final int planId;
  final String planName;
  const BillPlanBillsPage({
    super.key,
    required this.planId,
    required this.planName,
  });

  @override
  State<BillPlanBillsPage> createState() => _BillPlanBillsPageState();
}

class _BillPlanBillsPageState extends State<BillPlanBillsPage> {
  late final PaginationCubit<Bill, BillFilter> _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<PaginationCubit<Bill, BillFilter>>()
      ..fetchInitial(filter: BillFilter(billPlanId: widget.planId));
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tagihan • ${widget.planName}')),
      body: BlocListener<BillSignalCubit, int>(
        listener: (context, state) => _cubit.fetchInitial(
          filter: BillFilter(billPlanId: widget.planId),
        ),
        child: PaginationListView<Bill, BillFilter>(
          cubit: _cubit,
          emptyMessage: 'Belum ada tagihan.',
          listBuilder: (context, items) {
            return SliverList.separated(
              itemCount: items.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: 12),
              itemBuilder: (context, index) =>
                  BillTile(bill: items[index]),
            );
          },
        ),
      ),
    );
  }
}
