// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i37;
import 'package:dompet_app/features/accounts/models/account.dart' as _i39;
import 'package:dompet_app/features/activities/pages/activity_detail_page.dart'
    as _i1;
import 'package:dompet_app/features/activities/pages/activity_page.dart' as _i2;
import 'package:dompet_app/features/assets/forms/asset_form.dart' as _i40;
import 'package:dompet_app/features/assets/pages/asset_activity_page.dart'
    as _i3;
import 'package:dompet_app/features/assets/pages/asset_archived_page.dart'
    as _i4;
import 'package:dompet_app/features/assets/pages/asset_detail_page.dart' as _i5;
import 'package:dompet_app/features/assets/pages/asset_form_page.dart' as _i6;
import 'package:dompet_app/features/assets/pages/asset_page.dart' as _i7;
import 'package:dompet_app/features/bills/models/bill_plan.dart' as _i41;
import 'package:dompet_app/features/bills/pages/bill_detail_page.dart' as _i9;
import 'package:dompet_app/features/bills/pages/bill_page.dart' as _i10;
import 'package:dompet_app/features/bills/pages/bill_plan_bills_page.dart'
    as _i11;
import 'package:dompet_app/features/bills/pages/bill_plan_detail_page.dart'
    as _i12;
import 'package:dompet_app/features/bills/pages/bill_plan_form_page.dart'
    as _i13;
import 'package:dompet_app/features/bills/pages/bill_plan_list_page.dart'
    as _i14;
import 'package:dompet_app/features/budgets/models/budget_plan.dart' as _i42;
import 'package:dompet_app/features/budgets/pages/budget_detail_page.dart'
    as _i15;
import 'package:dompet_app/features/budgets/pages/budget_page.dart' as _i16;
import 'package:dompet_app/features/budgets/pages/budget_plan_form_page.dart'
    as _i17;
import 'package:dompet_app/features/budgets/pages/budget_plan_list_page.dart'
    as _i18;
import 'package:dompet_app/features/budgets/pages/budget_plan_page.dart'
    as _i19;
import 'package:dompet_app/features/categories/forms/category_form.dart'
    as _i44;
import 'package:dompet_app/features/categories/pages/category_archived_page.dart'
    as _i20;
import 'package:dompet_app/features/categories/pages/category_form_page.dart'
    as _i21;
import 'package:dompet_app/features/categories/pages/category_page.dart'
    as _i22;
import 'package:dompet_app/features/dashboard/pages/dashboard_page.dart'
    as _i23;
import 'package:dompet_app/features/dashboard/pages/shell_page.dart' as _i32;
import 'package:dompet_app/features/reports/pages/report_page.dart' as _i25;
import 'package:dompet_app/features/savings/models/saving_plan.dart' as _i45;
import 'package:dompet_app/features/savings/pages/saving_allocation_page.dart'
    as _i26;
import 'package:dompet_app/features/savings/pages/saving_detail_page.dart'
    as _i27;
import 'package:dompet_app/features/savings/pages/saving_form_page.dart'
    as _i28;
import 'package:dompet_app/features/savings/pages/saving_page.dart' as _i29;
import 'package:dompet_app/features/savings/pages/saving_spend_page.dart'
    as _i30;
import 'package:dompet_app/features/settings/pages/settings_page.dart' as _i31;
import 'package:dompet_app/features/setup/pages/initial_setup_page.dart'
    as _i24;
import 'package:dompet_app/features/setup/pages/wallet_setup_page.dart' as _i36;
import 'package:dompet_app/features/splash/pages/splash_page.dart' as _i33;
import 'package:dompet_app/features/transactions/enums/transaction_type.dart'
    as _i43;
import 'package:dompet_app/features/transactions/forms/transaction_form.dart'
    as _i46;
import 'package:dompet_app/features/transactions/forms/transfer_form.dart'
    as _i47;
import 'package:dompet_app/features/transactions/pages/balance_adjustment_page.dart'
    as _i8;
import 'package:dompet_app/features/transactions/pages/transaction_page.dart'
    as _i34;
import 'package:dompet_app/features/transactions/pages/transfer_page.dart'
    as _i35;
import 'package:flutter/material.dart' as _i38;

/// generated route for
/// [_i1.ActivityDetailPage]
class ActivityDetailRoute extends _i37.PageRouteInfo<ActivityDetailRouteArgs> {
  ActivityDetailRoute({
    _i38.Key? key,
    required int id,
    List<_i37.PageRouteInfo>? children,
  }) : super(
         ActivityDetailRoute.name,
         args: ActivityDetailRouteArgs(key: key, id: id),
         initialChildren: children,
       );

