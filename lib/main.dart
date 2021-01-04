import 'package:flutter/material.dart';

import 'pages/onStart/on_start.dart';

import 'pages/student/student_main.dart';
import 'pages/student/qr_scanner.dart';
import 'pages/student/form_flash_test.dart';
//import 'pages/student/form_scanner_autoLib.dart';

import 'pages/student/crop_form_Testing_StaticRatioRectangle.dart';

import 'pages/admin/admin_main.dart';

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
        "/form_scanner": (context) => FormScanner(),
        "/crop_form": (context) => CropForm(),
        "/admin_main": (context) => AdminMain(),
      },
    ),
  );
}
