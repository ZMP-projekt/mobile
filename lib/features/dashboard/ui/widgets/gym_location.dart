import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../locations/providers/location_provider.dart';

class GymLocationCard extends ConsumerWidget {
  const GymLocationCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<List<GymLocation>>>(locationsProvider, (_, next) {
      next.whenData(
        ref.read(selectedLocationIdProvider.notifier).ensureLocationSelected,
      );
    });

    final sortedLocationsAsync = ref.watch(sortedLocationsProvider);
    final activeLocationAsync = ref.watch(activeLocationProvider);
    final selectedLocationId = ref.watch(selectedLocationIdProvider);
    final userPosition = ref.watch(userPositionProvider).valueOrNull;

    return sortedLocationsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, _) => const _LocationUnavailable(),
      data: (locations) {
        final activeLocation = activeLocationAsync.valueOrNull;
        if (locations.isEmpty || activeLocation == null) {
          return const SizedBox.shrink();
        }

        return _LocationCardSurface(
          location: activeLocation,
          onTap: () => _showLocationPicker(
            context: context,
            ref: ref,
            locations: locations,
            selectedId: selectedLocationId,
            userPosition: userPosition,
          ),
        );
      },
    );
  }

  void _showLocationPicker({
    required BuildContext context,
    required WidgetRef ref,
    required List<GymLocation> locations,
    required int? selectedId,
    required Position? userPosition,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return _LocationPickerSheet(
          locations: locations,
          selectedId: selectedId,
          userPosition: userPosition,
          onSelected: (locationId) {
            ref
                .read(selectedLocationIdProvider.notifier)
                .setLocation(locationId);
            Navigator.pop(context);
          },
        );
      },
    );
  }
}

class _LocationCardSurface extends StatelessWidget {
  const _LocationCardSurface({
    required this.location,
    required this.onTap,
  });

  final GymLocation location;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.secondary.withValues(alpha: 0.15),
              blurRadius: 15,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.secondary.withValues(alpha: 0.05),
            ),
          ),
          child: Row(
            children: [
              const _LocationIcon(),
              const SizedBox(width: 16),
              Expanded(child: _LocationSummary(location: location)),
            ],
          ),
        ),
      ),
    );
  }
}

class _LocationIcon extends StatelessWidget {
  const _LocationIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Icon(
        Icons.location_on,
        color: AppColors.error,
        size: 24,
      ),
    );
  }
}

class _LocationSummary extends StatelessWidget {
  const _LocationSummary({required this.location});

  final GymLocation location;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                location.name,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.textSecondary,
              size: 20,
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '${location.address}, ${location.city}',
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _LocationPickerSheet extends StatelessWidget {
  const _LocationPickerSheet({
    required this.locations,
    required this.selectedId,
    required this.userPosition,
    required this.onSelected,
  });

  final List<GymLocation> locations;
  final int? selectedId;
  final Position? userPosition;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 24,
          left: 24,
          right: 24,
          bottom: 16,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Wybierz silownie',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: locations.length,
                  itemBuilder: (context, index) {
                    final location = locations[index];
                    return _LocationPickerTile(
                      location: location,
                      isSelected: location.id == selectedId,
                      userPosition: userPosition,
                      onTap: () => onSelected(location.id),
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
}

class _LocationPickerTile extends StatelessWidget {
  const _LocationPickerTile({
    required this.location,
    required this.isSelected,
    required this.userPosition,
    required this.onTap,
  });

  final GymLocation location;
  final bool isSelected;
  final Position? userPosition;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        Icons.location_city,
        color: isSelected ? AppColors.primary : AppColors.textSecondary,
      ),
      title: Text(
        location.name,
        style: TextStyle(
          color: isSelected ? AppColors.primary : AppColors.textPrimary,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      subtitle: Text(
        [
          '${location.address}, ${location.city}',
          formatDistance(userPosition, location),
        ].whereType<String>().join(' - '),
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 12,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: AppColors.primary)
          : null,
      onTap: onTap,
    );
  }
}

class _LocationUnavailable extends StatelessWidget {
  const _LocationUnavailable();

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