  static const String name = 'ActivityDetailRoute';

  static _i37.PageInfo page = _i37.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ActivityDetailRouteArgs>();
      return _i1.ActivityDetailPage(key: args.key, id: args.id);
    },
  );
}

class ActivityDetailRouteArgs {
  const ActivityDetailRouteArgs({this.key, required this.id});

  final _i38.Key? key;

  final int id;

  @override
  String toString() {
    return 'ActivityDetailRouteArgs{key: $key, id: $id}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ActivityDetailRouteArgs) return false;
    return key == other.key && id == other.id;
  }

  @override
  int get hashCode => key.hashCode ^ id.hashCode;
}

/// generated route for
/// [_i2.ActivityPage]
class ActivityRoute extends _i37.PageRouteInfo<void> {
  const ActivityRoute({List<_i37.PageRouteInfo>? children})
    : super(ActivityRoute.name, initialChildren: children);

  static const String name = 'ActivityRoute';

  static _i37.PageInfo page = _i37.PageInfo(
    name,
    builder: (data) {
      return const _i2.ActivityPage();
    },
  );
}

/// generated route for
/// [_i3.AssetActivityPage]
class AssetActivityRoute extends _i37.PageRouteInfo<AssetActivityRouteArgs> {
  AssetActivityRoute({
    _i38.Key? key,
    required _i39.Account account,
    List<_i37.PageRouteInfo>? children,
  }) : super(
         AssetActivityRoute.name,
         args: AssetActivityRouteArgs(key: key, account: account),
         initialChildren: children,
       );

  static const String name = 'AssetActivityRoute';

  static _i37.PageInfo page = _i37.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AssetActivityRouteArgs>();
      return _i3.AssetActivityPage(key: args.key, account: args.account);
    },
  );
}

class AssetActivityRouteArgs {
  const AssetActivityRouteArgs({this.key, required this.account});

  final _i38.Key? key;

  final _i39.Account account;

  @override
  String toString() {
    return 'AssetActivityRouteArgs{key: $key, account: $account}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AssetActivityRouteArgs) return false;
    return key == other.key && account == other.account;
  }

  @override
  int get hashCode => key.hashCode ^ account.hashCode;
}

/// generated route for
/// [_i4.AssetArchivedPage]
class AssetArchivedRoute extends _i37.PageRouteInfo<void> {
  const AssetArchivedRoute({List<_i37.PageRouteInfo>? children})
    : super(AssetArchivedRoute.name, initialChildren: children);

  static const String name = 'AssetArchivedRoute';

  static _i37.PageInfo page = _i37.PageInfo(
    name,
    builder: (data) {
      return const _i4.AssetArchivedPage();
    },
  );
}

/// generated route for
/// [_i5.AssetDetailPage]
class AssetDetailRoute extends _i37.PageRouteInfo<AssetDetailRouteArgs> {
  AssetDetailRoute({
    _i38.Key? key,
    required int id,
    List<_i37.PageRouteInfo>? children,
  }) : super(
         AssetDetailRoute.name,
         args: AssetDetailRouteArgs(key: key, id: id),
         initialChildren: children,
       );

  static const String name = 'AssetDetailRoute';

  static _i37.PageInfo page = _i37.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AssetDetailRouteArgs>();
      return _i5.AssetDetailPage(key: args.key, id: args.id);
    },
  );
}

class AssetDetailRouteArgs {
  const AssetDetailRouteArgs({this.key, required this.id});

  final _i38.Key? key;

  final int id;

  @override
  String toString() {
    return 'AssetDetailRouteArgs{key: $key, id: $id}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AssetDetailRouteArgs) return false;
    return key == other.key && id == other.id;
  }

  @override
  int get hashCode => key.hashCode ^ id.hashCode;
}

/// generated route for
/// [_i6.AssetFormPage]
class AssetFormRoute extends _i37.PageRouteInfo<AssetFormRouteArgs> {
  AssetFormRoute({
    _i38.Key? key,
    _i40.AssetForm? form,
    int? id,
    List<_i37.PageRouteInfo>? children,
  }) : super(
         AssetFormRoute.name,
         args: AssetFormRouteArgs(key: key, form: form, id: id),
         initialChildren: children,
       );

  static const String name = 'AssetFormRoute';

  static _i37.PageInfo page = _i37.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AssetFormRouteArgs>(
        orElse: () => const AssetFormRouteArgs(),
      );
      return _i6.AssetFormPage(key: args.key, form: args.form, id: args.id);
    },
  );
}

