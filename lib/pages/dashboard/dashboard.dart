import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:leaper/core/components/heading_card.dart';
import 'package:leaper/core/styles/text_styles/font_sizes.dart';
import 'package:leaper/models/schedule_data.dart';
import 'package:leaper/providers/auth_provider.dart';
import 'package:leaper/providers/user_info_provider.dart';

class Dashboard extends ConsumerStatefulWidget {
  const Dashboard({super.key});
  @override
  ConsumerState<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends ConsumerState<Dashboard> {
  Future<DayComponent?>? _upcomingFuture;

  @override
  void initState() {
    super.initState();

    _upcomingFuture = fetchUpcoming();
  }

  Future<DayComponent?> fetchUpcoming() async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/schedule/upcoming'),
      headers: {'Authorization': 'Bearer ${ref.read(authProvider).value}'},
    );

    print(response);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      if (json == null) return null;

      return DayComponent.fromJson(json);
    } else {
      throw Exception('Failed to fetch next session');
    }
  }

  @override
  // Note: This page is part of MainLayout so it doesn't use ScaffoldBackground
  Widget build(BuildContext context) {
    String name = ref.watch(userInfoProvider).value ?? "null";
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Hello, $name",
                style: GoogleFonts.montserrat(
                  fontSize: FontSizes.large,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(padding: EdgeInsets.all(8)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // TODO: Add Navigation
                Column(
                  children: [
                    DashboardButton(icon: Icons.book, onPressed: () {}),
                    Padding(padding: EdgeInsets.only(top: 8)),
                    Text("Course"),
                  ],
                ),
                Column(
                  children: [
                    DashboardButton(
                      icon: Icons.task_alt,
                      onPressed: () {
                        Navigator.pushNamed(context, '/tasks');
                      },
                    ),
                    Padding(padding: EdgeInsets.only(top: 8)),
                    Text("Task"),
                  ],
                ),
                Column(
                  children: [
                    DashboardButton(
                      icon: Icons.calendar_today,
                      onPressed: () {
                        Navigator.pushNamed(context, '/schedule');
                      },
                    ),
                    Padding(padding: EdgeInsets.only(top: 8)),
                    Text("Schedule"),
                  ],
                ),
                Column(
                  children: [
                    DashboardButton(
                      icon: Icons.view_kanban,
                      onPressed: () {
                        Navigator.pushNamed(context, '/grades');
                      },
                    ),
                    Padding(padding: EdgeInsets.only(top: 8)),
                    Text("Grade"),
                  ],
                ),
              ],
            ),
            Padding(padding: EdgeInsets.all(8)),
            HeadingCard(
              heading: Padding(
                padding: EdgeInsets.only(left: 12),
                child: Text(
                  "Upcoming Class",
                  style: GoogleFonts.montserrat(
                    fontSize: FontSizes.small,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              // TODO: Add Content
              content: FutureBuilder<DayComponent?>(
                future: _upcomingFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (snapshot.hasError) {
                    return Text('Failed to load');
                  }

                  final upcoming = snapshot.data;

                  if (upcoming == null) {
                    return Text('No upcoming sessions');
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        upcoming.courseName,
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(upcoming.sessionName ?? ''),

                      Text(
                        "${DateFormat('dd MMM yyyy • HH:mm').format(upcoming.startTime!)} - ${DateFormat('dd MMM yyyy • HH:mm').format(upcoming.endTime!)}",
                      ),
                    ],
                  );
                },
              ),
            ),
            Padding(padding: EdgeInsets.all(8)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: HeadingCard(
                    heading: Text(
                      "Activity",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        fontSize: FontSizes.small,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    // TODO: Add Content
                    content: Text("Temp Content"),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: HeadingCard(
                    heading: Text(
                      "Reminder",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        fontSize: FontSizes.small,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    // TODO: Add Content
                    content: Text("Temp Content"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardButton extends StatelessWidget {
  final IconData icon;
  final void Function() onPressed;
  const DashboardButton({
    super.key,
    required this.onPressed,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(),
        padding: EdgeInsets.all(16),
        elevation: 4,
      ),
      child: Icon(icon, size: 24, color: Color(0xFF000000)),
    );
  }
}
