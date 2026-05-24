import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:leaper/core/components/back_nav_heading.dart';
import 'package:leaper/core/components/heading_card.dart';
import 'package:leaper/core/components/scaffold_background.dart';
import 'package:leaper/core/styles/text_styles/font_sizes.dart';
import 'package:leaper/models/grade_data.dart';
import 'package:leaper/pages/courses/course_detail.dart';
import 'package:leaper/providers/api_provider.dart';
import 'package:leaper/providers/auth_provider.dart';

class Grades extends ConsumerWidget {
  // TODO: Add Search Bar
  const Grades({super.key});

  Future<List<GradeData>> fetchGrades(WidgetRef ref) async {
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScaffoldBackground(
      child: Center(
        child: Column(
          children: [
            BackNavHeading(heading: "Grades"),
            Expanded(
              child: FutureBuilder<List<GradeData>>(
                future: fetchGrades(ref),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Something went wrong'));
                  }
                  final grades = snapshot.data!
                      .where((g) => g.components.isNotEmpty)
                      .toList();
                  if (grades.isEmpty) {
                    return Center(
                      child: Text("You have no courses with grades!"),
                    );
                  } else {
                    return GradeListItem(items: grades);
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
              children: items[index].components.map((component) {
                return Padding(
                  padding: EdgeInsets.only(left: 12, right: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(component.component),
                      if (component.grade != null)
                        Text(component.grade!.toStringAsFixed(1))
                      else
                        Text("N/A"),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
