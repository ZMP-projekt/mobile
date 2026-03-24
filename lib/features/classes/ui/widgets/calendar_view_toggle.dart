import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class CalendarViewToggle extends StatelessWidget {
  final bool isMyClassesSelected;
  final ValueChanged<bool> onToggle;

  const CalendarViewToggle({
    super.key,
    required this.isMyClassesSelected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            alignment: isMyClassesSelected ? Alignment.centerRight : Alignment.centerLeft,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            child: FractionallySizedBox(
              widthFactor: 0.5,
              heightFactor: 1.0,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.5), width: 1),
                ),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => onToggle(false),
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: Text(
                      'Wszystkie zajęcia',
                      style: TextStyle(
                        color: !isMyClassesSelected ? AppColors.primary : AppColors.textSecondary,
                        fontWeight: !isMyClassesSelected ? FontWeight.bold : FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => onToggle(true),
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: Text(
                      'Moje rezerwacje',
                      style: TextStyle(
                        color: isMyClassesSelected ? AppColors.primary : AppColors.textSecondary,
                        fontWeight: isMyClassesSelected ? FontWeight.bold : FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}