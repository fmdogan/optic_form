import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'crop_form_EdgeLines.dart';

const flashOn = 'FLASH ON';
const flashOff = 'FLASH OFF';
int selectedFormType = 0;

class QRScanner extends StatefulWidget {
  @override
  _QRScannerState createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  TextEditingController selectFormCtrl = TextEditingController();
  bool isScanned = false;

  var qrText = '';
  var flashState = flashOn;
  QRViewController qrViewCtrl;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  bool _isFlashOn(String current) {
    return flashOn == current;
  }

  void _onQRViewCreated(QRViewController qrViewCtrl) {
    this.qrViewCtrl = qrViewCtrl;
    qrViewCtrl.scannedDataStream.listen((scanData) {
      setState(() {
        qrText = scanData;
      });
      print(qrText);
      qrViewCtrl?.pauseCamera();
      setState(() {
        isScanned = true;
      });
      Timer(Duration(milliseconds: 700), () {
        Navigator.pushNamed(context, "/form_scanner");
        /*scannerPageCtrl.nextPage(
          duration: Duration(milliseconds: 500),
          curve: Curves.decelerate,
        );*/
        /*Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => FormScanner()),
        );*/

        ///isScanned = false;
      });
    });
    selectFormCtrl.text = "0";
  }

  @override
  void dispose() {
    qrViewCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: QRView(
                    key: qrKey,
                    onQRViewCreated: _onQRViewCreated,
                    overlay: QrScannerOverlayShape(
                      borderColor: Colors.red,
                      borderRadius: 10,
                      borderLength: 30,
                      borderWidth: 10,
                      cutOutSize: _size.width * 5 / 7,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.all(8),
                          child: RaisedButton(
                            onPressed: () {
                              if (qrViewCtrl != null) {
                                qrViewCtrl.toggleFlash();
                                if (_isFlashOn(flashState)) {
                                  setState(() {
                                    flashState = flashOff;
                                  });
                                } else {
                                  setState(() {
                                    flashState = flashOn;
                                  });
                                }
                              }
                            },
                            child: Text(flashState,
                                style: TextStyle(fontSize: 20)),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            /*Container(
                              margin: EdgeInsets.all(8),
                              child: RaisedButton(
                                onPressed: () {
                                  qrViewCtrl?.pauseCamera();
                                },
                                child: Text('pause',
                                    style: TextStyle(fontSize: 20)),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(8),
                              child: RaisedButton(
                                onPressed: () {
                                  qrViewCtrl?.resumeCamera();
                                },
                                child: Text('resume',
                                    style: TextStyle(fontSize: 20)),
                              ),
                            ),*/
                            Container(
                              width: _size.width / 3,
                              child: TextField(
                                controller: selectFormCtrl,
                                showCursor: true,
                                decoration: InputDecoration(
                                  labelText: "Form Kodu Gir",
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(8),
                              child: RaisedButton(
                                onPressed: () {
                                  qrViewCtrl?.pauseCamera();
                                  setState(() {
                                    isScanned = true;
                                  });
                                  print(qrText);
                                  selectedFormType =
                                      int.tryParse(selectFormCtrl.text);
                                  Timer(Duration(seconds: 1), () {
                                    /*scannerPageCtrl.nextPage(
                                      duration: Duration(milliseconds: 500),
                                      curve: Curves.decelerate,
                                    );*/
                                    Navigator.pushNamed(
                                        context, "/form_scanner");
                                    /*setState(() {
                                      isScanned = false;
                                    });*/
                                  });
                                },
                                child: Text(
                                  'İLERİ',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            isScanned
                ? Column(
                    children: [
                      Expanded(
                        flex: 4,
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(10),
                              //color: Colors.black54,
                            ),
                            child: Icon(
                              Icons.done_rounded,
                              size: 250,
                              color: Colors.greenAccent,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: SizedBox(),
                      ),
                    ],
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
