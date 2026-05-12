import 'package:json_annotation/json_annotation.dart';
part 'course_data.g.dart';

@JsonSerializable()
class CourseData {
  String name;
  int id;

  CourseData({required this.id, required this.name});
  static List<CourseData> fromJsonList(List<dynamic> json) {
    return json.map((e) => CourseData.fromJson(e)).toList();
  }

  factory CourseData.fromJson(Map<String, dynamic> json) =>
      _$CourseDataFromJson(json);
  Map<String, dynamic> toJson() => _$CourseDataToJson(this);
}
