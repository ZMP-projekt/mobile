import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const User._();

  const factory User({
    required int id,
    required String email,
    String? role,
    required String firstName,
    required String lastName,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  String get fullName => '$firstName $lastName';

  String get displayAvatarUrl {

    final seed = (firstName + lastName).codeUnits.fold(0, (a, b) => a + b);
    return 'https://api.dicebear.com/9.x/thumbs/png'
        '?seed=$seed'
        '&shapeColor=00d2d3,ff2a7a,b721ff'
        '&backgroundColor=0a0a14';
  }

  bool get isTrainer => role == 'ROLE_TRAINER' || role == 'ROLE_ADMIN';
}