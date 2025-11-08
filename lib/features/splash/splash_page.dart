import 'package:dompet/features/account/presentation/provider/account_list_provider.dart';
import 'package:dompet/features/auth/presentation/providers/user_provider.dart';
import 'package:dompet/features/pocket/presentation/provider/pocket_list_provider.dart';
import 'package:dompet/features/wallet/presentation/providers/wallet_provider.dart';
import 'package:dompet/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        _checkAuth();
      },
    );
  }

  Future _initialize() async {
    try {
      await Future.wait([
        ref.watch(walletProvider.future),
        ref.watch(accountListProvider.future),
        ref.watch(pocketListProvider.future),
      ]);

      if (!mounted || !context.mounted) return;

      DashboardRoute().replace(context);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future _checkAuth() async {
    final user = await ref.watch(userProvider.future);

    if (!context.mounted || !mounted) return;

    if (user == null) {
      AuthRoute().replace(context);
      return;
    }

    _initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Loading...')),
    );
  }
}
