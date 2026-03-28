import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/classes_provider.dart';
import '../data/models/gym_class.dart';
import 'widgets/class_card.dart';
import 'widgets/calendar_view_toggle.dart';

class CalendarPage extends ConsumerStatefulWidget {
  const CalendarPage({super.key});

  @override
  ConsumerState<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends ConsumerState<CalendarPage> {
  bool _showOnlyMyClasses = false;

  @override
  Widget build(BuildContext context) {
    final classesAsync = ref.watch(allClassesProvider);

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
                  const Text('Grafik', style: TextStyle(color: AppColors.textPrimary, fontSize: 34, fontWeight: FontWeight.w800, letterSpacing: -1.0))
                      .animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),
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
                data: (allClasses) {
                  final displayedClasses = _showOnlyMyClasses
                      ? allClasses.where((c) => c.isBookedByUser).toList()
                      : allClasses;

                  Widget content = displayedClasses.isEmpty
                      ? _buildEmptyState(key: ValueKey('empty_$_showOnlyMyClasses'))
                      : _buildClassesList(displayedClasses, key: ValueKey('list_$_showOnlyMyClasses'));

                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    switchInCurve: Curves.easeOutQuart,
                    switchOutCurve: Curves.easeInQuart,
                    transitionBuilder: (child, animation) {
                      final offsetAnimation = Tween<Offset>(
                          begin: const Offset(0.1, 0.0),
                          end: Offset.zero
                      ).animate(animation);

                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: offsetAnimation,
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

  Widget _buildClassesList(List<GymClass> classes, {required Key key}) {
    final groupedClasses = _groupClassesByDay(classes);

    return ListView.builder(
      key: key,
      padding: const EdgeInsets.only(bottom: 130),
      itemCount: groupedClasses.length,
      itemBuilder: (context, index) {
        final date = groupedClasses.keys.elementAt(index);
        final dayClasses = groupedClasses[date]!;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 12, top: 10),
                child: Row(
                  children: [
                    Container(width: 4, height: 16, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(2))),
                    const SizedBox(width: 8),
                    Text(_getDateLabel(date).toUpperCase(), style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                  ],
                ),
              ).animate().fadeIn(delay: (50 * index).ms),

              ...dayClasses.asMap().entries.map((entry) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: ClassCard(gymClass: entry.value)
                    .animate()
                    .fadeIn(delay: (100 + (index * 50) + (entry.key * 50)).ms, duration: 300.ms)
                    .slideX(begin: 0.05, curve: Curves.easeOutQuad),
              )),

              const SizedBox(height: 10),
            ],
          ),
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
              boxShadow: AppColors.subtleGlow,
            ),
            child: const Icon(Icons.event_note_rounded, size: 70, color: AppColors.primary),
          ).animate().scale(delay: 200.ms, duration: 400.ms, curve: Curves.easeOutBack),

          const SizedBox(height: 35),

          Text(
            _showOnlyMyClasses ? 'Brak zaplanowanych\nzajęć' : 'Brak zajęć\nw grafiku',
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 24, fontWeight: FontWeight.bold, height: 1.2, letterSpacing: -0.5),
          ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1),

          const SizedBox(height: 16),

          Text(
            _showOnlyMyClasses ? 'Przełącz na "Wszystkie", aby coś znaleźć.' : 'Zajrzyj tu później!',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary.withValues(alpha: 0.8), fontSize: 16, height: 1.5),
          ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1),
        ],
      ),
    );
  }

  Map<DateTime, List<GymClass>> _groupClassesByDay(List<GymClass> classes) {
    final Map<DateTime, List<GymClass>> grouped = {};
    for (final gymClass in classes) {
      final date = DateTime(gymClass.startTime.year, gymClass.startTime.month, gymClass.startTime.day);
      if (!grouped.containsKey(date)) grouped[date] = [];
      grouped[date]!.add(gymClass);
    }
    final sortedKeys = grouped.keys.toList()..sort();
    return Map.fromEntries(sortedKeys.map((key) => MapEntry(key, grouped[key]!)));
  }

  String _getDateLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    if (date == today) return 'Dzisiaj';
    if (date == tomorrow) return 'Jutro';
    final days = ['Poniedziałek', 'Wtorek', 'Środa', 'Czwartek', 'Piątek', 'Sobota', 'Niedziela'];
    final months = ['Sty', 'Lut', 'Mar', 'Kwi', 'Maj', 'Cze', 'Lip', 'Sie', 'Wrz', 'Paź', 'Lis', 'Gru'];
    return '${days[date.weekday - 1]}, ${date.day} ${months[date.month - 1]}';
  }
}