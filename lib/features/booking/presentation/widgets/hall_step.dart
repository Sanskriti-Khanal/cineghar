import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cineghar/app/theme/app_colors.dart';
import 'package:cineghar/features/booking/data/models/hall_api_model.dart';
import 'package:cineghar/features/booking/domain/entities/hall_entity.dart';
import 'package:cineghar/features/booking/presentation/providers/booking_providers.dart';

class HallStep extends ConsumerWidget {
  final String? city;
  final Function(String hallId, String hallName) onSelect;

  const HallStep({
    super.key,
    required this.city,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final bool isTablet = size.shortestSide > 600;
    
    final hallsState = city != null 
        ? ref.watch(hallsProvider(city!))
        : const AsyncValue.data(<HallEntity>[]);
    
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
          "Select Cinema Hall",
          style: TextStyle(
            fontSize: isTablet ? 32 : 24,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: isTablet ? 12 : 8),
        Text(
          city != null ? "Choose a cinema hall in $city" : "Please choose a city first",
          style: TextStyle(
            fontSize: isTablet ? 18 : 14,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: isTablet ? 32 : 24),
        if (city == null)
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(isTablet ? 32 : 24),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.location_city,
                  size: isTablet ? 64 : 48,
                  color: AppColors.textTertiary,
                ),
                SizedBox(height: isTablet ? 16 : 12),
                Text(
                  "No City Selected",
                  style: TextStyle(
                    fontSize: isTablet ? 20 : 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: isTablet ? 8 : 6),
                Text(
                  "Please go back and select a city first",
                  style: TextStyle(
                    fontSize: isTablet ? 16 : 14,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          )
        else
          hallsState.when(
            data: (halls) {
              if (halls.isEmpty) {
                return Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(isTablet ? 32 : 24),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.theater_comedy,
                        size: isTablet ? 64 : 48,
                        color: AppColors.textTertiary,
                      ),
                      SizedBox(height: isTablet ? 16 : 12),
                      Text(
                        "No Halls Available",
                        style: TextStyle(
                          fontSize: isTablet ? 20 : 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: isTablet ? 8 : 6),
                      Text(
                        "No cinema halls available in $city",
                        style: TextStyle(
                          fontSize: isTablet ? 16 : 14,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return Column(
                children: halls.map((hall) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: isTablet ? 16 : 12),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => onSelect(hall.id, hall.name),
                        borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(isTablet ? 24 : 20),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
                            border: Border.all(color: AppColors.border),
                            boxShadow: AppColors.softShadow,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: isTablet ? 56 : 48,
                                height: isTablet ? 56 : 48,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(isTablet ? 16 : 14),
                                ),
                                child: Icon(
                                  Icons.theater_comedy,
                                  size: isTablet ? 28 : 24,
                                  color: AppColors.primary,
                                ),
                              ),
                              SizedBox(width: isTablet ? 20 : 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      hall.name,
                                      style: TextStyle(
                                        fontSize: isTablet ? 20 : 18,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    SizedBox(height: isTablet ? 4 : 2),
                                    Text(
                                      'Premium cinema experience',
                                      style: TextStyle(
                                        fontSize: isTablet ? 16 : 14,
                                        color: AppColors.textSecondary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: isTablet ? 20 : 16,
                                color: AppColors.textTertiary,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
            error: (error, stackTrace) {
              return Container(
                width: double.infinity,
                padding: EdgeInsets.all(isTablet ? 32 : 24),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
                  border: Border.all(color: AppColors.error.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: isTablet ? 64 : 48,
                      color: AppColors.error,
                    ),
                    SizedBox(height: isTablet ? 16 : 12),
                    Text(
                      "Error Loading Halls",
                      style: TextStyle(
                        fontSize: isTablet ? 20 : 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.error,
                      ),
                    ),
                    SizedBox(height: isTablet ? 8 : 6),
                    Text(
                      error.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isTablet ? 16 : 14,
                        color: AppColors.error,
                      ),
                    ),
                  ],
                ),
              );
            },
            loading: () {
              return Container(
                width: double.infinity,
                padding: EdgeInsets.all(isTablet ? 48 : 32),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    CircularProgressIndicator(
                      strokeWidth: isTablet ? 3 : 2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                    SizedBox(height: isTablet ? 20 : 16),
                    Text(
                      "Loading cinema halls...",
                      style: TextStyle(
                        fontSize: isTablet ? 18 : 16,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
