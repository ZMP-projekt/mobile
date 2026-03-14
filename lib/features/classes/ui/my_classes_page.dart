import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/classes_provider.dart';
import '../data/models/gym_class.dart';

class MyClassesPage extends ConsumerWidget {
  const MyClassesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myClassesAsync = ref.watch(myClassesProvider);

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
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Moje Zajęcia',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              )
                  .animate()
                  .fadeIn(duration: 400.ms)
                  .slideY(begin: -0.2, end: 0),
              const SizedBox(height: 20),
              Expanded(
                child: myClassesAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Center(child: Text('Błąd: $err')),
                  data: (classes) {
                    if (classes.isEmpty) {
                      return _buildEmptyState();
                    }
                    return ListView.builder(
                      itemCount: classes.length,
                      itemBuilder: (context, index) {
                        final gymClass = classes[index];
                        return AnimatedClassCard(
                          gymClass: gymClass,
                          index: index,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy,
            size: 80,
            color: AppColors.primary.withValues(alpha: 0.7),
          ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
          const SizedBox(height: 20),
          const Text(
            'Brak zapisów',
            style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Nie jesteś zapisany na żadne zajęcia.\nPrzejdź do kalendarza, aby dołączyć!',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
class AnimatedClassCard extends ConsumerStatefulWidget {
  final GymClass gymClass;
  final int index;

  const AnimatedClassCard({
    super.key,
    required this.gymClass,
    required this.index,
  });

  @override
  ConsumerState<AnimatedClassCard> createState() => _AnimatedClassCardState();
}

class _AnimatedClassCardState extends ConsumerState<AnimatedClassCard> {
  bool _isExiting = false;
  void _confirmCancel() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Zrezygnować?'),
        content: Text('Czy na pewno chcesz się wypisać z zajęć: ${widget.gymClass.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Nie', style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);

              setState(() {
                _isExiting = true;
              });

              await Future.delayed(const Duration(milliseconds: 300));

              if (mounted) {
                ref.read(bookingNotifierProvider.notifier).cancelBooking(widget.gymClass.id);
              }
            },
            child: const Text('Tak, wypisz mnie', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(bookingNotifierProvider);

    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: _isExiting
          ? const SizedBox(width: double.infinity, height: 0)
          : _buildCardContent(isLoading)
          .animate()
          .fadeIn(delay: (widget.index * 100).ms, duration: 400.ms)
          .slideX(begin: 0.1, end: 0)
          .animate(target: _isExiting ? 1 : 0)
          .slideX(begin: 0, end: -0.5, duration: 250.ms)
          .fadeOut(duration: 250.ms),
    );
  }

  Widget _buildCardContent(bool isLoading) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  widget.gymClass.startTime.day.toString(),
                  style: const TextStyle(color: AppColors.primary, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  _getMonthName(widget.gymClass.startTime.month),
                  style: const TextStyle(color: AppColors.primary, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.gymClass.name,
                  style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  '${widget.gymClass.startTimeFormatted} - ${widget.gymClass.trainerName}',
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: isLoading ? null : _confirmCancel,
            icon: const Icon(Icons.cancel_outlined, color: AppColors.error),
            tooltip: 'Wypisz się',
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const months = ['STYZ', 'LUT', 'MAR', 'KWI', 'MAJ', 'CZE', 'LIP', 'SIE', 'WRZ', 'PAZ', 'LIS', 'GRU'];
    return months[month - 1];
  }
}