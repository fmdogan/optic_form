import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'form_flash_test.dart';

GlobalKey imageKey = GlobalKey();
GlobalKey buttonKey = GlobalKey();
double imageHeight, imageWidth, xPosition, yPosition;
double tlX = 80, tlY = 224;
double trX = 280, trY = 224;
double blX = 80, blY = 524;
double brX = 280, brY = 524;

class CropForm extends StatefulWidget {
  @override
  _CropFormState createState() => _CropFormState();
}

class _CropFormState extends State<CropForm> {
  List<Widget> cornerDots = [];

  @override
  void initState() {
    Timer(Duration(seconds: 1), () {
      findOffset(imageKey);
      findOffset(buttonKey);

      // üst sol köşe
      tlX = 80;
      tlY = 224;
      // üst sağ köşe
      trX = 280;
      trY = 224;
      // alt sol köşe
      blX = 80;
      blY = 524;
      // alt sağ köşe
      brX = 280;
      brY = 524;
    });

    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    // ignore: unused_local_variable
    double height = _size.height;
    // ignore: unused_local_variable
    double width = _size.width;
    getCornerDots();

    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
      },
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              height: _size.height,
              width: _size.width,
              child: filePath.isEmpty
                  ? Center(child: Text("RESİM BULUNAMADI!"))
                  : Image.file(
                      File(filePath),
                      key: imageKey,
                    ),
            ),
            ClipPath(
              clipper: RectangleOverlay(),
              child: Container(color: Colors.red.withOpacity(.6)),
            ),
            cornerDots[0],
            cornerDots[1],
            cornerDots[2],
            cornerDots[3],
          ],
        ),
      ),
    );
  }

  void findOffset(GlobalKey key) {
    RenderBox renderBox = key.currentContext.findRenderObject();
    imageHeight = renderBox.size.height;
    imageWidth = renderBox.size.width;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    xPosition = offset.distanceSquared;
    yPosition = offset.dy;

    print(
      "--- xPosition : " +
          xPosition.toString() +
          ", yPosition : " +
          yPosition.toString(),
    );
    print(
      "--- height : " +
          imageHeight.toString() +
          ", width : " +
          imageWidth.toString(),
    );
  }

  void getCornerDots() {
    cornerDots = [
      Positioned(
        left: tlX,
        top: tlY,
        child: GestureDetector(
            onPanUpdate: (DragUpdateDetails details) {
              Offset _newPosition = details.globalPosition;
              setState(() {
                tlX = _newPosition.dx - 20;
                tlY = _newPosition.dy - 20;
              });
            },
            child: cornerDot()),
      ),
      Positioned(
        left: trX,
        top: trY,
        child: GestureDetector(
            onPanUpdate: (DragUpdateDetails details) {
              Offset _newPosition = details.globalPosition;
              setState(() {
                trX = _newPosition.dx - 20;
                trY = _newPosition.dy - 20;
              });
            },
            child: cornerDot()),
      ),
      Positioned(
        left: blX,
        top: blY,
        child: GestureDetector(
            onPanUpdate: (DragUpdateDetails details) {
              Offset _newPosition = details.globalPosition;
              setState(() {
                blX = _newPosition.dx - 20;
                blY = _newPosition.dy - 20;
              });
            },
            child: cornerDot()),
      ),
      Positioned(
        left: brX,
        top: brY,
        child: GestureDetector(
          onPanUpdate: (DragUpdateDetails details) {
            Offset _newPosition = details.globalPosition;
            setState(() {
              brX = _newPosition.dx - 20;
              brY = _newPosition.dy - 20;
            });
          },
          child: cornerDot(),
        ),
      ),
    ];
  }

  Widget cornerDot() {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.green.withOpacity(0.6),
      ),
      child: Center(
        child: Container(
          height: 5,
          width: 5,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

class RectangleOverlay extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(tlX + 20, tlY + 20);
    path.lineTo(trX + 20, trY + 20);
    path.lineTo(brX + 20, brY + 20);
    path.lineTo(blX + 20, blY + 20);
    return path;
  }

  @override
  bool shouldReclip(RectangleOverlay oldClipper) => true;
}
