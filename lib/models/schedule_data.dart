import 'package:json_annotation/json_annotation.dart';
part 'schedule_data.g.dart';

enum EventType { course, exam }

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
