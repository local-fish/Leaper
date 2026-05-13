// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CourseData _$CourseDataFromJson(Map<String, dynamic> json) => CourseData(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  studentCount: (json['studentCount'] as num).toInt(),
  sessionCount: (json['sessionCount'] as num).toInt(),
);

Map<String, dynamic> _$CourseDataToJson(CourseData instance) =>
    <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'studentCount': instance.studentCount,
      'sessionCount': instance.sessionCount,
    };
