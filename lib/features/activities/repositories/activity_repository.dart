// import 'package:dompet_app/core/constants/field_keys/field_key.dart';
// import 'package:dompet_app/core/database/db_service.dart';
// import 'package:dompet_app/core/database/schemas/schemas.dart';
// import 'package:dompet_app/core/database/views/views.dart';
// import 'package:dompet_app/core/enums/enum.dart';
// import 'package:dompet_app/core/models/pagination.dart';
// import 'package:dompet_app/core/models/pagination_meta.dart';
// import 'package:dompet_app/core/models/pagination_result.dart';
// import 'package:dompet_app/features/accounts/model/account.dart';
// import 'package:dompet_app/features/activities/models/activity_detail.dart';
// import 'package:dompet_app/features/activities/models/activity_filter.dart';
// import 'package:dompet_app/features/journals/enums/journal_source.dart';
// import 'package:dompet_app/features/journals/enums/journal_status.dart';

// class ActivityRepository {
//   final DbService _dbService;

//   const ActivityRepository(this._dbService);

//   Future<PaginationResult<Activity>> getActivities({
//     required Pagination pagination,
//     ActivityFilter? filter,
//   }) async {
//     final db = await _dbService.database;

//     final clauses = [
//       '$journalEntryTable.${JournalEntryKey.source} != ?',
//       '$journalEntryTable.${JournalEntryKey.status} = ?',
//       '($journalEntryTable.${JournalEntryKey.source} != ? OR main_line.${JournalLineKey.creditAmount} > 0)',
//     ];

//     final List<dynamic> args = [
//       AccountTypeName.asset.value,
//       JournalSource.setup.value,
//       JournalStatus.posted.name,
//       JournalSource.transfer.value,
//     ];

//     if (filter != null) {
//       clauses.addAll(filter.whereClauses);
//       args.addAll(filter.arguments);
//     }

//     args.addAll([pagination.limit, pagination.offset]);

//     final queryResult = await db.rawQuery('''
//       SELECT
//         $journalEntryTable.${JournalEntryKey.id} AS ${JournalEntryKey.id},
//         $journalEntryTable.${JournalEntryKey.entryDate} AS ${JournalEntryKey.entryDate},
//         $journalEntryTable.${JournalEntryKey.description} AS ${JournalEntryKey.description},
//         $journalEntryTable.${JournalEntryKey.source} AS ${JournalEntryKey.source},
//         main_line.${JournalLineKey.debitAmount} AS ${JournalEntryKey.debitAmount},
//         main_line.${JournalLineKey.creditAmount} AS ${JournalEntryKey.creditAmount},
//         main_account.${AccountKey.name} AS ${JournalEntryKey.accountName},
//         destination_account.${AccountKey.name} AS ${JournalEntryKey.accountDestinationName},
//         main_account.${AccountKey.type} AS ${JournalEntryKey.accountType},
//         (SELECT COUNT(*) FROM $journalLineTable
//           WHERE ${JournalLineKey.journalEntryId} = $journalEntryTable.${JournalEntryKey.id}
//         ) AS ${JournalEntryKey.linesCount},
//         COUNT(*) OVER() AS total
//       FROM $journalEntryTable
//       INNER JOIN $journalLineTable main_line
//         ON main_line.${JournalLineKey.journalEntryId} = $journalEntryTable.${JournalEntryKey.id}
//       INNER JOIN $accountTable main_account
//         ON main_account.${AccountKey.id} = main_line.${JournalLineKey.accountId}
//         AND main_account.${AccountKey.type} = ?
//       INNER JOIN $journalLineTable destination_line
//         ON destination_line.${JournalLineKey.journalEntryId} = $journalEntryTable.${JournalEntryKey.id}
//         AND destination_line.${JournalLineKey.id} != main_line.${JournalLineKey.id}
//       INNER JOIN $accountTable destination_account
//         ON destination_account.${AccountKey.id} = destination_line.${JournalLineKey.accountId}
//       WHERE ${clauses.join(' AND ')}
//       GROUP BY $journalEntryTable.${JournalEntryKey.id}, main_line.${JournalLineKey.id}
//       ORDER BY $journalEntryTable.${JournalEntryKey.entryDate} DESC
//       LIMIT ? OFFSET ?
//     ''', args);

//     final total = queryResult.isEmpty ? 0 : queryResult.first['total'] as int;

//     return PaginationResult(
//       items: queryResult.map((json) => Activity.fromJson(json)).toList(),
//       meta: PaginationMeta(
//         total: total,
//         limit: pagination.limit,
//         page: pagination.page,
//       ),
//     );
//   }

//   Future<ActivityDetail> getActivity(int id) async {
//     final db = await _dbService.database;

//     final journalResults = await db.query(
//       journalEntryTable,
//       where: '${JournalEntryKey.id} = ?',
//       whereArgs: [id],
//     );

//     if (journalResults.isEmpty) {
//       throw Exception('Aktivitas tidak ditemukan');
//     }

//     final journal = ActivityDetail.fromJson(journalResults.first);

//     final journalLineResults = await db.rawQuery(
//       '''
//       SELECT
//         *,
//         $accountTable.${AccountKey.name} AS ${JournalLineKey.accountName},
//         $accountTable.${AccountKey.type} AS ${JournalLineKey.accountType}
//       FROM $journalLineTable
//       INNER JOIN $accountTable ON $accountTable.${AccountKey.id} = $journalLineTable.${JournalLineKey.accountId}
//       WHERE $journalLineTable.${JournalLineKey.journalEntryId} = ?
//       ORDER BY $journalLineTable.${JournalLineKey.lineOrder} ASC
//     ''',
//       [journal.id],
//     );

//     final journalLines = journalLineResults
//         .map((e) => ActivityDetailLine.fromJson(e))
//         .toList();

//     final assetAccountIds = journalLines
//         .where((line) => line.accountType == .asset)
//         .map((e) => e.accountId)
//         .toList();

//     final placeholder = assetAccountIds.map((_) => '?').toList();

//     final accountResults = await db.rawQuery('''
//       SELECT *
//       FROM $accountBalanceViewName
//       WHERE ${AccountKey.id} IN (${placeholder.join(', ')})
//     ''', assetAccountIds);

//     return journal.copyWith(
//       lines: journalLines,
//       assetAccounts: accountResults
//           .map((account) => Account.fromJson(account))
//           .toList(),
//     );
//   }

//   Future<void> deleteActivity(int id) async {
//     final db = await _dbService.database;

//     await db.update(
//       journalEntryTable,
//       {JournalEntryKey.status: JournalStatus.voided.name},
//       where: '${JournalEntryKey.id} = ?',
//       whereArgs: [id],
//     );
//   }
// }
