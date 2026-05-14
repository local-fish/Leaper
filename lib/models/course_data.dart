import 'package:json_annotation/json_annotation.dart';
part 'course_data.g.dart';

@JsonSerializable()
class CourseData {
  String name;
  int id;
  int studentCount;
  int sessionCount;

  CourseData({
    required this.id,
    required this.name,
    required this.studentCount,
    required this.sessionCount,
  });
  static List<CourseData> fromJsonList(List<dynamic> json) {
    return json.map((e) => CourseData.fromJson(e)).toList();
  }

  factory CourseData.fromJson(Map<String, dynamic> json) =>
      _$CourseDataFromJson(json);
  Map<String, dynamic> toJson() => _$CourseDataToJson(this);
}

@JsonSerializable()
class CourseStudentData {
  int id;
  String name;
  String email;
  String role;

  CourseStudentData({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });
  static List<CourseStudentData> fromJsonList(List<dynamic> json) {
    return json.map((e) => CourseStudentData.fromJson(e)).toList();
  }

  factory CourseStudentData.fromJson(Map<String, dynamic> json) =>
      _$CourseStudentDataFromJson(json);
  Map<String, dynamic> toJson() => _$CourseStudentDataToJson(this);
}
