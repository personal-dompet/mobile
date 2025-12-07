// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i21;
import 'package:dompet/core/enum/create_from.dart' as _i25;
import 'package:dompet/core/enum/transaction_static_subject.dart' as _i24;
import 'package:dompet/core/enum/transfer_static_subject.dart' as _i23;
import 'package:dompet/features/account/presentation/pages/account_page.dart'
    as _i1;
import 'package:dompet/features/account/presentation/pages/create_account_detail_page.dart'
    as _i4;
import 'package:dompet/features/account/presentation/pages/create_account_page.dart'
    as _i5;
import 'package:dompet/features/account/presentation/pages/select_account_page.dart'
    as _i16;
import 'package:dompet/features/analytic/presentation/analytic_page.dart'
    as _i2;
import 'package:dompet/features/auth/presentation/pages/auth_page.dart' as _i3;
import 'package:dompet/features/dashbaord/dashboard_page.dart' as _i13;
import 'package:dompet/features/home/presentation/pages/home_page.dart' as _i14;
import 'package:dompet/features/pocket/presentation/pages/create_pocket_page.dart'
    as _i7;
import 'package:dompet/features/pocket/presentation/pages/create_recurring_pocket_page.dart'
    as _i9;
import 'package:dompet/features/pocket/presentation/pages/create_saving_pocket_page.dart'
    as _i10;
import 'package:dompet/features/pocket/presentation/pages/create_spending_pocket_page.dart'
    as _i11;
import 'package:dompet/features/pocket/presentation/pages/pocket_page.dart'
    as _i15;
import 'package:dompet/features/pocket/presentation/pages/select_pocket_page.dart'
    as _i18;
import 'package:dompet/features/splash/splash_page.dart' as _i19;
import 'package:dompet/features/transaction/presentation/pages/create_transaction_page.dart'
    as _i12;
import 'package:dompet/features/transaction/presentation/pages/select_category_page.dart'
    as _i17;
import 'package:dompet/features/transaction/presentation/pages/transaction_page.dart'
    as _i20;
import 'package:dompet/features/transfer/presentation/pages/create_account_transfer_page.dart'
    as _i6;
import 'package:dompet/features/transfer/presentation/pages/create_pocket_transfer_page.dart'
    as _i8;
import 'package:flutter/material.dart' as _i22;

/// generated route for
/// [_i1.AccountPage]
class AccountRoute extends _i21.PageRouteInfo<void> {
  const AccountRoute({List<_i21.PageRouteInfo>? children})
      : super(AccountRoute.name, initialChildren: children);

  static const String name = 'AccountRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i1.AccountPage();
    },
  );
}

/// generated route for
/// [_i2.AnalyticPage]
class AnalyticRoute extends _i21.PageRouteInfo<void> {
  const AnalyticRoute({List<_i21.PageRouteInfo>? children})
      : super(AnalyticRoute.name, initialChildren: children);

  static const String name = 'AnalyticRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i2.AnalyticPage();
    },
  );
}

/// generated route for
/// [_i3.AuthPage]
class AuthRoute extends _i21.PageRouteInfo<void> {
  const AuthRoute({List<_i21.PageRouteInfo>? children})
      : super(AuthRoute.name, initialChildren: children);

  static const String name = 'AuthRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i3.AuthPage();
    },
  );
}

/// generated route for
/// [_i4.CreateAccountDetailPage]
class CreateAccountDetailRoute extends _i21.PageRouteInfo<void> {
  const CreateAccountDetailRoute({List<_i21.PageRouteInfo>? children})
      : super(CreateAccountDetailRoute.name, initialChildren: children);

  static const String name = 'CreateAccountDetailRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i4.CreateAccountDetailPage();
    },
  );
}

/// generated route for
/// [_i5.CreateAccountPage]
class CreateAccountRoute extends _i21.PageRouteInfo<void> {
  const CreateAccountRoute({List<_i21.PageRouteInfo>? children})
      : super(CreateAccountRoute.name, initialChildren: children);

  static const String name = 'CreateAccountRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i5.CreateAccountPage();
    },
  );
}

