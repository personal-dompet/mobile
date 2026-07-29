import 'dart:async';

import 'package:dompet_app/core/cubits/pagination_cubit.dart';
import 'package:dompet_app/core/enums/enum.dart';
import 'package:dompet_app/core/extensions/date.dart';
import 'package:dompet_app/core/widgets/widget.dart';
import 'package:dompet_app/features/accounts/model/account.dart';
import 'package:dompet_app/features/activities/cubits/activity_signal_cubit.dart';
import 'package:dompet_app/features/activities/enums/activity_type.dart';
import 'package:dompet_app/features/activities/extensions/list_activity.dart';
import 'package:dompet_app/features/activities/forms/activity_filter_form.dart';
import 'package:dompet_app/features/activities/models/activity_list_item.dart';
import 'package:dompet_app/features/activities/widgets/activity_item_tile.dart';
import 'package:dompet_app/features/activities/widgets/empty_activities.dart';
import 'package:dompet_app/features/journals/models/journal_entry.dart';
import 'package:dompet_app/features/journals/models/journal_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';

class ActivityList extends StatefulWidget {
  final Account? account;
  const ActivityList({super.key, this.account});

  @override
  State<ActivityList> createState() => _ActivityListState();
}

class _ActivityListState extends State<ActivityList> {
  final _filterForm = ActivityFilterForm();
  final now = DateTime.now();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _fetch(_filterForm.filter);
    _filterForm.descriptionControl.valueChanges.listen((description) {
      _debounce?.cancel();
      _debounce = Timer(Duration(milliseconds: 300), () {
        _fetch(_filterForm.filter);
      });
    });

    _filterForm.typeControl.valueChanges.listen((event) {
      _fetch(_filterForm.filter);
    });

    _filterForm.periodeControl.valueChanges.listen((event) {
      _fetch(_filterForm.filter);
    });
  }

  List<ActivityType> get _typeOptions => [
    .all,
    .expense,
    .billPayment,
    .income,
    .transfer,
    .adjustment,
  ];

  @override
  void dispose() {
    _filterForm.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _fetch(JournalFilter filter) {
    context.read<PaginationCubit<JournalEntry, JournalFilter>>().fetchInitial(
      filter: filter.copyWith(accountId: widget.account?.id),
    );
  }

  String _groupLabel(DateTime date) {
    final diff = date.difference(now).inDays.abs();
    if (diff > 6) return date.format();
    if (diff > 1) return date.dayName;
    if (diff == 1) return 'Kemarin';
    return 'Hari Ini';
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return BlocListener<ActivitySignalCubit, int>(
      listener: (_, _) {
        _fetch(_filterForm.filter);
      },
      child: SafeArea(
        child: PaginationListView(
          cubit: context.read<PaginationCubit<JournalEntry, JournalFilter>>(),
          empty: Center(
            child: EmptyActivities(
              center: true,
              selectedAccount: widget.account,
            ),
          ),
          header: Column(
            crossAxisAlignment: .stretch,
            children: [
              Column(
                mainAxisSize: .min,
                crossAxisAlignment: .stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: DompetTextField(
                      placeholder: 'Cari aktivitas...',
                      formControl: _filterForm.descriptionControl,
                      textInputAction: .search,
                      clearable: true,
                    ),
                  ),
                  SizedBox(
                    height: 36,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: .horizontal,
                      itemCount: _typeOptions.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final type = _typeOptions[index];
                        return ReactiveValueListenableBuilder(
                          formControl: _filterForm.typeControl,
                          builder: (context, control, child) {
                            final typeControl =
                                control as FormControl<ActivityType>;
                            return FilterChip(
                              label: Text(type.label),
                              visualDensity: .compact,
                              selected: typeControl.value == type,
                              onSelected: (_) {
                                typeControl.value = type;
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 12),

                  SizedBox(
                    height: 36,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: .horizontal,
                      itemCount: PeriodicTime.options.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final type = PeriodicTime.options[index];
                        return ReactiveValueListenableBuilder(
                          formControl: _filterForm.periodeControl,
                          builder: (context, control, child) {
                            final periodeControl =
                                control as FormControl<PeriodicTime>;
                            return FilterChip(
                              label: Text(type.label),
                              visualDensity: .compact,
                              selected: periodeControl.value == type,
                              onSelected: (_) {
                                periodeControl.value = type;
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 16),
                ],
              ),
            ],
          ),
          listBuilder: (context, items) {
            final grouped = items.groupedItems;
            return SliverList.builder(
              itemCount: grouped.length,
              itemBuilder: (context, index) {
                return switch (grouped[index]) {
                  ActivityDateHeader(:final date) => Text(
                    _groupLabel(date),
                    style: themeData.textTheme.bodyLarge?.copyWith(
                      fontWeight: .w600,
                    ),
                  ),
                  ActivityItem(:final activity) => ActivityItemTile(
                    activity: activity,
                    hideDate: true,
                    accountId: widget.account?.id,
                  ),
                  ActivitySpacing(:final height) => SizedBox(height: height),
                };
              },
            );
          },
        ),
      ),
    );
  }
}
