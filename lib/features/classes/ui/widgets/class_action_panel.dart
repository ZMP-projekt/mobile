import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/ui/success_overlay.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/models/gym_class.dart';
import '../../providers/classes_provider.dart';

class ClassActionPanel extends ConsumerWidget {
  final GymClass gymClass;
  final bool isTrainer;

  const ClassActionPanel({super.key, required this.gymClass, required this.isTrainer});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isProcessing = ref.watch(bookingNotifierProvider).isLoading;

    return SafeArea(
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: BoxDecoration(
              color: AppColors.background.withValues(alpha: 0.85),
              border: Border(
                top: BorderSide(
                    color: Colors.white.withValues(alpha: 0.08),
                    width: 1.5
                ),
              ),
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
    final l10n = AppLocalizations.of(context)!;

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
          child: isProcessing ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.error)) : Text(l10n.classesCancelBooking, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, letterSpacing: -0.5)),
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
            await SuccessOverlay.show(context, l10n.classesBookingSuccess);
          } catch (e) {
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error));
          }
        },
        style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, foregroundColor: Colors.white, shadowColor: Colors.transparent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
        child: isProcessing ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : Text(gymClass.isPast ? l10n.classesFinished : gymClass.isFull ? l10n.classesFull : l10n.classesBookLong, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: -0.5)),
      ),
    );
  }

  Widget _buildTrainerActionButtons(BuildContext context, WidgetRef ref, bool isProcessing) {
    final bool isStarted = !gymClass.isFuture;
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: (isProcessing || isStarted) ? null : () => _showRescheduleModal(context),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: BorderSide(color: isStarted ? Colors.white10 : Colors.white.withValues(alpha: 0.3)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            child: Text(
              l10n.classesRescheduleTitle,
              style: TextStyle(
                  color: isStarted ? AppColors.textSecondary : AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: (isProcessing || isStarted) ? null : () => _showCancelClassDialog(context, ref),
            style: ElevatedButton.styleFrom(
              backgroundColor: isStarted ? AppColors.surface : AppColors.error,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: isStarted ? 0 : 2,
            ),
            child: isProcessing
                ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : Text(
              isStarted
                  ? (gymClass.isPast ? l10n.classesFinished : l10n.classesOngoing)
                  : l10n.classesDeleteAction,
              style: TextStyle(
                  color: isStarted ? AppColors.textSecondary : Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _confirmCancel(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(l10n.classesCancelDialogTitle, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        content: Text(l10n.classesCancelDialogBody(gymClass.name), style: const TextStyle(color: AppColors.textSecondary, height: 1.5)),
        actions: [
          TextButton(onPressed: () => ctx.pop(), child: Text(l10n.commonBack, style: const TextStyle(color: AppColors.textSecondary))),
          TextButton(
            onPressed: () {
              ctx.pop();
              ref.read(bookingNotifierProvider.notifier).cancelBooking(gymClass.id);
            },
            child: Text(l10n.classesCancelBookingShort, style: const TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showCancelClassDialog(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(l10n.classesDeleteDialogTitle, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        content: Text(l10n.classesDeleteDialogBody, style: const TextStyle(color: AppColors.textSecondary, height: 1.5)),
        actions: [
          TextButton(onPressed: () => ctx.pop(), child: Text(l10n.commonBack, style: const TextStyle(color: AppColors.textSecondary))),
          ElevatedButton(
            onPressed: () async {
              ctx.pop();
              await ref.read(bookingNotifierProvider.notifier).deleteClass(gymClass.id);

              if (context.mounted && context.canPop()) {
                context.pop();
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: Text(l10n.classesDeleteConfirm, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showRescheduleModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => _RescheduleModal(gymClass: gymClass),
    );
  }
}

class _RescheduleModal extends ConsumerStatefulWidget {
  final GymClass gymClass;
  const _RescheduleModal({required this.gymClass});

  @override
  ConsumerState<_RescheduleModal> createState() => _RescheduleModalState();
}

class _RescheduleModalState extends ConsumerState<_RescheduleModal> {
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.gymClass.startTime;
    _selectedTime = TimeOfDay.fromDateTime(widget.gymClass.startTime);
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    final newTime = DateTime(
      _selectedDate.year, _selectedDate.month, _selectedDate.day,
      _selectedTime.hour, _selectedTime.minute,
    );

    if (newTime.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.classesReschedulePastError), backgroundColor: AppColors.error),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ref.read(bookingNotifierProvider.notifier).rescheduleClass(widget.gymClass.id, newTime);

      if (!mounted) return;
      context.pop();
      await SuccessOverlay.show(context, l10n.classesRescheduledSuccess);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
    );
    if (date != null) setState(() => _selectedDate = date);
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (time != null) setState(() => _selectedTime = time);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: EdgeInsets.only(
        top: 24, left: 24, right: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 32,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.classesRescheduleTitle, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 24),

          _buildPickerTile(
            label: l10n.classesNewDate,
            value: DateFormat('dd.MM.yyyy').format(_selectedDate),
            icon: Icons.calendar_today_rounded,
            onTap: _pickDate,
          ),
          const SizedBox(height: 12),

          _buildPickerTile(
            label: l10n.classesNewTime,
            value: _selectedTime.format(context),
            icon: Icons.access_time_rounded,
            onTap: _pickTime,
          ),

          const SizedBox(height: 32),

          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(l10n.classesRescheduleConfirm, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPickerTile({required String label, required String value, required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                Text(value, style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
