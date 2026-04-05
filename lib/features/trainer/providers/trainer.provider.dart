import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_client.dart';
import '../data/repositories/trainer_repository.dart';
import '../data/models/trainer.dart';

final trainerRepositoryProvider = Provider<TrainerRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return TrainerRepository(dio);
});

final trainersProvider = FutureProvider.autoDispose<List<Trainer>>((ref) async {
  final repo = ref.watch(trainerRepositoryProvider);
  return await repo.getTrainers();
});