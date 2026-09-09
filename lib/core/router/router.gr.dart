// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i31;
import 'package:dompet_app/features/accounts/models/account.dart' as _i33;
import 'package:dompet_app/features/activities/pages/activity_detail_page.dart'
    as _i1;
import 'package:dompet_app/features/activities/pages/activity_page.dart' as _i2;
import 'package:dompet_app/features/assets/forms/asset_form.dart' as _i34;
import 'package:dompet_app/features/assets/pages/asset_activity_page.dart'
    as _i3;
import 'package:dompet_app/features/assets/pages/asset_archived_page.dart'
    as _i4;
import 'package:dompet_app/features/assets/pages/asset_detail_page.dart' as _i5;
import 'package:dompet_app/features/assets/pages/asset_form_page.dart' as _i6;
import 'package:dompet_app/features/assets/pages/asset_page.dart' as _i7;
import 'package:dompet_app/features/budgets/models/budget_plan.dart' as _i35;
import 'package:dompet_app/features/budgets/pages/budget_detail_page.dart'
    as _i9;
import 'package:dompet_app/features/budgets/pages/budget_page.dart' as _i10;
import 'package:dompet_app/features/budgets/pages/budget_plan_form_page.dart'
    as _i11;
import 'package:dompet_app/features/budgets/pages/budget_plan_list_page.dart'
    as _i12;
import 'package:dompet_app/features/budgets/pages/budget_plan_page.dart'
    as _i13;
import 'package:dompet_app/features/categories/forms/category_form.dart'
    as _i37;
import 'package:dompet_app/features/categories/pages/category_archived_page.dart'
    as _i14;
import 'package:dompet_app/features/categories/pages/category_form_page.dart'
    as _i15;
import 'package:dompet_app/features/categories/pages/category_page.dart'
    as _i16;
import 'package:dompet_app/features/dashboard/pages/dashboard_page.dart'
    as _i17;
import 'package:dompet_app/features/dashboard/pages/shell_page.dart' as _i26;
import 'package:dompet_app/features/reports/pages/report_page.dart' as _i19;
import 'package:dompet_app/features/savings/models/saving_plan.dart' as _i38;
import 'package:dompet_app/features/savings/pages/saving_allocation_page.dart'
    as _i20;
import 'package:dompet_app/features/savings/pages/saving_detail_page.dart'
    as _i21;
import 'package:dompet_app/features/savings/pages/saving_form_page.dart'
    as _i22;
import 'package:dompet_app/features/savings/pages/saving_page.dart' as _i23;
import 'package:dompet_app/features/savings/pages/saving_spend_page.dart'
    as _i24;
import 'package:dompet_app/features/settings/pages/settings_page.dart' as _i25;
import 'package:dompet_app/features/setup/pages/initial_setup_page.dart'
    as _i18;
import 'package:dompet_app/features/setup/pages/wallet_setup_page.dart' as _i30;
import 'package:dompet_app/features/splash/pages/splash_page.dart' as _i27;
import 'package:dompet_app/features/transactions/enums/transaction_type.dart'
    as _i36;
import 'package:dompet_app/features/transactions/forms/transaction_form.dart'
    as _i39;
import 'package:dompet_app/features/transactions/forms/transfer_form.dart'
    as _i40;
import 'package:dompet_app/features/transactions/pages/balance_adjustment_page.dart'
    as _i8;
import 'package:dompet_app/features/transactions/pages/transaction_page.dart'
    as _i28;
import 'package:dompet_app/features/transactions/pages/transfer_page.dart'
    as _i29;
import 'package:flutter/material.dart' as _i32;

/// generated route for
/// [_i1.ActivityDetailPage]
class ActivityDetailRoute extends _i31.PageRouteInfo<ActivityDetailRouteArgs> {
  ActivityDetailRoute({
    _i32.Key? key,
    required int id,
    List<_i31.PageRouteInfo>? children,
  }) : super(
         ActivityDetailRoute.name,
         args: ActivityDetailRouteArgs(key: key, id: id),
         initialChildren: children,
       );

  static const String name = 'ActivityDetailRoute';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ActivityDetailRouteArgs>();
      return _i1.ActivityDetailPage(key: args.key, id: args.id);
    },
  );
}

