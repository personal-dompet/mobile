import 'package:flutter/material.dart';

class RecentListContainer extends StatelessWidget {
  final int length;
  final Widget Function(BuildContext, int) itemBuilder;
  final String title;
  final VoidCallback? onSeeAllPressed;

  const RecentListContainer({
    super.key,
    required this.length,
    required this.itemBuilder,
    required this.title,
    this.onSeeAllPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: onSeeAllPressed,
                  child: Text(
                    'See all',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: length,
            separatorBuilder: (context, index) => Divider(
              color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
              height: 1,
              indent: 72,
              endIndent: 16,
            ),
            itemBuilder: itemBuilder,
          )
        ],
      ),
    );
  }
}
