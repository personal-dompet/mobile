import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:dompet_app/core/database/schemas/schemas.dart';
import 'package:dompet_app/core/database/views/account_balance.dart';

const savingTrackerView = 'v_saving_tracker';

String savingTrackerViewDefinition =
    '''
CREATE VIEW $savingTrackerView AS
  SELECT
    $savingPlanTable.*,
    $accountTable.${AccountKey.code} AS ${SavingPlanKey.accountCode},
    $accountTable.${AccountKey.name} AS ${SavingPlanKey.accountName},
    $accountTable.${AccountKey.iconCode} AS ${SavingPlanKey.iconCode},
    $accountBalanceView.${AccountKey.balance} AS ${SavingPlanKey.balance},
    CASE
      WHEN $savingPlanTable.${SavingPlanKey.targetAmount} IS NULL THEN NULL
      ELSE $accountBalanceView.${AccountKey.balance} * 1.0 / $savingPlanTable.${SavingPlanKey.targetAmount}
    END AS ${SavingPlanKey.progress}
  FROM $savingPlanTable
  INNER JOIN $accountTable ON $accountTable.${AccountKey.id} = $savingPlanTable.${SavingPlanKey.accountId}
  LEFT JOIN $accountBalanceView ON $accountBalanceView.${AccountKey.id} = $savingPlanTable.${SavingPlanKey.accountId}
  WHERE $savingPlanTable.${SavingPlanKey.isDeleted} = 0
    AND $accountTable.${AccountKey.isDeleted} = 0
''';
