import 'package:flutter/material.dart';
import 'package:comfort_zone/presentation/screens/home_screen.dart';
import 'package:comfort_zone/presentation/screens/profiles_screen.dart';
import 'package:comfort_zone/presentation/screens/settings_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Погода',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/profile': (context) => const ProfilesScreen(),
        '/settings': (context) => const SettingsScreen(),
      },

    );

  }
}
