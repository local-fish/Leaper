import 'package:flutter/material.dart';
import 'package:leaper/core/components/scaffold_background.dart';

class ForumPostArgs {
  final int forumId;
  ForumPostArgs({required this.forumId});
}

class ForumPost extends StatelessWidget {
  const ForumPost({super.key});
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ForumPostArgs;
    return ScaffoldBackground(
      child: Center(
        child: Text(textAlign: TextAlign.center, "${args.forumId}"),
      ),
    );
  }
}
