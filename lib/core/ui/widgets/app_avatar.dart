import 'package:flutter/material.dart';

class AppAvatar extends StatelessWidget {
  final String label;
  final String? imageUrl;
  final double radius;
  final IconData fallbackIcon;

  const AppAvatar({
    super.key,
    required this.label,
    this.imageUrl,
    this.radius = 24,
    this.fallbackIcon = Icons.person_rounded,
  });

  @override
  Widget build(BuildContext context) {
    final fallback = _fallbackAvatar();
    final resolvedImageUrl = imageUrl?.trim();

    if (resolvedImageUrl == null || resolvedImageUrl.isEmpty) {
      return fallback;
    }

    return SizedBox.square(
      dimension: radius * 2,
      child: ClipOval(
        child: Image.network(
          resolvedImageUrl,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return fallback;
          },
          errorBuilder: (_, _, _) => fallback,
        ),
      ),
    );
  }

  Widget _fallbackAvatar() {
    final initials = _initials(label);

    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _colorsFor(label),
        ),
      ),
      alignment: Alignment.center,
      child: initials.isEmpty
          ? Icon(fallbackIcon, color: Colors.white, size: radius)
          : Text(
              initials,
              style: TextStyle(
                color: Colors.white,
                fontSize: radius * 0.72,
                fontWeight: FontWeight.w800,
              ),
            ),
    );
  }
}

String _initials(String label) {
  final parts = label
      .trim()
      .split(RegExp(r'\s+'))
      .where((part) => part.isNotEmpty)
      .toList();

  if (parts.isEmpty) return '';
  if (parts.length == 1) return parts.first.characters.first.toUpperCase();

  return '${parts.first.characters.first}${parts.last.characters.first}'
      .toUpperCase();
}

List<Color> _colorsFor(String label) {
  const palettes = [
    [Color(0xFF2563EB), Color(0xFF06B6D4)],
    [Color(0xFF7C3AED), Color(0xFFDB2777)],
    [Color(0xFF059669), Color(0xFF84CC16)],
    [Color(0xFFEA580C), Color(0xFFE11D48)],
    [Color(0xFF0F766E), Color(0xFF3B82F6)],
    [Color(0xFF9333EA), Color(0xFFF59E0B)],
  ];

  final seed = label.codeUnits.fold<int>(0, (sum, codeUnit) => sum + codeUnit);
  final palette = palettes[seed % palettes.length];

  return [
    palette.first.withValues(alpha: 0.95),
    palette.last.withValues(alpha: 0.95),
  ];
}
