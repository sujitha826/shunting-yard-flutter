import 'package:flutter/material.dart';
import 'package:shunting_yard_flutter/screens/home_bloc_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      title: 'Shunting Yard Algorithm',
      home: const HomeBlocScreen(),
    );
  }
}
