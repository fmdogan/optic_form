import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
//import 'package:flashlight/flashlight.dart';
import 'package:path_provider/path_provider.dart';

List<CameraDescription> cameras = [];
final GlobalKey<ScaffoldState> camScaffoldKey = GlobalKey<ScaffoldState>();

CameraController camCtrl;
Directory extDir;
String dirPath;
String filePath;

class FormScanner extends StatefulWidget {
  @override
  _FormScannerState createState() {
    return _FormScannerState();
  }
}

class _FormScannerState extends State<FormScanner> {
  ///String imagePath;
  bool isFlashOn = false;

  @override
  initState() {
    super.initState();
    
    ///initFlashlight();
  }

  @override
  void dispose() {
    camCtrl.dispose();
    //camCtrl.setFlashMode(FlashMode.off);
    super.dispose();
  }
/*
  void initFlashlight() {
    hasFlash = Flashlight.hasFlashlight;
    print("Device has flash ? $hasFlash");
  }*/

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;

    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        Navigator.pop(context);
        Navigator.pop(context);
      },
      child: Scaffold(
        key: camScaffoldKey,
        body: Stack(
          children: [
            FutureBuilder(
                future: getCameras(),
                builder: (BuildContext context, AsyncSnapshot snapshot1) {
                  return !snapshot1.hasData
                      ? Center(child: CircularProgressIndicator())
                      : FutureBuilder(
                          future: onNewCameraSelected(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot2) {
                            return !snapshot2.hasData
                                ? Center(child: CircularProgressIndicator())
                                : Container(
                                    padding: EdgeInsets.all(10),
                                    width: _size.width,
                                    height: _size.height,
                                    /*_size.width *
                                      (1 / camCtrl.value.aspectRatio),*/
                                    child: Center(
                                      child: _cameraPreviewWidget(),
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      /*border: Border.all(
                                      color: Colors.grey,
                                      width: 0.0,
                                    ),*/
                                    ),
                                  );
                          });
                }),
            getGrid(_size),
            Align(
              alignment: Alignment.bottomCenter,
              child:
                  /*FloatingActionButton(
                    onPressed: onTakePictureButtonPressed,
                    child: Icon(
                      Icons.camera,
                      size: 40,
                    )),*/
                  Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      /*!isFlashOn
                          // ignore: unnecessary_statements
                          ? {camCtrl.setFlashMode(FlashMode.always), print("flash on")}
                          // ignore: unnecessary_statements
                          : {camCtrl.setFlashMode(FlashMode.off), print("flash off")};
                      isFlashOn = !isFlashOn;*/
                    },
                    child: Container(
                      padding: EdgeInsets.all(20),
                      //decoration: BoxDecoration(
                      //shape: BoxShape.circle, color: Colors.black45),
                      child: Icon(
                        Icons.wb_incandescent_rounded,
                        color: Colors.orangeAccent,
                        size: 30,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: onTakePictureButtonPressed,
                    child: Container(
                      padding: EdgeInsets.all(20),
                      /*decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black45,
                      ),*/
                      child: Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.orangeAccent,
                        size: 70,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Display the preview from the camera (or a message if the preview is not available).
  Widget _cameraPreviewWidget() {
    if (camCtrl == null || !camCtrl.value.isInitialized) {
      return const Text(
        'Kamera aranıyor...',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      print("aspectRatio : " + camCtrl.value.aspectRatio.toString());
      return AspectRatio(
        aspectRatio: camCtrl.value.aspectRatio,
        child: CameraPreview(camCtrl),
      );
    }
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  void showInSnackBar(String message) {
    // ignore: deprecated_member_use
    camScaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  Future<String> onNewCameraSelected() async {
    camCtrl = CameraController(
      cameras[0],
      ResolutionPreset.high,
      enableAudio: false,
    );

    // If the camCtrl is updated then update the UI.
    camCtrl.addListener(() {
      //if (mounted) setState(() {});
      if (camCtrl.value.hasError) {
        showInSnackBar('Camera error ${camCtrl.value.errorDescription}');
      }
    });

    try {
      await camCtrl.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }
    /*
    if (mounted) {
      setState(() {});
    }*/

    return "succesfully_selected_camera";
  }

  /// Click on button to take picture ///
  void onTakePictureButtonPressed() {
    takePicture().then((String filePath) {
      if (mounted) {
        if (filePath != null) showInSnackBar('Picture saved to $filePath');
      }
      camCtrl.dispose();
      Navigator.pushNamed(context, "/crop_form");
    });
  }

  /// Take Picture ///
  Future<String> takePicture() async {
    if (!camCtrl.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }
    extDir = await getExternalStorageDirectory();
    dirPath = '${extDir.path}/Pictures/flutter_test';
    await Directory(dirPath).create(recursive: true);
    filePath = '$dirPath/${timestamp()}.jpg';

    if (camCtrl.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      //await camCtrl.takePicture(filePath);
      //filePath = await camCtrl.takePicture().then((value) => value.path);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return filePath;
  }

  /// Camera Exception ///
  void _showCameraException(CameraException e) {
    logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }
}

Future<String> getCameras() async {
  /// Fetch the available cameras before initializing the app.
  try {
    print("in try of getCameras");
    //WidgetsFlutterBinding.ensureInitialized();
    // ignore: missing_return
    cameras = await availableCameras().then((value) {print("camera : " + value[0].name);});
  } on CameraException catch (e) {
    print("in catch!");
    logError(e.code, e.description);
  }
  print("cameras found.");
  // ignore: invalid_use_of_protected_member
  camScaffoldKey.currentState.setState(() {
    ///futureBody = 0;
    cameras.isNotEmpty
        ? print("cameras found : " + cameras[0].toString())
        : print("cameras not found");
  });
  return "successful";
}

void logError(String code, String message) =>
    print('Error: $code\nError Message: $message');

Widget getGrid(Size size) {
  return Container(
    height: size.height,
    child: Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                height: size.height / 5,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: Colors.green.withOpacity(.5),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                height: size.height / 5,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: Colors.green.withOpacity(.5),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                height: size.height / 5,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: Colors.green.withOpacity(.5),
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                height: size.height * 3 / 5,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: Colors.green.withOpacity(.5),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                height: size.height * 3 / 5,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: Colors.green.withOpacity(.5),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                height: size.height * 3 / 5,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: Colors.green.withOpacity(.5),
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                height: size.height / 5,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: Colors.green.withOpacity(.5),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                height: size.height / 5,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: Colors.green.withOpacity(.5),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                height: size.height / 5,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: Colors.green.withOpacity(.5),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
