import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:leaper/core/components/back_nav_heading.dart';
import 'package:leaper/core/components/heading_card.dart';
import 'package:leaper/core/components/scaffold_background.dart';
import 'package:leaper/core/styles/text_styles/font_sizes.dart';
import 'package:leaper/models/forum_data.dart';
import 'package:leaper/providers/auth_provider.dart';

class ForumArgs {
  final int courseId;
  ForumArgs({required this.courseId});
}

class Forum extends ConsumerStatefulWidget {
  const Forum({super.key});
  @override
  ConsumerState<Forum> createState() => _ForumState();
}

class _ForumState extends ConsumerState<Forum> {
  Future<List<ForumData>>? forumData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as ForumArgs;
    forumData ??= fetchForumList(ref, args);
  }

  Future<List<ForumData>> fetchForumList(WidgetRef ref, ForumArgs args) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/course/${args.courseId}/forums'),
      headers: {'Authorization': 'Bearer ${ref.read(authProvider).value}'},
    );

    if (response.statusCode == 200) {
      final out = jsonDecode(response.body) as List;
      return ForumData.fromJsonList(out);
    } else {
      throw Exception('Failed to fetch forum');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldBackground(
      child: Column(
        children: [
          BackNavHeading(heading: "Forums"),
          FutureBuilder(
            future: forumData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Column(
                  children: [Center(child: CircularProgressIndicator())],
                );
              } else if (snapshot.hasError) {
                return Column(
                  children: [
                    Center(
                      child: Text("Something went wrong ${snapshot.error}"),
                    ),
                  ],
                );
              }
              final data = snapshot.data!;
              data.sort((a, b) => b.time.compareTo(a.time));
              return Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      children: data
                          .expand(
                            (x) => {
                              ForumListCard(item: x),
                              SizedBox(height: 8),
                            },
                          )
                          .toList(),
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

class ForumListCard extends StatelessWidget {
  final ForumData item;
  const ForumListCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return HeadingCard(
      heading: Padding(
        padding: EdgeInsets.only(left: 8, right: 8),
        child: Text(
          item.title,
          style: GoogleFonts.montserrat(
            fontSize: FontSizes.small,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      content: ConstrainedBox(
        constraints: BoxConstraints(minWidth: double.infinity),
        child: Table(
          columnWidths: const <int, TableColumnWidth>{
            0: IntrinsicColumnWidth(),
            1: FlexColumnWidth(),
          },
          children: <TableRow>[
            TableRow(
              children: [
                Text("Posted on "),
                Text(
                  ": ${DateFormat('dd MMM yyyy • HH:mm:ss').format(item.time)}",
                ),
              ],
            ),
            TableRow(
              children: [Text("Posted by"), Text(": ${item.user.name}")],
            ),
          ],
        ),
      ),
    );
  }
}
