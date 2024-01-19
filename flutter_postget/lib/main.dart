import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xatieti_jd/other/app_data.dart';
import 'package:xatieti_jd/pages/home.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppData(), // Reemplaza TuChangeNotifier con tu clase ChangeNotifier
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'XatIETI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Home(),
    );
  }
}

