import 'package:freezed_annotation/freezed_annotation.dart';

part 'trainer.freezed.dart';
part 'trainer.g.dart';

@freezed
class Trainer with _$Trainer {
  const Trainer._();

  const factory Trainer({
    required String firstName,
    required String lastName,
    String? photoUrl,
  }) = _Trainer;

  String get fullName => '$firstName $lastName';

  String get displayAvatarUrl {
    if (photoUrl != null) return photoUrl!;
    final seed = '${firstName.trim().toLowerCase()}${lastName.trim().toLowerCase()}';
    return 'https://api.dicebear.com/9.x/thumbs/png?seed=$seed&shapeColor=00d2d3,ff2a7a,b721ff&backgroundColor=0a0a14';
  }
  factory Trainer.fromJson(Map<String, dynamic> json) => _$TrainerFromJson(json);
}