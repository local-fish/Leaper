// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DayComponent _$DayComponentFromJson(Map<String, dynamic> json) => DayComponent(
  courseName: json['courseName'] as String,
  courseId: (json['courseId'] as num).toInt(),
  sessionName: json['sessionName'] as String,
  sessionId: (json['sessionId'] as num).toInt(),
  type: $enumDecode(_$EventTypeEnumMap, json['type']),
  sessionNumber: (json['sessionNumber'] as num?)?.toInt(),
  startTime: json['startTime'] == null
      ? null
      : DateTime.parse(json['startTime'] as String),
  endTime: json['endTime'] == null
      ? null
      : DateTime.parse(json['endTime'] as String),
  location: json['location'] as String?,
);

Map<String, dynamic> _$DayComponentToJson(DayComponent instance) =>
    <String, dynamic>{
      'courseName': instance.courseName,
      'courseId': instance.courseId,
      'sessionName': instance.sessionName,
      'sessionId': instance.sessionId,
      'type': _$EventTypeEnumMap[instance.type]!,
      'sessionNumber': instance.sessionNumber,
      'startTime': instance.startTime?.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
      'location': instance.location,
    };

const _$EventTypeEnumMap = {EventType.course: 'course', EventType.exam: 'exam'};
