import 'dart:io';
import 'dart:ui';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'package:bitirme_projesi/form_class.dart';
import 'package:bitirme_projesi/login_data.dart';
import 'package:bitirme_projesi/database_helper.dart';
//import 'package:bitirme_projesi/pages/admin/admin_main.dart';
import 'package:bitirme_projesi/pages/admin/create_form.dart';

//GlobalKey createFormScaffoldKey = GlobalKey();
GlobalKey rbKey = GlobalKey();
int lastFormID = 0;
String qrData = "";
var node;
Size size;
List<TextEditingController> textFieldsList = [];
bool textFieldsListCtrl = true;
List<LessonToSave> lessonsToSave = [];

TextEditingController formNameCtrl = TextEditingController();
TextEditingController formWidthCtrl = TextEditingController();
TextEditingController formHeightCtrl = TextEditingController();

TextEditingController lessonNameCtrl = TextEditingController();
TextEditingController questionAmountCtrl = TextEditingController();
TextEditingController optionAmountCtrl = TextEditingController();
TextEditingController lessonXCtrl = TextEditingController();
TextEditingController lessonYCtrl = TextEditingController();
TextEditingController lessonWidthCtrl = TextEditingController();
TextEditingController lessonHeightCtrl = TextEditingController();
TextEditingController firstOptionXCtrl = TextEditingController();
TextEditingController firstOptionYCtrl = TextEditingController();
TextEditingController optionWidthCtrl = TextEditingController();
TextEditingController optionsDistanceCtrl = TextEditingController();
TextEditingController correctAnswersCtrl = TextEditingController();

FocusNode formNameNode = FocusNode();
FocusNode formWidthNode = FocusNode();
FocusNode formHeightNode = FocusNode();

FocusNode lessonNameNode = FocusNode();
FocusNode questionAmountNode = FocusNode();
FocusNode optionAmountNode = FocusNode();
FocusNode lessonXNode = FocusNode();
FocusNode lessonYNode = FocusNode();
FocusNode lessonWidthNode = FocusNode();
FocusNode lessonHeightNode = FocusNode();
FocusNode firstOptionXNode = FocusNode();
FocusNode firstOptionYNode = FocusNode();
FocusNode optionWidthNode = FocusNode();
FocusNode optionsDistanceNode = FocusNode();
FocusNode correctAnswersNode = FocusNode();

void getTextFieldsList() {
  textFieldsList.addAll([
    lessonNameCtrl,
    questionAmountCtrl,
    optionAmountCtrl,
    lessonXCtrl,
    lessonYCtrl,
    lessonWidthCtrl,
    lessonHeightCtrl,
    firstOptionXCtrl,
    firstOptionYCtrl,
    optionWidthCtrl,
    optionsDistanceCtrl,
    correctAnswersCtrl,
  ]);
}

void addLesson() {
  lessonsToSave.add(new LessonToSave(
    name: lessonNameCtrl.text,
    questionAmount: questionAmountCtrl.text,
    optionAmount: optionAmountCtrl.text,
    lessonX: lessonXCtrl.text,
    lessonY: lessonYCtrl.text,
    lessonWidth: lessonWidthCtrl.text,
    lessonHeight: lessonHeightCtrl.text,
    firstOptionX: firstOptionXCtrl.text,
    firstOptionY: firstOptionYCtrl.text,
    optionWidth: optionWidthCtrl.text,
    optionsDistance: optionsDistanceCtrl.text,
    correctAnswers: correctAnswersCtrl.text,
  ));
}

class CreateFormPage extends StatefulWidget {
  @override
  _CreateFormPageState createState() => _CreateFormPageState();
}

