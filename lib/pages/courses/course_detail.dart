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
import 'package:leaper/providers/auth_provider.dart';

class CourseDetailArgs {
  final int courseId;
  CourseDetailArgs({required this.courseId});
}

class CourseDetail extends ConsumerStatefulWidget {
  const CourseDetail({super.key});

  @override
  ConsumerState<CourseDetail> createState() => _CourseDetailState();
}

class _CourseDetailState extends ConsumerState<CourseDetail> {
  Future<List<CourseStudentData>>? _studentsFuture;
  Future<CourseData>? _courseDetailsFuture;
  Future<List<CourseSessionData>>? _courseSessionsFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as CourseDetailArgs;
    _courseDetailsFuture ??= fetchCourseDetails(ref, args);
    _courseSessionsFuture ??= fetchCourseSessions(ref, args);
  }

  Future<CourseData> fetchCourseDetails(
    WidgetRef ref,
    CourseDetailArgs args,
  ) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/course/${args.courseId}'),
      headers: {'Authorization': 'Bearer ${ref.read(authProvider).value}'},
    );

    if (response.statusCode == 200) {
      final out = jsonDecode(response.body);
      return CourseData.fromJson(out);
    } else {
      throw Exception('Failed to fetch course');
    }
  }

  Future<List<CourseStudentData>> fetchCourseStudents(
    WidgetRef ref,
    CourseDetailArgs args,
  ) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/course/${args.courseId}/students'),
      headers: {'Authorization': 'Bearer ${ref.read(authProvider).value}'},
    );

    if (response.statusCode == 200) {
      final out = jsonDecode(response.body) as List;
      return CourseStudentData.fromJsonList(out);
    } else {
      throw Exception('Failed to fetch people');
    }
  }

  Future<List<CourseSessionData>> fetchCourseSessions(
    WidgetRef ref,
    CourseDetailArgs args,
  ) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/course/${args.courseId}/sessions'),
      headers: {'Authorization': 'Bearer ${ref.read(authProvider).value}'},
    );

    if (response.statusCode == 200) {
      final out = jsonDecode(response.body) as List;
      return CourseSessionData.fromJsonList(out);
    } else {
      throw Exception('Failed to fetch sessions');
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as CourseDetailArgs;
    return ScaffoldBackground(
      child: Column(
        children: [
          BackNavHeading(heading: "Course Details"),
          FutureBuilder(
            future: _courseDetailsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Column(
                  children: [Center(child: CircularProgressIndicator())],
                );
              } else if (snapshot.hasError) {
                return Column(
                  children: [Center(child: Text("Something went wrong"))],
                );
              }
              final course = snapshot.data!;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  // Todo: Scrollview
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        HeadingCard(
                          heading: Padding(
                            padding: EdgeInsets.only(left: 8),
                            child: Text(
                              "Course Data",
                              style: GoogleFonts.montserrat(
                                fontSize: FontSizes.small,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          content: Table(
                            columnWidths: const <int, TableColumnWidth>{
                              0: IntrinsicColumnWidth(),
                              1: FlexColumnWidth(),
                            },
                            children: <TableRow>[
                              TableRow(
                                children: [
                                  Text("Course"),
                                  Text(": ${course.name}"),
                                ],
                              ),
                              TableRow(
                                children: [Text("Lecturer"), Text(": TODO")],
                              ),
                              TableRow(
                                children: [
                                  Text("Students"),
                                  Text(": ${course.studentCount.toString()}"),
                                ],
                              ),
                              TableRow(
                                children: [
                                  Text("Sessions"),
                                  Text(": ${course.sessionCount.toString()}"),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 12),
                        HeadingCard(
                          heading: Padding(
                            padding: EdgeInsets.only(left: 8),
                            child: Text(
                              "People",
                              style: GoogleFonts.montserrat(
                                fontSize: FontSizes.small,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          content: ExpansionTile(
                            onExpansionChanged: (expanded) {
                              if (expanded && _studentsFuture == null) {
                                setState(() {
                                  _studentsFuture = fetchCourseStudents(
                                    ref,
                                    args,
                                  );
                                });
                              }
                            },
                            tilePadding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 0,
                            ),
                            title: Text(
                              "Students",
                              style: TextStyle(
                                fontSize: FontSizes.small,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            shape: Border(),
                            children: [
                              FutureBuilder(
                                future: _studentsFuture,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Center(
                                      child: Text("Something went wrong"),
                                    );
                                  }
                                  final people = snapshot.data!;
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      left: 12,
                                      right: 12,
                                    ),
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: people
                                            .expand(
                                              (x) => {
                                                Person(person: x),
                                                SizedBox(height: 4),
                                              },
                                            )
                                            .toList(),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 12),
                        HeadingCard(
                          heading: Padding(
                            padding: EdgeInsets.only(left: 8),
                            child: Text(
                              "Sessions",
                              style: GoogleFonts.montserrat(
                                fontSize: FontSizes.small,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          content: FutureBuilder(
                            future: _courseSessionsFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (snapshot.hasError) {
                                return Center(
                                  child: Text("Something went wrong"),
                                );
                              }
                              final sessions = snapshot.data!;
                              return Column(
                                children: sessions
                                    .map((x) => Text(x.topic))
                                    .toList(),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class Person extends StatelessWidget {
  final CourseStudentData person;
  const Person({super.key, required this.person});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          person.name,
          style: TextStyle(
            fontSize: FontSizes.small,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(person.email, style: TextStyle(fontSize: FontSizes.verySmall)),
        Text(
          "${person.role} • ${person.id}",
          style: TextStyle(fontSize: FontSizes.verySmall),
        ),
      ],
    );
  }
}
