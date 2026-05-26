import 'package:flutter/material.dart';

class HeadingCard extends StatelessWidget {
  final Widget heading;
  final Widget content;
  const HeadingCard({super.key, required this.heading, required this.content});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [BoxShadow(color: Color(0x1D000000), blurRadius: 12)],
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [
          // dark header
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF7A84B0), Color(0xFF919ABB)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            padding: EdgeInsets.all(8),
            child: DefaultTextStyle(
              style: TextStyle(color: Colors.white),
              child: heading,
            ),
          ),
          // white body
          Padding(padding: EdgeInsets.all(12), child: content),
        ],
      ),
    );
  }
}
