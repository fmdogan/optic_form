import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class StudentMain extends StatefulWidget {
  @override
  _StudentMainState createState() => _StudentMainState();
}

class _StudentMainState extends State<StudentMain> {
  void permissions() async {
    // ignore: unused_local_variable
    final status = await Permission.storage.request();
    // ignore: unused_local_variable
    final status1 = await Permission.camera.request();
  }

  @override
  initState() {
    super.initState();
    permissions();
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
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
                  SizedBox(height: (_size.height / 2) - 180),
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
                        Icons.camera_alt_outlined,
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
