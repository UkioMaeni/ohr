import 'dart:io';

import 'package:flutter/material.dart';
import 'package:secure_kpp/pages/start_page/start_page.dart';
void main() {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        "/start":(context) => StartPage(),
      },
      initialRoute: "/start",
    );
  }
}


class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = super.createHttpClient(context);
    final badCertCallback = (X509Certificate cert, String host, int port) => true;
    client.badCertificateCallback = badCertCallback;
    return client;
  }
}