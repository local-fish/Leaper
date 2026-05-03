import 'package:flutter/material.dart';
import 'package:leaper/core/components/scaffold_background.dart';

class Schedule extends StatefulWidget {
  const Schedule({super.key});
  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldBackground(
      child: Center(
        child: Text(
          textAlign: TextAlign.center,
          "Welcome to the Schedule page. I haven't implemented anything, so have a duck 🦆",
        ),
      ),
    );
  }
}
