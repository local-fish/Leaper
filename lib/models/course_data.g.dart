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
  lecturers: (json['lecturers'] as List<dynamic>?)
      ?.map((e) => CoursePersonHeader.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$CourseDataToJson(CourseData instance) =>
    <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'studentCount': instance.studentCount,
      'sessionCount': instance.sessionCount,
      'lecturers': instance.lecturers,
    };

CoursePersonHeader _$CoursePersonHeaderFromJson(Map<String, dynamic> json) =>
    CoursePersonHeader(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$CoursePersonHeaderToJson(CoursePersonHeader instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};

CoursePersonData _$CoursePersonDataFromJson(Map<String, dynamic> json) =>
    CoursePersonData(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
    );

Map<String, dynamic> _$CoursePersonDataToJson(CoursePersonData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'role': instance.role,
    };

CourseSessionData _$CourseSessionDataFromJson(Map<String, dynamic> json) =>
    CourseSessionData(
      topic: json['topic'] as String,
      id: (json['id'] as num).toInt(),
      sessionNo: (json['sessionNo'] as num).toInt(),
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      location: json['location'] as String,
      files: (json['files'] as List<dynamic>?)
          ?.map((e) => FileData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CourseSessionDataToJson(CourseSessionData instance) =>
    <String, dynamic>{
      'topic': instance.topic,
      'id': instance.id,
      'sessionNo': instance.sessionNo,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'location': instance.location,
      'files': instance.files,
    };

FileData _$FileDataFromJson(Map<String, dynamic> json) => FileData(
  id: json['id'] as String,
  name: json['name'] as String,
  size: (json['size'] as num).toInt(),
);

Map<String, dynamic> _$FileDataToJson(FileData instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'size': instance.size,
};
