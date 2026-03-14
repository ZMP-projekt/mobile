import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/classes_provider.dart';
import '../data/models/gym_class.dart';

class CalendarPage extends ConsumerWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final classesAsync = ref.watch(allClassesProvider);

    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topRight,
          radius: 1.8,
          colors: [
            AppColors.primary.withValues(alpha: 0.12),
            AppColors.secondary.withValues(alpha: 0.08),
            AppColors.background,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Kalendarz Zajęć',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 400.ms)
                      .slideX(begin: -0.2, end: 0),
                  const SizedBox(height: 8),
                  Text(
                    'Wszystkie dostępne zajęcia',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 16,
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 100.ms, duration: 400.ms)
                      .slideX(begin: -0.2, end: 0),
                ],
              ),
            ),

            // Content
            Expanded(
              child: classesAsync.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
                error: (err, stack) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, color: AppColors.error, size: 48),
                      const SizedBox(height: 16),
                      Text(
                        'Błąd pobierania zajęć',
                        style: TextStyle(color: AppColors.error, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        err.toString(),
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                data: (classes) {
                  if (classes.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.event_busy,
                            size: 80,
                            color: AppColors.textSecondary.withValues(alpha: 0.3),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Brak zajęć w tym tygodniu',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  // Grupuj zajęcia po dniach
                  final groupedClasses = _groupClassesByDay(classes);

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: groupedClasses.length,
                    itemBuilder: (context, index) {
                      final entry = groupedClasses.entries.elementAt(index);
                      final date = entry.key;
                      final dayClasses = entry.value;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Data header
                          _buildDateHeader(date)
                              .animate()
                              .fadeIn(delay: (100 * index).ms)
                              .slideX(begin: -0.1, end: 0),

                          const SizedBox(height: 12),

                          // Lista zajęć w tym dniu
                          ...dayClasses.asMap().entries.map((classEntry) {
                            final classIndex = classEntry.key;
                            final gymClass = classEntry.value;

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _buildClassCard(context, ref, gymClass)
                                  .animate()
                                  .fadeIn(delay: (100 * index + 50 * classIndex).ms)
                                  .slideX(begin: 0.1, end: 0),
                            );
                          }).toList(),

                          const SizedBox(height: 20),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<DateTime, List<GymClass>> _groupClassesByDay(List<GymClass> classes) {
    final Map<DateTime, List<GymClass>> grouped = {};

    for (final gymClass in classes) {
      final date = DateTime(
        gymClass.startTime.year,
        gymClass.startTime.month,
        gymClass.startTime.day,
      );

      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(gymClass);
    }

    // Sortuj po dacie
    final sortedKeys = grouped.keys.toList()..sort();
    return Map.fromEntries(
      sortedKeys.map((key) => MapEntry(key, grouped[key]!)),
    );
  }

  Widget _buildDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    String label;
    if (date == today) {
      label = 'Dzisiaj';
    } else if (date == tomorrow) {
      label = 'Jutro';
    } else {
      final days = ['Pon', 'Wt', 'Śr', 'Czw', 'Pt', 'Sob', 'Niedz'];
      final months = ['Sty', 'Lut', 'Mar', 'Kwi', 'Maj', 'Cze', 'Lip', 'Sie', 'Wrz', 'Paź', 'Lis', 'Gru'];
      label = '${days[date.weekday - 1]}, ${date.day} ${months[date.month - 1]}';
    }

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildClassCard(BuildContext context, WidgetRef ref, GymClass gymClass) {
    final isProcessing = ref.watch(bookingNotifierProvider);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppColors.mediumGlow,
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: gymClass.isBookedByUser
                ? AppColors.success.withValues(alpha: 0.5)
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Icon
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getIconForClass(gymClass.name),
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),

                // Name & Time
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        gymClass.name,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 14, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          Text(
                            '${gymClass.startTimeFormatted} • ${gymClass.durationMinutes} min',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Badge
                if (gymClass.isBookedByUser)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Zapisany',
                      style: TextStyle(
                        color: AppColors.success,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 12),

            // Trainer & Spots
            Row(
              children: [
                Icon(Icons.person_outline, size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(
                  gymClass.trainerName,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const Spacer(),
                Icon(
                  gymClass.isFull ? Icons.people : Icons.people_outline,
                  size: 14,
                  color: gymClass.isFull ? AppColors.error : AppColors.success,
                ),
                const SizedBox(width: 4),
                Text(
                  '${gymClass.spotsLeft} ${_getSpotsLabel(gymClass.spotsLeft)}',
                  style: TextStyle(
                    color: gymClass.isFull ? AppColors.error : AppColors.success,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            if (gymClass.description != null) ...[
              const SizedBox(height: 8),
              Text(
                gymClass.description!,
                style: TextStyle(
                  color: AppColors.textSecondary.withValues(alpha: 0.8),
                  fontSize: 12,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],

            const SizedBox(height: 12),

            // Action Button
            SizedBox(
              width: double.infinity,
              child: gymClass.isBookedByUser
                  ? ElevatedButton(
                onPressed: isProcessing
                    ? null
                    : () {
                  ref.read(bookingNotifierProvider.notifier).cancelBooking(gymClass.id);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error.withValues(alpha: 0.8),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isProcessing
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : const Text(
                  'Wypisz się',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              )
                  : Container(
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: (isProcessing || gymClass.isFull || gymClass.isPast)
                      ? null
                      : () {
                    ref.read(bookingNotifierProvider.notifier).bookClass(gymClass.id);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    disabledBackgroundColor: AppColors.surface.withValues(alpha: 0.5),
                  ),
                  child: isProcessing
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : Text(
                    gymClass.isPast
                        ? 'Zakończone'
                        : gymClass.isFull
                        ? 'Brak miejsc'
                        : 'Zapisz się',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForClass(String name) {
    final nameLower = name.toLowerCase();
    if (nameLower.contains('yoga')) return Icons.self_improvement;
    if (nameLower.contains('crossfit') || nameLower.contains('hiit')) return Icons.bolt;
    if (nameLower.contains('pilates')) return Icons.accessibility_new;
    if (nameLower.contains('spinning')) return Icons.directions_bike;
    if (nameLower.contains('zumba')) return Icons.music_note;
    if (nameLower.contains('pump')) return Icons.fitness_center;
    if (nameLower.contains('stretch')) return Icons.airline_seat_recline_extra;
    if (nameLower.contains('boxing')) return Icons.sports_martial_arts;
    if (nameLower.contains('trx')) return Icons.sports_gymnastics;
    return Icons.sports;
  }

  String _getSpotsLabel(int spots) {
    if (spots == 1) return 'miejsce';
    if (spots >= 2 && spots <= 4) return 'miejsca';
    return 'miejsc';
  }
}