/*import 'package:flutter/material.dart';

import 'form_scanner.dart';
import 'qr_scanner.dart';

PageController scannerPageCtrl = PageController();

class Scanner extends StatefulWidget {
  @override
  _FormScannerState createState() => _FormScannerState();
}

class _FormScannerState extends State<Scanner> {
  @override
  Widget build(BuildContext context) {
    //Size _size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: PageView(
            controller: scannerPageCtrl,
            //physics: new NeverScrollableScrollPhysics(),
            children: [
              QRScanner(),
              FormScanner(),
              //CameraExampleHome(),
            ],
          ),
        ),
      ),
    );
  }
}
*/