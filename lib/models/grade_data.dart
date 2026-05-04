import 'package:json_annotation/json_annotation.dart';

part 'grade_data.g.dart'; // this file gets auto-generated

@JsonSerializable()
class GradeData {
  List<GradeComponent> components;
  GradeData({required this.components});

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
