import 'package:auto_route/auto_route.dart';
import 'package:dompet/features/home/presentation/widgets/header.dart';
import 'package:dompet/router.gr.dart';
import 'package:flutter/material.dart';

@RoutePage()
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: const [
        HomeRoute(),
        PocketRoute(),
        AccountRoute(),
        AnalyticRoute(),
      ],
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);

        String title = '';

        if (tabsRouter.activeIndex == 0) title = 'Dompet';
        if (tabsRouter.activeIndex == 1) title = 'Pocket';
        if (tabsRouter.activeIndex == 2) title = 'Account';
        if (tabsRouter.activeIndex == 3) title = 'Analytic';

        return Scaffold(
          appBar: HeaderAppBar(title: title),
          body: SafeArea(child: child),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: tabsRouter.activeIndex,
            iconSize: 32,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded),
                label: 'Dompet',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.wallet_rounded),
                label: 'Pocket',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.credit_card_rounded),
                label: 'Account',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.stacked_line_chart_rounded),
                label: 'Analytic',
              ),
            ],
            onTap: (index) {
              tabsRouter.setActiveIndex(index);
            },
          ),
        );
      },
    );
  }
}