class ActivityDetailRouteArgs {
  const ActivityDetailRouteArgs({this.key, required this.id});

  final _i32.Key? key;

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
class ActivityRoute extends _i31.PageRouteInfo<void> {
  const ActivityRoute({List<_i31.PageRouteInfo>? children})
    : super(ActivityRoute.name, initialChildren: children);

  static const String name = 'ActivityRoute';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      return const _i2.ActivityPage();
    },
  );
}

/// generated route for
/// [_i3.AssetActivityPage]
class AssetActivityRoute extends _i31.PageRouteInfo<AssetActivityRouteArgs> {
  AssetActivityRoute({
    _i32.Key? key,
    required _i33.Account account,
    List<_i31.PageRouteInfo>? children,
  }) : super(
         AssetActivityRoute.name,
         args: AssetActivityRouteArgs(key: key, account: account),
         initialChildren: children,
       );

  static const String name = 'AssetActivityRoute';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AssetActivityRouteArgs>();
      return _i3.AssetActivityPage(key: args.key, account: args.account);
    },
  );
}

class AssetActivityRouteArgs {
  const AssetActivityRouteArgs({this.key, required this.account});

  final _i32.Key? key;

  final _i33.Account account;

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
class AssetArchivedRoute extends _i31.PageRouteInfo<void> {
  const AssetArchivedRoute({List<_i31.PageRouteInfo>? children})
    : super(AssetArchivedRoute.name, initialChildren: children);

  static const String name = 'AssetArchivedRoute';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      return const _i4.AssetArchivedPage();
    },
  );
}

/// generated route for
/// [_i5.AssetDetailPage]
class AssetDetailRoute extends _i31.PageRouteInfo<AssetDetailRouteArgs> {
  AssetDetailRoute({
    _i32.Key? key,
    required int id,
    List<_i31.PageRouteInfo>? children,
  }) : super(
         AssetDetailRoute.name,
         args: AssetDetailRouteArgs(key: key, id: id),
         initialChildren: children,
       );

  static const String name = 'AssetDetailRoute';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AssetDetailRouteArgs>();
      return _i5.AssetDetailPage(key: args.key, id: args.id);
    },
  );
}

class AssetDetailRouteArgs {
  const AssetDetailRouteArgs({this.key, required this.id});

  final _i32.Key? key;

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
class AssetFormRoute extends _i31.PageRouteInfo<AssetFormRouteArgs> {
  AssetFormRoute({
    _i32.Key? key,
    _i34.AssetForm? form,
    int? id,
    List<_i31.PageRouteInfo>? children,
  }) : super(
         AssetFormRoute.name,
         args: AssetFormRouteArgs(key: key, form: form, id: id),
         initialChildren: children,
       );

  static const String name = 'AssetFormRoute';

  static _i31.PageInfo page = _i31.PageInfo(
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

  final _i32.Key? key;

  final _i34.AssetForm? form;

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
class AssetRoute extends _i31.PageRouteInfo<void> {
  const AssetRoute({List<_i31.PageRouteInfo>? children})
    : super(AssetRoute.name, initialChildren: children);

  static const String name = 'AssetRoute';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      return const _i7.AssetPage();
    },
  );
}

/// generated route for
/// [_i8.BalanceAdjustmentPage]
class BalanceAdjustmentRoute
    extends _i31.PageRouteInfo<BalanceAdjustmentRouteArgs> {
  BalanceAdjustmentRoute({
    _i32.Key? key,
    required _i33.Account account,
    List<_i31.PageRouteInfo>? children,
  }) : super(
         BalanceAdjustmentRoute.name,
         args: BalanceAdjustmentRouteArgs(key: key, account: account),
         initialChildren: children,
       );

  static const String name = 'BalanceAdjustmentRoute';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<BalanceAdjustmentRouteArgs>();
      return _i8.BalanceAdjustmentPage(key: args.key, account: args.account);
    },
  );
}

class BalanceAdjustmentRouteArgs {
  const BalanceAdjustmentRouteArgs({this.key, required this.account});

  final _i32.Key? key;

