import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class DompetBottomBar extends StatelessWidget {
  const DompetBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    final tabsRouter = AutoTabsRouter.of(context);
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      padding: const EdgeInsets.all(0),
      clipBehavior: .antiAlias,
      child: SizedBox(
        height: 60,
        child: Row(
          children: [
            _Item(
              onTap: () => tabsRouter.setActiveIndex(0),
              label: 'Beranda',
              icon: Icons.home_rounded,
              isActive: tabsRouter.activeIndex == 0,
            ),
            _Item(
              onTap: () => tabsRouter.setActiveIndex(1),
              label: 'Aktivitas',
              icon: Icons.receipt_long_rounded,
              isActive: tabsRouter.activeIndex == 1,
            ),
            const SizedBox(width: 40),
            _Item(
              onTap: () => tabsRouter.setActiveIndex(2),
              label: 'Anggaran',
              icon: Icons.wallet_rounded,
              isActive: tabsRouter.activeIndex == 2,
            ),
            _Item(
              onTap: () => tabsRouter.setActiveIndex(3),
              label: 'Target',
              icon: Icons.savings_rounded,
              isActive: tabsRouter.activeIndex == 3,
            ),
          ],
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  final VoidCallback? onTap;
  final String label;
  final IconData icon;
  final bool isActive;
  const _Item({
    required this.label,
    required this.icon,
    this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Icon(
              icon,
              color: isActive
                  ? themeData.colorScheme.primary
                  : themeData.colorScheme.onSurface,
            ),
            Text(
              label,
              style: TextStyle(
                color: isActive
                    ? themeData.colorScheme.primary
                    : themeData.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