class AssetFormRouteArgs {
  const AssetFormRouteArgs({this.key, this.form, this.id});

  final _i38.Key? key;

  final _i40.AssetForm? form;

  final int? id;

  @override
  String toString() {
    return 'AssetFormRouteArgs{key: $key, form: $form, id: $id}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AssetFormRouteArgs) return false;
    return key == other.key && form == other.form && id == other.id;
  }

  @override
  int get hashCode => key.hashCode ^ form.hashCode ^ id.hashCode;
}

/// generated route for
/// [_i7.AssetPage]
class AssetRoute extends _i37.PageRouteInfo<void> {
  const AssetRoute({List<_i37.PageRouteInfo>? children})
    : super(AssetRoute.name, initialChildren: children);

  static const String name = 'AssetRoute';

  static _i37.PageInfo page = _i37.PageInfo(
    name,
    builder: (data) {
      return const _i7.AssetPage();
    },
  );
}

/// generated route for
/// [_i8.BalanceAdjustmentPage]
class BalanceAdjustmentRoute
    extends _i37.PageRouteInfo<BalanceAdjustmentRouteArgs> {
  BalanceAdjustmentRoute({
    _i38.Key? key,
    required _i39.Account account,
    List<_i37.PageRouteInfo>? children,
  }) : super(
         BalanceAdjustmentRoute.name,
         args: BalanceAdjustmentRouteArgs(key: key, account: account),
         initialChildren: children,
       );

  static const String name = 'BalanceAdjustmentRoute';

  static _i37.PageInfo page = _i37.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<BalanceAdjustmentRouteArgs>();
      return _i8.BalanceAdjustmentPage(key: args.key, account: args.account);
    },
  );
}

class BalanceAdjustmentRouteArgs {
  const BalanceAdjustmentRouteArgs({this.key, required this.account});

  final _i38.Key? key;

  final _i39.Account account;

  @override
  String toString() {
    return 'BalanceAdjustmentRouteArgs{key: $key, account: $account}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! BalanceAdjustmentRouteArgs) return false;
    return key == other.key && account == other.account;
  }

  @override
  int get hashCode => key.hashCode ^ account.hashCode;
}

/// generated route for
/// [_i9.BillDetailPage]
class BillDetailRoute extends _i37.PageRouteInfo<BillDetailRouteArgs> {
  BillDetailRoute({
    _i38.Key? key,
    required int billId,
    List<_i37.PageRouteInfo>? children,
  }) : super(
         BillDetailRoute.name,
         args: BillDetailRouteArgs(key: key, billId: billId),
         initialChildren: children,
       );

  static const String name = 'BillDetailRoute';

  static _i37.PageInfo page = _i37.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<BillDetailRouteArgs>();
      return _i9.BillDetailPage(key: args.key, billId: args.billId);
    },
  );
}

class BillDetailRouteArgs {
  const BillDetailRouteArgs({this.key, required this.billId});

  final _i38.Key? key;

  final int billId;

  @override
  String toString() {
    return 'BillDetailRouteArgs{key: $key, billId: $billId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! BillDetailRouteArgs) return false;
    return key == other.key && billId == other.billId;
  }

  @override
  int get hashCode => key.hashCode ^ billId.hashCode;
}

/// generated route for
/// [_i10.BillPage]
class BillRoute extends _i37.PageRouteInfo<void> {
  const BillRoute({List<_i37.PageRouteInfo>? children})
    : super(BillRoute.name, initialChildren: children);

  static const String name = 'BillRoute';

  static _i37.PageInfo page = _i37.PageInfo(
    name,
    builder: (data) {
      return const _i10.BillPage();
    },
  );
}

/// generated route for
/// [_i11.BillPlanBillsPage]
class BillPlanBillsRoute extends _i37.PageRouteInfo<BillPlanBillsRouteArgs> {
  BillPlanBillsRoute({
    _i38.Key? key,
    required int planId,
    required String planName,
    List<_i37.PageRouteInfo>? children,
  }) : super(
         BillPlanBillsRoute.name,
         args: BillPlanBillsRouteArgs(
           key: key,
           planId: planId,
           planName: planName,
         ),
         initialChildren: children,
       );

  static const String name = 'BillPlanBillsRoute';

  static _i37.PageInfo page = _i37.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<BillPlanBillsRouteArgs>();
      return _i11.BillPlanBillsPage(
        key: args.key,
        planId: args.planId,
        planName: args.planName,
      );
    },
  );
}

class BillPlanBillsRouteArgs {
  const BillPlanBillsRouteArgs({
    this.key,
    required this.planId,
    required this.planName,
  });

