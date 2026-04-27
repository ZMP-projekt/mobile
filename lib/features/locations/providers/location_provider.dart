import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/providers/shared_preferences_provider.dart';

const _locationTimeout = Duration(seconds: 8);

class GymLocation {
  final int id;
  final String name;
  final String city;
  final String address;
  final double? latitude;
  final double? longitude;

  GymLocation({
    required this.id,
    required this.name,
    required this.city,
    required this.address,
    this.latitude,
    this.longitude,
  });

  factory GymLocation.fromJson(Map<String, dynamic> json) {
    return GymLocation(
      id: json['id'],
      name: json['name'],
      city: json['city'],
      address: json['address'],
      latitude: _optionalDouble(json['latitude']),
      longitude: _optionalDouble(json['longitude']),
    );
  }

  bool get hasCoordinates => latitude != null && longitude != null;
}

double? _optionalDouble(Object? value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  if (value is String) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;
    return double.tryParse(trimmed.replaceAll(',', '.'));
  }
  return null;
}

final locationsProvider = FutureProvider<List<GymLocation>>((ref) async {
  final dio = ref.watch(dioProvider);
  final response = await dio.get('/api/locations');
  final List<dynamic> data = response.data;
  return data.map((json) => GymLocation.fromJson(json)).toList();
});

class SelectedLocationNotifier extends Notifier<int?> {
  static const _key = 'selected_gym_location_id';

  @override
  int? build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return prefs.getInt(_key);
  }

  void setLocation(int id) {
    state = id;
    ref.read(sharedPreferencesProvider).setInt(_key, id);
  }

  void clearLocation() {
    state = null;
    ref.read(sharedPreferencesProvider).remove(_key);
  }

  void ensureLocationSelected(List<GymLocation> locations) {
    if (locations.isEmpty) return;
    if (locations.any((location) => location.id == state)) return;
    setLocation(locations.first.id);
  }
}

final selectedLocationIdProvider = NotifierProvider<SelectedLocationNotifier, int?>(
  SelectedLocationNotifier.new,
);

final userPositionProvider = FutureProvider<Position?>((ref) async {
  final serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) return null;

  var permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return null;
    }
  }
  if (permission == LocationPermission.deniedForever) return null;

  try {
    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    ).timeout(_locationTimeout);
  } catch (_) {
    return null;
  }
});

final sortedLocationsProvider = Provider<AsyncValue<List<GymLocation>>>((ref) {
  final locationsAsync = ref.watch(locationsProvider);
  final selectedLocationId = ref.watch(selectedLocationIdProvider);
  final userPosition = ref.watch(userPositionProvider).valueOrNull;

  return locationsAsync.whenData((locations) {
    final sorted = [...locations];
    sorted.sort((a, b) {
      final isASelected = a.id == selectedLocationId;
      final isBSelected = b.id == selectedLocationId;

      if (isASelected && !isBSelected) return -1;
      if (!isASelected && isBSelected) return 1;

      final distanceA = distanceInMeters(userPosition, a);
      final distanceB = distanceInMeters(userPosition, b);

      if (distanceA != null && distanceB != null) {
        return distanceA.compareTo(distanceB);
      }
      if (distanceA != null) return -1;
      if (distanceB != null) return 1;

      return a.name.compareTo(b.name);
    });

    return sorted;
  });
});

final activeLocationProvider = Provider<AsyncValue<GymLocation?>>((ref) {
  final sortedLocationsAsync = ref.watch(sortedLocationsProvider);
  final selectedLocationId = ref.watch(selectedLocationIdProvider);

  return sortedLocationsAsync.whenData((locations) {
    if (locations.isEmpty) return null;
    return locations.firstWhere(
      (location) => location.id == selectedLocationId,
      orElse: () => locations.first,
    );
  });
});

final effectiveSelectedLocationIdProvider = FutureProvider<int?>((ref) async {
  final selectedLocationId = ref.watch(selectedLocationIdProvider);
  if (selectedLocationId != null) return selectedLocationId;

  try {
    final locations = await ref.watch(locationsProvider.future);
    if (locations.isEmpty) return null;

    return locations.first.id;
  } on Exception {
    return null;
  }
});

String? formatDistance(Position? userPos, GymLocation loc) {
  final meters = distanceInMeters(userPos, loc);
  if (meters == null) return null;

  if (meters < 1000) return '${meters.round()} m';
  return '${(meters / 1000).toStringAsFixed(1)} km';
}

double? distanceInMeters(Position? userPos, GymLocation loc) {
  if (userPos == null || !loc.hasCoordinates) return null;

  return Geolocator.distanceBetween(
    userPos.latitude,
    userPos.longitude,
    loc.latitude!,
    loc.longitude!,
  );
}
