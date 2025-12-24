import 'package:flutter/material.dart';
import 'home.dart';
import 'signup.dart';
import 'map_page.dart';
import 'location_details_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Panchayat App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        scaffoldBackgroundColor: const Color(0xFFEFF7EF), // lighter pastel green
        useMaterial3: true,
      ),
      // use named routes and set initialRoute to login
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/map': (context) => const MapPage(),
        // '/location_details' can be pushed with arguments if needed
      },
    );
  }
}