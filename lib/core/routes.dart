import 'package:flutter/material.dart';
import 'package:leaper/pages/dashboard/grades.dart';
import 'package:leaper/pages/dashboard/tasks.dart';
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
};