  final _i38.Key? key;

  final int planId;

  final String planName;

  @override
  String toString() {
    return 'BillPlanBillsRouteArgs{key: $key, planId: $planId, planName: $planName}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! BillPlanBillsRouteArgs) return false;
    return key == other.key &&
        planId == other.planId &&
        planName == other.planName;
  }

  @override
  int get hashCode => key.hashCode ^ planId.hashCode ^ planName.hashCode;
}

/// generated route for
/// [_i12.BillPlanDetailPage]
class BillPlanDetailRoute extends _i37.PageRouteInfo<BillPlanDetailRouteArgs> {
  BillPlanDetailRoute({
    _i38.Key? key,
    required int planId,
    List<_i37.PageRouteInfo>? children,
  }) : super(
         BillPlanDetailRoute.name,
         args: BillPlanDetailRouteArgs(key: key, planId: planId),
         initialChildren: children,
       );

  static const String name = 'BillPlanDetailRoute';

  static _i37.PageInfo page = _i37.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<BillPlanDetailRouteArgs>();
      return _i12.BillPlanDetailPage(key: args.key, planId: args.planId);
    },
  );
}

class BillPlanDetailRouteArgs {
  const BillPlanDetailRouteArgs({this.key, required this.planId});

  final _i38.Key? key;

  final int planId;

  @override
  String toString() {
    return 'BillPlanDetailRouteArgs{key: $key, planId: $planId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! BillPlanDetailRouteArgs) return false;
    return key == other.key && planId == other.planId;
  }

  @override
  int get hashCode => key.hashCode ^ planId.hashCode;
}

/// generated route for
/// [_i13.BillPlanFormPage]
class BillPlanFormRoute extends _i37.PageRouteInfo<BillPlanFormRouteArgs> {
  BillPlanFormRoute({
    _i38.Key? key,
    _i39.Account? account,
    _i41.BillPlan? plan,
    List<_i37.PageRouteInfo>? children,
  }) : super(
         BillPlanFormRoute.name,
         args: BillPlanFormRouteArgs(key: key, account: account, plan: plan),
         initialChildren: children,
       );

  static const String name = 'BillPlanFormRoute';

  static _i37.PageInfo page = _i37.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<BillPlanFormRouteArgs>(
        orElse: () => const BillPlanFormRouteArgs(),
      );
      return _i13.BillPlanFormPage(
        key: args.key,
        account: args.account,
        plan: args.plan,
      );
    },
  );
}

class BillPlanFormRouteArgs {
  const BillPlanFormRouteArgs({this.key, this.account, this.plan});

  final _i38.Key? key;

  final _i39.Account? account;

  final _i41.BillPlan? plan;

  @override
  String toString() {
    return 'BillPlanFormRouteArgs{key: $key, account: $account, plan: $plan}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! BillPlanFormRouteArgs) return false;
    return key == other.key && account == other.account && plan == other.plan;
  }

  @override
  int get hashCode => key.hashCode ^ account.hashCode ^ plan.hashCode;
}

/// generated route for
/// [_i14.BillPlanListPage]
class BillPlanListRoute extends _i37.PageRouteInfo<void> {
  const BillPlanListRoute({List<_i37.PageRouteInfo>? children})
    : super(BillPlanListRoute.name, initialChildren: children);

  static const String name = 'BillPlanListRoute';

  static _i37.PageInfo page = _i37.PageInfo(
    name,
    builder: (data) {
      return const _i14.BillPlanListPage();
    },
  );
}

/// generated route for
/// [_i15.BudgetDetailPage]
class BudgetDetailRoute extends _i37.PageRouteInfo<BudgetDetailRouteArgs> {
  BudgetDetailRoute({
    _i38.Key? key,
    required int budgetId,
    List<_i37.PageRouteInfo>? children,
  }) : super(
         BudgetDetailRoute.name,
         args: BudgetDetailRouteArgs(key: key, budgetId: budgetId),
         initialChildren: children,
       );

  static const String name = 'BudgetDetailRoute';

  static _i37.PageInfo page = _i37.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<BudgetDetailRouteArgs>();
      return _i15.BudgetDetailPage(key: args.key, budgetId: args.budgetId);
    },
  );
}

class BudgetDetailRouteArgs {
  const BudgetDetailRouteArgs({this.key, required this.budgetId});

  final _i38.Key? key;

  final int budgetId;

  @override
  String toString() {
    return 'BudgetDetailRouteArgs{key: $key, budgetId: $budgetId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! BudgetDetailRouteArgs) return false;
    return key == other.key && budgetId == other.budgetId;
  }

