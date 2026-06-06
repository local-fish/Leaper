import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:leaper/core/components/back_nav_heading.dart';
import 'package:leaper/core/components/custom_icon_button.dart';
import 'package:leaper/core/components/heading_card.dart';
import 'package:leaper/core/components/info_grid.dart';
import 'package:leaper/core/components/info_row.dart';
import 'package:leaper/core/components/scaffold_background.dart';
import 'package:leaper/core/styles/text_styles/font_sizes.dart';
import 'package:leaper/models/course_data.dart';
import 'package:leaper/pages/forum/forum.dart';
import 'package:leaper/providers/api_provider.dart';
import 'package:leaper/providers/auth_provider.dart';
import 'package:leaper/providers/user_info_provider.dart';
import 'package:url_launcher/url_launcher.dart';

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
  Future<List<CoursePersonData>>? _participantFuture;
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
      Uri.parse('${ref.read(apiProvider).value}/course/${args.courseId}'),
      headers: {'Authorization': 'Bearer ${ref.read(authProvider).value}'},
    );

    if (response.statusCode == 200) {
      final out = jsonDecode(response.body);
      return CourseData.fromJson(out);
    } else {
      throw Exception('Failed to fetch course');
    }
  }

  Future<List<CoursePersonData>> fetchCourseStudents(
    WidgetRef ref,
    CourseDetailArgs args,
  ) async {
    final response = await http.get(
      Uri.parse(
        '${ref.read(apiProvider).value}/course/${args.courseId}/students',
      ),
      headers: {'Authorization': 'Bearer ${ref.read(authProvider).value}'},
    );

    if (response.statusCode == 200) {
      final out = jsonDecode(response.body) as List;
      return CoursePersonData.fromJsonList(out);
    } else {
      throw Exception('Failed to fetch people');
    }
  }

  Future<List<CourseSessionData>> fetchCourseSessions(
    WidgetRef ref,
    CourseDetailArgs args,
  ) async {
    final response = await http.get(
      Uri.parse(
        '${ref.read(apiProvider).value}/course/${args.courseId}/sessions',
      ),
      headers: {'Authorization': 'Bearer ${ref.read(authProvider).value}'},
    );

    if (response.statusCode == 200) {
      final out = jsonDecode(response.body) as List;
      return CourseSessionData.fromJsonList(out);
    } else {
      throw Exception('Failed to fetch sessions');
    }
  }

  Future<CourseSessionData> fetchSessionMaterials(
    WidgetRef ref,
    int args,
  ) async {
    final response = await http.get(
      Uri.parse('${ref.read(apiProvider).value}/session/$args'),
      headers: {'Authorization': 'Bearer ${ref.read(authProvider).value}'},
    );

    if (response.statusCode == 200) {
      final out = jsonDecode(response.body);
      return CourseSessionData.fromJson(out);
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
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                CustomIconButton(
                                  onPressed: () => Navigator.pushNamed(
                                    context,
                                    '/forum',
                                    arguments: ForumArgs(
                                      courseId: args.courseId,
                                    ),
                                  ),
                                  icon: Icons.chat,
                                ),
                                Text("Forum"),
                              ],
                            ),
                            /*
                            Column(
                              children: [
                                CustomIconButton(
                                  onPressed: () => Navigator.pushNamed(
                                    context,
                                    '/course/tasks',
                                  ),
                                  icon: Icons.task_alt,
                                ),
                                Text("Tasks"),
                              ],
                            ),
                            */
                          ],
                        ),

                        SizedBox(height: 12),
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
                          content: Column(
                            children: [
                              InfoGrid(
                                fields: [
                                  InfoField(
                                    label: "Course",
                                    value: course.name,
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              InfoGrid(
                                fields: [
                                  InfoField(
                                    label:
                                        "Lecturer${course.lecturers!.length > 1 ? 's' : ''}",
                                    value: course.lecturers!
                                        .map((l) => l.name)
                                        .join(', '),
                                  ),
                                  InfoField(
                                    label: "Students",
                                    value: course.studentCount.toString(),
                                  ),
                                  InfoField(
                                    label: "Sessions",
                                    value: course.sessionCount.toString(),
                                  ),
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
                          content: Column(
                            children: [
                              ExpansionTile(
                                onExpansionChanged: (expanded) {
                                  if (expanded && _participantFuture == null) {
                                    setState(() {
                                      _participantFuture = fetchCourseStudents(
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
                                  "Lecturers",
                                  style: TextStyle(
                                    fontSize: FontSizes.small,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                shape: Border(),
                                children: [
                                  FutureBuilder(
                                    future: _participantFuture,
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
                                      final data = snapshot.data!;
                                      final lecturers = data
                                          .where((p) => p.role == 'Teacher')
                                          .toList();
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
                                            children: lecturers
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
                              ExpansionTile(
                                onExpansionChanged: (expanded) {
                                  if (expanded && _participantFuture == null) {
                                    setState(() {
                                      _participantFuture = fetchCourseStudents(
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
                                    future: _participantFuture,
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
                                      final students = people
                                          .where((p) => p.role == 'Student')
                                          .toList();
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
                                            children: students
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
                              // Just in case!
                              sessions.sort(
                                (a, b) => a.sessionNo.compareTo(b.sessionNo),
                              );
                              return Column(
                                children: sessions
                                    .map(
                                      (x) => Session(
                                        data: x,
                                        fetchSessionMaterials:
                                            (WidgetRef ref, int args) =>
                                                fetchSessionMaterials(
                                                  ref,
                                                  args,
                                                ),
                                      ),
                                    )
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

class Session extends ConsumerStatefulWidget {
  final Future<CourseSessionData> Function(WidgetRef ref, int args)
  fetchSessionMaterials;
  final CourseSessionData data;

  const Session({
    super.key,
    required this.data,
    required this.fetchSessionMaterials,
  });
  @override
  ConsumerState<Session> createState() => _SessionState();
}

class _SessionState extends ConsumerState<Session> {
  Future<CourseSessionData>? future;

  Future<void> uploadMaterial(int sessionId) async {
    final result = await FilePicker.pickFiles();
    if (result == null) return;
    final file = result.files.first;
    if (file.path == null) return;

    final apiUrl = ref.read(apiProvider).value;
    final token = ref.read(authProvider).value;

    // Get Presign
    final presignResponse = await http.post(
      Uri.parse('$apiUrl/file/presign'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'name': file.name}),
    );
    final presignData = jsonDecode(presignResponse.body);
    final uploadUrl = presignData['clientUrl'];
    final key = presignData['key'];

    // Upload Directly to S3
    final bytes = await File(file.path!).readAsBytes();
    await http.put(Uri.parse(uploadUrl), body: bytes);

    // Confirm (Refreshes S3)
    await http.post(
      Uri.parse('$apiUrl/file/confirm/$key'),
      headers: {'Authorization': 'Bearer $token'},
    );

    // Link to Session
    await http.post(
      Uri.parse('$apiUrl/session/$sessionId/files'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'fileId': key}),
    );

    // Refresh
    setState(() => future = null);
  }

  @override
  Widget build(BuildContext context) {
    final CourseSessionData data = widget.data;
    return ExpansionTile(
      onExpansionChanged: (expanded) {
        if (expanded && future == null) {
          setState(() {
            future = widget.fetchSessionMaterials(ref, data.id);
          });
        }
      },
      tilePadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      title: Text(
        "${data.sessionNo} • ${data.topic}",
        style: TextStyle(
          fontSize: FontSizes.small,
          fontWeight: FontWeight.w600,
        ),
      ),
      shape: Border(),
      children: [
        Padding(
          padding: EdgeInsets.only(left: 8, right: 8),
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: double.infinity),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InfoRow(
                  field: InfoField(
                    label: "Start",
                    value: DateFormat(
                      'dd MMM yyyy • HH:mm',
                    ).format(data.startTime),
                  ),
                ),
                InfoRow(
                  field: InfoField(
                    label: "End",
                    value: DateFormat(
                      'dd MMM yyyy • HH:mm',
                    ).format(data.endTime),
                  ),
                ),
                InfoRow(
                  field: InfoField(
                    label: "Location",
                    value: data.location ?? '',
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(),
        FutureBuilder(
          future: future,
          builder: (context, snapshot) {
            // TODO: this should probably be standardized into a component but honestly i'm too far deep to do that
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Something went wrong"));
            }
            final data = snapshot.data!;
            return ConstrainedBox(
              constraints: BoxConstraints(minWidth: double.infinity),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (data.files!.isNotEmpty) Text("Materials: "),
                    ...?data.files?.map((x) => SessionMaterial(data: x)),
                    if (data.files!.isNotEmpty) Divider(),
                    if (ref.read(userInfoProvider).value?.role ==
                        'Teacher') ...[
                      TextButton.icon(
                        onPressed: () => uploadMaterial(data.id),
                        icon: Icon(Icons.upload_file),
                        label: Text("Add Material"),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class SessionMaterial extends ConsumerWidget {
  final FileData data;
  const SessionMaterial({super.key, required this.data});
  Future<void> downloadFile(WidgetRef ref, String fileId) async {
    final client = http.Client();
    final request = http.Request(
      'GET',
      Uri.parse('${ref.read(apiProvider).value}/file/$fileId'),
    );
    request.headers['Authorization'] = 'Bearer ${ref.read(authProvider).value}';
    request.followRedirects = false;
    final response = await client.send(request);

    if (response.statusCode == 301 || response.statusCode == 302) {
      final redirectUrl = response.headers['location']!;
      await launchUrl(Uri.parse(redirectUrl));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => downloadFile(ref, data.id),
      child: Row(children: [Icon(Icons.file_download), Text(data.name)]),
    );
  }
}

class Person extends StatelessWidget {
  final CoursePersonData person;
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
