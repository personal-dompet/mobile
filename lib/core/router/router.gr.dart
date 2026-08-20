// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i22;
import 'package:dompet_app/features/accounts/models/account.dart' as _i24;
import 'package:dompet_app/features/activities/pages/activity_detail_page.dart'
    as _i1;
import 'package:dompet_app/features/activities/pages/activity_page.dart' as _i2;
import 'package:dompet_app/features/assets/forms/asset_form.dart' as _i25;
import 'package:dompet_app/features/assets/pages/asset_activity_page.dart'
    as _i3;
import 'package:dompet_app/features/assets/pages/asset_detail_page.dart' as _i4;
import 'package:dompet_app/features/assets/pages/asset_form_page.dart' as _i5;
import 'package:dompet_app/features/assets/pages/asset_page.dart' as _i6;
import 'package:dompet_app/features/budgets/models/budget_plan.dart' as _i26;
import 'package:dompet_app/features/budgets/pages/budget_form_page.dart' as _i8;
import 'package:dompet_app/features/budgets/pages/budget_page.dart' as _i9;
import 'package:dompet_app/features/budgets/pages/budget_plan_page.dart'
    as _i10;
import 'package:dompet_app/features/categories/forms/category_form.dart'
    as _i27;
import 'package:dompet_app/features/categories/pages/category_form_page.dart'
    as _i11;
import 'package:dompet_app/features/categories/pages/category_page.dart'
    as _i12;
import 'package:dompet_app/features/categories/pages/category_selector_page.dart'
    as _i13;
import 'package:dompet_app/features/dashboard/pages/dashboard_page.dart'
    as _i14;
import 'package:dompet_app/features/dashboard/pages/shell_page.dart' as _i17;
import 'package:dompet_app/features/savings/pages/saving_page.dart' as _i16;
import 'package:dompet_app/features/setup/pages/initial_setup_page.dart'
    as _i15;
import 'package:dompet_app/features/setup/pages/wallet_setup_page.dart' as _i21;
import 'package:dompet_app/features/splash/pages/splash_page.dart' as _i18;
import 'package:dompet_app/features/transactions/enums/transaction_type.dart'
    as _i28;
import 'package:dompet_app/features/transactions/forms/transaction_form.dart'
    as _i29;
import 'package:dompet_app/features/transactions/forms/transfer_form.dart'
    as _i30;
import 'package:dompet_app/features/transactions/pages/balance_adjustment_page.dart'
    as _i7;
import 'package:dompet_app/features/transactions/pages/transaction_page.dart'
    as _i19;
import 'package:dompet_app/features/transactions/pages/transfer_page.dart'
    as _i20;
import 'package:flutter/material.dart' as _i23;

/// generated route for
/// [_i1.ActivityDetailPage]
class ActivityDetailRoute extends _i22.PageRouteInfo<ActivityDetailRouteArgs> {
  ActivityDetailRoute({
    _i23.Key? key,
    required int id,
    List<_i22.PageRouteInfo>? children,
  }) : super(
         ActivityDetailRoute.name,
         args: ActivityDetailRouteArgs(key: key, id: id),
         initialChildren: children,
       );

  static const String name = 'ActivityDetailRoute';

  static _i22.PageInfo page = _i22.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ActivityDetailRouteArgs>();
      return _i1.ActivityDetailPage(key: args.key, id: args.id);
    },
  );
}

class ActivityDetailRouteArgs {
  const ActivityDetailRouteArgs({this.key, required this.id});

  final _i23.Key? key;

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
class ActivityRoute extends _i22.PageRouteInfo<void> {
  const ActivityRoute({List<_i22.PageRouteInfo>? children})
    : super(ActivityRoute.name, initialChildren: children);

  static const String name = 'ActivityRoute';

  static _i22.PageInfo page = _i22.PageInfo(
    name,
    builder: (data) {
      return const _i2.ActivityPage();
    },
  );
}

/// generated route for
/// [_i3.AssetActivityPage]
class AssetActivityRoute extends _i22.PageRouteInfo<AssetActivityRouteArgs> {
  AssetActivityRoute({
    _i23.Key? key,
    required _i24.Account account,
    List<_i22.PageRouteInfo>? children,
  }) : super(
         AssetActivityRoute.name,
         args: AssetActivityRouteArgs(key: key, account: account),
         initialChildren: children,
       );

  static const String name = 'AssetActivityRoute';

  static _i22.PageInfo page = _i22.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AssetActivityRouteArgs>();
      return _i3.AssetActivityPage(key: args.key, account: args.account);
    },
  );
}