  final _i33.Account account;

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
/// [_i9.BudgetDetailPage]
class BudgetDetailRoute extends _i31.PageRouteInfo<BudgetDetailRouteArgs> {
  BudgetDetailRoute({
    _i32.Key? key,
    required int budgetId,
    List<_i31.PageRouteInfo>? children,
  }) : super(
         BudgetDetailRoute.name,
         args: BudgetDetailRouteArgs(key: key, budgetId: budgetId),
         initialChildren: children,
       );

  static const String name = 'BudgetDetailRoute';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<BudgetDetailRouteArgs>();
      return _i9.BudgetDetailPage(key: args.key, budgetId: args.budgetId);
    },
  );
}

class BudgetDetailRouteArgs {
  const BudgetDetailRouteArgs({this.key, required this.budgetId});

  final _i32.Key? key;

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
/// [_i10.BudgetPage]
class BudgetRoute extends _i31.PageRouteInfo<void> {
  const BudgetRoute({List<_i31.PageRouteInfo>? children})
    : super(BudgetRoute.name, initialChildren: children);

  static const String name = 'BudgetRoute';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      return const _i10.BudgetPage();
    },
  );
}

/// generated route for
/// [_i11.BudgetPlanFormPage]
class BudgetPlanFormRoute extends _i31.PageRouteInfo<BudgetPlanFormRouteArgs> {
  BudgetPlanFormRoute({
    _i32.Key? key,
    required _i33.Account category,
    _i35.BudgetPlan? plan,
    List<_i31.PageRouteInfo>? children,
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

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<BudgetPlanFormRouteArgs>();
      return _i11.BudgetPlanFormPage(
        key: args.key,
        category: args.category,
        plan: args.plan,
      );
    },
  );
}

class BudgetPlanFormRouteArgs {
  const BudgetPlanFormRouteArgs({this.key, required this.category, this.plan});

  final _i32.Key? key;

  final _i33.Account category;

  final _i35.BudgetPlan? plan;

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
/// [_i12.BudgetPlanListPage]
class BudgetPlanListRoute extends _i31.PageRouteInfo<void> {
  const BudgetPlanListRoute({List<_i31.PageRouteInfo>? children})
    : super(BudgetPlanListRoute.name, initialChildren: children);

  static const String name = 'BudgetPlanListRoute';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      return const _i12.BudgetPlanListPage();
    },
  );
}

/// generated route for
/// [_i13.BudgetPlanPage]
class BudgetPlanRoute extends _i31.PageRouteInfo<BudgetPlanRouteArgs> {
  BudgetPlanRoute({
    _i32.Key? key,
    required _i33.Account category,
    List<_i31.PageRouteInfo>? children,
  }) : super(
         BudgetPlanRoute.name,
         args: BudgetPlanRouteArgs(key: key, category: category),
         initialChildren: children,
       );

  static const String name = 'BudgetPlanRoute';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<BudgetPlanRouteArgs>();
      return _i13.BudgetPlanPage(key: args.key, category: args.category);
    },
  );
}

class BudgetPlanRouteArgs {
  const BudgetPlanRouteArgs({this.key, required this.category});

  final _i32.Key? key;

  final _i33.Account category;

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
/// [_i14.CategoryArchivedPage]
class CategoryArchivedRoute
    extends _i31.PageRouteInfo<CategoryArchivedRouteArgs> {
  CategoryArchivedRoute({
    _i32.Key? key,
    required _i36.TransactionType type,
    List<_i31.PageRouteInfo>? children,
  }) : super(
         CategoryArchivedRoute.name,
         args: CategoryArchivedRouteArgs(key: key, type: type),
         initialChildren: children,
       );

  static const String name = 'CategoryArchivedRoute';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CategoryArchivedRouteArgs>();
      return _i14.CategoryArchivedPage(key: args.key, type: args.type);
    },
  );
}

class CategoryArchivedRouteArgs {
  const CategoryArchivedRouteArgs({this.key, required this.type});

  final _i32.Key? key;

