import 'package:flutter/material.dart';

/// A widget that displays a horizontal stepper indicator with steps and active step highlighting
class StepperIndicator extends StatelessWidget {
  final List<String> steps;
  final int activeIndex;

  const StepperIndicator({
    super.key,
    required this.steps,
    required this.activeIndex,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeColor = theme.colorScheme.primary; // #6366F1 (Indigo)
    final completedColor = theme.colorScheme.tertiary; // #10B981 (Green)
    final inactiveColor =
        theme.colorScheme.outlineVariant; // #4B5563 (Dark gray)
    final connectorColor = inactiveColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: List.generate(steps.length, (index) {
          final isCurrentStep = index == activeIndex;
          final isCompletedStep = index < activeIndex;

          return Expanded(
            child: Row(
              children: [
                // Step indicator circle
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCurrentStep
                        ? activeColor
                        : isCompletedStep
                            ? completedColor
                            : Colors.transparent,
                    border: Border.all(
                      color: isCurrentStep
                          ? activeColor
                          : (isCompletedStep ? completedColor : inactiveColor),
                      width: isCurrentStep ? 2 : 1,
                    ),
                  ),
                  child: Center(
                    child: isCompletedStep
                        ? Icon(
                            Icons.check,
                            size: 16,
                            color: theme.colorScheme.surface,
                          )
                        : Text(
                            '${index + 1}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isCurrentStep
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isCurrentStep
                                  ? theme.colorScheme.surface
                                  : (isCompletedStep
                                      ? theme.colorScheme.surface
                                      : inactiveColor),
                            ),
                          ),
                  ),
                ),
                // Step label
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 8),
                    child: Text(
                      steps[index],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight:
                            isCurrentStep ? FontWeight.bold : FontWeight.normal,
                        color: isCurrentStep
                            ? activeColor
                            : isCompletedStep
                                ? theme.colorScheme.tertiary
                                : theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
                // Connector line to next step (if not the last step)
                if (index < steps.length - 1)
                  Expanded(
                    child: Container(
                      height: 1,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      color:
                          index < activeIndex ? completedColor : connectorColor,
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
