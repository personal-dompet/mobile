import 'package:dompet/theme_data.dart';
import 'package:flutter/material.dart';

class BillingDateOption extends StatelessWidget {
  final int? selectedDate;
  final ValueChanged<int> onDateSelected;
  const BillingDateOption(
      {super.key, required this.selectedDate, required this.onDateSelected});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1.0,
      ),
      itemCount: 28,
      itemBuilder: (context, index) {
        final isSelected = selectedDate != null && selectedDate == (index + 1);
        return GestureDetector(
          onTap: () {
            onDateSelected(index + 1);
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? AppTheme.primaryColor.withValues(alpha: 0.2)
                  : null,
              borderRadius: BorderRadius.circular(12),
              border: isSelected
                  ? Border.all(
                      color: AppTheme.primaryColor,
                    )
                  : null,
            ),
            child: Center(
                child: Text(
              '${index + 1}',
              style: TextStyle(
                color: isSelected ? AppTheme.primaryColor : null,
                fontWeight: isSelected ? FontWeight.w500 : null,
              ),
            )),
          ),
        );
      },
    );
  }
}
