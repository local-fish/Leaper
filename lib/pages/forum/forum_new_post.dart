import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leaper/core/components/back_nav_heading.dart';
import 'package:leaper/core/components/scaffold_background.dart';
import 'package:leaper/providers/api_provider.dart';
import 'package:leaper/providers/auth_provider.dart';
import 'package:http/http.dart' as http;

class ForumNewPostArgs {
  int courseId;
  bool isEditing;
  int? postId;
  String? title;
  String? body;

  ForumNewPostArgs({
    required this.courseId,
    required this.isEditing,
    this.postId,
    this.title,
    this.body,
  });
}

class ForumNewPost extends ConsumerStatefulWidget {
  const ForumNewPost({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ForumNewPostState();
}

class _ForumNewPostState extends ConsumerState<ForumNewPost> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  bool _isLoading = false;
  bool _initialized = false;
  ForumNewPostArgs? _args;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_initialized) return;
    _initialized = true;
    _args = ModalRoute.of(context)!.settings.arguments as ForumNewPostArgs;
    if (_args!.isEditing) {
      _titleController.text = _args!.title ?? "";
      _bodyController.text = _args!.body ?? "";
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> submitPost() async {
    if (_titleController.text.trim().isEmpty) return;
    final navigator = Navigator.of(context);
    setState(() => _isLoading = true);
    try {
      final response = await http.post(
        Uri.parse('${ref.read(apiProvider).value}/forum/new'),
        headers: {
          'Authorization': 'Bearer ${ref.read(authProvider).value}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'courseId': _args!.courseId,
          'title': _titleController.text.trim(),
          'body': _bodyController.text.trim(),
        }),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        navigator.pop();
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> submitEdit() async {
    if (_titleController.text.trim().isEmpty) return;
    final navigator = Navigator.of(context);
    setState(() => _isLoading = true);
    try {
      final response = await http.patch(
        Uri.parse('${ref.read(apiProvider).value}/forum/edit'),
        headers: {
          'Authorization': 'Bearer ${ref.read(authProvider).value}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'id': _args!.postId,
          'title': _titleController.text.trim(),
          'body': _bodyController.text.trim(),
        }),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        navigator.pop();
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldBackground(
      child: Column(
        children: [
          BackNavHeading(
            heading: _args!.isEditing ? "Edit Post" : "Create New Post",
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(labelText: "Title"),
                  ),
                  SizedBox(height: 12),
                  Expanded(
                    child: TextField(
                      controller: _bodyController,
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: InputDecoration(
                        labelText: "Body",
                        alignLabelWithHint: true,
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : (_args!.isEditing ? submitEdit : submitPost),
                      child: _isLoading
                          ? CircularProgressIndicator()
                          : Text(_args!.isEditing ? "Edit" : "Post"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