class AssetActivityRouteArgs {
  const AssetActivityRouteArgs({this.key, required this.account});

  final _i23.Key? key;

  final _i24.Account account;

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
/// [_i4.AssetDetailPage]
class AssetDetailRoute extends _i22.PageRouteInfo<AssetDetailRouteArgs> {
  AssetDetailRoute({
    _i23.Key? key,
    required int id,
    List<_i22.PageRouteInfo>? children,
  }) : super(
         AssetDetailRoute.name,
         args: AssetDetailRouteArgs(key: key, id: id),
         initialChildren: children,
       );

  static const String name = 'AssetDetailRoute';

  static _i22.PageInfo page = _i22.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AssetDetailRouteArgs>();
      return _i4.AssetDetailPage(key: args.key, id: args.id);
    },
  );
}

class AssetDetailRouteArgs {
  const AssetDetailRouteArgs({this.key, required this.id});

  final _i23.Key? key;

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
/// [_i5.AssetFormPage]
class AssetFormRoute extends _i22.PageRouteInfo<AssetFormRouteArgs> {
  AssetFormRoute({
    _i23.Key? key,
    _i25.AssetForm? form,
    int? id,
    List<_i22.PageRouteInfo>? children,
  }) : super(
         AssetFormRoute.name,
         args: AssetFormRouteArgs(key: key, form: form, id: id),
         initialChildren: children,
       );

  static const String name = 'AssetFormRoute';

  static _i22.PageInfo page = _i22.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AssetFormRouteArgs>(
        orElse: () => const AssetFormRouteArgs(),
      );
      return _i5.AssetFormPage(key: args.key, form: args.form, id: args.id);
    },
  );
}

class AssetFormRouteArgs {
  const AssetFormRouteArgs({this.key, this.form, this.id});

  final _i23.Key? key;

  final _i25.AssetForm? form;

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
/// [_i6.AssetPage]
class AssetRoute extends _i22.PageRouteInfo<void> {
  const AssetRoute({List<_i22.PageRouteInfo>? children})
    : super(AssetRoute.name, initialChildren: children);

  static const String name = 'AssetRoute';

  static _i22.PageInfo page = _i22.PageInfo(
    name,
    builder: (data) {
      return const _i6.AssetPage();
    },
  );
}

/// generated route for
/// [_i7.BalanceAdjustmentPage]
class BalanceAdjustmentRoute
    extends _i22.PageRouteInfo<BalanceAdjustmentRouteArgs> {
  BalanceAdjustmentRoute({
    _i23.Key? key,
    required _i24.Account account,
    List<_i22.PageRouteInfo>? children,
  }) : super(
         BalanceAdjustmentRoute.name,
         args: BalanceAdjustmentRouteArgs(key: key, account: account),
         initialChildren: children,
       );

  static const String name = 'BalanceAdjustmentRoute';

  static _i22.PageInfo page = _i22.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<BalanceAdjustmentRouteArgs>();
      return _i7.BalanceAdjustmentPage(key: args.key, account: args.account);
    },
  );
}

class BalanceAdjustmentRouteArgs {
  const BalanceAdjustmentRouteArgs({this.key, required this.account});

  final _i23.Key? key;

  final _i24.Account account;

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
/// [_i8.BudgetFormPage]
class BudgetFormRoute extends _i22.PageRouteInfo<BudgetFormRouteArgs> {
  BudgetFormRoute({
    _i23.Key? key,
    required _i24.Account category,
    _i26.BudgetPlan? plan,
    List<_i22.PageRouteInfo>? children,
  }) : super(
         BudgetFormRoute.name,
         args: BudgetFormRouteArgs(key: key, category: category, plan: plan),
         initialChildren: children,
       );

  static const String name = 'BudgetFormRoute';

  static _i22.PageInfo page = _i22.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<BudgetFormRouteArgs>();
      return _i8.BudgetFormPage(
        key: args.key,
        category: args.category,
        plan: args.plan,
      );
    },
  );
}

class BudgetFormRouteArgs {
  const BudgetFormRouteArgs({this.key, required this.category, this.plan});

  final _i23.Key? key;

  final _i24.Account category;

  final _i26.BudgetPlan? plan;

  @override
  String toString() {
    return 'BudgetFormRouteArgs{key: $key, category: $category, plan: $plan}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! BudgetFormRouteArgs) return false;
    return key == other.key && category == other.category && plan == other.plan;
  }

  @override
  int get hashCode => key.hashCode ^ category.hashCode ^ plan.hashCode;
}

