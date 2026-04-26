import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/network/dio_client.dart';

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
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );
  }
}


final locationsProvider = FutureProvider<List<GymLocation>>((ref) async {
  final dio = ref.watch(dioProvider);
  final response = await dio.get('/api/locations');
  final List<dynamic> data = response.data;
  return data.map((json) => GymLocation.fromJson(json)).toList();
});


final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
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
}

final selectedLocationIdProvider = NotifierProvider<SelectedLocationNotifier, int?>(
  SelectedLocationNotifier.new,
);


final userPositionProvider = FutureProvider<Position?>((ref) async {
  final permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    final requested = await Geolocator.requestPermission();
    if (requested == LocationPermission.denied ||
        requested == LocationPermission.deniedForever) {
      return null;
    }
  }
  if (permission == LocationPermission.deniedForever) return null;

  return Geolocator.getCurrentPosition(
    locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
  );
});


String? formatDistance(Position? userPos, GymLocation loc) {
  if (userPos == null || loc.latitude == null || loc.longitude == null) return null;

  final meters = Geolocator.distanceBetween(
    userPos.latitude,
    userPos.longitude,
    loc.latitude!,
    loc.longitude!,
  );

  if (meters < 1000) return '${meters.round()} m';
  return '${(meters / 1000).toStringAsFixed(1)} km';
}