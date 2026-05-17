import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/reels_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    print('Firebase initialized successfully.');
  } catch (e) {
    print('Failed to initialize Firebase (it might not be configured yet). Proceeding with mock data. Error: $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TikTok Reels Clone',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
        useMaterial3: true,
      ),
      home: ReelsScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