/// generated route for
/// [_i6.CreateAccountTransferPage]
class CreateAccountTransferRoute
    extends _i21.PageRouteInfo<CreateAccountTransferRouteArgs> {
  CreateAccountTransferRoute({
    _i22.Key? key,
    _i23.TransferStaticSubject? subject,
    List<_i21.PageRouteInfo>? children,
  }) : super(
          CreateAccountTransferRoute.name,
          args: CreateAccountTransferRouteArgs(key: key, subject: subject),
          initialChildren: children,
        );

  static const String name = 'CreateAccountTransferRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CreateAccountTransferRouteArgs>(
        orElse: () => const CreateAccountTransferRouteArgs(),
      );
      return _i6.CreateAccountTransferPage(
        key: args.key,
        subject: args.subject,
      );
    },
  );
}

class CreateAccountTransferRouteArgs {
  const CreateAccountTransferRouteArgs({this.key, this.subject});

  final _i22.Key? key;

  final _i23.TransferStaticSubject? subject;

  @override
  String toString() {
    return 'CreateAccountTransferRouteArgs{key: $key, subject: $subject}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CreateAccountTransferRouteArgs) return false;
    return key == other.key && subject == other.subject;
  }

  @override
  int get hashCode => key.hashCode ^ subject.hashCode;
}

/// generated route for
/// [_i7.CreatePocketPage]
class CreatePocketRoute extends _i21.PageRouteInfo<void> {
  const CreatePocketRoute({List<_i21.PageRouteInfo>? children})
      : super(CreatePocketRoute.name, initialChildren: children);

  static const String name = 'CreatePocketRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i7.CreatePocketPage();
    },
  );
}

/// generated route for
/// [_i8.CreatePocketTransferPage]
class CreatePocketTransferRoute
    extends _i21.PageRouteInfo<CreatePocketTransferRouteArgs> {
  CreatePocketTransferRoute({
    _i22.Key? key,
    _i23.TransferStaticSubject? subject,
    List<_i21.PageRouteInfo>? children,
  }) : super(
          CreatePocketTransferRoute.name,
          args: CreatePocketTransferRouteArgs(key: key, subject: subject),
          initialChildren: children,
        );

  static const String name = 'CreatePocketTransferRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CreatePocketTransferRouteArgs>(
        orElse: () => const CreatePocketTransferRouteArgs(),
      );
      return _i8.CreatePocketTransferPage(key: args.key, subject: args.subject);
    },
  );
}

class CreatePocketTransferRouteArgs {
  const CreatePocketTransferRouteArgs({this.key, this.subject});

  final _i22.Key? key;

  final _i23.TransferStaticSubject? subject;

  @override
  String toString() {
    return 'CreatePocketTransferRouteArgs{key: $key, subject: $subject}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CreatePocketTransferRouteArgs) return false;
    return key == other.key && subject == other.subject;
  }

  @override
  int get hashCode => key.hashCode ^ subject.hashCode;
}

/// generated route for
/// [_i9.CreateRecurringPocketPage]
class CreateRecurringPocketRoute extends _i21.PageRouteInfo<void> {
  const CreateRecurringPocketRoute({List<_i21.PageRouteInfo>? children})
      : super(CreateRecurringPocketRoute.name, initialChildren: children);

  static const String name = 'CreateRecurringPocketRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i9.CreateRecurringPocketPage();
    },
  );
}

/// generated route for
/// [_i10.CreateSavingPocketPage]
class CreateSavingPocketRoute extends _i21.PageRouteInfo<void> {
  const CreateSavingPocketRoute({List<_i21.PageRouteInfo>? children})
      : super(CreateSavingPocketRoute.name, initialChildren: children);

  static const String name = 'CreateSavingPocketRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i10.CreateSavingPocketPage();
    },
  );
}

/// generated route for
/// [_i11.CreateSpendingPocketPage]
class CreateSpendingPocketRoute extends _i21.PageRouteInfo<void> {
  const CreateSpendingPocketRoute({List<_i21.PageRouteInfo>? children})
      : super(CreateSpendingPocketRoute.name, initialChildren: children);

  static const String name = 'CreateSpendingPocketRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i11.CreateSpendingPocketPage();
    },
  );
}

