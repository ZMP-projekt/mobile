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

  factory Trainer.fromJson(Map<String, dynamic> json) =>
      _$TrainerFromJson(json);
}