  final _i36.TransactionType type;

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
/// [_i15.CategoryFormPage]
class CategoryFormRoute extends _i31.PageRouteInfo<CategoryFormRouteArgs> {
  CategoryFormRoute({
    _i32.Key? key,
    required _i37.CategoryForm form,
    int? id,
    List<_i31.PageRouteInfo>? children,
  }) : super(
         CategoryFormRoute.name,
         args: CategoryFormRouteArgs(key: key, form: form, id: id),
         initialChildren: children,
       );

  static const String name = 'CategoryFormRoute';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CategoryFormRouteArgs>();
      return _i15.CategoryFormPage(key: args.key, form: args.form, id: args.id);
    },
  );
}

class CategoryFormRouteArgs {
  const CategoryFormRouteArgs({this.key, required this.form, this.id});

  final _i32.Key? key;

  final _i37.CategoryForm form;

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
/// [_i16.CategoryPage]
class CategoryRoute extends _i31.PageRouteInfo<CategoryRouteArgs> {
  CategoryRoute({
    _i32.Key? key,
    required _i36.TransactionType type,
    List<_i31.PageRouteInfo>? children,
  }) : super(
         CategoryRoute.name,
         args: CategoryRouteArgs(key: key, type: type),
         initialChildren: children,
       );

  static const String name = 'CategoryRoute';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CategoryRouteArgs>();
      return _i16.CategoryPage(key: args.key, type: args.type);
    },
  );
}

class CategoryRouteArgs {
  const CategoryRouteArgs({this.key, required this.type});

  final _i32.Key? key;

  final _i36.TransactionType type;

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
/// [_i17.DashboardPage]
class DashboardRoute extends _i31.PageRouteInfo<void> {
  const DashboardRoute({List<_i31.PageRouteInfo>? children})
    : super(DashboardRoute.name, initialChildren: children);

  static const String name = 'DashboardRoute';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      return const _i17.DashboardPage();
    },
  );
}

/// generated route for
/// [_i18.InitialSetupPage]
class InitialSetupRoute extends _i31.PageRouteInfo<void> {
  const InitialSetupRoute({List<_i31.PageRouteInfo>? children})
    : super(InitialSetupRoute.name, initialChildren: children);

  static const String name = 'InitialSetupRoute';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      return const _i18.InitialSetupPage();
    },
  );
}

/// generated route for
/// [_i19.ReportPage]
class ReportRoute extends _i31.PageRouteInfo<void> {
  const ReportRoute({List<_i31.PageRouteInfo>? children})
    : super(ReportRoute.name, initialChildren: children);

  static const String name = 'ReportRoute';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      return const _i19.ReportPage();
    },
  );
}

/// generated route for
/// [_i20.SavingAllocationPage]
class SavingAllocationRoute
    extends _i31.PageRouteInfo<SavingAllocationRouteArgs> {
  SavingAllocationRoute({
    _i32.Key? key,
    required int accountId,
    bool isWithdraw = false,
    List<_i31.PageRouteInfo>? children,
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

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SavingAllocationRouteArgs>();
      return _i20.SavingAllocationPage(
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

  final _i32.Key? key;

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
/// [_i21.SavingDetailPage]
class SavingDetailRoute extends _i31.PageRouteInfo<SavingDetailRouteArgs> {
  SavingDetailRoute({
    _i32.Key? key,
    required int accountId,
    List<_i31.PageRouteInfo>? children,
  }) : super(
         SavingDetailRoute.name,
         args: SavingDetailRouteArgs(key: key, accountId: accountId),
         initialChildren: children,
       );

  static const String name = 'SavingDetailRoute';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SavingDetailRouteArgs>();
      return _i21.SavingDetailPage(key: args.key, accountId: args.accountId);
    },
  );
}

class SavingDetailRouteArgs {
  const SavingDetailRouteArgs({this.key, required this.accountId});

  final _i32.Key? key;

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
/// [_i22.SavingFormPage]
class SavingFormRoute extends _i31.PageRouteInfo<SavingFormRouteArgs> {
  SavingFormRoute({
    _i32.Key? key,
    _i38.SavingPlan? plan,
    List<_i31.PageRouteInfo>? children,
  }) : super(
         SavingFormRoute.name,
         args: SavingFormRouteArgs(key: key, plan: plan),
         initialChildren: children,
       );

  static const String name = 'SavingFormRoute';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SavingFormRouteArgs>(
        orElse: () => const SavingFormRouteArgs(),
      );
      return _i22.SavingFormPage(key: args.key, plan: args.plan);
    },
  );
}

class SavingFormRouteArgs {
  const SavingFormRouteArgs({this.key, this.plan});

  final _i32.Key? key;

  final _i38.SavingPlan? plan;

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
/// [_i23.SavingPage]
class SavingRoute extends _i31.PageRouteInfo<void> {
  const SavingRoute({List<_i31.PageRouteInfo>? children})
    : super(SavingRoute.name, initialChildren: children);

  static const String name = 'SavingRoute';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      return const _i23.SavingPage();
    },
  );
}

