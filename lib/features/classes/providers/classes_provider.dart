import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_client.dart';
import '../../locations/providers/location_provider.dart';
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

final classesForDateProvider = FutureProvider.autoDispose.family<List<GymClass>, DateTime>((ref, date) async {
  final repo = ref.watch(classesRepositoryProvider);
  final selectedLocationId = ref.watch(selectedLocationIdProvider);

  List<GymClass> classes;

  if (selectedLocationId != null) {
    classes = await repo.getClassesByLocation(selectedLocationId);

    classes = classes.where((c) =>
    c.startTime.year == date.year &&
        c.startTime.month == date.month &&
        c.startTime.day == date.day
    ).toList();
  } else {
    classes = await repo.getClassesByDate(date);
  }

  return classes;
});

final trainerClassesProvider = FutureProvider.autoDispose.family<List<GymClass>, DateTime>((ref, date) async {
  final repo = ref.watch(classesRepositoryProvider);
  final allTrainerClasses = await repo.getTrainerClasses(date);

  final selectedLocationId = ref.watch(selectedLocationIdProvider);
  if (selectedLocationId == null) return allTrainerClasses;

  return allTrainerClasses.where((c) => c.locationId == selectedLocationId).toList();
});

final todayClassesProvider = FutureProvider.autoDispose<List<GymClass>>((ref) async {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  final classes = await ref.watch(classesForDateProvider(today).future);

  return classes.where((c) => c.isFuture).toList();
});

final classParticipantsProvider = FutureProvider.autoDispose.family<List<User>, int>((ref, classId) async {
  return ref.watch(classesRepositoryProvider).getClassParticipants(classId);
});

class BookingNotifier extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  void _refreshAllClasses(int? classId) {
    ref.invalidate(classesForDateProvider);
    ref.invalidate(todayClassesProvider);
    ref.invalidate(trainerClassesProvider);
    if (classId != null) {
      ref.invalidate(classParticipantsProvider(classId));
    }
  }

  Future<void> bookClass(int classId) async {
    state = const AsyncLoading();
    try {
      await ref.read(classesRepositoryProvider).bookClass(classId);
      await Future.delayed(const Duration(milliseconds: 300));
      state = const AsyncData(null);
    } catch (error, stack) {
      state = AsyncError(error, stack);
      rethrow;
    } finally {
      _refreshAllClasses(classId);
    }
  }

  Future<void> cancelBooking(int classId) async {
    state = const AsyncLoading();
    try {
      await ref.read(classesRepositoryProvider).cancelBooking(classId);
      await Future.delayed(const Duration(milliseconds: 300));
      state = const AsyncData(null);
    } catch (error, stack) {
      state = AsyncError(error, stack);
      rethrow;
    } finally {
      _refreshAllClasses(classId);
    }
  }

  Future<void> createClass(Map<String, dynamic> classData) async {
    state = const AsyncLoading();
    try {
      await ref.read(classesRepositoryProvider).createClass(classData);
      await Future.delayed(const Duration(milliseconds: 300));
      state = const AsyncData(null);
    } catch (error, stack) {
      if (error.toString().contains('500') || error.toString().contains('Internal Server Error')) {
        state = const AsyncData(null);
      } else {
        state = AsyncError(error, stack);
        rethrow;
      }
    } finally {
      _refreshAllClasses(null);
    }
  }

  Future<void> rescheduleClass(int classId, DateTime newTime) async {
    state = const AsyncLoading();
    try {
      await ref.read(classesRepositoryProvider).rescheduleClass(classId, newTime);
      await Future.delayed(const Duration(milliseconds: 300));
      state = const AsyncData(null);
    } catch (error, stack) {
      state = AsyncError(error, stack);
      rethrow;
    } finally {
      _refreshAllClasses(classId);
    }
  }

  Future<void> deleteClass(int classId) async {
    state = const AsyncLoading();
    try {
      await ref.read(classesRepositoryProvider).deleteClass(classId);
      await Future.delayed(const Duration(milliseconds: 300));
      state = const AsyncData(null);
    } catch (error, stack) {
      state = AsyncError(error, stack);
      rethrow;
    } finally {
      _refreshAllClasses(classId);
    }
  }
}

final bookingNotifierProvider = AsyncNotifierProvider.autoDispose<BookingNotifier, void>(
  BookingNotifier.new,
);