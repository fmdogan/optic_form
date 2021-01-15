import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';

import 'form_flash_test.dart';

final GlobalKey<ScaffoldState> cropScaffoldKey = GlobalKey<ScaffoldState>();
GlobalKey imageKey = GlobalKey();
double imageHeight, imageWidth, xPosition, yPosition;
bool isCropped = false;

// Sample Form Data
int questionAmount = 10;
int optionAmount = 4;
double formWidth = 194;
double formHeight = 429;
double frameRatio = formWidth / formHeight;
double optionWidth = 28;
double firstOptionX = 58;
double firstOptionY = 54;
double betweenOptions = 40;

//ans  opt  coords 
List<List<List<double>>> answersCoords = [];
List<int> answers = new List.generate(questionAmount, (index) => -1);

double top = 224, bottom = 524, left = 80, right = 280;

class CropForm extends StatefulWidget {
  @override
  _CropFormState createState() => _CropFormState();
}

class _CropFormState extends State<CropForm> {
  GlobalKey rbCtrl = new GlobalKey();
  List<Widget> cornerDots = [];
  Size _size;
  double height;
  double width;

  //Convert to Black-White
  void convertToBW(List<int> tempImgData, img.Image pngImg) {
    List<int> temp = [];
    int sum;
    for (int y = 0; y < pngImg.height; y++) {
      for (int x = 0; x < pngImg.width; x++) {
        sum = 0;
        temp = tempImgData.sublist(
          (pngImg.width * y + x) * 3,
          (pngImg.width * y + x) * 3 + 3,
        );
        temp.forEach((element) => {sum += element});
        if (sum < 254) {
          pngImg.setPixelRgba(x, y, 0, 0, 0);
        } else {
          pngImg.setPixelRgba(x, y, 255, 255, 255);
        }
      }
    }
    print("Converted to Black-White.");
  }

  // Save Coords of options
  void saveCoords(img.Image pngImg) {
    double rate = pngImg.width / formWidth;
    print(firstOptionX * rate);
    print(firstOptionY * rate);
    for (double i = 0; i < questionAmount; i++) {
      answersCoords.add([]);
      for (double j = 0; j < optionAmount; j++) {
        answersCoords[i.toInt()].add([
          (firstOptionX + (40 * j)) * rate,
          (firstOptionY + (40 * i)) * rate,
        ]);
      }
    }
    print("Coords saved.");
  }

  List<int> getPixData(
    List<int> tempImgData,
    img.Image pngImg,
    int optionX,
    int optionY,
  ) {
    return tempImgData.sublist(
      ((pngImg.width * optionY + optionX) * 3).toInt(),
      ((pngImg.width * optionY + optionX) * 3 + 3).toInt(),
    );
  }

  Future<void> _saveAsPng() async {
    try {
      // ignore: unused_local_variable
      File file;
      RenderRepaintBoundary boundary = rbCtrl.currentContext.findRenderObject();
      var _image = await boundary.toImage();
      ByteData byteData = await _image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();

      img.Image pngImg;
      pngImg = img.decodePng(pngBytes);

      pngImg = img.copyCrop(pngImg, (left + 20).toInt(), (top + 20).toInt(),
          (right - left).toInt(), (bottom - top).toInt());

      pngImg = img.grayscale(pngImg);

      List<int> tempImgData = pngImg.getBytes(format: img.Format.rgb);

      List<List<int>> temp = [];

      //Convert to Black-White
      convertToBW(tempImgData, pngImg);
      print("Image res: ${pngImg.width} : ${pngImg.height}");

      // Save Coords of options
      saveCoords(pngImg);
/*
      // print coords of options
      answersCoords.forEach((element) {
        element.forEach((element) {
          print(
              "x:y = " + element[0].toString() + " : " + element[1].toString());
        });
      });
*/
      answers.forEach((element) {
        print(element);
      });
      // Check if the option is marked
      tempImgData = pngImg.getBytes(format: img.Format.rgb);
      double rate = pngImg.width / formWidth;
      int counter;
      int optionX = 0;
      int optionY = 0;

      answers.fillRange(0, questionAmount, -1);
      // Loops
      for (int question = 0; question < questionAmount; question++) {
        for (int option = 0; option < optionAmount; option++) {
          optionX = (answersCoords[question][option][0]).toInt();
          optionY = (answersCoords[question][option][1]).toInt();
          print(
            "${question + 1}. Question: ${option + 1}. Option's coord Option's coord: $optionX : $optionY. / " +
                answersCoords[question][option][0].toString() +
                " : " +
                answersCoords[question][option][1].toString(),
          );
          /////////////////////////////////////////////////
          temp.clear();
          temp.add(getPixData(
              tempImgData, pngImg, optionX + 7 * rate.toInt(), optionY));
          temp.add(getPixData(
              tempImgData, pngImg, optionX, optionY - 7 * rate.toInt()));
          temp.add(getPixData(
              tempImgData, pngImg, optionX - 7 * rate.toInt(), optionY));
          temp.add(getPixData(
              tempImgData, pngImg, optionX, optionY + 7 * rate.toInt()));
          /////////////////////////////////////////////////
          /*print(
            temp[0][1].toString() +
                " " +
                temp[1][1].toString() +
                " " +
                temp[2][1].toString() +
                " " +
                temp[3][1].toString(),
          );*/

          counter = 0; // counter 50-60 gibi sayılara ulaşıyor!!!
          temp.forEach((element) {
            if (element[1] == 0) counter++;
          });

          print(
            "Counter: " +
                counter.toString() +
                ", Dots: " +
                temp[0][1].toString() +
                " " +
                temp[1][1].toString() +
                " " +
                temp[2][1].toString() +
                " " +
                temp[3][1].toString(),
          );

          if (counter > 3) {
            if (answers[question] == -1) {
              answers[question] = option;
            } else {
              answers[question] = -2;
            } // -2 means more than 2 option is marked
          }
        }
        print(
            "////////////// ${question + 1}. Question is done //////////////");
      }

      for (int i = 0; i < answers.length; i++) {
        print(
          "${i+1}. question : " +
              (answers[i] == 0
                  ? "A"
                  : answers[i] == 1
                      ? "B"
                      : answers[i] == 2
                          ? "C"
                          : answers[i] == 3
                              ? "D"
                              : answers[i] == -1
                                  ? "Boş"
                                  : "Çoklu İşaretleme"),
        );
      }

      //Get this App Document Directory
      Directory _appDocDir = await getExternalStorageDirectory();
      String path = '${_appDocDir.path}/Pictures/${timestamp()}.png';

      file = await File(path)
          .create()
          .then((value) => value.writeAsBytes(img.encodePng(pngImg)));
      //await file.writeAsBytes(img.encodePng(pngImg));

      setState(() {
        filePath = path;
        isCropped = true;
      });

      showInSnackBar('Photo saved.');
    } catch (e) {
      print("Olmadı! " + e.toString());
    }
  }

