import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:mobile_gym_app/core/ui/widgets/full_screen_empty_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/ui/widgets/horizontal_calendar.dart';
import '../../../core/ui/widgets/no_connection_view.dart';
import '../../../l10n/app_localizations.dart';
import '../../user/providers/user_provider.dart';
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
    final selectedDate = ref.watch(selectedDateProvider);
    final userAsync = ref.watch(currentUserProvider);
    final isTrainer = userAsync.valueOrNull?.isTrainer ?? false;
    final l10n = AppLocalizations.of(context)!;

    final classesAsync = isTrainer
        ? ref.watch(trainerClassesProvider(selectedDate))
        : ref.watch(classesForDateProvider(selectedDate));

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
                  Text(
                    l10n.classesSchedule,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1.0,
                    ),
                  ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),

                  const SizedBox(height: 20),
                  HorizontalCalendar(
                    selectedDate: selectedDate,
                    onDateSelected: (date) {
                      ref.read(selectedDateProvider.notifier).state = date;
                    },
                  ),
                  const SizedBox(height: 20),

                  if (!isTrainer)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: userAsync.when(
                        data: (_) => CalendarViewToggle(
                          isMyClassesSelected: _showOnlyMyClasses,
                          onToggle: (value) =>
                              setState(() => _showOnlyMyClasses = value),
                        ).animate().fadeIn(),
                        loading: () => const SizedBox(height: 48),
                        error: (_, _) => const SizedBox.shrink(),
                      ),
                    ),
                ],
              ),
            ),

            Expanded(
              child: classesAsync.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
                error: (err, stack) => NoConnectionView(
                  onRetry: () => isTrainer
                      ? ref.invalidate(trainerClassesProvider(selectedDate))
                      : ref.invalidate(classesForDateProvider(selectedDate)),
                ),
                data: (dayClasses) {
                  final displayedClasses = dayClasses.where((c) {
                    if (c.personalTraining) return false;
                    return _showOnlyMyClasses ? c.userEnrolled : true;
                  }).toList();

                  final content = displayedClasses.isEmpty
                      ? FullScreenEmptyState(
                    key: ValueKey(
                        'empty_${selectedDate}_$_showOnlyMyClasses'),
                    icon: Icons.event_busy_rounded,
                    title: l10n.classesNoClassesDateTitle,
                    subtitle: l10n.classesChooseAnotherDate,
                    iconColor: AppColors.primary,
                  )
                      : _buildClassesList(
                    displayedClasses,
                    selectedDate,
                    key: ValueKey(
                        'list_${selectedDate}_$_showOnlyMyClasses'),
                  );

                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    switchInCurve: Curves.easeOutQuart,
                    switchOutCurve: Curves.easeInQuart,
                    transitionBuilder: (child, animation) => FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.05, 0.0),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    ),
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

  Widget _buildClassesList(
      List<GymClass> classes,
      DateTime selectedDate, {
        required Key key,
      }) {
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
                    Container(
                      width: 4,
                      height: 16,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _getDateLabel(context, selectedDate).toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
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

  String _getDateLabel(BuildContext context, DateTime date) {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    if (date.isAtSameMomentAs(today)) return l10n.notificationsToday;
    return DateFormat('EEEE, d MMMM', l10n.localeName).format(date);
  }
}
