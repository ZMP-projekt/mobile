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

final classesForDateProvider =
    FutureProvider.autoDispose.family<List<GymClass>, DateTime>((ref, date) async {
  final repo = ref.watch(classesRepositoryProvider);
  final selectedLocationId =
      await ref.watch(effectiveSelectedLocationIdProvider.future);

  if (selectedLocationId != null) {
    final locationClasses = await repo.getClassesByLocation(selectedLocationId);

    return locationClasses.where((c) {
      return c.startTime.year == date.year &&
          c.startTime.month == date.month &&
          c.startTime.day == date.day;
    }).toList();
  }

  return await repo.getClassesByDate(date);
});

final trainerLocationFilterProvider = StateProvider<int?>((ref) => null);

final trainerClassesProvider = FutureProvider.autoDispose
    .family<List<GymClass>, DateTime>((ref, date) async {
  final repo = ref.watch(classesRepositoryProvider);
  final allClasses = await repo.getTrainerClasses(date);

  final filterLocationId = ref.watch(trainerLocationFilterProvider);

  if (filterLocationId == null) return allClasses;

  return allClasses.where((c) => c.locationId == filterLocationId).toList();
});

final todayClassesProvider =
    FutureProvider.autoDispose<List<GymClass>>((ref) async {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  final classes = await ref.watch(classesForDateProvider(today).future);

  return classes.where((c) => c.isFuture).toList();
});

final classParticipantsProvider =
    FutureProvider.autoDispose.family<List<User>, int>((ref, classId) async {
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
      state = const AsyncData(null);
    } catch (error, stack) {
      state = AsyncError(error, stack);
      rethrow;
    } finally {
      _refreshAllClasses(null);
    }
  }

  Future<void> rescheduleClass(int classId, DateTime newTime) async {
    state = const AsyncLoading();
    try {
      await ref
          .read(classesRepositoryProvider)
          .rescheduleClass(classId, newTime);
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
      state = const AsyncData(null);
    } catch (error, stack) {
      state = AsyncError(error, stack);
      rethrow;
    } finally {
      _refreshAllClasses(classId);
    }
  }
}

final bookingNotifierProvider =
    AsyncNotifierProvider.autoDispose<BookingNotifier, void>(
  BookingNotifier.new,
);