  @override
  int get hashCode => key.hashCode ^ budgetId.hashCode;
}

/// generated route for
/// [_i16.BudgetPage]
class BudgetRoute extends _i37.PageRouteInfo<void> {
  const BudgetRoute({List<_i37.PageRouteInfo>? children})
    : super(BudgetRoute.name, initialChildren: children);

  static const String name = 'BudgetRoute';

  static _i37.PageInfo page = _i37.PageInfo(
    name,
    builder: (data) {
      return const _i16.BudgetPage();
    },
  );
}

/// generated route for
/// [_i17.BudgetPlanFormPage]
class BudgetPlanFormRoute extends _i37.PageRouteInfo<BudgetPlanFormRouteArgs> {
  BudgetPlanFormRoute({
    _i38.Key? key,
    required _i39.Account category,
    _i42.BudgetPlan? plan,
    List<_i37.PageRouteInfo>? children,
  }) : super(
         BudgetPlanFormRoute.name,
         args: BudgetPlanFormRouteArgs(
           key: key,
           category: category,
           plan: plan,
         ),
         initialChildren: children,
       );

  static const String name = 'BudgetPlanFormRoute';

  static _i37.PageInfo page = _i37.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<BudgetPlanFormRouteArgs>();
      return _i17.BudgetPlanFormPage(
        key: args.key,
        category: args.category,
        plan: args.plan,
      );
    },
  );
}

class BudgetPlanFormRouteArgs {
  const BudgetPlanFormRouteArgs({this.key, required this.category, this.plan});

  final _i38.Key? key;

  final _i39.Account category;

  final _i42.BudgetPlan? plan;

  @override
  String toString() {
    return 'BudgetPlanFormRouteArgs{key: $key, category: $category, plan: $plan}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! BudgetPlanFormRouteArgs) return false;
    return key == other.key && category == other.category && plan == other.plan;
  }

  @override
  int get hashCode => key.hashCode ^ category.hashCode ^ plan.hashCode;
}

/// generated route for
/// [_i18.BudgetPlanListPage]
class BudgetPlanListRoute extends _i37.PageRouteInfo<void> {
  const BudgetPlanListRoute({List<_i37.PageRouteInfo>? children})
    : super(BudgetPlanListRoute.name, initialChildren: children);

  static const String name = 'BudgetPlanListRoute';

  static _i37.PageInfo page = _i37.PageInfo(
    name,
    builder: (data) {
      return const _i18.BudgetPlanListPage();
    },
  );
}

/// generated route for
/// [_i19.BudgetPlanPage]
class BudgetPlanRoute extends _i37.PageRouteInfo<BudgetPlanRouteArgs> {
  BudgetPlanRoute({
    _i38.Key? key,
    required _i39.Account category,
    List<_i37.PageRouteInfo>? children,
  }) : super(
         BudgetPlanRoute.name,
         args: BudgetPlanRouteArgs(key: key, category: category),
         initialChildren: children,
       );

  static const String name = 'BudgetPlanRoute';

  static _i37.PageInfo page = _i37.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<BudgetPlanRouteArgs>();
      return _i19.BudgetPlanPage(key: args.key, category: args.category);
    },
  );
}

class BudgetPlanRouteArgs {
  const BudgetPlanRouteArgs({this.key, required this.category});

  final _i38.Key? key;

  final _i39.Account category;

  @override
  String toString() {
    return 'BudgetPlanRouteArgs{key: $key, category: $category}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! BudgetPlanRouteArgs) return false;
    return key == other.key && category == other.category;
  }

  @override
  int get hashCode => key.hashCode ^ category.hashCode;
}

/// generated route for
/// [_i20.CategoryArchivedPage]
class CategoryArchivedRoute
    extends _i37.PageRouteInfo<CategoryArchivedRouteArgs> {
  CategoryArchivedRoute({
    _i38.Key? key,
    required _i43.TransactionType type,
    List<_i37.PageRouteInfo>? children,
  }) : super(
         CategoryArchivedRoute.name,
         args: CategoryArchivedRouteArgs(key: key, type: type),
         initialChildren: children,
       );

  static const String name = 'CategoryArchivedRoute';

  static _i37.PageInfo page = _i37.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CategoryArchivedRouteArgs>();
      return _i20.CategoryArchivedPage(key: args.key, type: args.type);
    },
  );
}

class CategoryArchivedRouteArgs {
  const CategoryArchivedRouteArgs({this.key, required this.type});

  final _i38.Key? key;

  final _i43.TransactionType type;

