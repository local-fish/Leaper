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
            color: Color(0xFF919ABB),
            padding: EdgeInsets.all(4),
            child: heading,
          ),
          // white body
          Padding(padding: EdgeInsets.all(12), child: content),
        ],
      ),
    );
  }
}
