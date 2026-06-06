import 'package:json_annotation/json_annotation.dart';
import 'package:leaper/models/course_data.dart';
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
  double? grade;
  GradeComponent({required this.component, this.grade});
  factory GradeComponent.fromJson(Map<String, dynamic> json) =>
      _$GradeComponentFromJson(json);
  Map<String, dynamic> toJson() => _$GradeComponentToJson(this);
}

@JsonSerializable()
class GradeList {
  List<GradeComponentData> components;
  List<UserGrade> scores;
  GradeList({required this.components, required this.scores});
  factory GradeList.fromJson(Map<String, dynamic> json) =>
      _$GradeListFromJson(json);
  Map<String, dynamic> toJson() => _$GradeListToJson(this);
}

@JsonSerializable()
class GradeComponentData {
  int id;
  String name;
  GradeComponentData({required this.id, required this.name});
  factory GradeComponentData.fromJson(Map<String, dynamic> json) =>
      _$GradeComponentDataFromJson(json);
  Map<String, dynamic> toJson() => _$GradeComponentDataToJson(this);
}

@JsonSerializable()
class UserGrade {
  CoursePersonHeader user;
  List<double?> grades;
  UserGrade({required this.user, required this.grades});
  factory UserGrade.fromJson(Map<String, dynamic> json) =>
      _$UserGradeFromJson(json);
  Map<String, dynamic> toJson() => _$UserGradeToJson(this);
}
