import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leaper/models/course_data.dart';

class CoursesCacheNotifier extends Notifier<List<CourseData>> {
  @override
  List<CourseData> build() => [];

  void setCache(List<CourseData> courses) => state = courses;
}

final coursesCacheProvider =
    NotifierProvider<CoursesCacheNotifier, List<CourseData>>(
      CoursesCacheNotifier.new,
    );

class CacheTimeNotifier extends Notifier<DateTime?> {
  @override
  DateTime? build() => null;

  void setTime(DateTime time) => state = time;
}

final coursesCacheTimeProvider = NotifierProvider<CacheTimeNotifier, DateTime?>(
  CacheTimeNotifier.new,
);

