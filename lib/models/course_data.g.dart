// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CourseData _$CourseDataFromJson(Map<String, dynamic> json) =>
    CourseData(id: (json['id'] as num).toInt(), name: json['name'] as String);

Map<String, dynamic> _$CourseDataToJson(CourseData instance) =>
    <String, dynamic>{'name': instance.name, 'id': instance.id};
