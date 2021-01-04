import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flashlight/flashlight.dart';
import 'package:permission_handler/permission_handler.dart';

class StudentMain extends StatefulWidget {
  @override
  _StudentMainState createState() => _StudentMainState();
}

class _StudentMainState extends State<StudentMain> {
  bool isFlashOn = false;
  void permissions() async {
    // ignore: unused_local_variable
    final status = await Permission.storage.request();
    // ignore: unused_local_variable
    final status1 = await Permission.camera.request();
  }
/*
  void initFlashlight() async {
    bool hasFlash = await Flashlight.hasFlashlight;
    print("Device has flash ? $hasFlash");
  }*/

  @override
  initState() {
    super.initState();

    ///initFlashlight();
    permissions();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background.jpg"),
              fit: BoxFit.fitHeight,
            ),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              color: Colors.black12,
              child: Column(
                children: [
                  SizedBox(height: 40),
                  Center(
                    child: Text(
                      "Öğrenci",
                      style: TextStyle(
                        fontSize: 40,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ),
                  SizedBox(height: 200),
                  ///////// FLASH BUTTONS /////////
                  FlatButton(
                    onPressed: () {
                      !isFlashOn ? Flashlight.lightOn() : Flashlight.lightOff();
                      setState(() {
                        isFlashOn = !isFlashOn;
                      });
                    },
                    child: Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          isFlashOn ? "turn Flash off" : "turn Flash on",
                        ),
                      ),
                    ),
                  ),
                  /////////////////////////////////
                  InkWell(
                    onTap: () => {
                      Navigator.pushNamed(context, "/qr_scanner"),
                    },
                    child: Container(
                      height: 200,
                      width: 200,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.black38,
                            Colors.white,
                          ],
                        ),
                        boxShadow: [
                          new BoxShadow(
                            blurRadius: 25,
                            color: Colors.white,
                            offset: new Offset(-10.0, -10.0),
                          ),
                          new BoxShadow(
                            blurRadius: 25,
                            color: Colors.black54,
                            offset: new Offset(10.0, 10.0),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons
                            .camera_alt_outlined, //Icons.qr_code_scanner_rounded,
                        size: 100,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