/// generated route for
/// [_i9.BudgetPage]
class BudgetRoute extends _i22.PageRouteInfo<void> {
  const BudgetRoute({List<_i22.PageRouteInfo>? children})
    : super(BudgetRoute.name, initialChildren: children);

  static const String name = 'BudgetRoute';

  static _i22.PageInfo page = _i22.PageInfo(
    name,
    builder: (data) {
      return const _i9.BudgetPage();
    },
  );
}

/// generated route for
/// [_i10.BudgetPlanPage]
class BudgetPlanRoute extends _i22.PageRouteInfo<BudgetPlanRouteArgs> {
  BudgetPlanRoute({
    _i23.Key? key,
    required _i24.Account category,
    required _i26.BudgetPlan plan,
    List<_i22.PageRouteInfo>? children,
  }) : super(
         BudgetPlanRoute.name,
         args: BudgetPlanRouteArgs(key: key, category: category, plan: plan),
         initialChildren: children,
       );

  static const String name = 'BudgetPlanRoute';

  static _i22.PageInfo page = _i22.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<BudgetPlanRouteArgs>();
      return _i10.BudgetPlanPage(
        key: args.key,
        category: args.category,
        plan: args.plan,
      );
    },
  );
}

class BudgetPlanRouteArgs {
  const BudgetPlanRouteArgs({
    this.key,
    required this.category,
    required this.plan,
  });

  final _i23.Key? key;

  final _i24.Account category;

  final _i26.BudgetPlan plan;

  @override
  String toString() {
    return 'BudgetPlanRouteArgs{key: $key, category: $category, plan: $plan}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! BudgetPlanRouteArgs) return false;
    return key == other.key && category == other.category && plan == other.plan;
  }

  @override
  int get hashCode => key.hashCode ^ category.hashCode ^ plan.hashCode;
}

/// generated route for
/// [_i11.CategoryFormPage]
class CategoryFormRoute extends _i22.PageRouteInfo<CategoryFormRouteArgs> {
  CategoryFormRoute({
    _i23.Key? key,
    required _i27.CategoryForm form,
    int? id,
    List<_i22.PageRouteInfo>? children,
  }) : super(
         CategoryFormRoute.name,
         args: CategoryFormRouteArgs(key: key, form: form, id: id),
         initialChildren: children,
       );

  static const String name = 'CategoryFormRoute';

  static _i22.PageInfo page = _i22.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CategoryFormRouteArgs>();
      return _i11.CategoryFormPage(key: args.key, form: args.form, id: args.id);
    },
  );
}

class CategoryFormRouteArgs {
  const CategoryFormRouteArgs({this.key, required this.form, this.id});

  final _i23.Key? key;

  final _i27.CategoryForm form;

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
/// [_i12.CategoryPage]
class CategoryRoute extends _i22.PageRouteInfo<CategoryRouteArgs> {
  CategoryRoute({
    _i23.Key? key,
    required _i28.TransactionType type,
    List<_i22.PageRouteInfo>? children,
  }) : super(
         CategoryRoute.name,
         args: CategoryRouteArgs(key: key, type: type),
         initialChildren: children,
       );

  static const String name = 'CategoryRoute';

  static _i22.PageInfo page = _i22.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CategoryRouteArgs>();
      return _i12.CategoryPage(key: args.key, type: args.type);
    },
  );
}

class CategoryRouteArgs {
  const CategoryRouteArgs({this.key, required this.type});

  final _i23.Key? key;

  final _i28.TransactionType type;

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
/// [_i13.CategorySelectorPage]
class CategorySelectorRoute
    extends _i22.PageRouteInfo<CategorySelectorRouteArgs> {
  CategorySelectorRoute({
    _i23.Key? key,
    required _i28.TransactionType type,
    bool showBudgetStatus = false,
    List<_i22.PageRouteInfo>? children,
  }) : super(
         CategorySelectorRoute.name,
         args: CategorySelectorRouteArgs(
           key: key,
           type: type,
           showBudgetStatus: showBudgetStatus,
         ),
         initialChildren: children,
       );

  static const String name = 'CategorySelectorRoute';

  static _i22.PageInfo page = _i22.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CategorySelectorRouteArgs>();
      return _i13.CategorySelectorPage(
        key: args.key,
        type: args.type,
        showBudgetStatus: args.showBudgetStatus,
      );
    },
  );
}

class CategorySelectorRouteArgs {
  const CategorySelectorRouteArgs({
    this.key,
    required this.type,
    this.showBudgetStatus = false,
  });

  final _i23.Key? key;

