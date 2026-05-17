import 'package:json_annotation/json_annotation.dart';
part 'forum_data.g.dart';

@JsonSerializable()
class ForumData {
  int? courseId;
  int id;
  DateTime time;
  String title;
  String? body;
  ForumPersonData user;
  int? comments;

  ForumData({
    this.courseId,
    required this.id,
    required this.time,
    required this.title,
    this.body,
    required this.user,
    this.comments,
  });
  static List<ForumData> fromJsonList(List<dynamic> json) {
    return json.map((e) => ForumData.fromJson(e)).toList();
  }

  factory ForumData.fromJson(Map<String, dynamic> json) =>
      _$ForumDataFromJson(json);
  Map<String, dynamic> toJson() => _$ForumDataToJson(this);
}

@JsonSerializable()
class ForumPersonData {
  int id;
  String name;

  ForumPersonData({required this.id, required this.name});

  static List<ForumPersonData> fromJsonList(List<dynamic> json) {
    return json.map((e) => ForumPersonData.fromJson(e)).toList();
  }

  factory ForumPersonData.fromJson(Map<String, dynamic> json) =>
      _$ForumPersonDataFromJson(json);
  Map<String, dynamic> toJson() => _$ForumPersonDataToJson(this);
}

@JsonSerializable()
class CommentData {
  int id;
  DateTime time;
  String body;
  ForumPersonData user;
  int replies;

  CommentData({
    required this.id,
    required this.time,
    required this.body,
    required this.user,
    required this.replies,
  });
  static List<CommentData> fromJsonList(List<dynamic> json) {
    return json.map((e) => CommentData.fromJson(e)).toList();
  }

  factory CommentData.fromJson(Map<String, dynamic> json) =>
      _$CommentDataFromJson(json);
  Map<String, dynamic> toJson() => _$CommentDataToJson(this);
}
