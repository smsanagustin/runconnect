import 'package:flutter/material.dart';
import 'package:runconnect/shared/styled_text.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Run Connect",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: Scaffold(
          body: Center(
        child: Column(children: [
          Container(
              margin: const EdgeInsets.only(top: 200),
              child: const StyledTitle("RunConnect")),
          const StyledText("Welcome, runner!"),
          const SizedBox(
            height: 50,
          ),
          const Image(
              image:
                  AssetImage("assets/logos/runconnect_logo_blue_on_blue.png"))
        ]),
      )),
    );
  }
}
