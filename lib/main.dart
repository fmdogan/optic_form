import 'package:flutter/material.dart';

import 'pages/onStart/on_start.dart';

import 'pages/student/student_main.dart';
import 'pages/student/qr_scanner.dart';
import 'pages/student/crop_form.dart';

import 'pages/admin/admin_main.dart';
import 'pages/admin/create_form.dart';

int loggedUserID = -1;

void main() {
  String _initialRoute = "/";
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: _initialRoute,
      routes: {
        "/": (context) => OnStartPage(),
        "/student_main": (context) => StudentMain(),
        "/qr_scanner": (context) => QRScanner(),
        "/crop_form": (context) => CropForm(),
        "/admin_main": (context) => AdminMain(),
        "/create_form": (context) => CreateForm(),
      },
    ),
  );
}
