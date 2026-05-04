// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grade_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GradeData _$GradeDataFromJson(Map<String, dynamic> json) => GradeData(
  components: (json['components'] as List<dynamic>)
      .map((e) => GradeComponent.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$GradeDataToJson(GradeData instance) => <String, dynamic>{
  'components': instance.components,
};

GradeComponent _$GradeComponentFromJson(Map<String, dynamic> json) =>
    GradeComponent(
      component: json['component'] as String,
      grade: (json['grade'] as num).toDouble(),
    );

Map<String, dynamic> _$GradeComponentToJson(GradeComponent instance) =>
    <String, dynamic>{'component': instance.component, 'grade': instance.grade};
