import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/offline/offline_image_cache_provider.dart';
import '../../../../core/theme/app_colors.dart';

class ClassImage extends ConsumerWidget {
  final String name;
  final String? imageUrl;

  const ClassImage({super.key, required this.name, this.imageUrl});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fallback = _assetOrFallbackImage();
    final resolvedImageUrl = imageUrl?.trim();

    if (resolvedImageUrl == null || resolvedImageUrl.isEmpty) {
      return fallback;
    }

    final cachedImageAsync = ref.watch(
      cachedImageFileProvider(resolvedImageUrl),
    );

    return cachedImageAsync.when(
      data: (file) {
        if (file == null) return fallback;

        return Image.file(
          file,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (_, _, _) => fallback,
        );
      },
      loading: () => fallback,
      error: (_, _) => fallback,
    );
  }

  Widget _assetOrFallbackImage() {
    return Image.asset(
      _assetFor(name),
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (_, _, _) => _fallbackImage(),
    );
  }

  Widget _fallbackImage() {
    final colors = _colorsFor(name);

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
      ),
      child: Align(
        alignment: Alignment.center,
        child: Icon(
          _iconFor(name),
          color: Colors.white.withValues(alpha: 0.24),
          size: 88,
        ),
      ),
    );
  }
}

String _assetFor(String name) {
  final nameLower = name.toLowerCase();

  if (_containsAny(nameLower, [
    'personal',
    'indywidual',
    'trener personalny',
    'trening personalny',
    'pt',
  ])) {
    return 'assets/classes/personal_training.jpg';
  }
  if (nameLower.contains('yoga') || nameLower.contains('joga')) {
    return 'assets/classes/yoga.jpg';
  }
  if (_containsAny(nameLower, ['crossfit', 'hiit', 'wod', 'tabata'])) {
    return 'assets/classes/crossfit.jpg';
  }
  if (_containsAny(nameLower, [
    'stretch',
    'mobility',
    'mobil',
    'rozciag',
    'rozciąg',
    'zdrowy kregoslup',
    'zdrowy kręgosłup',
  ])) {
    return 'assets/classes/mobility.jpg';
  }
  if (nameLower.contains('pilates')) {
    return 'assets/classes/mobility.jpg';
  }
  if (_containsAny(nameLower, ['spinning', 'bike', 'rower', 'cycling'])) {
    return 'assets/classes/cardio.jpg';
  }
  if (_containsAny(nameLower, ['zumba', 'dance', 'taniec', 'aerobic'])) {
    return 'assets/classes/cardio.jpg';
  }
  if (_containsAny(nameLower, ['boxing', 'boks', 'kickboxing', 'mma'])) {
    return 'assets/classes/boxing.jpg';
  }
  if (nameLower.contains('trx')) {
    return 'assets/classes/trx.jpg';
  }
  if (_containsAny(nameLower, [
    'cardio',
    'fat burn',
    'fatburn',
    'burn',
    'interwal',
    'interwał',
    'treadmill',
    'bieznia',
    'bieżnia',
  ])) {
    return 'assets/classes/cardio.jpg';
  }
  if (_containsAny(nameLower, [
    'strength',
    'silow',
    'siłow',
    'power',
    'barbell',
    'sztanga',
    'dumbbell',
    'hantle',
    'legs',
    'nogi',
    'pośladki',
    'posladki',
    'full body',
    'body pump',
  ])) {
    return 'assets/classes/strength.jpg';
  }

  return 'assets/classes/default.jpg';
}

bool _containsAny(String value, List<String> patterns) {
  return patterns.any(value.contains);
}

IconData _iconFor(String name) {
  final nameLower = name.toLowerCase();

  if (nameLower.contains('yoga') || nameLower.contains('joga')) {
    return Icons.self_improvement_rounded;
  }
  if (nameLower.contains('boxing') || nameLower.contains('boks')) {
    return Icons.sports_mma_rounded;
  }
  if (nameLower.contains('spinning') || nameLower.contains('bike')) {
    return Icons.directions_bike_rounded;
  }
  if (nameLower.contains('pilates') || nameLower.contains('stretch')) {
    return Icons.accessibility_new_rounded;
  }
  if (nameLower.contains('zumba') || nameLower.contains('dance')) {
    return Icons.music_note_rounded;
  }

  return Icons.fitness_center_rounded;
}

List<Color> _colorsFor(String name) {
  const palettes = [
    [Color(0xFF0F766E), Color(0xFF0F172A)],
    [Color(0xFF1D4ED8), Color(0xFF111827)],
    [Color(0xFF7E22CE), Color(0xFF172554)],
    [Color(0xFFBE123C), Color(0xFF1F2937)],
    [Color(0xFF047857), Color(0xFF1E1B4B)],
  ];

  final seed = name.codeUnits.fold<int>(0, (sum, codeUnit) => sum + codeUnit);
  final palette = palettes[seed % palettes.length];

  return [
    palette.first.withValues(alpha: 0.95),
    AppColors.surface.withValues(alpha: 0.84),
    palette.last.withValues(alpha: 0.98),
  ];
}
