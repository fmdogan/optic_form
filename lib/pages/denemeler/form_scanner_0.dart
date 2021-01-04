/*
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class FormScanner extends StatefulWidget {
  @override
  _FormScannerState createState() => _FormScannerState();
}

class _FormScannerState extends State<FormScanner> {
  CameraController cameraController;
  List cameras;
  int selectedCameraIndex;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    availableCameras().then((value) {
      cameras = value;
      if(cameras.length > 0){
        setState(() {
          selectedCameraIndex = 0;
        });
        initCamera(cameras[selectedCameraIndex]).then((value) {

        });
      } else {
        print('No camera available');
      }
    }).catchError((e){
      print('Error : ${e.code}');
    });
  }

onCapture(context) async {
    try {
      final p = await getTemporaryDirectory();
      final name = DateTime.now();
      final path = "${p.path}/$name.png";

      await cameraController.takePicture(path).then((value) {
        print('here');
        print(path);
        //Navigator.push(context, MaterialPageRoute(builder: (context) =>PreviewScreen(imgPath: path,fileName: "$name.png",)));
      });

    } catch (e) {
      print(e.toString());
    }
  }

  Future initCamera(CameraDescription cameraDescription) async {
    if (cameraController != null) {
      await cameraController.dispose();
    }

    cameraController =
        CameraController(cameraDescription, ResolutionPreset.high);

    cameraController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    if (cameraController.value.hasError) {
      print('Camera Error ${cameraController.value.errorDescription}');
    }

    try {
      await cameraController.initialize();
    } catch (e) {
      String errorText = 'Error ${e.code} \nError message: ${e.description}';
    }

    if (mounted) {
      setState(() {});
    }
  }

  Widget cameraPreview() {
    if (cameraController == null || !cameraController.value.isInitialized) {
      return Text(
        'Loading',
        style: TextStyle(
            color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
      );
    }

    return AspectRatio(
      aspectRatio: cameraController.value.aspectRatio,
      child: CameraPreview(cameraController),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    print("building...");
    cameraController.initialize();
    print("Initialize: " + cameraController.description.toString());
    return Scaffold(
      body: [
        Container(
          height: _size.height,
          width: _size.width,
          child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: Center(
              child: cameraPreview(),
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(
              color: cameraController != null && cameraController.value.isRecordingVideo
                  ? Colors.redAccent
                  : Colors.grey,
              width: 3.0,
            ),
          ),
        ),
        Container(
          child: Text("camera"),
        ),
      ][0],
    );
  }

  Widget _cameraPreviewWidget() {
    if (cameraController == null || !cameraController.value.isInitialized) {
      return const Text(
        'Tap a camera',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      return AspectRatio(
        aspectRatio: cameraController.value.aspectRatio,
        child: CameraPreview(cameraController),
      );
    }
  }
}
*/