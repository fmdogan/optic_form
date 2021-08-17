import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/rendering.dart';

import 'form_scanner.dart';
import 'package:bitirme_projesi/form_class.dart';
import 'package:bitirme_projesi/pages/student/form_result.dart';

final GlobalKey<ScaffoldState> cropScaffoldKey = GlobalKey<ScaffoldState>();
GlobalKey imageKey = GlobalKey();
PageController lessonPageViewCtrl = PageController();
PageController backgroundPageViewCtrl = PageController();
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
  img.Image formImg;
  List<img.Image> lessonsImages = [];
  List<String> lessonsImagesFiles = [];

  Future<void> _onCropClicked(img.Image formImg) async {
    try {
      // ignore: unused_local_variable
      File file;
      RenderRepaintBoundary boundary = rbCtrl.currentContext.findRenderObject();
      var _image = await boundary.toImage();
      ByteData byteData = await _image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();

      formImg = img.decodePng(pngBytes);

      formImg = img.copyCrop(formImg, frameX.toInt(), frameY.toInt(),
          frameWidth.toInt(), frameHeight.toInt());

      formImg = img.grayscale(formImg);

      // Convert to Black-White
      convertToBW(formImg);

      // Analyze the Form
      _analyzeForm(form, formImg).then(
        (value) => {
          setState(() => {isCropped = true}),
          Navigator.of(context).push(
            PageRouteBuilder(
              transitionDuration: Duration(milliseconds: 800),
              pageBuilder: (BuildContext context, Animation<double> animation,
                  Animation<double> secondaryAnimation) {
                return FormResult(form: form);
              },
            ),
          ),
        },
      );
    } catch (e) {
      print("Olmadı! " + e.toString());
    }
  } // _onCropClicked function

  Future<void> _analyzeForm(FormType form, img.Image formImg) async {
    List<int> tempImgData = [];
    // tempPixDatas stores the data of the 4 pixels around the option center
    List<List<int>> tempPixDatas = [];
    double formRate = formImg.width / form.formWidth;
    print("formRate is calculated.");

    // Crop lessons from the image of the form
    for (int i = 0; i < form.lessons.length; i++) {
      lessonsImages.add(
        img.copyCrop(
          formImg,
          (form.lessons[i].lessonX * formRate).toInt(),
          (form.lessons[i].lessonY * formRate).toInt(),
          (form.lessons[i].lessonWidth * formRate).toInt(),
          (form.lessons[i].lessonHeight * formRate).toInt(),
        ),
      );

      print("$i th lesson is cropped to lessonsImages.");
    }
    print("Edges got marked.");

    // Save coords of options for each lessons
    for (int i = 0; i < form.lessons.length; i++) {
      form.lessons[i].saveCoords(lessonsImages[i]);
    }
    print("Coords are saved.");

    // Analyze options for each lessons
    int counter;
    int optionX;
    int optionY;

    form.lessons.forEach((lessonElement) {
      print("ders döngüsü içinde");
      img.Image _image = lessonsImages[form.lessons.indexOf(lessonElement)];
      tempImgData = _image.getBytes(format: img.Format.rgb);
      double lessonRate = _image.width / lessonElement.lessonWidth;
      optionX = 0;
      optionY = 0;
      // Analyze options for each questions
      for (int question = 0;
          question < lessonElement.questionAmount;
          question++) {
        // Analyze option
        for (int option = 0; option < lessonElement.optionAmount; option++) {
          optionX = (lessonElement.optionsCoords[question][option][0]).toInt();
          optionY = (lessonElement.optionsCoords[question][option][1]).toInt();
          print(
              "${question + 1}. Question: ${option + 1}. Option's coord Option's coord: $optionX : $optionY. / " +
                  lessonElement.optionsCoords[question][option][0].toString() +
                  " : " +
                  lessonElement.optionsCoords[question][option][1].toString());
          /////////////////////////////////////////////////

          tempPixDatas?.clear();
          tempPixDatas.add(getPixData(tempImgData, _image, optionX, optionY));

          tempPixDatas.add(getPixData(
              tempImgData,
              _image,
              optionX + ((lessonElement.optionWidth / 4) * lessonRate).toInt(),
              optionY));

          tempPixDatas.add(getPixData(
              tempImgData,
              _image,
              optionX,
              optionY -
                  ((lessonElement.optionWidth / 4) * lessonRate).toInt()));

          tempPixDatas.add(getPixData(
              tempImgData,
              _image,
              optionX - ((lessonElement.optionWidth / 4) * lessonRate).toInt(),
              optionY));

          tempPixDatas.add(getPixData(
              tempImgData,
              _image,
              optionX,
              optionY +
                  ((lessonElement.optionWidth / 4) * lessonRate).toInt()));

          /////////////////////////////////////////////////

          counter = 0;
          tempPixDatas.forEach((tempPixDatasElement) {
            if (tempPixDatasElement[1] == 0) counter++;
          });

          // Add user answers
          if (counter > 2)
            lessonElement.userAnswers[question].add(answerTypes[option]);
        } // Opitons loop
      } // Questions loop
      lessonElement.userAnswers.forEach((userAnswerElement) {
        print(lessonElement.name +
            " " +
            (lessonElement.userAnswers.indexOf(userAnswerElement) + 1)
                .toString() +
            ". Soru : " +
            userAnswerElement.toString());
      });
    }); // Lessons loop
  } // _analyzeForm function

  void showInSnackBar(String message) {
    // ignore: deprecated_member_use
    cropScaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  @override
  void initState() {
    isCropped = false;
    frameRatio = form.formHeight / form.formWidth;
    frameX = 50;
    frameY = 100;
    frameWidth = frameX * 2;
    frameHeight = frameWidth * frameRatio;

    form.lessons.forEach((element) {
      element.userAnswers = List.generate(
          form.lessons[form.lessons.indexOf(element)].questionAmount,
          (index) => ["Boş"]);
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
              Center(
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
                        colorFilter:
                            ColorFilter.mode(Colors.transparent, BlendMode.hue),
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
              edgeLines[0],
              edgeLines[1],
              edgeLines[2],
              edgeLines[3],
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _onCropClicked(formImg),
            child: Icon(Icons.done),
          ),
        ),
      ),
    );
  }

  void getEdgeLines() {
    edgeLines = [
      Positioned(
        // Top - moves the frame - doesn't change width/height
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
            child: edgeLine("Horizontal")),
      ),
      Positioned(
        // Right - expands the frame
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
            child: edgeLine("Vertical")),
      ),
      Positioned(
        // Left - moves the frame - doesn't change width/height
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
            child: edgeLine("Vertical")),
      ),
      Positioned(
        // Bottom - expands the frame
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
            child: edgeLine("Horizontal")),
      ),
    ];
  }

  Widget edgeLine(String _isVertical) {
    return Container(
        width: _isVertical == "Vertical" ? 10 : frameWidth + 20,
        height: _isVertical == "Vertical" ? (frameWidth * frameRatio) + 20 : 10,
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
void convertToBW(img.Image formImg) {
  List<int> tempImgBytes = formImg.getBytes(format: img.Format.rgb);
  List<int> temp = [];
  int sum;
  for (int y = 0; y < formImg.height; y++) {
    for (int x = 0; x < formImg.width; x++) {
      sum = 0;
      temp = tempImgBytes.sublist(
        (formImg.width * y + x) * 3,
        (formImg.width * y + x) * 3 + 3,
      );
      temp.forEach((element) => {sum += element});
      if (sum < 254) {
        formImg.setPixelRgba(x, y, 0, 0, 0);
      } else {
        formImg.setPixelRgba(x, y, 255, 255, 255);
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
