import 'dart:io';

import 'package:flutter/material.dart';
import 'form_flash_test.dart';

GlobalKey imageKey = GlobalKey();

class CropForm extends StatefulWidget {
  @override
  _CropFormState createState() => _CropFormState();
}

class _CropFormState extends State<CropForm> {
  List<Widget> cornerDots = [];

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    // ignore: unused_local_variable
    double height = _size.height;
    // ignore: unused_local_variable
    double width = _size.width;

    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
      },
      child: Scaffold(
        body: Container(
          height: _size.height,
          width: _size.width,
          child: filePath.isEmpty
              ? Center(child: Text("RESİM BULUNAMADI!"))
              : Image.file(
                  File(filePath),
                  key: imageKey,
                ),
        ),
      ),
    );
  }
}