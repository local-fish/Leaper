import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leaper/core/components/scaffold_background.dart';
import 'package:leaper/core/styles/text_styles/font_sizes.dart';
import 'package:leaper/core/styles/text_styles/input_styles.dart';
import 'package:leaper/providers/api_provider.dart';
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
  final _urlController = TextEditingController();
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final url = ref.read(apiProvider).value ?? '';
    if (url.isNotEmpty) {
      _urlController.text = url;
    }
  }

  Future<void> handleLogin() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      if (_urlController.text.trim().isEmpty) {
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text("Please enter an API URL!")),
        );
        return;
      }
      final navigator = Navigator.of(context);
      final endpoint = _urlController.text.trim();
      final response = await http.post(
        Uri.parse('$endpoint/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': _usernameController.text,
          'password': _passwordController.text,
        }),
      );
      if (response.statusCode == 200) {
        final token = jsonDecode(response.body)['token'];
        final UserInfo info = await getUserInfo(token, endpoint);
        ref.read(userInfoProvider.notifier).login(info);
        ref.read(authProvider.notifier).login(token);
        ref.read(apiProvider.notifier).login(endpoint);
        scaffoldMessenger.clearSnackBars();
        navigator.pushReplacementNamed('/main');
      } else {
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text("Invalid email or password!")),
        );
      }
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text("Something went wrong! (Check your API Url!)")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<UserInfo> getUserInfo(String token, String endpoint) async {
    final response = await http.get(
      Uri.parse('$endpoint/user/info'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final out = jsonDecode(response.body);
      return UserInfo.fromJson(out);
    } else {
      throw Exception('Failed to fetch user info');
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldBackground(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(left: 32, right: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/icon.png',
                    width: 200,
                    height: 200,
                  ),
                  SizedBox(height: 12),
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
                          hintText: "Email",
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
                        controller: _urlController,
                        decoration: InputDecoration(
                          icon: Icon(Icons.link),
                          hintText: "API URL",
                          border: InputBorder.none,
                          hintStyle: InputStyle.hintText,
                        ),
                        style: InputStyle.inputText,
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 8)),
                  ElevatedButton(
                    onPressed: _isLoading ? null : handleLogin,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 96,
                        vertical: 8,
                      ),
                    ),
                    child: _isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(
                            "Login",
                            style: TextStyle(fontSize: FontSizes.medium),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
