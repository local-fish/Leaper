import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leaper/core/components/back_nav_heading.dart';
import 'package:leaper/core/components/heading_card.dart';
import 'package:leaper/core/components/scaffold_background.dart';
import 'package:leaper/core/styles/text_styles/font_sizes.dart';
import 'package:leaper/models/grade_data.dart';

class Grades extends StatelessWidget {
  // TODO: Add Search Bar
  const Grades({super.key});

  Future<List<GradeData>> fetchGrades() async {
    //TODO: Add API Call

    List<GradeData> mockGrades = [
      GradeData(
        courseId: 1,
        courseName: "Mathematics",
        components: [
          GradeComponent(component: "Midterm", grade: 85.0),
          GradeComponent(component: "Final", grade: 90.0),
          GradeComponent(component: "Assignment 1", grade: 78.5),
        ],
      ),
      GradeData(
        courseId: 2,
        courseName: "Physics",
        components: [
          GradeComponent(component: "Midterm", grade: 72.0),
          GradeComponent(component: "Final", grade: 88.0),
        ],
      ),
      GradeData(
        courseId: 3,
        courseName: "English Literature",
        components: [
          GradeComponent(component: "Essay 1", grade: 91.0),
          GradeComponent(component: "Essay 2", grade: 87.5),
          GradeComponent(component: "Final", grade: 89.0),
        ],
      ),
    ];
    return mockGrades;
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldBackground(
      child: Center(
        child: Column(
          children: [
            BackNavHeading(heading: "Grades"),
            Expanded(
              child: FutureBuilder<List<GradeData>>(
                future: fetchGrades(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Something went wrong'));
                  }
                  final grades = snapshot.data!;
                  return GradeListItem(items: grades);
                },
              ),
            ),
          ],
        ),
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
        return HeadingCard(
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
            children: items[index].components.map((component) {
              return Padding(
                padding: EdgeInsets.only(left: 12, right: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(component.component),
                    Text(component.grade.toStringAsFixed(1)),
                  ],
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