  void showInSnackBar(String message) {
    // ignore: deprecated_member_use
    cropScaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  String timestamp() => DateTime.now().millisecond.toString();

  @override
  void initState() {
    Timer(Duration(seconds: 1), () {
      findOffset(imageKey);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    height = _size.height;
    width = _size.width;
    getCornerDots();

    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        isCropped = false;
      },
      child: SafeArea(
        child: Scaffold(
          key: cropScaffoldKey,
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
                        fit: BoxFit.contain,
                      ),
              ),
              isCropped
                  ? SizedBox()
                  : Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.5),
                        ),
                        //border: Border.all(color: Colors.green, width: 5)),
                        child: RepaintBoundary(
                          key: rbCtrl,
                          child: ClipPath(
                            clipper: RectangleOverlay(),
                            child: ColorFiltered(
                              colorFilter: ColorFilter.mode(
                                  Colors.transparent, BlendMode.hue),
                              child: Container(
                                decoration: BoxDecoration(
                                    image: filePath.isEmpty
                                        ? null
                                        : DecorationImage(
                                            image: FileImage(File(filePath)))),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
              isCropped ? SizedBox() : cornerDots[0],
              isCropped ? SizedBox() : cornerDots[1],
              isCropped ? SizedBox() : cornerDots[2],
              isCropped ? SizedBox() : cornerDots[3],
            ],
          ),
          floatingActionButton: isCropped
              ? SizedBox()
              : FloatingActionButton(
                  onPressed: _saveAsPng,
                  child: Icon(Icons.done),
                ),
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

    //print("--- xPosition : " + xPosition.toString() + ", yPosition : " + yPosition.toString());
    //print("--- height : " + imageHeight.toString() + ", width : " + imageWidth.toString());
  }

  void getCornerDots() {
    cornerDots = [
      Positioned(
        left: left,
        top: top,
        child: GestureDetector(
            onPanUpdate: (DragUpdateDetails details) {
              Offset _newPosition = details.globalPosition;
              setState(() {
                left = _newPosition.dx - width / 8;
                top = _newPosition.dy - width / 8 - 20;
              });
            },
            child: cornerDot()),
      ),
      Positioned(
        left: right,
        top: top,
        child: GestureDetector(
            onPanUpdate: (DragUpdateDetails details) {
              Offset _newPosition = details.globalPosition;
              setState(() {
                right = _newPosition.dx + width / 8 - 40;
                top = _newPosition.dy - width / 8 - 20;
              });
            },
            child: cornerDot()),
      ),
      Positioned(
        left: left,
        top: bottom,
        child: GestureDetector(
            onPanUpdate: (DragUpdateDetails details) {
              Offset _newPosition = details.globalPosition;
              setState(() {
                left = _newPosition.dx - width / 8;
                bottom = _newPosition.dy + width / 8 - 60;
              });
            },
            child: cornerDot()),
      ),
      Positioned(
        left: right,
        top: bottom,
        child: GestureDetector(
          onPanUpdate: (DragUpdateDetails details) {
            Offset _newPosition = details.globalPosition;
            setState(() {
              right = _newPosition.dx + width / 8 - 40;
              bottom = _newPosition.dy + width / 8 - 60;
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
        color: Colors.red.withOpacity(0.6),
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
    path.moveTo(left + 20, top + 20);
    path.lineTo(right + 20, top + 20);
    path.lineTo(right + 20, bottom + 20);
    path.lineTo(left + 20, bottom + 20);
    return path;
  }

  @override
  bool shouldReclip(RectangleOverlay oldClipper) => true;
}
