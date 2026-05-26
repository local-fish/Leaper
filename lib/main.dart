import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leaper/core/routes.dart';
import 'package:leaper/pages/login_page.dart';
import 'package:leaper/providers/api_provider.dart';
import 'package:leaper/providers/auth_provider.dart';
import 'package:leaper/providers/user_info_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
    return MaterialApp(
      routes: routes,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF929EC3)),
      ),
    );
  }
}

class AuthCheck extends ConsumerWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    return authState.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, st) => LoginPage(),
      data: (token) {
        if (token == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, '/login');
          });
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final ctx = context;
        final apiUrl = ref.read(apiProvider).value;
        if (apiUrl == null || apiUrl.isEmpty) {
          Navigator.pushReplacementNamed(context, '/login');
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        http
            .get(
              Uri.parse('$apiUrl/health'),
              headers: {'Authorization': 'Bearer $token'},
            )
            .then((response) {
              if (response.statusCode == 401) {
                ref.read(authProvider.notifier).logout();
                ref.read(userInfoProvider.notifier).logout();
              } else {
                if (!ctx.mounted) return;
                Navigator.pushReplacementNamed(context, '/main');
              }
            });
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
