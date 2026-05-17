// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forum_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ForumData _$ForumDataFromJson(Map<String, dynamic> json) => ForumData(
  courseId: (json['courseId'] as num?)?.toInt(),
  id: (json['id'] as num).toInt(),
  time: DateTime.parse(json['time'] as String),
  title: json['title'] as String,
  body: json['body'] as String?,
  user: ForumPersonData.fromJson(json['user'] as Map<String, dynamic>),
  comments: (json['comments'] as num?)?.toInt(),
);

Map<String, dynamic> _$ForumDataToJson(ForumData instance) => <String, dynamic>{
  'courseId': instance.courseId,
  'id': instance.id,
  'time': instance.time.toIso8601String(),
  'title': instance.title,
  'body': instance.body,
  'user': instance.user,
  'comments': instance.comments,
};

ForumPersonData _$ForumPersonDataFromJson(Map<String, dynamic> json) =>
    ForumPersonData(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$ForumPersonDataToJson(ForumPersonData instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};

CommentData _$CommentDataFromJson(Map<String, dynamic> json) => CommentData(
  id: (json['id'] as num).toInt(),
  time: DateTime.parse(json['time'] as String),
  body: json['body'] as String,
  user: ForumPersonData.fromJson(json['user'] as Map<String, dynamic>),
  replies: (json['replies'] as num).toInt(),
);

Map<String, dynamic> _$CommentDataToJson(CommentData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'time': instance.time.toIso8601String(),
      'body': instance.body,
      'user': instance.user,
      'replies': instance.replies,
    };
