import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leaper/core/components/scaffold_background.dart';
import 'package:leaper/core/styles/text_styles/font_sizes.dart';
import 'package:leaper/core/styles/text_styles/input_styles.dart';
import 'package:leaper/providers/auth_provider.dart';
import 'package:leaper/providers/user_info_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  Future<void> handleLogin() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final response = await http.post(
      Uri.parse('${dotenv.env['API_URL']}/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': _usernameController.text,
        'password': _passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      final token = jsonDecode(response.body)['token'];
      ref.read(userInfoProvider.notifier).login(_usernameController.text);
      ref.read(authProvider.notifier).login(token);
      scaffoldMessenger.clearSnackBars();
      navigator.pushReplacementNamed('/main');
    } else {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text("Invalid username or password!")),
      );
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldBackground(
      child: Center(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(left: 32, right: 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Login",
                        style: TextStyle(
                          fontSize: FontSizes.veryLarge,
                          color: Color(0xFF787880),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 12)),
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.circular(32),
                          boxShadow: [
                            BoxShadow(color: Color(0x0D000000), blurRadius: 24),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(left: 12, right: 12),
                          child: TextFormField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              icon: Icon(Icons.person),
                              hintText: "Username or Email",
                              border: InputBorder.none,
                              hintStyle: InputStyle.hintText,
                            ),
                            style: InputStyle.inputText,
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 8)),
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.circular(32),
                          boxShadow: [
                            BoxShadow(color: Color(0x0D000000), blurRadius: 24),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(left: 12, right: 12),
                          child: TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              icon: Icon(Icons.lock),
                              hintText: "Password",
                              border: InputBorder.none,
                              hintStyle: InputStyle.hintText,
                            ),
                            style: InputStyle.inputText,
                            obscureText: true,
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 8)),
                      ElevatedButton(
                        onPressed: handleLogin,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: 96,
                            vertical: 8,
                          ),
                        ),
                        child: Text(
                          "Login",
                          style: TextStyle(fontSize: FontSizes.medium),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
