// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScheduleData _$ScheduleDataFromJson(Map<String, dynamic> json) => ScheduleData(
  components: (json['components'] as List<dynamic>)
      .map((e) => ScheduleComponent.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ScheduleDataToJson(ScheduleData instance) =>
    <String, dynamic>{'components': instance.components};

ScheduleComponent _$ScheduleComponentFromJson(Map<String, dynamic> json) =>
    ScheduleComponent(
      event: $enumDecode(_$EventTypeEnumMap, json['event']),
      day: DateTime.parse(json['day'] as String),
    );

Map<String, dynamic> _$ScheduleComponentToJson(ScheduleComponent instance) =>
    <String, dynamic>{
      'event': _$EventTypeEnumMap[instance.event]!,
      'day': instance.day.toIso8601String(),
    };

const _$EventTypeEnumMap = {EventType.course: 'course', EventType.exam: 'exam'};

ScheduleDayData _$ScheduleDayDataFromJson(Map<String, dynamic> json) =>
    ScheduleDayData(
      components: (json['components'] as List<dynamic>)
          .map((e) => DayComponent.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ScheduleDayDataToJson(ScheduleDayData instance) =>
    <String, dynamic>{'components': instance.components};

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
