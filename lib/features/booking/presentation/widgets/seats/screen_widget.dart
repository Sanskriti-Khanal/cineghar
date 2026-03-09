import 'package:flutter/material.dart';
import 'package:cineghar/app/theme/app_colors.dart';

class ScreenWidget extends StatelessWidget {
  const ScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Simple glow effect
        Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.primary.withOpacity(0.2),
                Colors.transparent,
              ],
            ),
          ),
        ),
        
        // Curved screen
        Container(
          width: double.infinity,
          height: 45,
          decoration: BoxDecoration(
            color: Colors.grey.shade400,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(100),
              bottomRight: Radius.circular(100),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              "SCREEN",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                letterSpacing: 4,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ),
        
        // Bottom glow
        Container(
          width: double.infinity,
          height: 25,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.primary.withOpacity(0.1),
                Colors.transparent,
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 20),
      ],
    );
  }
}