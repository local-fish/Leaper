import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leaper/core/components/heading_card.dart';
import 'package:leaper/core/components/scaffold_background.dart';
import 'package:leaper/core/styles/text_styles/font_sizes.dart';
import 'package:leaper/providers/api_provider.dart';
import 'package:leaper/providers/auth_provider.dart';
import 'package:leaper/providers/user_info_provider.dart';

class Profile extends ConsumerWidget {
  const Profile({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(userInfoProvider).value;
    return ScaffoldBackground(
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: double.infinity),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              HeadingCard(
                heading: Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Text(
                    "User Data",
                    style: GoogleFonts.montserrat(
                      fontSize: FontSizes.medium,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                content: Table(
                  columnWidths: <int, TableColumnWidth>{
                    0: IntrinsicColumnWidth(),
                    1: FlexColumnWidth(),
                  },
                  children: <TableRow>[
                    TableRow(
                      children: [Text("Name"), Text(" : ${userInfo?.name}")],
                    ),
                    TableRow(
                      children: [
                        Text("UserId"),
                        Text(" : ${userInfo?.userId}"),
                      ],
                    ),
                    TableRow(
                      children: [Text("Email"), Text(" : ${userInfo?.email}")],
                    ),
                    TableRow(
                      children: [Text("Role"), Text(" : ${userInfo?.role}")],
                    ),
                    TableRow(
                      children: [
                        Text("Connected to"),
                        Text(" : ${ref.read(apiProvider).value}"),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () async {
                  final nav = Navigator.of(context);
                  await ref.read(userInfoProvider.notifier).logout();
                  await ref.read(authProvider.notifier).logout();
                  nav.pushReplacementNamed('/');
                },
                child: Text("Log Out"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
