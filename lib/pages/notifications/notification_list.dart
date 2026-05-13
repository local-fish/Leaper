import 'package:flutter/material.dart';
import 'package:leaper/core/components/scaffold_background.dart';

class NotificationList extends StatelessWidget {
  const NotificationList({super.key});
  @override
  Widget build(BuildContext context) {
    return ScaffoldBackground(
      child: Center(
        child: Text(
          textAlign: TextAlign.center,
          "This is a template page. I haven't implemented anything, so have a duck 🦆",
        ),
      ),
    );
  }
}