  final _i28.TransactionType type;

  final bool showBudgetStatus;

  @override
  String toString() {
    return 'CategorySelectorRouteArgs{key: $key, type: $type, showBudgetStatus: $showBudgetStatus}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CategorySelectorRouteArgs) return false;
    return key == other.key &&
        type == other.type &&
        showBudgetStatus == other.showBudgetStatus;
  }

  @override
  int get hashCode => key.hashCode ^ type.hashCode ^ showBudgetStatus.hashCode;
}

/// generated route for
/// [_i14.DashboardPage]
class DashboardRoute extends _i22.PageRouteInfo<void> {
  const DashboardRoute({List<_i22.PageRouteInfo>? children})
    : super(DashboardRoute.name, initialChildren: children);

  static const String name = 'DashboardRoute';

  static _i22.PageInfo page = _i22.PageInfo(
    name,
    builder: (data) {
      return const _i14.DashboardPage();
    },
  );
}

/// generated route for
/// [_i15.InitialSetupPage]
class InitialSetupRoute extends _i22.PageRouteInfo<void> {
  const InitialSetupRoute({List<_i22.PageRouteInfo>? children})
    : super(InitialSetupRoute.name, initialChildren: children);

  static const String name = 'InitialSetupRoute';

  static _i22.PageInfo page = _i22.PageInfo(
    name,
    builder: (data) {
      return const _i15.InitialSetupPage();
    },
  );
}

/// generated route for
/// [_i16.SavingPage]
class SavingRoute extends _i22.PageRouteInfo<void> {
  const SavingRoute({List<_i22.PageRouteInfo>? children})
    : super(SavingRoute.name, initialChildren: children);

  static const String name = 'SavingRoute';

  static _i22.PageInfo page = _i22.PageInfo(
    name,
    builder: (data) {
      return const _i16.SavingPage();
    },
  );
}

/// generated route for
/// [_i17.ShellPage]
class ShellRoute extends _i22.PageRouteInfo<void> {
  const ShellRoute({List<_i22.PageRouteInfo>? children})
    : super(ShellRoute.name, initialChildren: children);

  static const String name = 'ShellRoute';

  static _i22.PageInfo page = _i22.PageInfo(
    name,
    builder: (data) {
      return const _i17.ShellPage();
    },
  );
}

/// generated route for
/// [_i18.SplashPage]
class SplashRoute extends _i22.PageRouteInfo<void> {
  const SplashRoute({List<_i22.PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static _i22.PageInfo page = _i22.PageInfo(
    name,
    builder: (data) {
      return const _i18.SplashPage();
    },
  );
}

/// generated route for
/// [_i19.TransactionPage]
class TransactionRoute extends _i22.PageRouteInfo<TransactionRouteArgs> {
  TransactionRoute({
    _i23.Key? key,
    required _i28.TransactionType type,
    bool batch = false,
    _i29.TransactionForm? form,
    int? id,
    List<_i22.PageRouteInfo>? children,
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

  static _i22.PageInfo page = _i22.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<TransactionRouteArgs>();
      return _i19.TransactionPage(
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

  final _i23.Key? key;

  final _i28.TransactionType type;

  final bool batch;

  final _i29.TransactionForm? form;

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
/// [_i20.TransferPage]
class TransferRoute extends _i22.PageRouteInfo<TransferRouteArgs> {
  TransferRoute({
    _i23.Key? key,
    _i30.TransferForm? form,
    int? id,
    List<_i22.PageRouteInfo>? children,
  }) : super(
         TransferRoute.name,
         args: TransferRouteArgs(key: key, form: form, id: id),
         initialChildren: children,
       );

  static const String name = 'TransferRoute';

  static _i22.PageInfo page = _i22.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<TransferRouteArgs>(
        orElse: () => const TransferRouteArgs(),
      );
      return _i20.TransferPage(key: args.key, form: args.form, id: args.id);
    },
  );
}

class TransferRouteArgs {
  const TransferRouteArgs({this.key, this.form, this.id});

  final _i23.Key? key;

  final _i30.TransferForm? form;

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
/// [_i21.WalletSetupPage]
class WalletSetupRoute extends _i22.PageRouteInfo<void> {
  const WalletSetupRoute({List<_i22.PageRouteInfo>? children})
    : super(WalletSetupRoute.name, initialChildren: children);

  static const String name = 'WalletSetupRoute';

  static _i22.PageInfo page = _i22.PageInfo(
    name,
    builder: (data) {
      return const _i21.WalletSetupPage();
    },
  );
}
