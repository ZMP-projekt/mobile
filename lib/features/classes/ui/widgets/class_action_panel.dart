import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/ui/success_overlay.dart';
import '../../data/models/gym_class.dart';
import '../../providers/classes_provider.dart';

class ClassActionPanel extends ConsumerWidget {
  final GymClass gymClass;
  final bool isTrainer;

  const ClassActionPanel({super.key, required this.gymClass, required this.isTrainer});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isProcessing = ref.watch(bookingNotifierProvider).isLoading;

    return Positioned(
      bottom: 0, left: 0, right: 0,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: EdgeInsets.fromLTRB(24, 20, 24, MediaQuery.of(context).padding.bottom + 20),
            decoration: BoxDecoration(
              color: AppColors.background.withValues(alpha: 0.75),
              border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.05), width: 1)),
            ),
            child: isTrainer
                ? _buildTrainerActionButtons(context, ref, isProcessing)
                : _buildMainActionButton(context, ref, isProcessing),
          ),
        ),
      ),
    ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.5, end: 0);
  }

  Widget _buildMainActionButton(BuildContext context, WidgetRef ref, bool isProcessing) {
    if (gymClass.userEnrolled) {
      return SizedBox(
        height: 58, width: double.infinity,
        child: ElevatedButton(
          onPressed: isProcessing ? null : () => _confirmCancel(context, ref),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.surface, foregroundColor: AppColors.error,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: AppColors.error.withValues(alpha: 0.3), width: 1)),
            elevation: 0,
          ),
          child: isProcessing ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.error)) : const Text('Zrezygnuj z zajęć', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, letterSpacing: -0.5)),
        ),
      );
    }

    final isDisabled = gymClass.isFull || gymClass.isPast;

    return Container(
      height: 58, width: double.infinity,
      decoration: BoxDecoration(
        gradient: isDisabled ? null : AppColors.primaryGradient,
        color: isDisabled ? AppColors.surface : null,
        borderRadius: BorderRadius.circular(20),
        boxShadow: isDisabled ? [] : [BoxShadow(color: AppColors.primary.withValues(alpha: 0.4), blurRadius: 25, spreadRadius: 2, offset: const Offset(0, 8))],
      ),
      child: ElevatedButton(
        onPressed: (isProcessing || isDisabled) ? null : () async {
          try {
            await ref.read(bookingNotifierProvider.notifier).bookClass(gymClass.id);
            if (!context.mounted) return;
            await SuccessOverlay.show(context, "Zapisano na\nzajęcia!");
          } catch (e) {
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error));
          }
        },
        style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, foregroundColor: Colors.white, shadowColor: Colors.transparent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
        child: isProcessing ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : Text(gymClass.isPast ? 'Zakończone' : gymClass.isFull ? 'Brak miejsc' : 'Zapisz się', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: -0.5)),
      ),
    );
  }

  Widget _buildTrainerActionButtons(BuildContext context, WidgetRef ref, bool isProcessing) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: isProcessing ? null : () => _showRescheduleModal(context),
            style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), side: BorderSide(color: Colors.white.withValues(alpha: 0.3)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
            child: const Text('Przełóż', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: isProcessing ? null : () => _showCancelClassDialog(context, ref),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
            child: isProcessing ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('Odwołaj zajęcia', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  void _confirmCancel(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Zrezygnować?', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        content: Text('Czy na pewno chcesz anulować:\n${gymClass.name}?', style: const TextStyle(color: AppColors.textSecondary, height: 1.5)),
        actions: [
          TextButton(onPressed: () => ctx.pop(), child: const Text('Wróć', style: TextStyle(color: AppColors.textSecondary))),
          TextButton(
            onPressed: () {
              ctx.pop();
              ref.read(bookingNotifierProvider.notifier).cancelBooking(gymClass.id);
            },
            child: const Text('Zrezygnuj', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showCancelClassDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Odwołać zajęcia?', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        content: const Text('Zapisani uczestnicy otrzymają powiadomienie. Tej operacji nie można cofnąć.', style: TextStyle(color: AppColors.textSecondary, height: 1.5)),
        actions: [
          TextButton(onPressed: () => ctx.pop(), child: const Text('Wróć', style: TextStyle(color: AppColors.textSecondary))),
          ElevatedButton(
            onPressed: () {
              ctx.pop();
              ref.read(bookingNotifierProvider.notifier).deleteClass(gymClass.id);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: const Text('Tak, odwołaj', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showRescheduleModal(BuildContext context) {
    showModalBottomSheet(
      context: context, backgroundColor: AppColors.surface, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Przełóż zajęcia', style: TextStyle(color: AppColors.textPrimary, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
            const SizedBox(height: 16),
            const Text('Wybierz nową datę i godzinę.', style: TextStyle(color: AppColors.textSecondary, fontSize: 16, height: 1.5)),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => ctx.pop(),
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 56), backgroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
              child: const Text('Zatwierdź zmianę', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}