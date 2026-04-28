import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';

class AsyncValueWidget<T> extends StatelessWidget {
  final AsyncValue<T> value;
  final Widget Function(T) data;
  final Widget Function()? loading;
  final Widget Function(Object, StackTrace)? error;

  const AsyncValueWidget({
    super.key,
    required this.value,
    required this.data,
    this.loading,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return value.when(
      skipLoadingOnReload: true,
      data: data,
      loading: loading ?? () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
      error: error ?? (err, stack) => Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline_rounded, color: AppColors.error, size: 28),
              const SizedBox(height: 8),
              Text(
                l10n.errorDataLoad,
                style: TextStyle(color: AppColors.textSecondary.withValues(alpha: 0.8), fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
