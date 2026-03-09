import 'package:flutter/material.dart';

class StepHeader extends StatelessWidget {
  final int step;

  const StepHeader({
    super.key,
    required this.step,
  });

  @override
  Widget build(BuildContext context) {
    final steps = [
      "City",
      "Hall",
      "Date",
      "Seats",
      "Summary"
    ];

    return Row(
      children: List.generate(steps.length, (index) {
        final isActive = index == step;
        final isCompleted = index < step;

        return Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  // Circle
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive || isCompleted
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey.shade300,
                    ),
                    child: Center(
                      child: Text(
                        "${index + 1}",
                        style: TextStyle(
                          color: isActive || isCompleted
                              ? Colors.white
                              : Colors.grey.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // Progress Line
                  if (index != steps.length - 1)
                    Expanded(
                      child: Container(
                        height: 3,
                        color: index < step
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey.shade300,
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 6),

              Text(
                steps[index],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight:
                      isActive ? FontWeight.w600 : FontWeight.normal,
                  color: isActive
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey.shade600,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}