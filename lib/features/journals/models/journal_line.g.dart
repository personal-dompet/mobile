// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_line.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_JournalLine _$JournalLineFromJson(Map<String, dynamic> json) => $checkedCreate(
  '_JournalLine',
  json,
  ($checkedConvert) {
    final val = _JournalLine(
      id: $checkedConvert('id', (v) => (v as num).toInt()),
      journalEntryId: $checkedConvert(
        'journal_entry_id',
        (v) => (v as num).toInt(),
      ),
      accountId: $checkedConvert('account_id', (v) => (v as num).toInt()),
      debitAmount: $checkedConvert(
        'debit_amount',
        (v) => (v as num?)?.toInt() ?? 0,
      ),
      creditAmount: $checkedConvert(
        'credit_amount',
        (v) => (v as num?)?.toInt() ?? 0,
      ),
      note: $checkedConvert('note', (v) => v as String?),
      lineOrder: $checkedConvert(
        'line_order',
        (v) => (v as num?)?.toInt() ?? 0,
      ),
      accountName: $checkedConvert('account_name', (v) => v as String),
      accountType: $checkedConvert(
        'account_type',
        (v) => $enumDecode(_$AccountTypeNameEnumMap, v),
      ),
      balance: $checkedConvert(
        'account_balance',
        (v) => (v as num?)?.toInt() ?? 0,
      ),
      accountNormalBalance: $checkedConvert(
        'account_normal_balance',
        (v) => $enumDecode(_$BalanceTypeEnumMap, v),
      ),
    );
    return val;
  },
  fieldKeyMap: const {
    'journalEntryId': 'journal_entry_id',
    'accountId': 'account_id',
    'debitAmount': 'debit_amount',
    'creditAmount': 'credit_amount',
    'lineOrder': 'line_order',
    'accountName': 'account_name',
    'accountType': 'account_type',
    'balance': 'account_balance',
    'accountNormalBalance': 'account_normal_balance',
  },
);

Map<String, dynamic> _$JournalLineToJson(_JournalLine instance) =>
    <String, dynamic>{
      'id': instance.id,
      'journal_entry_id': instance.journalEntryId,
      'account_id': instance.accountId,
      'debit_amount': instance.debitAmount,
      'credit_amount': instance.creditAmount,
      'note': ?instance.note,
      'line_order': instance.lineOrder,
      'account_name': instance.accountName,
      'account_type': _$AccountTypeNameEnumMap[instance.accountType]!,
      'account_balance': instance.balance,
      'account_normal_balance':
          _$BalanceTypeEnumMap[instance.accountNormalBalance]!,
    };

const _$AccountTypeNameEnumMap = {
  AccountTypeName.asset: 'ASSET',
  AccountTypeName.liability: 'LIABILITY',
  AccountTypeName.equity: 'EQUITY',
  AccountTypeName.income: 'INCOME',
  AccountTypeName.expense: 'EXPENSE',
};

const _$BalanceTypeEnumMap = {
  BalanceType.debit: 'DEBIT',
  BalanceType.credit: 'CREDIT',
};
