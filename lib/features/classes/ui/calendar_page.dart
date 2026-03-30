import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/classes_provider.dart';
import '../data/models/gym_class.dart';
import 'widgets/class_card.dart';
import 'widgets/calendar_view_toggle.dart';

final selectedDateProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
});

class CalendarPage extends ConsumerStatefulWidget {
  const CalendarPage({super.key});

  @override
  ConsumerState<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends ConsumerState<CalendarPage> {
  bool _showOnlyMyClasses = false;

  @override
  Widget build(BuildContext context) {
    final selectedDate = ref.watch(selectedDateProvider);
    final classesAsync = ref.watch(classesForDateProvider(selectedDate));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Grafik',
                      style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 34,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -1.0
                      )
                  ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),

                  const SizedBox(height: 20),

                  _buildHorizontalCalendar(ref, selectedDate),

                  const SizedBox(height: 20),

                  CalendarViewToggle(
                    isMyClassesSelected: _showOnlyMyClasses,
                    onToggle: (value) => setState(() => _showOnlyMyClasses = value),
                  ).animate().fadeIn(delay: 100.ms),
                ],
              ),
            ),
            Expanded(
              child: classesAsync.when(
                loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
                error: (err, stack) => Center(child: Text('Błąd: $err', style: const TextStyle(color: AppColors.error))),
                data: (dayClasses) {
                  final displayedClasses = dayClasses.where((c) {
                    return _showOnlyMyClasses ? c.userEnrolled : true;
                  }).toList();

                  Widget content = displayedClasses.isEmpty
                      ? _buildEmptyState(key: ValueKey('empty_${selectedDate}_$_showOnlyMyClasses'))
                      : _buildClassesList(displayedClasses, selectedDate, key: ValueKey('list_${selectedDate}_$_showOnlyMyClasses'));

                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    switchInCurve: Curves.easeOutQuart,
                    switchOutCurve: Curves.easeInQuart,
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(begin: const Offset(0.05, 0.0), end: Offset.zero).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: content,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHorizontalCalendar(WidgetRef ref, DateTime selectedDate) {
    final today = DateTime.now();
    final normalizedToday = DateTime(today.year, today.month, today.day);
    final days = List.generate(14, (index) => normalizedToday.add(Duration(days: index)));

    return SizedBox(
      height: 85,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: days.length,
        itemBuilder: (context, index) {
          final date = days[index];
          final isSelected = date.isAtSameMomentAs(selectedDate);
          final dayName = DateFormat('E', 'pl_PL').format(date).toLowerCase();

          return GestureDetector(
            onTap: () => ref.read(selectedDateProvider.notifier).state = date,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 65,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: isSelected ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  )
                ] : [],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dayName,
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${date.day}',
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(delay: (index * 30).ms).slideX(begin: 0.1);
        },
      ),
    );
  }

  Widget _buildClassesList(List<GymClass> classes, DateTime selectedDate, {required Key key}) {
    return ListView.builder(
      key: key,
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 130),
      itemCount: classes.length,
      itemBuilder: (context, index) {
        final gymClass = classes[index];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (index == 0)
              Padding(
                padding: const EdgeInsets.only(bottom: 16, top: 5),
                child: Row(
                  children: [
                    Container(width: 4, height: 16, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(2))),
                    const SizedBox(width: 8),
                    Text(
                        _getDateLabel(selectedDate).toUpperCase(),
                        style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.2)
                    ),
                  ],
                ),
              ).animate().fadeIn(),

            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: ClassCard(gymClass: gymClass)
                  .animate()
                  .fadeIn(delay: (index * 50).ms, duration: 300.ms)
                  .slideX(begin: 0.05, curve: Curves.easeOutQuad),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState({required Key key}) {
    return Center(
      key: key,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(35),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surface,
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: const Icon(Icons.event_busy_rounded, size: 70, color: AppColors.textSecondary),
          ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),
          const SizedBox(height: 25),
          const Text(
            'Brak zajęć w tym dniu',
            style: TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  String _getDateLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    if (date.isAtSameMomentAs(today)) return 'Dzisiaj';
    return DateFormat('EEEE, d MMMM', 'pl_PL').format(date);
  }
}