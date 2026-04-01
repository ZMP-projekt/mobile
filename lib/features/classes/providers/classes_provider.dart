import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_client.dart';
import '../data/models/gym_class.dart';
import '../data/repositories/class_repository.dart';
import '../../user/data/models/user.dart';

final classesRepositoryProvider = Provider<IClassesRepository>((ref) {
  return ApiClassesRepository(ref.watch(dioProvider));
});

final selectedDateProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
});

final classesForDateProvider = FutureProvider.family<List<GymClass>, DateTime>((ref, date) async {
  final repo = ref.watch(classesRepositoryProvider);
  return await repo.getClassesByDate(date);
});

final todayClassesProvider = FutureProvider<List<GymClass>>((ref) async {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final classes = await ref.watch(classesForDateProvider(today).future);
  return classes.where((c) => c.isFuture).toList();
});

final trainerClassesProvider = FutureProvider.family<List<GymClass>, DateTime>((ref, date) async {
  final repo = ref.watch(classesRepositoryProvider);
  return await repo.getTrainerClasses(date);
});

final classParticipantsProvider = FutureProvider.family<List<User>, int>((ref, classId) async {
  final repo = ref.watch(classesRepositoryProvider);
  return await repo.getClassParticipants(classId);
});

class BookingNotifier extends StateNotifier<bool> {
  final IClassesRepository _repository;
  final Ref _ref;

  BookingNotifier(this._repository, this._ref) : super(false);

  Future<void> bookClass(int classId) async {
    state = true;
    try {
      await _repository.bookClass(classId);
      _ref.invalidate(classesForDateProvider);
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
      _ref.invalidate(classesForDateProvider);
      state = false;
    } catch (error) {
      state = false;
      rethrow;
    }
  }

  Future<void> deleteClass(int classId) async {
    state = true;
    try {
      await _repository.deleteClass(classId);
      _ref.invalidate(classesForDateProvider);
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