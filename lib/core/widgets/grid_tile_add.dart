import 'package:flutter/material.dart';

class GridTileAdd extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  const GridTileAdd({super.key, required this.onTap, required this.label});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: .center,
          crossAxisAlignment: .center,
          spacing: 4,
          children: [
            Icon(Icons.add_circle_rounded),
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
