import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/gym_class.dart';
import '../data/repositories/mock_classes_repository.dart';

final classesRepositoryProvider = Provider<MockClassesRepository>((ref) {
  return MockClassesRepository();
});

final allClassesProvider = FutureProvider<List<GymClass>>((ref) async {
  final repo = ref.watch(classesRepositoryProvider);
  return await repo.getAllClasses();
});

final myClassesProvider = FutureProvider<List<GymClass>>((ref) async {
  final repo = ref.watch(classesRepositoryProvider);
  return await repo.getMyClasses();
});


final todayClassesProvider = FutureProvider<List<GymClass>>((ref) async {
  final allClasses = await ref.watch(allClassesProvider.future);
  return allClasses.where((c) => c.isToday && c.isFuture).toList();
});

final classesProvider = FutureProvider<Map<String, List<GymClass>>>((ref) async {
  final allClasses = await ref.watch(allClassesProvider.future);
  final grouped = <String, List<GymClass>>{};

  final now = DateTime.now();
  final tomorrow = now.add(const Duration(days: 1));

  for (final gymClass in allClasses) {
    String dateLabel;
    if (gymClass.isToday) {
      dateLabel = 'Dzisiaj';
    } else if (gymClass.startTime.year == tomorrow.year && gymClass.startTime.month == tomorrow.month && gymClass.startTime.day == tomorrow.day) {
      dateLabel = 'Jutro';
    } else {
      dateLabel = gymClass.dateFormatted;
    }

    if (!grouped.containsKey(dateLabel)) {
      grouped[dateLabel] = [];
    }
    grouped[dateLabel]!.add(gymClass);
  }

  return grouped;
});

class BookingNotifier extends StateNotifier<bool> {
  final MockClassesRepository _repository;
  final Ref _ref;

  BookingNotifier(this._repository, this._ref) : super(false);

  Future<void> bookClass(int classId) async {
    state = true;
    try {
      await _repository.bookClass(classId);

      _ref.invalidate(allClassesProvider);
      _ref.invalidate(myClassesProvider);
      _ref.invalidate(todayClassesProvider);

      state = false;
    } catch (error) {
      state = false;
      rethrow;
    }
  }

  Future<void> cancelBooking(int classId) async {
    state = true;
    try {
      await _repository.cancelBooking(classId);

      _ref.invalidate(allClassesProvider);
      _ref.invalidate(myClassesProvider);
      _ref.invalidate(todayClassesProvider);

      state = false;
    } catch (error) {
      state = false;
      rethrow;
    }
  }
}

final bookingNotifierProvider = StateNotifierProvider<BookingNotifier, bool>((ref) {
  final repository = ref.watch(classesRepositoryProvider);
  return BookingNotifier(repository, ref);
});