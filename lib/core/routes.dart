import 'package:flutter/material.dart';
import 'package:leaper/pages/courses/course_detail.dart';
import 'package:leaper/pages/dashboard/course.dart';
import 'package:leaper/pages/dashboard/grades.dart';
import 'package:leaper/pages/dashboard/tasks.dart';
import 'package:leaper/pages/forum/forum.dart';
import 'package:leaper/pages/forum/forum_new_post.dart';
import 'package:leaper/pages/forum/forum_post.dart';
import 'package:leaper/pages/main_layout.dart';
import 'package:leaper/main.dart';
import 'package:leaper/pages/dashboard/schedule.dart';
import 'package:leaper/pages/login_page.dart';

final Map<String, WidgetBuilder> routes = {
  '/': (context) => AuthCheck(),
  '/main': (context) => MainLayout(),
  '/login': (context) => LoginPage(),

  // Subpages
  '/schedule': (context) => Schedule(),
  '/grades': (context) => Grades(),
  '/tasks': (context) => Tasks(),
  '/course': (context) => Course(),

  // Course Root
  '/course/detail': (context) => CourseDetail(),

  // Forum
  '/forum': (context) => Forum(),
  '/forum/post': (context) => ForumPost(),
  '/forum/post/new': (context) => ForumNewPost(),
};