  @override
  String toString() {
    return 'CategoryArchivedRouteArgs{key: $key, type: $type}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CategoryArchivedRouteArgs) return false;
    return key == other.key && type == other.type;
  }

  @override
  int get hashCode => key.hashCode ^ type.hashCode;
}

/// generated route for
/// [_i21.CategoryFormPage]
class CategoryFormRoute extends _i37.PageRouteInfo<CategoryFormRouteArgs> {
  CategoryFormRoute({
    _i38.Key? key,
    required _i44.CategoryForm form,
    int? id,
    List<_i37.PageRouteInfo>? children,
  }) : super(
         CategoryFormRoute.name,
         args: CategoryFormRouteArgs(key: key, form: form, id: id),
         initialChildren: children,
       );

  static const String name = 'CategoryFormRoute';

  static _i37.PageInfo page = _i37.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CategoryFormRouteArgs>();
      return _i21.CategoryFormPage(key: args.key, form: args.form, id: args.id);
    },
  );
}

class CategoryFormRouteArgs {
  const CategoryFormRouteArgs({this.key, required this.form, this.id});

  final _i38.Key? key;

  final _i44.CategoryForm form;

  final int? id;

  @override
  String toString() {
    return 'CategoryFormRouteArgs{key: $key, form: $form, id: $id}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CategoryFormRouteArgs) return false;
    return key == other.key && form == other.form && id == other.id;
  }

  @override
  int get hashCode => key.hashCode ^ form.hashCode ^ id.hashCode;
}

/// generated route for
/// [_i22.CategoryPage]
class CategoryRoute extends _i37.PageRouteInfo<CategoryRouteArgs> {
  CategoryRoute({
    _i38.Key? key,
    required _i43.TransactionType type,
    List<_i37.PageRouteInfo>? children,
  }) : super(
         CategoryRoute.name,
         args: CategoryRouteArgs(key: key, type: type),
         initialChildren: children,
       );

  static const String name = 'CategoryRoute';

  static _i37.PageInfo page = _i37.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CategoryRouteArgs>();
      return _i22.CategoryPage(key: args.key, type: args.type);
    },
  );
}

class CategoryRouteArgs {
  const CategoryRouteArgs({this.key, required this.type});

  final _i38.Key? key;

  final _i43.TransactionType type;

  @override
  String toString() {
    return 'CategoryRouteArgs{key: $key, type: $type}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CategoryRouteArgs) return false;
    return key == other.key && type == other.type;
  }

  @override
  int get hashCode => key.hashCode ^ type.hashCode;
}

/// generated route for
/// [_i23.DashboardPage]
class DashboardRoute extends _i37.PageRouteInfo<void> {
  const DashboardRoute({List<_i37.PageRouteInfo>? children})
    : super(DashboardRoute.name, initialChildren: children);

  static const String name = 'DashboardRoute';

  static _i37.PageInfo page = _i37.PageInfo(
    name,
    builder: (data) {
      return const _i23.DashboardPage();
    },
  );
}

/// generated route for
/// [_i24.InitialSetupPage]
class InitialSetupRoute extends _i37.PageRouteInfo<void> {
  const InitialSetupRoute({List<_i37.PageRouteInfo>? children})
    : super(InitialSetupRoute.name, initialChildren: children);

  static const String name = 'InitialSetupRoute';

  static _i37.PageInfo page = _i37.PageInfo(
    name,
    builder: (data) {
      return const _i24.InitialSetupPage();
    },
  );
}

/// generated route for
/// [_i25.ReportPage]
class ReportRoute extends _i37.PageRouteInfo<void> {
  const ReportRoute({List<_i37.PageRouteInfo>? children})
    : super(ReportRoute.name, initialChildren: children);

  static const String name = 'ReportRoute';

  static _i37.PageInfo page = _i37.PageInfo(
    name,
    builder: (data) {
      return const _i25.ReportPage();
    },
  );
}

/// generated route for
/// [_i26.SavingAllocationPage]
class SavingAllocationRoute
    extends _i37.PageRouteInfo<SavingAllocationRouteArgs> {
  SavingAllocationRoute({
    _i38.Key? key,
    required int accountId,
    bool isWithdraw = false,
    List<_i37.PageRouteInfo>? children,
  }) : super(
         SavingAllocationRoute.name,
         args: SavingAllocationRouteArgs(
           key: key,
           accountId: accountId,
           isWithdraw: isWithdraw,
         ),
         initialChildren: children,
       );

  static const String name = 'SavingAllocationRoute';

  static _i37.PageInfo page = _i37.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SavingAllocationRouteArgs>();
      return _i26.SavingAllocationPage(
        key: args.key,
        accountId: args.accountId,
        isWithdraw: args.isWithdraw,
      );
    },
  );
}