/// generated route for
/// [_i12.CreateTransactionPage]
class CreateTransactionRoute
    extends _i21.PageRouteInfo<CreateTransactionRouteArgs> {
  CreateTransactionRoute({
    _i22.Key? key,
    _i24.TransactionStaticSubject? subject,
    List<_i21.PageRouteInfo>? children,
  }) : super(
          CreateTransactionRoute.name,
          args: CreateTransactionRouteArgs(key: key, subject: subject),
          initialChildren: children,
        );

  static const String name = 'CreateTransactionRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CreateTransactionRouteArgs>(
        orElse: () => const CreateTransactionRouteArgs(),
      );
      return _i12.CreateTransactionPage(key: args.key, subject: args.subject);
    },
  );
}

class CreateTransactionRouteArgs {
  const CreateTransactionRouteArgs({this.key, this.subject});

  final _i22.Key? key;

  final _i24.TransactionStaticSubject? subject;

  @override
  String toString() {
    return 'CreateTransactionRouteArgs{key: $key, subject: $subject}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CreateTransactionRouteArgs) return false;
    return key == other.key && subject == other.subject;
  }

  @override
  int get hashCode => key.hashCode ^ subject.hashCode;
}

/// generated route for
/// [_i13.DashboardPage]
class DashboardRoute extends _i21.PageRouteInfo<void> {
  const DashboardRoute({List<_i21.PageRouteInfo>? children})
      : super(DashboardRoute.name, initialChildren: children);

  static const String name = 'DashboardRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i13.DashboardPage();
    },
  );
}

/// generated route for
/// [_i14.HomePage]
class HomeRoute extends _i21.PageRouteInfo<void> {
  const HomeRoute({List<_i21.PageRouteInfo>? children})
      : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i14.HomePage();
    },
  );
}

/// generated route for
/// [_i15.PocketPage]
class PocketRoute extends _i21.PageRouteInfo<void> {
  const PocketRoute({List<_i21.PageRouteInfo>? children})
      : super(PocketRoute.name, initialChildren: children);

  static const String name = 'PocketRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i15.PocketPage();
    },
  );
}

/// generated route for
/// [_i16.SelectAccountPage]
class SelectAccountRoute extends _i21.PageRouteInfo<SelectAccountRouteArgs> {
  SelectAccountRoute({
    _i22.Key? key,
    int? selectedAccountId,
    _i25.CreateFrom? createFrom,
    bool? disableEmpty,
    _i16.SelectAccountTitle title = _i16.SelectAccountTitle.general,
    List<_i21.PageRouteInfo>? children,
  }) : super(
          SelectAccountRoute.name,
          args: SelectAccountRouteArgs(
            key: key,
            selectedAccountId: selectedAccountId,
            createFrom: createFrom,
            disableEmpty: disableEmpty,
            title: title,
          ),
          initialChildren: children,
        );

  static const String name = 'SelectAccountRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SelectAccountRouteArgs>(
        orElse: () => const SelectAccountRouteArgs(),
      );
      return _i16.SelectAccountPage(
        key: args.key,
        selectedAccountId: args.selectedAccountId,
        createFrom: args.createFrom,
        disableEmpty: args.disableEmpty,
        title: args.title,
      );
    },
  );
}

class SelectAccountRouteArgs {
  const SelectAccountRouteArgs({
    this.key,
    this.selectedAccountId,
    this.createFrom,
    this.disableEmpty,
    this.title = _i16.SelectAccountTitle.general,
  });

  final _i22.Key? key;

  final int? selectedAccountId;

  final _i25.CreateFrom? createFrom;

  final bool? disableEmpty;

  final _i16.SelectAccountTitle title;

  @override
  String toString() {
    return 'SelectAccountRouteArgs{key: $key, selectedAccountId: $selectedAccountId, createFrom: $createFrom, disableEmpty: $disableEmpty, title: $title}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SelectAccountRouteArgs) return false;
    return key == other.key &&
        selectedAccountId == other.selectedAccountId &&
        createFrom == other.createFrom &&
        disableEmpty == other.disableEmpty &&
        title == other.title;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      selectedAccountId.hashCode ^
      createFrom.hashCode ^
      disableEmpty.hashCode ^
      title.hashCode;
}

/// generated route for
/// [_i17.SelectCategoryPage]
class SelectCategoryRoute extends _i21.PageRouteInfo<SelectCategoryRouteArgs> {
  SelectCategoryRoute({
    _i22.Key? key,
    String? selectedCategoryIconKey,
    List<_i21.PageRouteInfo>? children,
  }) : super(
          SelectCategoryRoute.name,
          args: SelectCategoryRouteArgs(
            key: key,
            selectedCategoryIconKey: selectedCategoryIconKey,
          ),
          initialChildren: children,
        );

