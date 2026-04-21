import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GymLocation {
  final int id;
  final String name;
  final String city;
  final String address;

  GymLocation({required this.id, required this.name, required this.city, required this.address});

  factory GymLocation.fromJson(Map<String, dynamic> json) {
    return GymLocation(
      id: json['id'],
      name: json['name'],
      city: json['city'],
      address: json['address'],
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