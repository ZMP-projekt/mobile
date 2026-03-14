import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/gym_class.dart';
import '../data/repositories/mock_classes_repository.dart';

/// Provider dla Classes Repository (Mock version)
final classesRepositoryProvider = Provider<MockClassesRepository>((ref) {
  return MockClassesRepository();
});

/// Provider dla wszystkich zajęć
final allClassesProvider = FutureProvider<List<GymClass>>((ref) async {
  final repo = ref.watch(classesRepositoryProvider);
  return await repo.getAllClasses();
});

/// Provider dla zajęć użytkownika (zapisane)
final myClassesProvider = FutureProvider<List<GymClass>>((ref) async {
  final repo = ref.watch(classesRepositoryProvider);
  return await repo.getMyClasses();
});

/// Provider dla dzisiejszych zajęć (do Dashboard)
final todayClassesProvider = FutureProvider<List<GymClass>>((ref) async {
  final allClasses = await ref.watch(allClassesProvider.future);
  return allClasses.where((c) => c.isToday && c.isFuture).toList();
});

/// StateNotifier dla booking actions
class BookingNotifier extends StateNotifier<bool> {
  final MockClassesRepository _repository;
  final Ref _ref;

  BookingNotifier(this._repository, this._ref) : super(false);

  /// Zapisz się na zajęcia
  Future<void> bookClass(int classId) async {
    state = true; // Loading

    try {
      await _repository.bookClass(classId);

      // Odśwież listy zajęć - TO WYMUSZA PONOWNE POBRANIE
      _ref.invalidate(allClassesProvider);
      _ref.invalidate(myClassesProvider);
      _ref.invalidate(todayClassesProvider);

      state = false; // Done
    } catch (error, stackTrace) {
      state = false; // Error
      rethrow;
    }
  }

  /// Wypisz się z zajęć
  Future<void> cancelBooking(int classId) async {
    state = true; // Loading

    try {
      await _repository.cancelBooking(classId);

      // Odśwież listy zajęć
      _ref.invalidate(allClassesProvider);
      _ref.invalidate(myClassesProvider);
      _ref.invalidate(todayClassesProvider);

      state = false; // Done
    } catch (error, stackTrace) {
      state = false; // Error
      rethrow;
    }
  }
}

/// Provider dla booking actions (bool = isLoading)
final bookingNotifierProvider = StateNotifierProvider<BookingNotifier, bool>((ref) {
  final repository = ref.watch(classesRepositoryProvider);
  return BookingNotifier(repository, ref);
});