class SavingAllocationRouteArgs {
  const SavingAllocationRouteArgs({
    this.key,
    required this.accountId,
    this.isWithdraw = false,
  });

  final _i38.Key? key;

  final int accountId;

  final bool isWithdraw;

  @override
  String toString() {
    return 'SavingAllocationRouteArgs{key: $key, accountId: $accountId, isWithdraw: $isWithdraw}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SavingAllocationRouteArgs) return false;
    return key == other.key &&
        accountId == other.accountId &&
        isWithdraw == other.isWithdraw;
  }

  @override
  int get hashCode => key.hashCode ^ accountId.hashCode ^ isWithdraw.hashCode;
}

/// generated route for
/// [_i27.SavingDetailPage]
class SavingDetailRoute extends _i37.PageRouteInfo<SavingDetailRouteArgs> {
  SavingDetailRoute({
    _i38.Key? key,
    required int accountId,
    List<_i37.PageRouteInfo>? children,
  }) : super(
         SavingDetailRoute.name,
         args: SavingDetailRouteArgs(key: key, accountId: accountId),
         initialChildren: children,
       );

  static const String name = 'SavingDetailRoute';

  static _i37.PageInfo page = _i37.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SavingDetailRouteArgs>();
      return _i27.SavingDetailPage(key: args.key, accountId: args.accountId);
    },
  );
}

class SavingDetailRouteArgs {
  const SavingDetailRouteArgs({this.key, required this.accountId});

  final _i38.Key? key;

  final int accountId;

  @override
  String toString() {
    return 'SavingDetailRouteArgs{key: $key, accountId: $accountId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SavingDetailRouteArgs) return false;
    return key == other.key && accountId == other.accountId;
  }

  @override
  int get hashCode => key.hashCode ^ accountId.hashCode;
}

/// generated route for
/// [_i28.SavingFormPage]
class SavingFormRoute extends _i37.PageRouteInfo<SavingFormRouteArgs> {
  SavingFormRoute({
    _i38.Key? key,
    _i45.SavingPlan? plan,
    List<_i37.PageRouteInfo>? children,
  }) : super(
         SavingFormRoute.name,
         args: SavingFormRouteArgs(key: key, plan: plan),
         initialChildren: children,
       );

  static const String name = 'SavingFormRoute';

  static _i37.PageInfo page = _i37.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SavingFormRouteArgs>(
        orElse: () => const SavingFormRouteArgs(),
      );
      return _i28.SavingFormPage(key: args.key, plan: args.plan);
    },
  );
}

class SavingFormRouteArgs {
  const SavingFormRouteArgs({this.key, this.plan});

  final _i38.Key? key;

  final _i45.SavingPlan? plan;

  @override
  String toString() {
    return 'SavingFormRouteArgs{key: $key, plan: $plan}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SavingFormRouteArgs) return false;
    return key == other.key && plan == other.plan;
  }

  @override
  int get hashCode => key.hashCode ^ plan.hashCode;
}

/// generated route for
/// [_i29.SavingPage]
class SavingRoute extends _i37.PageRouteInfo<void> {
  const SavingRoute({List<_i37.PageRouteInfo>? children})
    : super(SavingRoute.name, initialChildren: children);

  static const String name = 'SavingRoute';

  static _i37.PageInfo page = _i37.PageInfo(
    name,
    builder: (data) {
      return const _i29.SavingPage();
    },
  );
}

/// generated route for
/// [_i30.SavingSpendPage]
class SavingSpendRoute extends _i37.PageRouteInfo<SavingSpendRouteArgs> {
  SavingSpendRoute({
    _i38.Key? key,
    required int accountId,
    List<_i37.PageRouteInfo>? children,
  }) : super(
         SavingSpendRoute.name,
         args: SavingSpendRouteArgs(key: key, accountId: accountId),
         initialChildren: children,
       );

  static const String name = 'SavingSpendRoute';

  static _i37.PageInfo page = _i37.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SavingSpendRouteArgs>();
      return _i30.SavingSpendPage(key: args.key, accountId: args.accountId);
    },
  );
}

class SavingSpendRouteArgs {
  const SavingSpendRouteArgs({this.key, required this.accountId});

  final _i38.Key? key;

  final int accountId;

  @override
  String toString() {
    return 'SavingSpendRouteArgs{key: $key, accountId: $accountId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SavingSpendRouteArgs) return false;
    return key == other.key && accountId == other.accountId;
  }

