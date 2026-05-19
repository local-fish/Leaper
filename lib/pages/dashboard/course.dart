import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:leaper/core/components/back_nav_heading.dart';
import 'package:leaper/core/components/heading_card.dart';
import 'package:leaper/core/components/scaffold_background.dart';
import 'package:leaper/core/styles/text_styles/font_sizes.dart';
import 'package:leaper/models/course_data.dart';
import 'package:leaper/pages/courses/course_detail.dart';
import 'package:leaper/providers/auth_provider.dart';

class Course extends ConsumerStatefulWidget {
  const Course({super.key});

  @override
  ConsumerState<Course> createState() => _CourseState();
}

class _CourseState extends ConsumerState<Course> {
  Future<List<CourseData>> fetchCourses(WidgetRef ref) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/courses'),
      headers: {'Authorization': 'Bearer ${ref.read(authProvider).value}'},
    );

    if (response.statusCode == 200) {
      final list = jsonDecode(response.body) as List;

      return CourseData.fromJsonList(list);
    } else {
      throw Exception('Failed to fetch courses');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldBackground(
      child: Center(
        child: Column(
          children: [
            BackNavHeading(heading: "Courses"),
            Expanded(
              child: FutureBuilder<List<CourseData>>(
                future: fetchCourses(ref),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Something went wrong'));
                  }
                  final course = snapshot.data!;
                  if (course.isEmpty) {
                    return Center(
                      child: Text("You have no courses you are enrolled in!"),
                    );
                  } else {
                    return Padding(
                      padding: EdgeInsets.all(8),
                      child: CourseListItem(items: course),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CourseListItem extends StatelessWidget {
  final List<CourseData> items;
  const CourseListItem({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (context, index) => SizedBox(height: 12),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              '/course/detail',
              arguments: CourseDetailArgs(courseId: items[index].id),
            );
          },
          child: HeadingCard(
            heading: Padding(
              padding: EdgeInsets.only(left: 12),
              child: Text(
                items[index].name,
                style: GoogleFonts.montserrat(
                  fontSize: FontSizes.small,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            content: Padding(
              padding: EdgeInsets.all(4),
              child: Table(
                columnWidths: <int, TableColumnWidth>{
                  0: IntrinsicColumnWidth(),
                  1: FlexColumnWidth(),
                },
                children: <TableRow>[
                  TableRow(
                    children: [
                      Text(
                        "Lecturer${items[index].lecturers!.length > 1 ? 's' : ''}",
                      ),
                      Text(
                        ": ${items[index].lecturers!.map((l) => l.name).join(', ')}",
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Text("Students"),
                      Text(": ${items[index].studentCount.toString()}"),
                    ],
                  ),
                  TableRow(
                    children: [
                      Text("Sessions"),
                      Text(": ${items[index].sessionCount.toString()}"),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
