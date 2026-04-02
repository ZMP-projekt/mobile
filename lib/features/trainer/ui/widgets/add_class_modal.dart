import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/ui/widgets/custom_text_field.dart';
import '../../../../core/ui/success_overlay.dart';
import '../../../classes/providers/classes_provider.dart';

class AddClassModal extends ConsumerStatefulWidget {
  const AddClassModal({super.key});

  @override
  ConsumerState<AddClassModal> createState() => _AddClassModalState();
}

class _AddClassModalState extends ConsumerState<AddClassModal> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _maxParticipantsController = TextEditingController(text: '15');

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _startTime = TimeOfDay(hour: (DateTime.now().hour + 1) % 24, minute: 0);
  TimeOfDay _endTime = TimeOfDay(hour: (DateTime.now().hour + 2) % 24, minute: 0);

  bool _isLoading = false;
  bool _isPersonalTraining = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _maxParticipantsController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppColors.primary,
            onPrimary: Colors.white,
            surface: AppColors.surface,
            onSurface: AppColors.textPrimary,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _selectTime(BuildContext context, bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _startTime : _endTime,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppColors.primary,
            surface: AppColors.surface,
          ),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
          _endTime = TimeOfDay(hour: (picked.hour + 1) % 24, minute: picked.minute);
        } else {
          _endTime = picked;
        }
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final startDateTime = DateTime(
        _selectedDate.year, _selectedDate.month, _selectedDate.day,
        _startTime.hour, _startTime.minute
    );
    final endDateTime = DateTime(
        _selectedDate.year, _selectedDate.month, _selectedDate.day,
        _endTime.hour, _endTime.minute
    );

    if (startDateTime.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Zajęcia nie mogą odbywać się w przeszłości.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (endDateTime.isBefore(startDateTime)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Czas zakończenia musi być po czasie rozpoczęcia.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final requestData = {
        'name': _nameController.text.trim(),
        'description': _descriptionController.text.trim(),
        'startTime': startDateTime.toUtc().toIso8601String(),
        'endTime': endDateTime.toUtc().toIso8601String(),
        'maxParticipants': _isPersonalTraining ? 1 : int.parse(_maxParticipantsController.text.trim()),
        'personalTraining': _isPersonalTraining,
      };

      final repo = ref.read(classesRepositoryProvider);
      await repo.createClass(requestData);

      ref.invalidate(classesForDateProvider);
      ref.invalidate(trainerClassesProvider);

      if (!mounted) return;
      context.pop();

      SuccessOverlay.show(context, 'Zajęcia zostały dodane!');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e is Exception ? e.toString().replaceFirst('Exception: ', '') : 'Wystąpił błąd.'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.background.withValues(alpha: 0.9),
            border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.1), width: 1)),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            top: 24, left: 24, right: 24,
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)))),
                  const SizedBox(height: 24),

                  const Text('Nowe zajęcia', style: TextStyle(color: AppColors.textPrimary, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
                  const SizedBox(height: 24),

                  CustomTextField(
                    controller: _nameController,
                    label: 'Nazwa zajęć',
                    icon: Icons.fitness_center_rounded,
                    validator: (v) => v!.isEmpty ? 'Podaj nazwę zajęć' : null,
                  ),
                  const SizedBox(height: 16),

                  CustomTextField(
                    controller: _descriptionController,
                    label: 'Opis (opcjonalnie)',
                    icon: Icons.description_outlined,
                  ),
                  const SizedBox(height: 16),

                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                    ),
                    child: SwitchListTile(
                      title: const Text('Trening personalny', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                      subtitle: const Text('Zajęcia z jednym klientem', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                      value: _isPersonalTraining,
                      activeThumbColor: AppColors.primary,
                      onChanged: (val) {
                        setState(() {
                          _isPersonalTraining = val;
                          if (val) {
                            _maxParticipantsController.text = '1';
                          } else {
                            _maxParticipantsController.text = '15';
                          }
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: _buildPickerField(
                          label: 'Data',
                          value: DateFormat('dd.MM.yyyy').format(_selectedDate),
                          icon: Icons.calendar_month_rounded,
                          onTap: () => _selectDate(context),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 1,
                        child: IgnorePointer(
                          ignoring: _isPersonalTraining,
                          child: Opacity(
                            opacity: _isPersonalTraining ? 0.5 : 1.0,
                            child: CustomTextField(
                              controller: _maxParticipantsController,
                              label: 'Miejsca',
                              icon: Icons.people_alt_rounded,
                              keyboardType: TextInputType.number,
                              validator: (v) => (int.tryParse(v ?? '') ?? 0) <= 0 ? 'Błąd' : null,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(child: _buildPickerField(label: 'Start', value: _startTime.format(context), icon: Icons.access_time_rounded, onTap: () => _selectTime(context, true))),
                      const SizedBox(width: 16),
                      Expanded(child: _buildPickerField(label: 'Koniec', value: _endTime.format(context), icon: Icons.access_time_filled_rounded, onTap: () => _selectTime(context, false))),
                    ],
                  ),
                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.4),
                            blurRadius: 25,
                            spreadRadius: 2,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        child: _isLoading
                            ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : const Text('UTWÓRZ ZAJĘCIA', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: -0.5)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPickerField({required String label, required String value, required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white.withValues(alpha: 0.1))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            const SizedBox(height: 4),
            Row(children: [Icon(icon, color: AppColors.primary, size: 18), const SizedBox(width: 8), Text(value, style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w600))]),
          ],
        ),
      ),
    );
  }
}