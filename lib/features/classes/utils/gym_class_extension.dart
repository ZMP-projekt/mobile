import '../data/models/gym_class.dart';

extension GymClassImageExt on GymClass {
  String get displayImageUrl {
    return imageUrl?.trim() ?? '';
  }
}
