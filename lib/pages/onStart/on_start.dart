import 'dart:ui';

import 'package:bitirme_projesi/database_helper.dart';
import 'package:flutter/material.dart';

import 'login.dart';
import 'sign_up.dart';

PageController onStartPageCtrl = PageController();

class OnStartPage extends StatefulWidget {
  @override
  _OnStartPageState createState() => _OnStartPageState();
}

class _OnStartPageState extends State<OnStartPage> {
  final dbHelper = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/background.jpg"),
                  fit: BoxFit.fitHeight),
            ),
            height: size.height,
            width: size.width,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.black12,
                child: Center(
                  child: Container(
                    height: size.height * 2 / 3,
                    width: double.infinity,
                    child: PageView(
                      controller: onStartPageCtrl,
                      physics: new NeverScrollableScrollPhysics(),
                      children: [
                        LoginPage(),
                        SignUpPage(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
