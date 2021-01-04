import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter_genius_scan/flutter_genius_scan.dart';

import 'package:open_file/open_file.dart';

class FormScanner extends StatefulWidget {
  @override
  _FormScannerState createState() {
    return _FormScannerState();
  }
}

class _FormScannerState extends State<FormScanner> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: Center(
        child: RaisedButton(
      onPressed: () {
        FlutterGeniusScan.scanWithConfiguration({
          'source': 'camera',
          'multiPage': false,
        }).then((result) {
          String pdfUrl = result['pdfUrl'];
          OpenFile.open(pdfUrl.replaceAll("file://", '')).then(
              (result) => debugPrint(result.toString()),
              onError: (error) => displayError(context, error));
        }, onError: (error) => displayError(context, error));
      },
      child: Text("START SCANNING"),
    )),),
    );
  }

  void displayError(BuildContext context, PlatformException error) {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(error.message)));
  }
}