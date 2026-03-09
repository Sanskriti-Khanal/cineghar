import 'package:flutter/material.dart';
import 'package:cineghar/app/theme/app_colors.dart';

class CityStep extends StatelessWidget {
  final String? selectedCity;
  final Function(String city) onSelect;

  const CityStep({
    super.key,
    required this.selectedCity,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isTablet = size.shortestSide > 600;
    
    final cities = [
      {'name': 'Kathmandu', 'icon': Icons.location_city},
      {'name': 'Pokhara', 'icon': Icons.landscape},
      {'name': 'Chitwan', 'icon': Icons.forest},
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isTablet ? 32 : 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Text(
          "Choose Your City",
          style: TextStyle(
            fontSize: isTablet ? 32 : 24,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: isTablet ? 12 : 8),
        Text(
          "Select the city where you want to watch the movie",
          style: TextStyle(
            fontSize: isTablet ? 18 : 14,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: isTablet ? 32 : 24),
        ...cities.map((cityData) {
          final isSelected = selectedCity == cityData['name'];
          return Padding(
            padding: EdgeInsets.only(bottom: isTablet ? 16 : 12),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => onSelect(cityData['name'] as String),
                borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(isTablet ? 24 : 20),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary.withOpacity(0.1) : AppColors.surface,
                    borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border,
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: isSelected ? AppColors.softShadow : null,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: isTablet ? 56 : 48,
                        height: isTablet ? 56 : 48,
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(isTablet ? 16 : 14),
                        ),
                        child: Icon(
                          cityData['icon'] as IconData,
                          size: isTablet ? 28 : 24,
                          color: isSelected ? Colors.white : AppColors.primary,
                        ),
                      ),
                      SizedBox(width: isTablet ? 20 : 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cityData['name'] as String,
                              style: TextStyle(
                                fontSize: isTablet ? 20 : 18,
                                fontWeight: FontWeight.w700,
                                color: isSelected ? AppColors.primary : AppColors.textPrimary,
                              ),
                            ),
                            SizedBox(height: isTablet ? 4 : 2),
                            Text(
                              'Explore cinemas in ${cityData['name']}',
                              style: TextStyle(
                                fontSize: isTablet ? 16 : 14,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: isTablet ? 28 : 24,
                        height: isTablet ? 28 : 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected ? AppColors.primary : Colors.transparent,
                          border: Border.all(
                            color: isSelected ? AppColors.primary : AppColors.border,
                            width: 2,
                          ),
                        ),
                        child: isSelected
                            ? Icon(
                                Icons.check,
                                size: isTablet ? 18 : 16,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
        ],
      ),
    );
  }
}