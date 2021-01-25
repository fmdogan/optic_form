import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';

import 'package:bitirme_projesi/form_class.dart';
import 'form_flash_test.dart';
import 'qr_scanner.dart';

final GlobalKey<ScaffoldState> cropScaffoldKey = GlobalKey<ScaffoldState>();
GlobalKey imageKey = GlobalKey();
bool isCropped;

double frameRatio;
double frameWidth;
double frameHeight = frameWidth * frameRatio;
double frameX;
double frameY;

class CropForm extends StatefulWidget {
  @override
  _CropFormState createState() => _CropFormState();
}

class _CropFormState extends State<CropForm> {
  GlobalKey rbCtrl = new GlobalKey();
  List<Widget> edgeLines = [];
  Size _size;
  img.Image pngImg;
  FormType form;

  Future<void> _saveAsPng(img.Image pngImg) async {
    try {
      // ignore: unused_local_variable
      File file;
      RenderRepaintBoundary boundary = rbCtrl.currentContext.findRenderObject();
      var _image = await boundary.toImage();
      ByteData byteData = await _image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();

      pngImg = img.decodePng(pngBytes);

      pngImg = img.copyCrop(pngImg, frameX.toInt(), frameY.toInt(),
          frameWidth.toInt(), frameHeight.toInt());

      pngImg = img.grayscale(pngImg);

      // Convert to Black-White
      convertToBW(pngImg);

      // Analyze the Form
      _analyzeForm(form, pngImg);

      // Get this App Document Directory
      Directory _appDocDir = await getExternalStorageDirectory();
      String path = '${_appDocDir.path}/Pictures/${timestamp()}.png';

      file = await File(path)
          .create()
          .then((value) => value.writeAsBytes(img.encodePng(pngImg)));

      setState(() => {filePath = path, isCropped = true});

      showInSnackBar('Photo saved.');
    } catch (e) {
      print("Olmadı! " + e.toString());
    }
  }

  void _analyzeForm(FormType form, img.Image pngImg) {
    List<int> tempImgData = [];// = pngImg.getBytes(format: img.Format.rgb);
    // tempPixDatas stores the data of the 4 pixels around the option center
    List<List<int>> tempPixDatas = [];
    List<img.Image> lessonsImages = [];
    double formRate = pngImg.width / form.formWidth;

    // Crop lessons from the image of the form
    for (int i = 0; i < form.lessons.length; i++) {
      lessonsImages.add(
        img.copyCrop(
          pngImg,
          (form.lessons[i].lessonX * formRate).toInt(),
          (form.lessons[i].lessonY * formRate).toInt(),
          (form.lessons[i].lessonWidth * formRate).toInt(),
          (form.lessons[i].lessonHeight * formRate).toInt(),
        ),
      );
      pngImg.setPixelRgba(
        (form.lessons[i].lessonX * formRate).toInt(),
        (form.lessons[i].lessonY * formRate).toInt(),
        0x66,
        0x255,
        0x00,
      );
      pngImg.setPixelRgba(
          ((form.lessons[i].lessonX + form.lessons[i].lessonWidth) * formRate -
                  1)
              .toInt(),
          ((form.lessons[i].lessonY + form.lessons[i].lessonHeight) * formRate -
                  1)
              .toInt(),
          0x66,
          0x255,
          0x00);
    }

    // Save coords of options for each lessons
    for (int i = 0; i < form.lessons.length; i++) {
      form.lessons[i].saveCoords(lessonsImages[i]);
    }

    // Analyze options for each lessons
    int counter;
    int optionX;
    int optionY;

    form.lessons.forEach((element) {
      tempImgData = lessonsImages[form.lessons.indexOf(element)]
          .getBytes(format: img.Format.rgb);
      double lessonRate = lessonsImages[form.lessons.indexOf(element)].width /
          element.lessonWidth;
      optionX = 0;
      optionY = 0;
      // Analyze options for each questions
      for (int question = 0; question < element.questionAmount; question++) {
        // Analyze option
        for (int option = 0; option < element.optionAmount; option++) {
          optionX = (element.optionsCoords[question][option][0]).toInt();
          optionY = (element.optionsCoords[question][option][1]).toInt();
          //print("${question + 1}. Question: ${option + 1}. Option's coord Option's coord: $optionX : $optionY. / " + element.answersCoords[question][option][0].toString() + " : " + element.answersCoords[question][option][1].toString());
          /////////////////////////////////////////////////
          pngImg.setPixelRgba(
              (element.lessonX * lessonRate).toInt() + optionX,
              (element.lessonY * lessonRate).toInt() + optionY,
              0x66,
              0x255,
              0x00);
          tempPixDatas?.clear();
          tempPixDatas.add(getPixData(
              tempImgData,
              lessonsImages[form.lessons.indexOf(element)],
              optionX + ((element.optionWidth / 4) * lessonRate).toInt(),
              optionY));
          pngImg.setPixelRgba(
              (element.lessonX * lessonRate).toInt() +
                  optionX +
                  ((element.optionWidth / 4) * lessonRate).toInt(),
              (element.lessonY * lessonRate).toInt() + optionY,
              0x66,
              0x255,
              0x00);
          tempPixDatas.add(getPixData(
              tempImgData,
              lessonsImages[form.lessons.indexOf(element)],
              optionX,
              optionY - ((element.optionWidth / 4) * lessonRate).toInt()));
          pngImg.setPixelRgba(
              (element.lessonX * lessonRate).toInt() + optionX,
              (element.lessonY * lessonRate).toInt() +
                  optionY -
                  ((element.optionWidth / 4) * lessonRate).toInt(),
              0x66,
              0x255,
              0x00);
          tempPixDatas.add(getPixData(
              tempImgData,
              lessonsImages[form.lessons.indexOf(element)],
              optionX - ((element.optionWidth / 4) * lessonRate).toInt(),
              optionY));
          pngImg.setPixelRgba(
              (element.lessonX * lessonRate).toInt() +
                  optionX -
                  ((element.optionWidth / 4) * lessonRate).toInt(),
              (element.lessonY * lessonRate).toInt() + optionY,
              0x66,
              0x255,
              0x00);
          tempPixDatas.add(getPixData(
              tempImgData,
              lessonsImages[form.lessons.indexOf(element)],
              optionX,
              optionY + ((element.optionWidth / 4) * lessonRate).toInt()));
          pngImg.setPixelRgba(
              (element.lessonX * lessonRate).toInt() + optionX,
              (element.lessonY * lessonRate).toInt() +
                  optionY +
                  ((element.optionWidth / 4) * lessonRate).toInt(),
              0x66,
              0x255,
              0x00);
          /////////////////////////////////////////////////

          counter = 0;
          tempPixDatas.forEach((tempPixDatasElement) {
            if (tempPixDatasElement[1] == 0) counter++;
          });

          if (counter > 2) {
            if (element.userAnswers[question] == -1) {
              element.userAnswers[question] = option;
            } else {
              element.userAnswers[question] = -2;
            } // -2 means that more than 1 option is marked
          }
        } // Opitons loop
      } // Questions loop
      element.userAnswers.forEach((userAnswerElement) {
        print(element.name +
            " " +
            (element.userAnswers.indexOf(userAnswerElement) + 1).toString() +
            ". Soru : " +
            userAnswerElement.toString());
      });
    }); // Lessons loop
  }

