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

const _$EventTypeEnumMap = {
  EventType.session: 'session',
  EventType.exam: 'exam',
};

ScheduleDayData _$ScheduleDayDataFromJson(Map<String, dynamic> json) =>
    ScheduleDayData(
      components: (json['components'] as List<dynamic>)
          .map((e) => DayComponent.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ScheduleDayDataToJson(ScheduleDayData instance) =>
    <String, dynamic>{'components': instance.components};

DayComponent _$DayComponentFromJson(Map<String, dynamic> json) => DayComponent(
  className: json['className'] as String,
  classId: json['classId'] as String,
  type: $enumDecode(_$EventTypeEnumMap, json['type']),
  sessionNumber: (json['sessionNumber'] as num?)?.toInt(),
  start: json['start'] == null ? null : DateTime.parse(json['start'] as String),
  end: json['end'] == null ? null : DateTime.parse(json['end'] as String),
  location: json['location'] as String?,
);

Map<String, dynamic> _$DayComponentToJson(DayComponent instance) =>
    <String, dynamic>{
      'className': instance.className,
      'classId': instance.classId,
      'type': _$EventTypeEnumMap[instance.type]!,
      'sessionNumber': instance.sessionNumber,
      'start': instance.start?.toIso8601String(),
      'end': instance.end?.toIso8601String(),
      'location': instance.location,
    };
