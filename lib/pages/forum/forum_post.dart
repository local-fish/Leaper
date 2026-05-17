import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:leaper/core/components/back_nav_heading.dart';
import 'package:leaper/core/styles/text_styles/font_sizes.dart';
import 'package:leaper/models/forum_data.dart';
import 'package:leaper/providers/auth_provider.dart';

class ForumPostArgs {
  final int forumId;
  ForumPostArgs({required this.forumId});
}

class ForumPost extends ConsumerStatefulWidget {
  const ForumPost({super.key});
  @override
  ConsumerState<ForumPost> createState() => _ForumPostState();
}

class _ForumPostState extends ConsumerState<ForumPost> {
  Future<ForumData>? forumData;
  Future<List<CommentData>>? commentData;
  ForumPostArgs? _args;
  // Force Refresh for Replies on Forced Refresh
  int _refreshKey = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _args = ModalRoute.of(context)!.settings.arguments as ForumPostArgs;
    forumData ??= fetchForumPost(ref, _args!);
    commentData ??= fetchForumComments(ref, _args!);
  }

  Future<void> onRefresh() async {
    setState(() {
      forumData = null;
      commentData = null;
      _refreshKey++; // Refreshes Replies
      forumData = fetchForumPost(ref, _args!);
      commentData = fetchForumComments(ref, _args!);
    });
  }

  Future<ForumData> fetchForumPost(WidgetRef ref, ForumPostArgs args) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/forum/${args.forumId}'),
      headers: {'Authorization': 'Bearer ${ref.read(authProvider).value}'},
    );

    if (response.statusCode == 200) {
      final out = jsonDecode(response.body);
      return ForumData.fromJson(out);
    } else {
      throw Exception('Failed to fetch forum');
    }
  }

  Future<List<CommentData>> fetchForumComments(
    WidgetRef ref,
    ForumPostArgs args,
  ) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/forum/${args.forumId}/comments'),
      headers: {'Authorization': 'Bearer ${ref.read(authProvider).value}'},
    );

    if (response.statusCode == 200) {
      final out = jsonDecode(response.body) as List;
      return CommentData.fromJsonList(out);
    } else {
      throw Exception('Failed to fetch comments');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(color: Color(0xFFd3d7df)),
          child: Column(
            children: [
              BackNavHeading(heading: "Post"),
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
                  // TODO: Add Area for Comments
                  return Expanded(
                    child: RefreshIndicator(
                      onRefresh: onRefresh,
                      child: SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: double.infinity,
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          data.title,
                                          style: GoogleFonts.montserrat(
                                            fontSize: FontSizes.medium,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text("Posted by ${data.user.name}"),
                                        Text(
                                          "Posted on ${DateFormat('dd MMM yyyy • HH:mm:ss').format(data.time)}",
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Divider(color: Color(0xFFAAAAAA)),
                                Text(data.body ?? ""),
                                Divider(color: Color(0xFFAAAAAA)),
                                if (data.comments! > 0) ...[
                                  Text(
                                    "Comments",
                                    style: GoogleFonts.montserrat(
                                      fontSize: FontSizes.small,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  FutureBuilder(
                                    future: commentData,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Column(
                                          children: [
                                            Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          ],
                                        );
                                      } else if (snapshot.hasError) {
                                        return Column(
                                          children: [
                                            Center(
                                              child: Text(
                                                "Something went wrong ${snapshot.error}",
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                      final commentData = snapshot.data!;
                                      return Column(
                                        key: ValueKey(_refreshKey),
                                        children: commentData
                                            .expand(
                                              (x) => {
                                                CommentWidget(
                                                  item: x,
                                                  root: data,
                                                ),

                                                Divider(
                                                  color: Color(0xFFAAAAAA),
                                                ),
                                              },
                                            )
                                            .toList(),
                                      );
                                    },
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CommentWidget extends ConsumerStatefulWidget {
  final int? parent;
  final CommentData item;
  final ForumData root;
  const CommentWidget({
    super.key,
    this.parent,
    required this.item,
    required this.root,
  });

  @override
  ConsumerState<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends ConsumerState<CommentWidget> {
  Future<List<CommentData>>? replies;
  Future<List<CommentData>> fetchForumReply(
    WidgetRef ref,
    int rootId,
    int parentId,
  ) async {
    final response = await http.get(
      Uri.parse(
        '${dotenv.env['API_URL']}/forum/$rootId/comments?replyId=$parentId',
      ),
      headers: {'Authorization': 'Bearer ${ref.read(authProvider).value}'},
    );

    if (response.statusCode == 200) {
      final out = jsonDecode(response.body) as List;
      return CommentData.fromJsonList(out);
    } else {
      throw Exception('Failed to fetch comments');
    }
  }

  @override
  Widget build(BuildContext context) {
    final CommentData item = widget.item;
    final ForumData root = widget.root;
    return Container(
      decoration: widget.parent != null
          ? BoxDecoration(
              border: Border(
                left: BorderSide(color: Color(0xFFAAAAAA), width: 1.5),
              ),
            )
          : null,
      padding: EdgeInsets.only(left: widget.parent != null ? 6 : 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8),
          Text(
            "${item.user.name} • ${DateFormat('dd MMM yyyy • HH:mm:ss').format(item.time)}",
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 8),
          Text(item.body),
          if (item.replies > 0) ...[
            ExpansionTile(
              tilePadding: EdgeInsets.all(0),
              onExpansionChanged: (expanded) {
                if (expanded && replies == null) {
                  setState(() {
                    replies = fetchForumReply(ref, root.id, item.id);
                  });
                }
              },
              minTileHeight: 24,
              title: Text(
                "View ${item.replies} replies",
                style: TextStyle(fontSize: FontSizes.verySmall),
              ),
              shape: Border(),
              children: [
                FutureBuilder(
                  future: replies,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Something went wrong"));
                    }
                    final replies = snapshot.data!;
                    return Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Column(
                        children: replies
                            .map(
                              (x) => CommentWidget(
                                item: x,
                                root: root,
                                parent: item.id,
                              ),
                            )
                            .toList(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
