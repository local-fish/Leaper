import 'package:flutter/material.dart';
import 'package:leaper/core/components/info_grid.dart';
import 'package:leaper/core/styles/text_styles/font_sizes.dart';

class InfoRow extends StatelessWidget {
  final InfoField field;
  const InfoRow({super.key, required this.field});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            field.label,
            style: TextStyle(
              fontSize: FontSizes.verySmall,
              color: Colors.black54,
            ),
          ),
          Text(
            field.value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: FontSizes.small,
            ),
          ),
        ],
      ),
    );
  }
}