  void showInSnackBar(String message) {
    // ignore: deprecated_member_use
    cropScaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  @override
  void initState() {
    form = getFormData(selectedFormType);
    isCropped = false;
    frameRatio = form.formHeight / form.formWidth;
    frameX = 50;
    frameY = 100;
    frameWidth = frameX * 2;
    frameHeight = frameWidth * frameRatio;

    form.lessons.forEach((element) {
      element.userAnswers = List.generate(
          form.lessons[form.lessons.indexOf(element)].questionAmount,
          (index) => -1);
    });
    super.initState();
  }

  @override
  void dispose() {
    form = null;
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
                        height: _size.height / 2,
                        color: Colors.green.withOpacity(.8),
                        child: PageView.builder(
                          itemCount: form.lessons.length,
                          itemBuilder: (context, pageViewIndex) => Column(
                            children: [
                              Text(form.lessons[pageViewIndex].name),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: form.lessons[pageViewIndex]
                                      .userAnswers.length,
                                  itemBuilder: (context, listViewIndex) {
                                    List<int> answers =
                                        form.lessons[pageViewIndex].userAnswers;
                                    return Text(
                                      "${listViewIndex + 1}. Soru : " +
                                          (answers[listViewIndex] == 0
                                              ? "A"
                                              : answers[listViewIndex] == 1
                                                  ? "B"
                                                  : answers[listViewIndex] == 2
                                                      ? "C"
                                                      : answers[listViewIndex] ==
                                                              3
                                                          ? "D"
                                                          : answers[listViewIndex] ==
                                                                  -1
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
                            ],
                          ),
                        ),
                      ),
                    ),
            ],
          ),
          floatingActionButton: isCropped
              ? SizedBox()
              : FloatingActionButton(
                  onPressed: () => {
                    _saveAsPng(pngImg)
                    //.whenComplete(() => _analyzeForm(form, pngImg)),
                  },
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
void convertToBW(img.Image pngImg) {
  List<int> tempImgBytes = pngImg.getBytes(format: img.Format.rgb);
  List<int> temp = [];
  int sum;
  for (int y = 0; y < pngImg.height; y++) {
    for (int x = 0; x < pngImg.width; x++) {
      sum = 0;
      temp = tempImgBytes.sublist(
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

List<int> getPixData(
  List<int> tempImgData,
  img.Image lessonImage,
  int pixelX,
  int pixelY,
) {
  return tempImgData.sublist(
    ((lessonImage.width * pixelY + pixelX) * 3).toInt(),
    ((lessonImage.width * pixelY + pixelX) * 3 + 3).toInt(),
  );
}
