import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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
                          Text("Login"),
                          TextFormField(
                            decoration: InputDecoration(
                              hintText: "Username or Email",
                            ),
                          ),
                          TextFormField(
                            decoration: InputDecoration(hintText: "Password"),
                            obscureText: true,
                          ),
                          ElevatedButton(
                            onPressed: () => {},
                            child: Text("Login"),
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
