import 'dart:io';
import 'dart:ui';
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:path_provider/path_provider.dart';

String qrData = "";

class AdminMain extends StatefulWidget {
  @override
  _AdminMainState createState() => _AdminMainState();
}

class _AdminMainState extends State<AdminMain> {
  TextEditingController qrDataCrtl = TextEditingController();
  bool isQrGeneratorActive = false;
  GlobalKey rbCtrl = new GlobalKey();

  void permissions() async {
    // ignore: unused_local_variable
    final status = await Permission.storage.request();
  }

  Future<void> _saveAsPng() async {
    try {
      RenderRepaintBoundary boundary = rbCtrl.currentContext.findRenderObject();
      print("1");
      var image = await boundary.toImage();
      print("2");
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      print("3");
      Uint8List pngBytes = byteData.buffer.asUint8List();
      print("4");

      //permissions();

      //Get this App Document Directory
      Directory _appDocDir = await getExternalStorageDirectory();
      print("5 ${_appDocDir.path}");
      final file =
          await new File('/storage/emulated/0//Pictures/image.png').create();
      print("6 ${_appDocDir.path}");
      await file.writeAsBytes(pngBytes);
      print("7");
    } catch (e) {
      print("Olmadı! " + e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    permissions();
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: _size.height,
            padding: EdgeInsets.all(40),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.jpg"),
                fit: BoxFit.fitHeight,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 40),
                  Center(
                    child: Text(
                      "Admin",
                      style: TextStyle(
                        fontSize: 40,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text("QR verisi gir"),
                  TextField(
                    controller: qrDataCrtl,
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.qr_code_rounded,
                        size: 35,
                        color: Colors.green,
                      ),
                      labelText: "QR verisi",
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(8)),
                  FlatButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      setState(() {
                        qrData = qrDataCrtl.text;
                      });
                      Timer(Duration(seconds: 1), () {
                        _saveAsPng();
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.green,
                      ),
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "QR Kod Oluştur",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(8)),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
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
                    child: RepaintBoundary(
                      key: rbCtrl,
                      child: Container(
                        color: Colors.white,
                        child: QrImage(
                          data: qrData,
                        ),
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
