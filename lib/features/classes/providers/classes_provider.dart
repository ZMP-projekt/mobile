import 'dart:async';
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

final classesForDateProvider = FutureProvider.autoDispose.family<List<GymClass>, DateTime>((ref, date) async {
  final repo = ref.watch(classesRepositoryProvider);
  return await repo.getClassesByDate(date);
});

final todayClassesProvider = FutureProvider.autoDispose<List<GymClass>>((ref) async {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final classes = await ref.watch(classesForDateProvider(today).future);
  return classes.where((c) => c.isFuture).toList();
});

final trainerClassesProvider = FutureProvider.autoDispose.family<List<GymClass>, DateTime>((ref, date) async {
  final repo = ref.watch(classesRepositoryProvider);
  return await repo.getTrainerClasses(date);
});

final classParticipantsProvider = FutureProvider.autoDispose.family<List<User>, int>((ref, classId) async {
  return ref.watch(classesRepositoryProvider).getClassParticipants(classId);
});

class BookingNotifier extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> bookClass(int classId) async {
    state = const AsyncLoading();
    try {
      await ref.read(classesRepositoryProvider).bookClass(classId);
      await Future.delayed(const Duration(milliseconds: 300));

      ref.invalidate(classesForDateProvider);
      ref.invalidate(todayClassesProvider);
      ref.invalidate(classParticipantsProvider(classId));

      state = const AsyncData(null);
    } catch (error, stack) {
      state = AsyncError(error, stack);
      rethrow;
    }
  }

  Future<void> cancelBooking(int classId) async {
    state = const AsyncLoading();
    try {
      await ref.read(classesRepositoryProvider).cancelBooking(classId);
      await Future.delayed(const Duration(milliseconds: 300));

      ref.invalidate(classesForDateProvider);
      ref.invalidate(todayClassesProvider);
      ref.invalidate(classParticipantsProvider(classId));

      state = const AsyncData(null);
    } catch (error, stack) {
      state = AsyncError(error, stack);
      rethrow;
    }
  }

  Future<void> createClass(Map<String, dynamic> classData) async {
    state = const AsyncLoading();
    try {
      await ref.read(classesRepositoryProvider).createClass(classData);
      await Future.delayed(const Duration(milliseconds: 300));

      final startTimeStr = classData['startTime'] as String;
      final classDate = DateTime.parse(startTimeStr);
      final targetDate = DateTime(
          classDate.year, classDate.month, classDate.day);

      ref.invalidate(classesForDateProvider(targetDate));
      ref.invalidate(trainerClassesProvider(targetDate));
      ref.invalidate(todayClassesProvider);

      final selectedDate = ref.read(selectedDateProvider);
      if (selectedDate != targetDate) {
        ref.invalidate(classesForDateProvider(selectedDate));
        ref.invalidate(trainerClassesProvider(selectedDate));
      }

      state = const AsyncData(null);
    } catch (error, stack) {
      state = AsyncError(error, stack);
      rethrow;
    }
  }

  Future<void> rescheduleClass(int classId, DateTime newTime) async {
    state = const AsyncLoading();
    try {
      await ref.read(classesRepositoryProvider).rescheduleClass(
          classId, newTime);
      await Future.delayed(const Duration(milliseconds: 300));

      final targetDate = DateTime(newTime.year, newTime.month, newTime.day);
      final selectedDate = ref.read(selectedDateProvider);

      ref.invalidate(classesForDateProvider(targetDate));
      ref.invalidate(trainerClassesProvider(targetDate));
      ref.invalidate(classesForDateProvider(selectedDate));
      ref.invalidate(trainerClassesProvider(selectedDate));
      ref.invalidate(todayClassesProvider);

      state = const AsyncData(null);
    } catch (error, stack) {
      state = AsyncError(error, stack);
      rethrow;
    }
  }

  Future<void> deleteClass(int classId) async {
    state = const AsyncLoading();
    try {
      await ref.read(classesRepositoryProvider).deleteClass(classId);
      await Future.delayed(const Duration(milliseconds: 300));

      final selectedDate = ref.read(selectedDateProvider);
      ref.invalidate(classesForDateProvider(selectedDate));
      ref.invalidate(trainerClassesProvider(selectedDate));
      ref.invalidate(todayClassesProvider);

      state = const AsyncData(null);
    } catch (error, stack) {
      state = AsyncError(error, stack);
      rethrow;
    }
  }
}

final bookingNotifierProvider = AsyncNotifierProvider.autoDispose<BookingNotifier, void>(
  BookingNotifier.new,
);