class _CreateFormPageState extends State<CreateFormPage> {
  final dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    getLastForm();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.red.shade200,
              borderRadius: BorderRadius.all(Radius.circular(35.0)),
            ),
            child: Column(
              children: [
                SizedBox(height: 20),
                Text(
                  "Form Oluştur",
                  style:
                      TextStyle(color: Colors.white, fontSize: size.width / 11),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: formNameCtrl,
                  focusNode: formNameNode,
                  decoration: InputDecoration(
                    labelText: "Form Adı",
                    labelStyle: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onSubmitted: (_text) => {node.requestFocus(formWidthNode)},
                ),
                TextField(
                  controller: formWidthCtrl,
                  focusNode: formWidthNode,
                  decoration: InputDecoration(
                    labelText: "Form Genişliği",
                    labelStyle: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onSubmitted: (_text) => {node.requestFocus(formHeightNode)},
                ),
                TextField(
                  controller: formHeightCtrl,
                  focusNode: formHeightNode,
                  decoration: InputDecoration(
                    labelText: "Form Yüksekliği",
                    labelStyle: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onSubmitted: (_text) => {},
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    " Dersler: ",
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                lessonsToSave.isEmpty
                    ? SizedBox()
                    : Container(
                        height: lessonsToSave.length.toDouble() * 50,
                        child: ListView.builder(
                          itemCount: lessonsToSave.length,
                          itemBuilder: (BuildContext ctxt, int index) {
                            return Container(
                              margin: EdgeInsets.all(5),
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              child: Center(
                                child: Text(
                                  lessonsToSave[index].name,
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 25,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                InkWell(
                  onTap: () => {
                    node.unfocus(),
                    createFormPVCtrl.nextPage(
                        duration: Duration(milliseconds: 200),
                        curve: Curves.easeIn),
                  },
                  child: Container(
                    margin: EdgeInsets.all(5),
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Text(
                        "Ders Ekle",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 25,
                        ),
                      ),
                    ),
                  ),
                ),
                /*
                Center(
                  child: InkWell(
                    onTap: () => {
                      node.unfocus(),
                      createFormPVCtrl.nextPage(
                          duration: Duration(milliseconds: 200),
                          curve: Curves.easeIn),
                    },
                    child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.green.shade400),
                      child: Text(
                        "Ders Ekle",
                        style: TextStyle(fontSize: 25, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                */
                SizedBox(height: 10),
                /*
                Center(
                  child: InkWell(
                    onTap: () => {},
                    child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.green.shade400),
                      child: Text(
                        "Formu Kaydet",
                        style: TextStyle(fontSize: 25, color: Colors.white),
                      ),
                    ),
                  ),
                ),*/
                SizedBox(height: 20),
                Center(
                  child: RepaintBoundary(
                    key: rbKey,
                    child: QrImage(
                      data: qrData,
                      size: 0.5 * size.width,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () => {
                        Navigator.of(context).pop(),
                        lessonsToSave.clear(),
                        node.unfocus(),
                      },
                      child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red.shade400),
                          child: Icon(
                            Icons.close,
                            size: 40,
                            color: Colors.white,
                          )),
                    ),
                    SizedBox(width: 8),
                    InkWell(
                      onTap: saveForm,
                      child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.green.shade400),
                          child: Icon(
                            Icons.done,
                            size: 40,
                            color: Colors.white,
                          )),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  void getLastForm() async {
    String _query =
        'SELECT formID FROM ${DatabaseHelper.dbTables[1]} ORDER BY formID DESC';
    var _result = await dbHelper.rawQuery(_query);
    lastFormID = _result.isNotEmpty ? _result[0]['formID'] : 0;
    qrData = (lastFormID + 1).toString();
    print("son form id: $lastFormID");
  }

  void saveForm() async {
    String qrImagePath = "";
    // Saves the QR code image to phone storage
    try {
      RenderRepaintBoundary boundary = rbKey.currentContext.findRenderObject();
      var image = await boundary.toImage();
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();

      final fileDir = await getExternalStorageDirectory();
      qrImagePath = '${fileDir.path}/Pictures/Optik_Form/$qrData.png';
      final file = await new File(qrImagePath).create(recursive: true);
      await file.writeAsBytes(pngBytes);
    } catch (e) {
      print(e.toString());
    }

    if (lessonsToSave.isNotEmpty) {
      /*String _query =
          'SELECT formID FROM ${DatabaseHelper.dbTables[1]} ORDER BY formID DESC';
      var _result = await dbHelper.rawQuery(_query);
      lastFormID = _result.isNotEmpty ? _result[0]['formID'] : -1;
      print("son form id: $lastFormID");*/

      var _formRow = {
        DatabaseHelper.dbColumns[DatabaseHelper.dbTables[1]][1]:
            loggedUser.id, // userID
        DatabaseHelper.dbColumns[DatabaseHelper.dbTables[1]][2]: qrImagePath,
        DatabaseHelper.dbColumns[DatabaseHelper.dbTables[1]][3]:
            formNameCtrl.text,
        DatabaseHelper.dbColumns[DatabaseHelper.dbTables[1]][4]:
            formWidthCtrl.text,
        DatabaseHelper.dbColumns[DatabaseHelper.dbTables[1]][5]:
            formHeightCtrl.text,
      };
      dbHelper.insert(DatabaseHelper.dbTables[1], _formRow);

      lessonsToSave.forEach((element) {
        var _lessonRow = {
          DatabaseHelper.dbColumns[DatabaseHelper.dbTables[2]][1]:
              lastFormID + 1,
          DatabaseHelper.dbColumns[DatabaseHelper.dbTables[2]][2]: element.name,
          DatabaseHelper.dbColumns[DatabaseHelper.dbTables[2]][3]:
              element.questionAmount,
          DatabaseHelper.dbColumns[DatabaseHelper.dbTables[2]][4]:
              element.optionAmount,
          DatabaseHelper.dbColumns[DatabaseHelper.dbTables[2]][5]:
              element.lessonX,
          DatabaseHelper.dbColumns[DatabaseHelper.dbTables[2]][6]:
              element.lessonY,
          DatabaseHelper.dbColumns[DatabaseHelper.dbTables[2]][7]:
              element.lessonWidth,
          DatabaseHelper.dbColumns[DatabaseHelper.dbTables[2]][8]:
              element.lessonHeight,
          DatabaseHelper.dbColumns[DatabaseHelper.dbTables[2]][9]:
              element.firstOptionX,
          DatabaseHelper.dbColumns[DatabaseHelper.dbTables[2]][10]:
              element.firstOptionY,
          DatabaseHelper.dbColumns[DatabaseHelper.dbTables[2]][11]:
              element.optionWidth,
          DatabaseHelper.dbColumns[DatabaseHelper.dbTables[2]][12]:
              element.optionsDistance,
          DatabaseHelper.dbColumns[DatabaseHelper.dbTables[2]][13]:
              element.correctAnswers,
        };

        dbHelper.insert(DatabaseHelper.dbTables[2], _lessonRow);
      });
    } else {
      print("Kaydedilecek ders bulunamadı");
    }

    formNameCtrl.clear();
    formWidthCtrl.clear();
    formHeightCtrl.clear();

    //formListKey.currentState.setState(() {});
    Navigator.of(context)
        .pushNamedAndRemoveUntil("/admin_main", (route) => false);
    lessonsToSave.clear();
    node.unfocus();
  }
}

class AddLessonPage extends StatefulWidget {
  @override
  _AddLessonPageState createState() => _AddLessonPageState();
}

class _AddLessonPageState extends State<AddLessonPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.red.shade200,
              borderRadius: BorderRadius.all(Radius.circular(35.0)),
            ),
            child: Column(
              children: [
                TextField(
                  controller: lessonNameCtrl,
                  focusNode: lessonNameNode,
                  decoration: InputDecoration(
                    labelText: "Ders Adı",
                    labelStyle: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onSubmitted: (text) =>
                      {node.requestFocus(questionAmountNode)},
                ),
                TextField(
                  controller: questionAmountCtrl,
                  focusNode: questionAmountNode,
                  decoration: InputDecoration(
                    labelText: "Soru Sayısı",
                    labelStyle: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onSubmitted: (text) => {node.requestFocus(optionAmountNode)},
                ),
                TextField(
                  controller: optionAmountCtrl,
                  focusNode: optionAmountNode,
                  decoration: InputDecoration(
                    labelText: "Şık Sayısı",
                    labelStyle: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onSubmitted: (text) => {node.requestFocus(lessonXNode)},
                ),
                TextField(
                  controller: lessonXCtrl,
                  focusNode: lessonXNode,
                  decoration: InputDecoration(
                    labelText: "Dersin Koordinatı X",
                    labelStyle: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onSubmitted: (text) => {node.requestFocus(lessonYNode)},
                ),
                TextField(
                  controller: lessonYCtrl,
                  focusNode: lessonYNode,
                  decoration: InputDecoration(
                    labelText: "Dersin Koordinatı Y",
                    labelStyle: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onSubmitted: (text) => {node.requestFocus(lessonWidthNode)},
                ),
                TextField(
                  controller: lessonWidthCtrl,
                  focusNode: lessonWidthNode,
                  decoration: InputDecoration(
                    labelText: "Ders Genişliği",
                    labelStyle: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onSubmitted: (text) => {node.requestFocus(lessonHeightNode)},
                ),
                TextField(
                  controller: lessonHeightCtrl,
                  focusNode: lessonHeightNode,
                  decoration: InputDecoration(
                    labelText: "Ders Yüksekliği",
                    labelStyle: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onSubmitted: (text) => {node.requestFocus(firstOptionXNode)},
                ),
                TextField(
                  controller: firstOptionXCtrl,
                  focusNode: firstOptionXNode,
                  decoration: InputDecoration(
                    labelText: "İlk Şık Koordinatı X",
                    labelStyle: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onSubmitted: (text) => {node.requestFocus(firstOptionYNode)},
                ),
                TextField(
                  controller: firstOptionYCtrl,
                  focusNode: firstOptionYNode,
                  decoration: InputDecoration(
                    labelText: "İlk Şık Koordinatı Y",
                    labelStyle: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onSubmitted: (text) => {node.requestFocus(optionWidthNode)},
                ),
                TextField(
                  controller: optionWidthCtrl,
                  focusNode: optionWidthNode,
                  decoration: InputDecoration(
                    labelText: "Şık Genişliği",
                    labelStyle: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onSubmitted: (text) =>
                      {node.requestFocus(optionsDistanceNode)},
                ),
                TextField(
                  controller: optionsDistanceCtrl,
                  focusNode: optionsDistanceNode,
                  decoration: InputDecoration(
                    labelText: "Şıklar Arası Mesafe",
                    labelStyle: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onSubmitted: (text) =>
                      {node.requestFocus(correctAnswersNode)},
                ),
                TextField(
                  controller: correctAnswersCtrl,
                  focusNode: correctAnswersNode,
                  decoration: InputDecoration(
                    labelText: "Doğru Cevaplar",
                    labelStyle: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onSubmitted: (text) => {node.unfocus()},
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      // Cancel
                      onTap: () => {
                        textFieldsList.forEach((element) {
                          element.clear();
                        }),
                        node.unfocus(),
                        createFormPVCtrl.previousPage(
                            duration: Duration(milliseconds: 200),
                            curve: Curves.easeIn),
                      },
                      child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red.shade400),
                          child: Icon(
                            Icons.close,
                            size: 40,
                            color: Colors.white,
                          )),
                    ),
                    SizedBox(width: 8),
                    InkWell(
                      // Approve
                      onTap: () => {
                        textFieldsListCtrl = true,
                        textFieldsList.forEach((element) {
                          if (element.text.isEmpty) textFieldsListCtrl = false;
                          //if (!textFieldsListCtrl) return;
                        }),
                        if (textFieldsListCtrl)
                          {
                            addLesson(),
                            //createFormScaffoldKey.currentState.setState(() {}),
                          },
                        textFieldsList.forEach((element) {
                          element.clear();
                        }),
                        node.unfocus(),
                        createFormPVCtrl.previousPage(
                            duration: Duration(milliseconds: 200),
                            curve: Curves.easeIn),
                      },
                      child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.green.shade400),
                          child: Icon(
                            Icons.done,
                            size: 40,
                            color: Colors.white,
                          )),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
