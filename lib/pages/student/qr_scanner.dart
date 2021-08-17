import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../../database_helper.dart';
import 'form_scanner.dart';
import 'package:bitirme_projesi/form_class.dart';
//import 'crop_form_EdgeLines.dart';

const flashOn = 'FLASH ON';
const flashOff = 'FLASH OFF';
//int selectedFormType = 1;

class QRScanner extends StatefulWidget {
  @override
  _QRScannerState createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  final dbHelper = DatabaseHelper.instance;
  FormType form;

  bool isScanned = false;

  var flashState = flashOff;
  QRViewController qrViewCtrl;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  /*void _getForm () async{
    form = await getForm(selectedFormType);
  }*/

  bool _isFlashOn(String current) {
    return flashOn == current;
  }

  void _onQRViewCreated(QRViewController qrViewCtrl) {
    this.qrViewCtrl = qrViewCtrl;
    qrViewCtrl.scannedDataStream.listen((scanData) {
      print(scanData);
      qrViewCtrl?.pauseCamera();
      setState(() {
        isScanned = true;
      });
      Timer(Duration(milliseconds: 700), () {

        // Fetch the form with the formID scanned from QR code
        dbHelper.fetchForm(int.parse(scanData)).then((_form) => {
              form = FormType(
                formWidth: double.tryParse(_form[0]['formWidth']),
                formHeight: double.tryParse(_form[0]['formHeight']),
                lessons: [],
              ),
              dbHelper.fetchLessons(int.parse(scanData)).then((_lessonList) => {
                    _lessonList.forEach((element) {
                      String _answers = element['correctAnswers'];
                      form.lessons.add(
                        Lesson(
                          name: element['lessonName'],
                          questionAmount: int.tryParse(element['questionAmount']),
                          optionAmount: int.tryParse(element['optionAmount']),
                          lessonX: double.tryParse(element['lessonX']),
                          lessonY: double.tryParse(element['lessonY']),
                          lessonWidth: double.tryParse(element['lessonWidth']),
                          lessonHeight: double.tryParse( element['lessonHeight']),
                          firstOptionX: double.tryParse( element['firstOptionX']),
                          firstOptionY: double.tryParse( element['firstOptionY']),
                          optionWidth: double.tryParse(element['optionWidth']),
                          optionsDistance: double.tryParse(element['optionsDistance']),
                          correctAnswers: _answers.toUpperCase().split(" "),
                        ),
                      );
                    })
                  }),
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FormScanner(form),
                ),
              ),
            });
      });
    });
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
                    child: FlatButton(
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
                      child: Container(
                        margin: EdgeInsets.all(8),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.green.shade500,
                          boxShadow: [
                            new BoxShadow(
                              blurRadius: flashState == flashOn ? 20 : 0,
                              color: Colors.yellow,
                              offset: new Offset(0, 0),
                            ),
                          ],
                        ),
                        child: Text(
                          flashState,
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
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
