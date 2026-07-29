import 'package:auto_route/annotations.dart';
import 'package:dompet_app/core/cubits/pagination_cubit.dart';
import 'package:dompet_app/core/dependencies/init_dependency.dart';
import 'package:dompet_app/features/activities/widgets/activity_list.dart';
import 'package:dompet_app/features/journals/models/journal_entry.dart';
import 'package:dompet_app/features/journals/models/journal_filter.dart';
import 'package:dompet_app/features/journals/repositories/journal_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class ActivityPage extends StatelessWidget {
  const ActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<PaginationCubit<JournalEntry, JournalFilter>>(
        param1: getIt<JournalRepository>().getJournals,
      ),
      child: ActivityList(),
    );
  }
}
