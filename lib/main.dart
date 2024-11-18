import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runconnect/firebase_options.dart';
import 'package:runconnect/models/app_user.dart';
import 'package:runconnect/providers/auth_provider.dart';
import 'package:runconnect/providers/profile_provider.dart';
import 'package:runconnect/screens/home/home.dart';
import 'package:runconnect/shared/styled_text.dart';
import 'package:runconnect/welcome/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
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
      home: Consumer(builder: (context, ref, child) {
        final AsyncValue<AppUser?> user = ref.watch(authProvider);

        return user.when(
            data: (value) {
              if (value == null) {
                return const WelcomeScreen();
              }
              ref.read(profileNotifierProvider.notifier).addUser(value.uid);
              // fetch user profile before returning home screen
              return const HomeScreen();
            },
            error: (error, _) =>
                const Text("Error loading authentication status..."),
            loading: () => const CircularProgressIndicator());
      }),
    );
  }
}
