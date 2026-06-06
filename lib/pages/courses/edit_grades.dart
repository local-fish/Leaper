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
import 'package:leaper/pages/dashboard/grades.dart';
import 'package:leaper/providers/api_provider.dart';
import 'package:leaper/providers/auth_provider.dart';

class EditGradeArgs {
  final int courseId;
  EditGradeArgs({required this.courseId});
}

class EditGrades extends ConsumerStatefulWidget {
  const EditGrades({super.key});
  @override
  ConsumerState<EditGrades> createState() => _EditGradeState();
}

class _EditGradeState extends ConsumerState<EditGrades> {
  Future<GradeList>? _gradesFuture;
  EditGradeArgs? _args;
  String _query = "";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _args = ModalRoute.of(context)!.settings.arguments as EditGradeArgs;
    _gradesFuture ??= fetchGrades();
  }

  Future<GradeList> fetchGrades() async {
    final response = await http.get(
      Uri.parse(
        '${ref.read(apiProvider).value}/course/lecturer/${_args!.courseId}/grades/student',
      ),
      headers: {'Authorization': 'Bearer ${ref.read(authProvider).value}'},
    );
    if (response.statusCode == 200) {
      return GradeList.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch grades');
    }
  }

  Future<void> editGrade(int componentId, int userId, double? grade) async {
    await http.post(
      Uri.parse('${ref.read(apiProvider).value}/course/lecturer/grades/edit'),
      headers: {
        'Authorization': 'Bearer ${ref.read(authProvider).value}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'courseId': _args!.courseId,
        'componentId': componentId,
        'userId': userId,
        'grade': grade,
      }),
    );
  }

  void showEditSheet(BuildContext context, GradeList data, UserGrade student) {
    final controllers = List.generate(
      data.components.length,
      (i) => TextEditingController(
        text: (i < student.grades.length && student.grades[i] != null)
            ? student.grades[i].toString()
            : '',
      ),
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom:
              MediaQuery.of(context).viewInsets.bottom +
              MediaQuery.of(context).padding.bottom +
              16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // drag handle
            Container(
              margin: EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Color(0xFFDDDDDD),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  student.user.name,
                  style: GoogleFonts.montserrat(
                    fontSize: FontSizes.medium,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(height: 12),
            ...List.generate(
              data.components.length,
              (i) => Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            data.components[i].name,
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 80,
                          child: TextField(
                            controller: controllers[i],
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onChanged: (value) {
                              final val = double.tryParse(value);
                              if (val != null && val > 100) {
                                controllers[i].text = '100';
                                controllers[i].selection =
                                    TextSelection.fromPosition(
                                      TextPosition(
                                        offset: controllers[i].text.length,
                                      ),
                                    );
                              } else if (val != null && val < 0) {
                                controllers[i].text = '0';
                                controllers[i].selection =
                                    TextSelection.fromPosition(
                                      TextPosition(
                                        offset: controllers[i].text.length,
                                      ),
                                    );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    for (int i = 0; i < data.components.length; i++) {
                      final val = double.tryParse(controllers[i].text);
                      await editGrade(
                        data.components[i].id,
                        student.user.id,
                        val,
                      );
                    }
                    if (context.mounted) {
                      Navigator.pop(context);
                      setState(() => _gradesFuture = fetchGrades());
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Save",
                    style: GoogleFonts.montserrat(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldBackground(
      child: Column(
        children: [
          BackNavHeading(heading: "Edit Grades"),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: TextField(
              onChanged: (value) => setState(() => _query = value),
              decoration: InputDecoration(
                hintText: "Search students...",
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(height: 12),
          Expanded(
            child: FutureBuilder<GradeList>(
              future: _gradesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Something went wrong'));
                }
                final raw = snapshot.data!;
                final scores = raw.scores
                    .where(
                      (s) => s.user.name.toLowerCase().contains(
                        _query.toLowerCase(),
                      ),
                    )
                    .toList();
                return ListView.separated(
                  padding: EdgeInsets.all(8),
                  itemCount: scores.length,
                  separatorBuilder: (_, __) => SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final student = scores[index];
                    return HeadingCard(
                      heading: Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Text(
                          student.user.name,
                          style: GoogleFonts.montserrat(
                            fontSize: FontSizes.small,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      content: Column(
                        children: [
                          ...List.generate(
                            raw.components.length,
                            (i) => GradeRow(
                              component: GradeComponent(
                                component: raw.components[i].name,
                                grade: i < student.grades.length
                                    ? student.grades[i]
                                    : null,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton.icon(
                              onPressed: () =>
                                  showEditSheet(context, raw, student),
                              icon: Icon(Icons.edit, size: 16),
                              label: Text("Edit"),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
