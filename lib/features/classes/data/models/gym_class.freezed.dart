// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gym_class.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

GymClass _$GymClassFromJson(Map<String, dynamic> json) {
  return _GymClass.fromJson(json);
}

/// @nodoc
mixin _$GymClass {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  DateTime get startTime => throw _privateConstructorUsedError;
  DateTime get endTime => throw _privateConstructorUsedError;
  Trainer get trainer => throw _privateConstructorUsedError;
  int get maxParticipants => throw _privateConstructorUsedError;
  int get currentParticipants => throw _privateConstructorUsedError;
  bool get userEnrolled => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;

  /// Serializes this GymClass to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GymClass
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GymClassCopyWith<GymClass> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GymClassCopyWith<$Res> {
  factory $GymClassCopyWith(GymClass value, $Res Function(GymClass) then) =
      _$GymClassCopyWithImpl<$Res, GymClass>;
  @useResult
  $Res call({
    int id,
    String name,
    DateTime startTime,
    DateTime endTime,
    Trainer trainer,
    int maxParticipants,
    int currentParticipants,
    bool userEnrolled,
    String? description,
    String? imageUrl,
  });

  $TrainerCopyWith<$Res> get trainer;
}

/// @nodoc
class _$GymClassCopyWithImpl<$Res, $Val extends GymClass>
    implements $GymClassCopyWith<$Res> {
  _$GymClassCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GymClass
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? trainer = null,
    Object? maxParticipants = null,
    Object? currentParticipants = null,
    Object? userEnrolled = null,
    Object? description = freezed,
    Object? imageUrl = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            startTime: null == startTime
                ? _value.startTime
                : startTime // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            endTime: null == endTime
                ? _value.endTime
                : endTime // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            trainer: null == trainer
                ? _value.trainer
                : trainer // ignore: cast_nullable_to_non_nullable
                      as Trainer,
            maxParticipants: null == maxParticipants
                ? _value.maxParticipants
                : maxParticipants // ignore: cast_nullable_to_non_nullable
                      as int,
            currentParticipants: null == currentParticipants
                ? _value.currentParticipants
                : currentParticipants // ignore: cast_nullable_to_non_nullable
                      as int,
            userEnrolled: null == userEnrolled
                ? _value.userEnrolled
                : userEnrolled // ignore: cast_nullable_to_non_nullable
                      as bool,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            imageUrl: freezed == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of GymClass
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TrainerCopyWith<$Res> get trainer {
    return $TrainerCopyWith<$Res>(_value.trainer, (value) {
      return _then(_value.copyWith(trainer: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GymClassImplCopyWith<$Res>
    implements $GymClassCopyWith<$Res> {
  factory _$$GymClassImplCopyWith(
    _$GymClassImpl value,
    $Res Function(_$GymClassImpl) then,
  ) = __$$GymClassImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String name,
    DateTime startTime,
    DateTime endTime,
    Trainer trainer,
    int maxParticipants,
    int currentParticipants,
    bool userEnrolled,
    String? description,
    String? imageUrl,
  });

  @override
  $TrainerCopyWith<$Res> get trainer;
}

/// @nodoc
class __$$GymClassImplCopyWithImpl<$Res>
    extends _$GymClassCopyWithImpl<$Res, _$GymClassImpl>
    implements _$$GymClassImplCopyWith<$Res> {
  __$$GymClassImplCopyWithImpl(
    _$GymClassImpl _value,
    $Res Function(_$GymClassImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GymClass
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? trainer = null,
    Object? maxParticipants = null,
    Object? currentParticipants = null,
    Object? userEnrolled = null,
    Object? description = freezed,
    Object? imageUrl = freezed,
  }) {
    return _then(
      _$GymClassImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        startTime: null == startTime
            ? _value.startTime
            : startTime // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        endTime: null == endTime
            ? _value.endTime
            : endTime // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        trainer: null == trainer
            ? _value.trainer
            : trainer // ignore: cast_nullable_to_non_nullable
                  as Trainer,
        maxParticipants: null == maxParticipants
            ? _value.maxParticipants
            : maxParticipants // ignore: cast_nullable_to_non_nullable
                  as int,
        currentParticipants: null == currentParticipants
            ? _value.currentParticipants
            : currentParticipants // ignore: cast_nullable_to_non_nullable
                  as int,
        userEnrolled: null == userEnrolled
            ? _value.userEnrolled
            : userEnrolled // ignore: cast_nullable_to_non_nullable
                  as bool,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        imageUrl: freezed == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GymClassImpl extends _GymClass {
  const _$GymClassImpl({
    required this.id,
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.trainer,
    this.maxParticipants = 0,
    this.currentParticipants = 0,
    this.userEnrolled = false,
    this.description,
    this.imageUrl,
  }) : super._();

  factory _$GymClassImpl.fromJson(Map<String, dynamic> json) =>
      _$$GymClassImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final DateTime startTime;
  @override
  final DateTime endTime;
  @override
  final Trainer trainer;
  @override
  @JsonKey()
  final int maxParticipants;
  @override
  @JsonKey()
  final int currentParticipants;
  @override
  @JsonKey()
  final bool userEnrolled;
  @override
  final String? description;
  @override
  final String? imageUrl;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GymClassImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.trainer, trainer) || other.trainer == trainer) &&
            (identical(other.maxParticipants, maxParticipants) ||
                other.maxParticipants == maxParticipants) &&
            (identical(other.currentParticipants, currentParticipants) ||
                other.currentParticipants == currentParticipants) &&
            (identical(other.userEnrolled, userEnrolled) ||
                other.userEnrolled == userEnrolled) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    startTime,
    endTime,
    trainer,
    maxParticipants,
    currentParticipants,
    userEnrolled,
    description,
    imageUrl,
  );

  /// Create a copy of GymClass
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GymClassImplCopyWith<_$GymClassImpl> get copyWith =>
      __$$GymClassImplCopyWithImpl<_$GymClassImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GymClassImplToJson(this);
  }
}

abstract class _GymClass extends GymClass {
  const factory _GymClass({
    required final int id,
    required final String name,
    required final DateTime startTime,
    required final DateTime endTime,
    required final Trainer trainer,
    final int maxParticipants,
    final int currentParticipants,
    final bool userEnrolled,
    final String? description,
    final String? imageUrl,
  }) = _$GymClassImpl;
  const _GymClass._() : super._();

  factory _GymClass.fromJson(Map<String, dynamic> json) =
      _$GymClassImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  DateTime get startTime;
  @override
  DateTime get endTime;
  @override
  Trainer get trainer;
  @override
  int get maxParticipants;
  @override
  int get currentParticipants;
  @override
  bool get userEnrolled;
  @override
  String? get description;
  @override
  String? get imageUrl;

  /// Create a copy of GymClass
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GymClassImplCopyWith<_$GymClassImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
