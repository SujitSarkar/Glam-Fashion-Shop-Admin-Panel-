import 'package:admin_panel_gs/pages/LoginPage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Panel (Glam Shop)',
      theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          canvasColor: Colors.transparent,
          cursorColor: Colors.deepOrange),
      home: LogIn(),
      debugShowCheckedModeBanner: false,
    );
  }
}
