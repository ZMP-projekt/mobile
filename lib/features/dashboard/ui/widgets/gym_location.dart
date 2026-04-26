import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../locations/providers/location_provider.dart';

class GymLocationCard extends ConsumerWidget {
  const GymLocationCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationsAsync = ref.watch(locationsProvider);
    final positionAsync = ref.watch(userPositionProvider);


    return locationsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => const SizedBox(),
      data: (locations) {
        if (locations.isEmpty) return const SizedBox();

        final userPosition = ref.watch(userPositionProvider).valueOrNull;
        final selectedLocationId = ref.watch(selectedLocationIdProvider);

        final sortedLocations = [...locations];

        sortedLocations.sort((a, b) {
          final isASelected = a.id == selectedLocationId;
          final isBSelected = b.id == selectedLocationId;

          if (isASelected && !isBSelected) return -1;
          if (!isASelected && isBSelected) return 1;

          if (userPosition != null && a.latitude != null && b.latitude != null) {
            final distA = Geolocator.distanceBetween(
                userPosition.latitude, userPosition.longitude, a.latitude!, a.longitude!);
            final distB = Geolocator.distanceBetween(
                userPosition.latitude, userPosition.longitude, b.latitude!, b.longitude!);
            return distA.compareTo(distB);
          }

          return 0;
        });

        final activeLocation = sortedLocations.firstWhere(
              (loc) => loc.id == selectedLocationId,
          orElse: () {
            final firstId = sortedLocations.first.id;
            Future.microtask(() =>
                ref.read(selectedLocationIdProvider.notifier).setLocation(firstId)
            );
            return sortedLocations.first;
          },
        );

        return GestureDetector(
          onTap: () => _showLocationPicker(
            context, ref, sortedLocations, selectedLocationId,
            positionAsync.valueOrNull, 
          ),

          child: Container(
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
                border: Border.all(color: AppColors.secondary.withValues(alpha: 0.05)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.location_on, color: AppColors.error, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                activeLocation.name,
                                style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textSecondary, size: 20),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${activeLocation.address}, ${activeLocation.city}',
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showLocationPicker(BuildContext context, WidgetRef ref, List<GymLocation> locations, int? selectedId, Position? userPosition) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 24.0, left: 24.0, right: 24.0, bottom: 16.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Wybierz siłownię', style: TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),

                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: locations.length,
                      itemBuilder: (context, index) {
                        final loc = locations[index];
                        final isSelected = loc.id == selectedId;

                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(Icons.location_city, color: isSelected ? AppColors.primary : AppColors.textSecondary),
                          title: Text(loc.name, style: TextStyle(color: isSelected ? AppColors.primary : AppColors.textPrimary, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                          subtitle: Text(
                            [
                              '${loc.address}, ${loc.city}',
                              formatDistance(userPosition, loc),
                            ].whereType<String>().join(' · '),
                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                          ),

                          trailing: isSelected ? const Icon(Icons.check_circle, color: AppColors.primary) : null,
                          onTap: () {
                            ref.read(selectedLocationIdProvider.notifier).setLocation(loc.id);
                            Navigator.pop(context);
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
      },
    );
  }
}