/// generated route for
/// [_i24.SavingSpendPage]
class SavingSpendRoute extends _i31.PageRouteInfo<SavingSpendRouteArgs> {
  SavingSpendRoute({
    _i32.Key? key,
    required int accountId,
    List<_i31.PageRouteInfo>? children,
  }) : super(
         SavingSpendRoute.name,
         args: SavingSpendRouteArgs(key: key, accountId: accountId),
         initialChildren: children,
       );

  static const String name = 'SavingSpendRoute';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SavingSpendRouteArgs>();
      return _i24.SavingSpendPage(key: args.key, accountId: args.accountId);
    },
  );
}

class SavingSpendRouteArgs {
  const SavingSpendRouteArgs({this.key, required this.accountId});

  final _i32.Key? key;

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
/// [_i25.SettingsPage]
class SettingsRoute extends _i31.PageRouteInfo<void> {
  const SettingsRoute({List<_i31.PageRouteInfo>? children})
    : super(SettingsRoute.name, initialChildren: children);

  static const String name = 'SettingsRoute';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      return const _i25.SettingsPage();
    },
  );
}

/// generated route for
/// [_i26.ShellPage]
class ShellRoute extends _i31.PageRouteInfo<void> {
  const ShellRoute({List<_i31.PageRouteInfo>? children})
    : super(ShellRoute.name, initialChildren: children);

  static const String name = 'ShellRoute';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      return const _i26.ShellPage();
    },
  );
}

/// generated route for
/// [_i27.SplashPage]
class SplashRoute extends _i31.PageRouteInfo<void> {
  const SplashRoute({List<_i31.PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      return const _i27.SplashPage();
    },
  );
}

/// generated route for
/// [_i28.TransactionPage]
class TransactionRoute extends _i31.PageRouteInfo<TransactionRouteArgs> {
  TransactionRoute({
    _i32.Key? key,
    required _i36.TransactionType type,
    bool batch = false,
    _i39.TransactionForm? form,
    int? id,
    List<_i31.PageRouteInfo>? children,
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

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<TransactionRouteArgs>();
      return _i28.TransactionPage(
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

  final _i32.Key? key;

  final _i36.TransactionType type;

  final bool batch;

  final _i39.TransactionForm? form;

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
/// [_i29.TransferPage]
class TransferRoute extends _i31.PageRouteInfo<TransferRouteArgs> {
  TransferRoute({
    _i32.Key? key,
    _i40.TransferForm? form,
    int? id,
    List<_i31.PageRouteInfo>? children,
  }) : super(
         TransferRoute.name,
         args: TransferRouteArgs(key: key, form: form, id: id),
         initialChildren: children,
       );

  static const String name = 'TransferRoute';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<TransferRouteArgs>(
        orElse: () => const TransferRouteArgs(),
      );
      return _i29.TransferPage(key: args.key, form: args.form, id: args.id);
    },
  );
}

class TransferRouteArgs {
  const TransferRouteArgs({this.key, this.form, this.id});

  final _i32.Key? key;

  final _i40.TransferForm? form;

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
/// [_i30.WalletSetupPage]
class WalletSetupRoute extends _i31.PageRouteInfo<void> {
  const WalletSetupRoute({List<_i31.PageRouteInfo>? children})
    : super(WalletSetupRoute.name, initialChildren: children);

  static const String name = 'WalletSetupRoute';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      return const _i30.WalletSetupPage();
    },
  );
}
