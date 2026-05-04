import 'package:json_annotation/json_annotation.dart';
part 'schedule_data.g.dart';

enum EventType { session, exam }

@JsonSerializable()
class ScheduleData {
  List<ScheduleComponent> components;
  ScheduleData({required this.components});

  factory ScheduleData.fromJson(Map<String, dynamic> json) =>
      _$ScheduleDataFromJson(json);
  Map<String, dynamic> toJson() => _$ScheduleDataToJson(this);
}

@JsonSerializable()
class ScheduleComponent {
  EventType event;
  DateTime day;
  ScheduleComponent({required this.event, required this.day});
  factory ScheduleComponent.fromJson(Map<String, dynamic> json) =>
      _$ScheduleComponentFromJson(json);
  Map<String, dynamic> toJson() => _$ScheduleComponentToJson(this);
}

@JsonSerializable()
class ScheduleDayData {
  List<DayComponent> components;
  ScheduleDayData({required this.components});
  factory ScheduleDayData.fromJson(Map<String, dynamic> json) =>
      _$ScheduleDayDataFromJson(json);
  Map<String, dynamic> toJson() => _$ScheduleDayDataToJson(this);
}

@JsonSerializable()
class DayComponent {
  String className;
  String classId;
  EventType type;
  int? sessionNumber;
  DateTime? start;
  DateTime? end;
  String? location;
  DayComponent({
    required this.className,
    required this.classId,
    required this.type,
    this.sessionNumber,
    this.start,
    this.end,
    this.location,
  });
  factory DayComponent.fromJson(Map<String, dynamic> json) =>
      _$DayComponentFromJson(json);
  Map<String, dynamic> toJson() => _$DayComponentToJson(this);
}
