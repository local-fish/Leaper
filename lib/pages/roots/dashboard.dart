import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leaper/core/components/scaffold_background.dart';
import 'package:leaper/core/styles/text_styles/font_sizes.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  //TODO: Add API Call OR Riverpod Listener
  String name = "Null";

  @override
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
                    DashboardButton(icon: Icons.task_alt, onPressed: () {}),
                    Padding(padding: EdgeInsets.only(top: 8)),
                    Text("Task"),
                  ],
                ),
                Column(
                  children: [
                    DashboardButton(
                      icon: Icons.calendar_today,
                      onPressed: () {},
                    ),
                    Padding(padding: EdgeInsets.only(top: 8)),
                    Text("Schedule"),
                  ],
                ),
                Column(
                  children: [
                    DashboardButton(icon: Icons.view_kanban, onPressed: () {}),
                    Padding(padding: EdgeInsets.only(top: 8)),
                    Text("Grade"),
                  ],
                ),
              ],
            ),
            Padding(padding: EdgeInsets.all(8)),
            DashboardCard(
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
                  child: DashboardCard(
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
                  child: DashboardCard(
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

class DashboardCard extends StatelessWidget {
  final Widget heading;
  final Widget content;
  const DashboardCard({
    super.key,
    required this.heading,
    required this.content,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [BoxShadow(color: Color(0x1D000000), blurRadius: 12)],
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [
          // dark header
          Container(
            width: double.infinity,
            color: Color(0xFF919ABB),
            padding: EdgeInsets.all(4),
            child: heading,
          ),
          // white body
          Padding(padding: EdgeInsets.all(12), child: content),
        ],
      ),
    );
  }
}