  @override
  int get hashCode => key.hashCode ^ accountId.hashCode;
}

/// generated route for
/// [_i31.SettingsPage]
class SettingsRoute extends _i37.PageRouteInfo<void> {
  const SettingsRoute({List<_i37.PageRouteInfo>? children})
    : super(SettingsRoute.name, initialChildren: children);

  static const String name = 'SettingsRoute';

  static _i37.PageInfo page = _i37.PageInfo(
    name,
    builder: (data) {
      return const _i31.SettingsPage();
    },
  );
}

/// generated route for
/// [_i32.ShellPage]
class ShellRoute extends _i37.PageRouteInfo<void> {
  const ShellRoute({List<_i37.PageRouteInfo>? children})
    : super(ShellRoute.name, initialChildren: children);

  static const String name = 'ShellRoute';

  static _i37.PageInfo page = _i37.PageInfo(
    name,
    builder: (data) {
      return const _i32.ShellPage();
    },
  );
}

/// generated route for
/// [_i33.SplashPage]
class SplashRoute extends _i37.PageRouteInfo<void> {
  const SplashRoute({List<_i37.PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static _i37.PageInfo page = _i37.PageInfo(
    name,
    builder: (data) {
      return const _i33.SplashPage();
    },
  );
}

/// generated route for
/// [_i34.TransactionPage]
class TransactionRoute extends _i37.PageRouteInfo<TransactionRouteArgs> {
  TransactionRoute({
    _i38.Key? key,
    required _i43.TransactionType type,
    bool batch = false,
    _i46.TransactionForm? form,
    int? id,
    List<_i37.PageRouteInfo>? children,
  }) : super(
         TransactionRoute.name,
         args: TransactionRouteArgs(
           key: key,
           type: type,
           batch: batch,
           form: form,
           id: id,
         ),
         initialChildren: children,
       );

  static const String name = 'TransactionRoute';

  static _i37.PageInfo page = _i37.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<TransactionRouteArgs>();
      return _i34.TransactionPage(
        key: args.key,
        type: args.type,
        batch: args.batch,
        form: args.form,
        id: args.id,
      );
    },
  );
}

class TransactionRouteArgs {
  const TransactionRouteArgs({
    this.key,
    required this.type,
    this.batch = false,
    this.form,
    this.id,
  });

  final _i38.Key? key;

  final _i43.TransactionType type;

  final bool batch;

  final _i46.TransactionForm? form;

  final int? id;

  @override
  String toString() {
    return 'TransactionRouteArgs{key: $key, type: $type, batch: $batch, form: $form, id: $id}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! TransactionRouteArgs) return false;
    return key == other.key &&
        type == other.type &&
        batch == other.batch &&
        form == other.form &&
        id == other.id;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      type.hashCode ^
      batch.hashCode ^
      form.hashCode ^
      id.hashCode;
}

/// generated route for
/// [_i35.TransferPage]
class TransferRoute extends _i37.PageRouteInfo<TransferRouteArgs> {
  TransferRoute({
    _i38.Key? key,
    _i47.TransferForm? form,
    int? id,
    List<_i37.PageRouteInfo>? children,
  }) : super(
         TransferRoute.name,
         args: TransferRouteArgs(key: key, form: form, id: id),
         initialChildren: children,
       );

  static const String name = 'TransferRoute';

  static _i37.PageInfo page = _i37.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<TransferRouteArgs>(
        orElse: () => const TransferRouteArgs(),
      );
      return _i35.TransferPage(key: args.key, form: args.form, id: args.id);
    },
  );
}

class TransferRouteArgs {
  const TransferRouteArgs({this.key, this.form, this.id});

  final _i38.Key? key;

  final _i47.TransferForm? form;

  final int? id;

  @override
  String toString() {
    return 'TransferRouteArgs{key: $key, form: $form, id: $id}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! TransferRouteArgs) return false;
    return key == other.key && form == other.form && id == other.id;
  }

  @override
  int get hashCode => key.hashCode ^ form.hashCode ^ id.hashCode;
}

/// generated route for
/// [_i36.WalletSetupPage]
class WalletSetupRoute extends _i37.PageRouteInfo<void> {
  const WalletSetupRoute({List<_i37.PageRouteInfo>? children})
    : super(WalletSetupRoute.name, initialChildren: children);

  static const String name = 'WalletSetupRoute';

  static _i37.PageInfo page = _i37.PageInfo(
    name,
    builder: (data) {
      return const _i36.WalletSetupPage();
    },
  );
}
