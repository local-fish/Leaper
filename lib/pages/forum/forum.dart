import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:leaper/core/components/back_nav_heading.dart';
import 'package:leaper/core/components/heading_card.dart';
import 'package:leaper/core/components/scaffold_background.dart';
import 'package:leaper/core/styles/text_styles/font_sizes.dart';
import 'package:leaper/models/forum_data.dart';
import 'package:leaper/pages/forum/forum_new_post.dart';
import 'package:leaper/pages/forum/forum_post.dart';
import 'package:leaper/providers/api_provider.dart';
import 'package:leaper/providers/auth_provider.dart';
import 'package:leaper/providers/user_info_provider.dart';

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
  String _query = "";
  ForumArgs? _args;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _args = ModalRoute.of(context)!.settings.arguments as ForumArgs;
    forumData ??= fetchForumList(ref, _args!);
  }

  Future<List<ForumData>> fetchForumList(WidgetRef ref, ForumArgs args) async {
    final response = await http.get(
      Uri.parse(
        '${ref.read(apiProvider).value}/course/${args.courseId}/forums',
      ),
      headers: {'Authorization': 'Bearer ${ref.read(authProvider).value}'},
    );

    if (response.statusCode == 200) {
      final out = jsonDecode(response.body) as List;
      return ForumData.fromJsonList(out);
    } else {
      throw Exception('Failed to fetch forum');
    }
  }

  Future<void> _onRefresh() async {
    setState(() => forumData = null);
    setState(() => forumData = fetchForumList(ref, _args!));
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldBackground(
      child: Column(
        children: [
          BackNavHeading(heading: "Forums"),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: TextField(
              onChanged: (value) => setState(() => _query = value),
              decoration: InputDecoration(
                hintText: "Search forums...",
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(height: 12),
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
              var data = snapshot.data!;
              data = data
                  .where(
                    (f) => f.title.toLowerCase().contains(_query.toLowerCase()),
                  )
                  .toList();
              data.sort((a, b) => b.time.compareTo(a.time));
              return Expanded(
                child: RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        children: [
                          ...data.expand(
                            (x) => {
                              ForumListCard(item: x, onReload: _onRefresh),
                              SizedBox(height: 8),
                            },
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/forum/post/new',
                                arguments: ForumNewPostArgs(
                                  courseId: _args!.courseId,
                                  isEditing: false,
                                ),
                              ).then((_) => _onRefresh());
                            },
                            child: Text("Create New Post"),
                          ),
                        ],
                      ),
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

class ForumListCard extends ConsumerWidget {
  final ForumData item;
  final void Function() onReload;
  const ForumListCard({super.key, required this.item, required this.onReload});
  Future<ForumData> fetchForumPost(WidgetRef ref, int args) async {
    final response = await http.get(
      Uri.parse('${ref.read(apiProvider).value}/forum/$args'),
      headers: {'Authorization': 'Bearer ${ref.read(authProvider).value}'},
    );

    if (response.statusCode == 200) {
      final out = jsonDecode(response.body);
      return ForumData.fromJson(out);
    } else {
      throw Exception('Failed to fetch forum');
    }
  }

  Future<void> deletePost(WidgetRef ref, int forumId) async {
    await http.delete(
      Uri.parse('${ref.read(apiProvider).value}/forum/$forumId'),
      headers: {'Authorization': 'Bearer ${ref.read(authProvider).value}'},
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => {
        Navigator.pushNamed(
          context,
          '/forum/post',
          arguments: ForumPostArgs(forumId: item.id),
        ),
      },
      onLongPress: () async {
        final currentUser = ref.read(userInfoProvider).value;
        if (currentUser?.userId != item.user.id) {
          return; // not your post, get out
        }

        final ctx = context; // save before async
        final ForumData forumData = await fetchForumPost(ref, item.id);

        if (!ctx.mounted) return;

        showModalBottomSheet(
          context: ctx,
          builder: (context) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.edit),
                title: Text("Edit"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(
                    context,
                    '/forum/post/new',
                    arguments: ForumNewPostArgs(
                      courseId: forumData.courseId ?? 0,
                      isEditing: true,
                      postId: forumData.id,
                      body: forumData.body,
                      title: forumData.title,
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.delete),
                title: Text("Delete"),
                onTap: () async {
                  final ctx = context; // save before async
                  await deletePost(ref, item.id);
                  if (!ctx.mounted) return;
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ).then((_) => onReload());
      },
      child: HeadingCard(
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
      ),
    );
  }
}
