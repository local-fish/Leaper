import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leaper/core/styles/text_styles/font_sizes.dart';
import 'package:leaper/core/styles/text_styles/input_styles.dart';
import 'package:leaper/providers/auth_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  void handleLogin() {
    // TODO: Remove Debug Text
    print(_usernameController.text);
    print(_passwordController.text);
    // TODO: Handle HTTP Request to Back End for Login
    final token = "temporary_token";
    ref.read(authProvider.notifier).login(token);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[Color(0xFFE6E6E6), Color(0xFF949EC3)],
            ),
          ),
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
                          Text("Image Placeholder Here"),
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
                                BoxShadow(
                                  color: Color(0x0D000000),
                                  blurRadius: 24,
                                ),
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
                                BoxShadow(
                                  color: Color(0x0D000000),
                                  blurRadius: 24,
                                ),
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
                              style: TextStyle(fontSize: FontSizes.large),
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
        ),
      ),
    );
  }
}
