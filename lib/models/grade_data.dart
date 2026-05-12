import 'package:json_annotation/json_annotation.dart';
part 'grade_data.g.dart';

@JsonSerializable()
class GradeData {
  int courseId;
  String courseName;
  List<GradeComponent> components;
  GradeData({
    required this.courseId,
    required this.courseName,
    required this.components,
  });

  static List<GradeData> fromJsonList(List<dynamic> json) {
    return json.map((e) => GradeData.fromJson(e)).toList();
  }

  factory GradeData.fromJson(Map<String, dynamic> json) =>
      _$GradeDataFromJson(json);
  Map<String, dynamic> toJson() => _$GradeDataToJson(this);
}

@JsonSerializable()
class GradeComponent {
  String component;
  double grade;
  GradeComponent({required this.component, required this.grade});
  factory GradeComponent.fromJson(Map<String, dynamic> json) =>
      _$GradeComponentFromJson(json);
  Map<String, dynamic> toJson() => _$GradeComponentToJson(this);
}
