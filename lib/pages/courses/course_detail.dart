import 'package:flutter/material.dart';
import 'package:leaper/core/components/scaffold_background.dart';

class CourseDetailArgs {
  final int courseId;
  CourseDetailArgs({required this.courseId});
}

class CourseDetail extends StatelessWidget {
  const CourseDetail({super.key});
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as CourseDetailArgs;
    return ScaffoldBackground(
      child: Center(
        child: Text(
          textAlign: TextAlign.center,
          "You accessed ${args.courseId}",
        ),
      ),
    );
  }
}
