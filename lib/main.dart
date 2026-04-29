import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:leaper/core/styles/text_styles/font_sizes.dart';
import 'package:leaper/core/styles/text_styles/input_styles.dart';

void main() {
  runApp(const MyApp());
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
      home: const MyHomePage(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF929EC3)),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
                            // TODO: Handle Input
                            onPressed: () => {},
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
