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

@JsonSerializable()
class CourseSessionData {
  String topic;
  int id;
  int sessionNo;
  DateTime startTime;
  DateTime endTime;
  String location;
  List<FileData>? files;

  CourseSessionData({
    required this.topic,
    required this.id,
    required this.sessionNo,
    required this.startTime,
    required this.endTime,
    required this.location,
    this.files,
  });
  static List<CourseSessionData> fromJsonList(List<dynamic> json) {
    return json.map((e) => CourseSessionData.fromJson(e)).toList();
  }

  factory CourseSessionData.fromJson(Map<String, dynamic> json) =>
      _$CourseSessionDataFromJson(json);
  Map<String, dynamic> toJson() => _$CourseSessionDataToJson(this);
}

@JsonSerializable()
class FileData {
  String id;
  String name;
  int size;

  FileData({required this.id, required this.name, required this.size});
  static List<FileData> fromJsonList(List<dynamic> json) {
    return json.map((e) => FileData.fromJson(e)).toList();
  }

  factory FileData.fromJson(Map<String, dynamic> json) =>
      _$FileDataFromJson(json);
  Map<String, dynamic> toJson() => _$FileDataToJson(this);
}
