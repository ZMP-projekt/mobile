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
  final repo = ref.watch(classesRepositoryProvider);
  return await repo.getClassParticipants(classId);
});

class BookingNotifier extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> bookClass(int classId) async {
    state = const AsyncLoading();
    try {
      await ref.read(classesRepositoryProvider).bookClass(classId);
      ref.invalidate(classesForDateProvider);
      ref.invalidate(todayClassesProvider);
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
      ref.invalidate(classesForDateProvider);
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
      ref.invalidate(classesForDateProvider);
      ref.invalidate(trainerClassesProvider);
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