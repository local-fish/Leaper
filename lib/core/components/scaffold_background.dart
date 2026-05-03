import 'package:flutter/material.dart';

class ScaffoldBackground extends StatelessWidget {
  final Widget child;
  final Widget? bottomBar;
  const ScaffoldBackground({super.key, required this.child, this.bottomBar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[Color(0xFFE6E6E6), Color(0xFF949EC3)],
            ),
          ),
          child: Stack(
            children: [
              child,
              // Bottom Bar
              if (bottomBar != null)
                Positioned(bottom: 16, left: 16, right: 16, child: bottomBar!),
            ],
          ),
        ),
      ),
    );
  }
}
