import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_gym_app/features/classes/data/models/gym_class.dart';
import 'package:mobile_gym_app/features/classes/data/repositories/class_repository.dart';
import 'package:mobile_gym_app/features/classes/providers/classes_provider.dart';
import 'package:mobile_gym_app/features/locations/providers/location_provider.dart';
import 'package:mobile_gym_app/features/trainer/data/models/trainer.dart';
import 'package:mobile_gym_app/features/user/data/models/user.dart';

class FakeClassesRepository implements IClassesRepository {
  FakeClassesRepository(this.classes);

  final List<GymClass> classes;

  @override
  Future<List<GymClass>> getClassesByDate(DateTime date) async => classes;

  @override
  Future<List<GymClass>> getClassesByLocation(int locationId) async => classes;

  @override
  Future<List<GymClass>> getTrainerClasses(DateTime date) async => classes;

  @override
  Future<List<User>> getClassParticipants(int classId) async => [];

  @override
  Future<void> bookClass(int classId) async {}

  @override
  Future<void> cancelBooking(int classId) async {}

  @override
  Future<void> createClass(Map<String, dynamic> classData) async {}

  @override
  Future<void> rescheduleClass(int classId, DateTime newTime) async {}

  @override
  Future<void> deleteClass(int classId) async {}
}

void main() {
  const trainer = Trainer(firstName: 'Anna', lastName: 'Kowalska');

  GymClass gymClass({
    required int id,
    required DateTime startTime,
    required DateTime endTime,
  }) {
    return GymClass(
      id: id,
      name: 'Yoga',
      startTime: startTime,
      endTime: endTime,
      trainer: trainer,
      maxParticipants: 10,
      currentParticipants: 2,
    );
  }

  test('todayClassesProvider keeps ongoing and future classes only', () async {
    final now = DateTime.now();
    final classes = [
      gymClass(
        id: 3,
        startTime: now.add(const Duration(hours: 2)),
        endTime: now.add(const Duration(hours: 3)),
      ),
      gymClass(
        id: 1,
        startTime: now.subtract(const Duration(hours: 3)),
        endTime: now.subtract(const Duration(hours: 2)),
      ),
      gymClass(
        id: 2,
        startTime: now.subtract(const Duration(minutes: 30)),
        endTime: now.add(const Duration(minutes: 30)),
      ),
    ];

    final container = ProviderContainer(
      overrides: [
        classesRepositoryProvider.overrideWithValue(
          FakeClassesRepository(classes),
        ),
        effectiveSelectedLocationIdProvider.overrideWith((ref) async => null),
      ],
    );
    addTearDown(container.dispose);

    final result = await container.read(todayClassesProvider.future);

    expect(result.map((gymClass) => gymClass.id), [2, 3]);
  });
}
