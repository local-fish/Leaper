import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leaper/pages/dashboard.dart';
import 'package:leaper/pages/login_page.dart';
import 'package:leaper/providers/auth_provider.dart';

void main() {
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
      home: AuthCheck(),
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
      data: (token) => token != null ? Dashboard() : LoginPage(),
    );
  }
}
