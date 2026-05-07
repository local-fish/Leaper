import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leaper/core/components/heading_card.dart';
import 'package:leaper/core/styles/text_styles/font_sizes.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  //TODO: Add API Call OR Riverpod Listener
  String name = "Null";

  // Navigation Stuff

  @override
  // Note: This page is part of MainLayout so it doesn't use ScaffoldBackground
  Widget build(BuildContext context) {
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
              content: Text("Temp Content"),
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
