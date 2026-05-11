import 'package:json_annotation/json_annotation.dart';
part 'schedule_data.g.dart';

enum EventType { course, exam }

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
  String courseName;
  int courseId;
  String sessionName;
  int sessionId;
  EventType type;
  int? sessionNumber;
  DateTime? startTime;
  DateTime? endTime;
  String? location;
  DayComponent({
    required this.courseName,
    required this.courseId,
    required this.sessionName,
    required this.sessionId,
    required this.type,
    this.sessionNumber,
    this.startTime,
    this.endTime,
    this.location,
  });
  factory DayComponent.fromJson(Map<String, dynamic> json) =>
      _$DayComponentFromJson(json);
  Map<String, dynamic> toJson() => _$DayComponentToJson(this);
}
