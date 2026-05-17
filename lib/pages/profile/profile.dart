import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leaper/core/components/scaffold_background.dart';
import 'package:leaper/providers/auth_provider.dart';
import 'package:leaper/providers/user_info_provider.dart';

class Profile extends ConsumerWidget {
  const Profile({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScaffoldBackground(
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: double.infinity),
        child: Column(
          children: [
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
    );
  }
}
