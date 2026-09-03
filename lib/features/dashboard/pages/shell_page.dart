import 'package:auto_route/auto_route.dart';
import 'package:dompet_app/core/router/router.gr.dart';
import 'package:dompet_app/core/widgets/dompet_dialog.dart';
import 'package:dompet_app/core/widgets/widget.dart';
import 'package:dompet_app/features/budgets/widgets/budget_fab.dart';
import 'package:dompet_app/features/dashboard/widgets/greeting_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

@RoutePage()
class ShellPage extends StatelessWidget {
  const ShellPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      ),
      child: AutoTabsRouter(
      routes: [DashboardRoute(), ActivityRoute(), BudgetRoute(), SavingRoute()],
      builder: (context, child) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop) return;

            final navigator = Navigator.of(context);

            if (navigator.canPop()) {
              navigator.pop(result);
              return;
            }

            final shouldExit = await showDialog<bool>(
              context: context,
              builder: (context) {
                return DompetDialog(
                  title: 'Tutup aplikasi?',
                  onCancel: () {
                    Navigator.pop(context, false);
                  },
                  onConfirm: () {
                    Navigator.pop(context, true);
                  },
                  confirmationText: 'Ya, Tutup',
                );
              },
            );

            if (shouldExit == true) {
              await SystemNavigator.pop();
            }
          },
          child: Scaffold(
            appBar: AppBar(title: _AppBarTitle()),
            body: child,
            floatingActionButton: Builder(
              builder: (context) {
                final isBudgetTab =
                    context.tabsRouter.current.name == BudgetRoute.name;
                return isBudgetTab ? const BudgetFab() : const DompetFab();
              },
            ),
            floatingActionButtonLocation: .centerDocked,
            bottomNavigationBar: DompetBottomBar(),
            drawer: _NavigationDrawer(),
          ),
        );
      },
      ),
    );
  }
}

class _NavigationDrawer extends StatefulWidget {
  const _NavigationDrawer();

  @override
  State<_NavigationDrawer> createState() => __NavigationDrawerState();
}

class __NavigationDrawerState extends State<_NavigationDrawer> {
  late List<_Menu> _menus;
  final int? _selectedIndex = null;

  @override
  void initState() {
    super.initState();
    _menus = [
      _Menu(
        label: 'Dompet',
        iconData: Icons.wallet_rounded,
        onTap: () {
          context.router.push(AssetRoute());
        },
      ),
      _Menu(
        label: 'Kategori Pemasukan',
        iconData: Icons.trending_up_rounded,
        onTap: () {
          context.router.push(CategoryRoute(type: .income));
        },
      ),
      _Menu(
        label: 'Kategori Pengeluaran',
        iconData: Icons.trending_down_rounded,
        onTap: () {
          context.router.push(CategoryRoute(type: .expense));
        },
      ),
      _Menu(
        label: 'Pengaturan',
        iconData: Icons.settings_rounded,
        onTap: () {
          context.router.push(const SettingsRoute());
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
      onDestinationSelected: (index) {
        Navigator.pop(context);
        final menu = _menus[index];
        menu.onTap.call();
      },
      indicatorColor: Colors.transparent,
      selectedIndex: _selectedIndex,
      children: [
        SizedBox(height: 24),
        ..._menus.map((menu) {
          return NavigationDrawerDestination(
            icon: Icon(menu.iconData),
            label: Text(menu.label),
          );
        }),
        SizedBox(height: 24),
      ],
    );
  }
}

class _AppBarTitle extends StatelessWidget {
  const _AppBarTitle();

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    if (context.tabsRouter.current.name == DashboardRoute.name) {
      return GreetingText();
    }

    final String title = switch (context.tabsRouter.current.name) {
      ActivityRoute.name => 'Aktivitas',
      BudgetRoute.name => 'Anggaran',
      SavingRoute.name => 'Tabungan',
      _ => '',
    };

    return Text(
      title,
      style: themeData.textTheme.titleLarge?.copyWith(fontWeight: .w600),
    );
  }
}

class _Menu {
  final String label;
  final IconData iconData;
  final VoidCallback onTap;

  const _Menu({
    required this.label,
    required this.iconData,
    required this.onTap,
  });
}
