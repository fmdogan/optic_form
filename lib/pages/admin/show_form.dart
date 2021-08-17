////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//import 'package:bitirme_projesi/pages/admin/create_form_companents.dart';
//import 'package:bitirme_projesi/pages/admin/admin_main.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../database_helper.dart';
import '../../login_data.dart';

import 'package:bitirme_projesi/pages/admin/show_lesson.dart';

PageController showFormPVCtrl = PageController();

class ShowForm extends StatefulWidget {
  Map<String, dynamic> _form;

  ShowForm(form) {
    this._form = form;
  }

  @override
  _ShowFormState createState() => _ShowFormState();
}

class _ShowFormState extends State<ShowForm> {
  final dbHelper = DatabaseHelper.instance;
  List<Map<String, dynamic>> fetchedLessons = [];

  Future fetchLessons(int _foreignID) async {
    // Fetch forms of this user
    print("bu formun dersleri:");
    String _query =
        'SELECT * FROM ${DatabaseHelper.dbTables[2]} WHERE formID = $_foreignID';
    await dbHelper.rawQuery(_query).then((_lessons) => {
          fetchedLessons = _lessons,
          _lessons.forEach((_form) => print(_form)),
        });
  }

  void deleteForm() async {
    await dbHelper.delete('forms', widget._form['formID']).whenComplete(
          () => {
            Navigator.of(context)
                .pushNamedAndRemoveUntil("/admin_main", (route) => false),
            print("form silindi")
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Material(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(15),
                height: size.height - 70,
                width: size.width - 40,
                decoration: BoxDecoration(
                  color: Colors.red.shade200,
                  borderRadius: BorderRadius.all(Radius.circular(35.0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Form Adı: ${widget._form['formName']}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                      ),
                    ),
                    Divider(height: 20, thickness: 5),
                    Text(
                      "Form Genişliği: ${widget._form['formWidth']}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                      ),
                    ),
                    Divider(height: 20, thickness: 5),
                    Text(
                      "Form Yüksekliği: ${widget._form['formHeight']}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                      ),
                    ),
                    Divider(height: 20, thickness: 5),
                    Text(
                      " Dersler: ",
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 5),
                    Expanded(
                      //height: 200,
                      child: FutureBuilder(
                        //key: formListKey,
                        future: fetchLessons(widget._form['formID']),
                        builder: (context, builder) {
                          return ListView.builder(
                            itemCount: fetchedLessons.length,
                            itemBuilder: (BuildContext context, int _index) {
                              return FlatButton(
                                onPressed: () {
                                  print("dersi göster");
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ShowLesson(
                                        fetchedLessons[_index]
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                  ),
                                  child: Center(
                                    child: Text(
                                      fetchedLessons[_index]['lessonName'],
                                      style: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontSize: 25,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: RepaintBoundary(
                        child: QrImage(
                          data: widget._form['formID'].toString(),
                          size: 0.5 * size.width,
                        ),
                      ),
                    ),
                    FlatButton(
                      onPressed: deleteForm,
                      child: Container(
                        margin: EdgeInsets.all(10),
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.red.shade900,
                        ),
                        child: Center(
                          child: Text(
                            "Formu sil",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
