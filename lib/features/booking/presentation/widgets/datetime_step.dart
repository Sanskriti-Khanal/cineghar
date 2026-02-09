import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cineghar/app/theme/app_colors.dart';
import 'package:cineghar/features/booking/presentation/providers/booking_providers.dart';
import 'package:cineghar/features/booking/domain/entities/showtime_entity.dart';

class DateTimeStep extends ConsumerWidget {
  final String? selectedDate;
  final ShowtimeEntity? selectedTime;
  final String? hallId;
  final Function(String) onSelectDate;
  final Function(ShowtimeEntity) onSelectTime;

  const DateTimeStep({
    super.key,
    required this.selectedDate,
    required this.selectedTime,
    required this.hallId,
    required this.onSelectDate,
    required this.onSelectTime,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final bool isTablet = size.shortestSide > 600;
    
    final dates = [
      ("today", "Today", Icons.today),
      ("tomorrow", "Tomorrow", Icons.calendar_today),
    ];

    final showtimesState = (hallId != null && selectedDate != null)
        ? ref.watch(showtimesProvider((movieId: ref.read(bookingViewModelProvider).movieId ?? '', hallId: hallId!, dateKey: selectedDate!)))
        : const AsyncValue.data(<ShowtimeEntity>[]);

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
          "Choose Date",
          style: TextStyle(
            fontSize: isTablet ? 32 : 24,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: isTablet ? 12 : 8),
        Text(
          "Select the date you want to watch the movie",
          style: TextStyle(
            fontSize: isTablet ? 18 : 14,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: isTablet ? 32 : 24),
        
        Row(
          children: dates.map((date) {
            final isSelected = selectedDate == date.$1;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: date.$1 == "today" ? (isTablet ? 16 : 12) : 0,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => onSelectDate(date.$1),
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
                      child: Column(
                        children: [
                          Icon(
                            date.$3,
                            size: isTablet ? 32 : 28,
                            color: isSelected ? AppColors.primary : AppColors.textSecondary,
                          ),
                          SizedBox(height: isTablet ? 12 : 8),
                          Text(
                            date.$2,
                            style: TextStyle(
                              fontSize: isTablet ? 20 : 18,
                              fontWeight: FontWeight.w700,
                              color: isSelected ? AppColors.primary : AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        SizedBox(height: isTablet ? 40 : 32),

        Text(
          "Choose Showtime",
          style: TextStyle(
            fontSize: isTablet ? 32 : 24,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: isTablet ? 12 : 8),
        Text(
          "Select your preferred show time",
          style: TextStyle(
            fontSize: isTablet ? 18 : 14,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: isTablet ? 32 : 24),

        if (hallId == null || selectedDate == null)
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
                  Icons.schedule,
                  size: isTablet ? 64 : 48,
                  color: AppColors.textTertiary,
                ),
                SizedBox(height: isTablet ? 16 : 12),
                Text(
                  hallId == null ? "No Hall Selected" : "No Date Selected",
                  style: TextStyle(
                    fontSize: isTablet ? 20 : 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: isTablet ? 8 : 6),
                Text(
                  hallId == null 
                      ? "Please select a cinema hall first" 
                      : "Please select a date first",
                  style: TextStyle(
                    fontSize: isTablet ? 16 : 14,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          )
        else
          showtimesState.when(
            data: (times) {
              if (times.isEmpty) {
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
                        Icons.event_busy,
                        size: isTablet ? 64 : 48,
                        color: AppColors.textTertiary,
                      ),
                      SizedBox(height: isTablet ? 16 : 12),
                      Text(
                        "No Showtimes Available",
                        style: TextStyle(
                          fontSize: isTablet ? 20 : 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: isTablet ? 8 : 6),
                      Text(
                        "No showtimes available for this date",
                        style: TextStyle(
                          fontSize: isTablet ? 16 : 14,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return Wrap(
                spacing: isTablet ? 16 : 12,
                runSpacing: isTablet ? 16 : 12,
                children: times.map((time) {
                  final isSelected = selectedTime == time;
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => onSelectTime(time),
                      borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isTablet ? 24 : 20,
                          vertical: isTablet ? 16 : 12,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : Colors.transparent,
                          borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
                          border: Border.all(
                            color: isSelected ? AppColors.primary : AppColors.border,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Text(
                          time.time,
                          style: TextStyle(
                            fontSize: isTablet ? 18 : 16,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.white : AppColors.textPrimary,
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
                      "Error Loading Showtimes",
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
                      "Loading showtimes...",
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
          ),
        ],
      ),
    );
  }
}
