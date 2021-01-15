import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';

import 'form_flash_test.dart';
import 'package:bitirme_projesi/form_class.dart';

final GlobalKey<ScaffoldState> cropScaffoldKey = GlobalKey<ScaffoldState>();
GlobalKey imageKey = GlobalKey();
//double imageHeight, imageWidth, xPosition, yPosition;
bool isCropped;
/*
// Sample Form Data
int questionAmount = 10;
int optionAmount = 4;
double formWidth = 194;
double formHeight = 429;
double optionWidth = 28;
double firstOptionX = 58;
double firstOptionY = 54;
double betweenOptions = 40;
*/
double frameRatio;
double frameWidth;
double frameHeight = frameWidth * frameRatio;
double frameX;
double frameY;

//ans  opt  coords
List<List<List<double>>> answersCoords = [];
List<int> answers = [];

class CropForm extends StatefulWidget {
  @override
  _CropFormState createState() => _CropFormState();
}

class _CropFormState extends State<CropForm> {
  GlobalKey rbCtrl = new GlobalKey();
  List<Widget> edgeLines = [];
  Size _size;
  FormType form = new FormType(
    questionAmount: 10,
    optionAmount: 4,
    formWidth: 194,
    formHeight: 429,
    optionWidth: 28,
    firstOptionX: 58,
    firstOptionY: 54,
    betweenOptions: 40,
  );

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

      pngImg = img.copyCrop(pngImg, frameX.toInt(), frameY.toInt(),
          frameWidth.toInt(), frameHeight.toInt());

      pngImg = img.grayscale(pngImg);

      List<int> tempImgData = pngImg.getBytes(format: img.Format.rgb);

      List<List<int>> temp = [];

      //Convert to Black-White
      convertToBW(tempImgData, pngImg);
      
      // Save Coords of options
      saveCoords(pngImg, form);

      // Check if the option is marked
      tempImgData = pngImg.getBytes(format: img.Format.rgb);
      double rate = pngImg.width / form.formWidth;
      int counter;
      int optionX = 0;
      int optionY = 0;

      // Loops
      for (int question = 0; question < form.questionAmount; question++) {
        for (int option = 0; option < form.optionAmount; option++) {
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

          counter = 0; // counter 50-60 gibi sayılara ulaşıyor!!!
          temp.forEach((element) {
            if (element[1] == 0) counter++;
          });

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
          "${i + 1}. question : " +
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

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();
  
  @override
  void initState() {
    isCropped = false;
    answers = new List.generate(form.questionAmount, (index) => -1);
    frameRatio = form.formHeight / form.formWidth;
    frameX = 50;
    frameY = 100;
    frameWidth = frameX * 2;
    frameHeight = frameWidth * frameRatio;
    super.initState();
  }

  @override
  void dispose() {
    answers.fillRange(0, form.questionAmount, -1);
    answersCoords = [];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    getEdgeLines();

    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
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
              isCropped ? SizedBox() : edgeLines[0],
              isCropped ? SizedBox() : edgeLines[1],
              isCropped ? SizedBox() : edgeLines[2],
              isCropped ? SizedBox() : edgeLines[3],
              !isCropped
                  ? SizedBox()
                  : Align(
                      alignment: Alignment.center,
                      child: Container(
                        padding: EdgeInsets.only(left: 8, top: 5),
                        width: _size.width * 5 / 7,
                        height: (form.questionAmount * 45).toDouble(),
                        color: Colors.green.withOpacity(.8),
                        child: ListView.builder(
                          itemCount: answers.length,
                          itemBuilder: (context, index) {
                            return Text(
                              "${index + 1}. question : " +
                                  (answers[index] == 0
                                      ? "A"
                                      : answers[index] == 1
                                          ? "B"
                                          : answers[index] == 2
                                              ? "C"
                                              : answers[index] == 3
                                                  ? "D"
                                                  : answers[index] == -1
                                                      ? "Boş"
                                                      : " -"),
                              style: TextStyle(
                                fontSize: _size.width / 12.5,
                                color: Colors.white,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
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

  void getEdgeLines() {
    edgeLines = [
      // Top - moves the frame - doesn't change width/height
      Positioned(
        left: frameX - 10,
        top: frameY - 10,
        child: GestureDetector(
            onPanUpdate: (DragUpdateDetails details) {
              Offset _newPosition = details.globalPosition;
              setState(() {
                frameX = _newPosition.dx - frameWidth / 2;
                frameY = _newPosition.dy - 20;
              });
            },
            child: edgeLine(false)),
      ),
      // Right
      Positioned(
        left: frameX + frameWidth,
        top: frameY - 10,
        child: GestureDetector(
            onPanUpdate: (DragUpdateDetails details) {
              Offset _newPosition = details.globalPosition;
              setState(() {
                frameWidth = _newPosition.dx - frameX;
                frameHeight = frameWidth * frameRatio;
              });
            },
            child: edgeLine(true)),
      ),
      // Left
      Positioned(
        left: frameX - 10,
        top: frameY - 10,
        child: GestureDetector(
            onPanUpdate: (DragUpdateDetails details) {
              Offset _newPosition = details.globalPosition;
              setState(() {
                frameX = _newPosition.dx;
                frameY = _newPosition.dy - frameHeight / 2 - 20;
              });
            },
            child: edgeLine(true)),
      ),
      // Bottom
      Positioned(
        left: frameX - 10,
        top: frameY + frameHeight,
        child: GestureDetector(
            onPanUpdate: (DragUpdateDetails details) {
              Offset _newPosition = details.globalPosition;
              setState(() {
                frameHeight = _newPosition.dy - frameY - 20;
                frameWidth = frameHeight / frameRatio;
              });
            },
            child: edgeLine(false)),
      ),
    ];
  }

  Widget edgeLine(bool _isVertical) {
    return Container(
        width: _isVertical ? 10 : frameWidth + 20,
        height: _isVertical ? (frameWidth * frameRatio) + 20 : 10,
        color: Colors.red.withOpacity(0.6),
        child: Center(
            child: Container(
                height: 5,
                width: 5,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.black))));
  }
}

class RectangleOverlay extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(frameX, frameY);
    path.lineTo(frameX + frameWidth, frameY);
    path.lineTo(frameX + frameWidth, frameY + (frameWidth * frameRatio));
    path.lineTo(frameX, frameY + (frameWidth * frameRatio));
    return path;
  }

  @override
  bool shouldReclip(RectangleOverlay oldClipper) => true;
}

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
void saveCoords(img.Image pngImg, FormType form) {
  double rate = pngImg.width / form.formWidth;
  print(form.firstOptionX * rate);
  print(form.firstOptionY * rate);
  for (double i = 0; i < form.questionAmount; i++) {
    answersCoords.add([]);
    for (double j = 0; j < form.optionAmount; j++) {
      answersCoords[i.toInt()].add([
        (form.firstOptionX + (form.betweenOptions * j)) * rate,
        (form.firstOptionY + (form.betweenOptions * i)) * rate,
      ]);
    }
  }
  print("Coords saved.");
}
