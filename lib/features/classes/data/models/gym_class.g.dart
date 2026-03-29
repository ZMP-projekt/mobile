// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gym_class.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GymClassImpl _$$GymClassImplFromJson(Map<String, dynamic> json) =>
    _$GymClassImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      trainer: Trainer.fromJson(json['trainer'] as Map<String, dynamic>),
      maxParticipants: (json['maxParticipants'] as num).toInt(),
      currentParticipants: (json['currentParticipants'] as num).toInt(),
      isBookedByUser: json['isBookedByUser'] as bool? ?? false,
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
    );

Map<String, dynamic> _$$GymClassImplToJson(_$GymClassImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'trainer': instance.trainer,
      'maxParticipants': instance.maxParticipants,
      'currentParticipants': instance.currentParticipants,
      'isBookedByUser': instance.isBookedByUser,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
    };