  static const String name = 'SelectCategoryRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SelectCategoryRouteArgs>(
        orElse: () => const SelectCategoryRouteArgs(),
      );
      return _i17.SelectCategoryPage(
        key: args.key,
        selectedCategoryIconKey: args.selectedCategoryIconKey,
      );
    },
  );
}

class SelectCategoryRouteArgs {
  const SelectCategoryRouteArgs({this.key, this.selectedCategoryIconKey});

  final _i22.Key? key;

  final String? selectedCategoryIconKey;

  @override
  String toString() {
    return 'SelectCategoryRouteArgs{key: $key, selectedCategoryIconKey: $selectedCategoryIconKey}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SelectCategoryRouteArgs) return false;
    return key == other.key &&
        selectedCategoryIconKey == other.selectedCategoryIconKey;
  }

  @override
  int get hashCode => key.hashCode ^ selectedCategoryIconKey.hashCode;
}

/// generated route for
/// [_i18.SelectPocketPage]
class SelectPocketRoute extends _i21.PageRouteInfo<SelectPocketRouteArgs> {
  SelectPocketRoute({
    _i22.Key? key,
    int? selectedPocketId,
    _i18.SelectPocketTitle title = _i18.SelectPocketTitle.general,
    _i25.CreateFrom? createFrom,
    bool? disableEmpty,
    bool? hideWallet = false,
    List<_i21.PageRouteInfo>? children,
  }) : super(
          SelectPocketRoute.name,
          args: SelectPocketRouteArgs(
            key: key,
            selectedPocketId: selectedPocketId,
            title: title,
            createFrom: createFrom,
            disableEmpty: disableEmpty,
            hideWallet: hideWallet,
          ),
          initialChildren: children,
        );

  static const String name = 'SelectPocketRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SelectPocketRouteArgs>(
        orElse: () => const SelectPocketRouteArgs(),
      );
      return _i18.SelectPocketPage(
        key: args.key,
        selectedPocketId: args.selectedPocketId,
        title: args.title,
        createFrom: args.createFrom,
        disableEmpty: args.disableEmpty,
        hideWallet: args.hideWallet,
      );
    },
  );
}

class SelectPocketRouteArgs {
  const SelectPocketRouteArgs({
    this.key,
    this.selectedPocketId,
    this.title = _i18.SelectPocketTitle.general,
    this.createFrom,
    this.disableEmpty,
    this.hideWallet = false,
  });

  final _i22.Key? key;

  final int? selectedPocketId;

  final _i18.SelectPocketTitle title;

  final _i25.CreateFrom? createFrom;

  final bool? disableEmpty;

  final bool? hideWallet;

  @override
  String toString() {
    return 'SelectPocketRouteArgs{key: $key, selectedPocketId: $selectedPocketId, title: $title, createFrom: $createFrom, disableEmpty: $disableEmpty, hideWallet: $hideWallet}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SelectPocketRouteArgs) return false;
    return key == other.key &&
        selectedPocketId == other.selectedPocketId &&
        title == other.title &&
        createFrom == other.createFrom &&
        disableEmpty == other.disableEmpty &&
        hideWallet == other.hideWallet;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      selectedPocketId.hashCode ^
      title.hashCode ^
      createFrom.hashCode ^
      disableEmpty.hashCode ^
      hideWallet.hashCode;
}

/// generated route for
/// [_i19.SplashPage]
class SplashRoute extends _i21.PageRouteInfo<void> {
  const SplashRoute({List<_i21.PageRouteInfo>? children})
      : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i19.SplashPage();
    },
  );
}

/// generated route for
/// [_i20.TransactionPage]
class TransactionRoute extends _i21.PageRouteInfo<void> {
  const TransactionRoute({List<_i21.PageRouteInfo>? children})
      : super(TransactionRoute.name, initialChildren: children);

  static const String name = 'TransactionRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i20.TransactionPage();
    },
  );
}
