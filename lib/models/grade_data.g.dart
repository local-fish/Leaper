// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grade_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GradeData _$GradeDataFromJson(Map<String, dynamic> json) => GradeData(
  courseId: (json['courseId'] as num).toInt(),
  courseName: json['courseName'] as String,
  components: (json['components'] as List<dynamic>)
      .map((e) => GradeComponent.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$GradeDataToJson(GradeData instance) => <String, dynamic>{
  'courseId': instance.courseId,
  'courseName': instance.courseName,
  'components': instance.components,
};

GradeComponent _$GradeComponentFromJson(Map<String, dynamic> json) =>
    GradeComponent(
      component: json['component'] as String,
      grade: (json['grade'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$GradeComponentToJson(GradeComponent instance) =>
    <String, dynamic>{'component': instance.component, 'grade': instance.grade};

GradeList _$GradeListFromJson(Map<String, dynamic> json) => GradeList(
  components: (json['components'] as List<dynamic>)
      .map((e) => GradeComponentData.fromJson(e as Map<String, dynamic>))
      .toList(),
  scores: (json['scores'] as List<dynamic>)
      .map((e) => UserGrade.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$GradeListToJson(GradeList instance) => <String, dynamic>{
  'components': instance.components,
  'scores': instance.scores,
};

GradeComponentData _$GradeComponentDataFromJson(Map<String, dynamic> json) =>
    GradeComponentData(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$GradeComponentDataToJson(GradeComponentData instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};

UserGrade _$UserGradeFromJson(Map<String, dynamic> json) => UserGrade(
  user: CoursePersonHeader.fromJson(json['user'] as Map<String, dynamic>),
  grades: (json['grades'] as List<dynamic>)
      .map((e) => (e as num?)?.toDouble())
      .toList(),
);

Map<String, dynamic> _$UserGradeToJson(UserGrade instance) => <String, dynamic>{
  'user': instance.user,
  'grades': instance.grades,
};
