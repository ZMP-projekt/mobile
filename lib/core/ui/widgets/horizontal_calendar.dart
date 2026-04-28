import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';

class HorizontalCalendar extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const HorizontalCalendar({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final l10n = AppLocalizations.of(context)!;
    final startDate = DateTime(now.year, now.month, now.day);
    final days = List.generate(15, (i) => startDate.add(Duration(days: i)));

    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        itemBuilder: (context, index) {
          final date = days[index];
          final isSelected = date.year == selectedDate.year &&
              date.month == selectedDate.month &&
              date.day == selectedDate.day;
          final isToday = date.year == now.year &&
              date.month == now.month &&
              date.day == now.day;

          return GestureDetector(
            onTap: () => onDateSelected(date),
            child: Container(
              width: 65,
              margin: EdgeInsets.only(
                left: index == 0 ? 0 : 8,
                right: index == days.length - 1 ? 20 : 8,
                top: 8,
                bottom: 8,
              ),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.white10,
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('E', l10n.localeName)
                        .format(date)
                        .toUpperCase(),
                    style: TextStyle(
                      color: isSelected ? AppColors.background : AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    date.day.toString(),
                    style: TextStyle(
                      color: isSelected ? AppColors.background : AppColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (isToday) ...[
                    const SizedBox(height: 4),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.background : AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ]
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
