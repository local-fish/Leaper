import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leaper/core/components/custom_icon_button.dart';
import 'package:leaper/core/styles/text_styles/font_sizes.dart';

class BackNavHeading extends StatelessWidget {
  const BackNavHeading({super.key, required this.heading});
  final String heading;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomIconButton(
            onPressed: () => {Navigator.pop(context)},
            icon: Icons.keyboard_return,
          ),
          Text(
            heading,
            style: GoogleFonts.montserrat(
              fontSize: FontSizes.large,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
