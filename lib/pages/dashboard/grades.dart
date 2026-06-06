import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:leaper/core/components/back_nav_heading.dart';
import 'package:leaper/core/components/heading_card.dart';
import 'package:leaper/core/components/info_grid.dart';
import 'package:leaper/core/components/scaffold_background.dart';
import 'package:leaper/core/styles/text_styles/font_sizes.dart';
import 'package:leaper/models/course_data.dart';
import 'package:leaper/models/grade_data.dart';
import 'package:leaper/pages/courses/course_detail.dart';
import 'package:leaper/pages/courses/edit_grades.dart';
import 'package:leaper/providers/api_provider.dart';
import 'package:leaper/providers/auth_provider.dart';
import 'package:leaper/providers/user_info_provider.dart';

class Grades extends ConsumerStatefulWidget {
  const Grades({super.key});
  @override
  ConsumerState<Grades> createState() => _GradesState();
}

class _GradesState extends ConsumerState<Grades> {
  String _query = "";
  Future<List<GradeData>>? gradesFuture;
  Future<List<CourseData>>? coursesFuture;

  @override
  void initState() {
    super.initState();
    final isTeacher = ref.read(userInfoProvider).value?.role == 'Teacher';
    if (isTeacher) {
      coursesFuture = fetchCourses();
    } else {
      gradesFuture = fetchGrades();
    }
  }

  Future<List<GradeData>> fetchGrades() async {
    final response = await http.get(
      Uri.parse('${ref.read(apiProvider).value}/grades'),
      headers: {'Authorization': 'Bearer ${ref.read(authProvider).value}'},
    );
    if (response.statusCode == 200) {
      final list = jsonDecode(response.body) as List;
      return list.map((e) => GradeData.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch grades');
    }
  }

  Future<List<CourseData>> fetchCourses() async {
    final response = await http.get(
      Uri.parse('${ref.read(apiProvider).value}/courses'),
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
    final isTeacher = ref.read(userInfoProvider).value?.role == 'Teacher';
    return ScaffoldBackground(
      child: Center(
        child: Column(
          children: [
            BackNavHeading(heading: isTeacher ? "Grade Editor" : "Grades"),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: TextField(
                onChanged: (value) => setState(() => _query = value),
                decoration: InputDecoration(
                  hintText: "Search courses...",
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(vertical: 4),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: isTeacher
                  ? FutureBuilder<List<CourseData>>(
                      future: coursesFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Something went wrong'));
                        }
                        final courses = snapshot.data!
                            .where(
                              (c) => c.name.toLowerCase().contains(
                                _query.toLowerCase(),
                              ),
                            )
                            .toList();
                        if (courses.isEmpty) {
                          return Center(child: Text("You have no courses!"));
                        }
                        return Padding(
                          padding: EdgeInsets.all(8),
                          child: ListView.separated(
                            itemCount: courses.length,
                            separatorBuilder: (_, __) => SizedBox(height: 12),
                            itemBuilder: (context, index) => GestureDetector(
                              onTap: () => Navigator.pushNamed(
                                context,
                                '/course/grades/edit',
                                arguments: EditGradeArgs(
                                  courseId: courses[index].id,
                                ),
                              ),
                              child: HeadingCard(
                                heading: Padding(
                                  padding: EdgeInsets.only(left: 12),
                                  child: Text(
                                    courses[index].name,
                                    style: GoogleFonts.montserrat(
                                      fontSize: FontSizes.small,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                content: InfoGrid(
                                  fields: [
                                    InfoField(
                                      label: "Students",
                                      value: courses[index].studentCount
                                          .toString(),
                                    ),
                                    InfoField(
                                      label: "Sessions",
                                      value: courses[index].sessionCount
                                          .toString(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : FutureBuilder<List<GradeData>>(
                      future: gradesFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Something went wrong'));
                        }
                        final grades = snapshot.data!
                            .where((g) => g.components.isNotEmpty)
                            .where(
                              (g) => g.courseName.toLowerCase().contains(
                                _query.toLowerCase(),
                              ),
                            )
                            .toList();
                        if (grades.isEmpty) {
                          return Center(
                            child: Text("You have no courses with grades!"),
                          );
                        }
                        return Padding(
                          padding: EdgeInsets.all(8),
                          child: GradeListItem(items: grades),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class GradeRow extends StatelessWidget {
  final GradeComponent component;
  const GradeRow({super.key, required this.component});

  Color _gradeColor(double grade) {
    if (grade >= 80) return Color(0xFF4CAF50); // green
    if (grade >= 60) return Color(0xFFFFC107); // yellow
    return Color(0xFFF44336); // red
  }

  @override
  Widget build(BuildContext context) {
    final grade = component.grade;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                component.component,
                style: GoogleFonts.montserrat(
                  fontSize: FontSizes.small,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                grade != null ? grade.toStringAsFixed(1) : "N/A",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: grade != null ? grade / 100 : 0,
              backgroundColor: Color(0xFFE0E0E0),
              valueColor: AlwaysStoppedAnimation<Color>(
                grade != null ? _gradeColor(grade) : Color(0xFFE0E0E0),
              ),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}

class GradeListItem extends StatelessWidget {
  final List<GradeData> items;
  const GradeListItem({super.key, required this.items});

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
              arguments: CourseDetailArgs(courseId: items[index].courseId),
            );
          },
          child: HeadingCard(
            heading: Padding(
              padding: EdgeInsets.only(left: 12),
              child: Text(
                items[index].courseName,
                style: GoogleFonts.montserrat(
                  fontSize: FontSizes.small,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            content: Column(
              children: items[index].components
                  .map((component) => GradeRow(component: component))
                  .toList(),
            ),
          ),
        );
      },
    );
  }
}
