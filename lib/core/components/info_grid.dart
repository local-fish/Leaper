import 'package:flutter/material.dart';
import 'package:leaper/core/styles/text_styles/font_sizes.dart';

class InfoField {
  final String label;
  final String value;
  const InfoField({required this.label, required this.value});
}

class InfoGrid extends StatelessWidget {
  final List<InfoField> fields;
  const InfoGrid({super.key, required this.fields});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: fields
          .map(
            (field) => Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
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
              ),
            ),
          )
          .toList(),
    );
  }
}
