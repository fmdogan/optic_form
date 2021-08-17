import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:permission_handler/permission_handler.dart';

//import 'package:bitirme_projesi/main.dart';
import 'package:bitirme_projesi/login_data.dart';
import 'package:bitirme_projesi/database_helper.dart';

import 'show_form.dart';

//var formListKey = new GlobalKey();
int formAmount = 0;

class AdminMain extends StatefulWidget {
  @override
  _AdminMainState createState() => _AdminMainState();
}

class _AdminMainState extends State<AdminMain> {
  final dbHelper = DatabaseHelper.instance;

  void permissions() async {
    // ignore: unused_local_variable
    final status = await Permission.storage.request();
  }

  Future formCounter(int _foreignID) async {
    await dbHelper.formCounter(_foreignID).then((value) => {
          formAmount = value,
          print("form sayisi: $formAmount"),
        });

    return formAmount;
  }

  void deleteForm(int formID) async {
    await dbHelper.delete('forms', formID).whenComplete(
          () => {
            Navigator.of(context)
                .pushNamedAndRemoveUntil("/admin_main", (route) => false),
            print("form silindi")
          },
        );
  }

  void fetchForms(int _foreignID) async {
    // Fetch forms of this user
    print("bu kullanıcının formları:");
    String _query =
        'SELECT * FROM ${DatabaseHelper.dbTables[1]} WHERE adminID = $_foreignID';
    await dbHelper.rawQuery(_query).then((_forms) => {
          loggedUser.forms = _forms,
          _forms.forEach((_form) => print(_form)),
        });

    // Fetch all forms
    print("tüm formlar:");
    await dbHelper
        .queryAllRows('forms')
        .then((value) => value.forEach((_form) => print(_form)));
  }

  @override
  void initState() {
    super.initState();
    permissions();
    fetchForms(loggedUser.id);
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: _size.height,
            padding: EdgeInsets.all(40),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.jpg"),
                fit: BoxFit.fitHeight,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Text(
                        "Admin",
                        style: TextStyle(
                          fontSize: 40,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
                      height: 500,
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.green.shade300.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        children: [
                          SizedBox(height: 10),
                          Text(
                            "Formlar",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: FutureBuilder(
                              //key: formListKey,
                              future: formCounter(loggedUser.id),
                              builder: (context, builder) {
                                return ListView.builder(
                                  itemCount: loggedUser.forms.length,
                                  itemBuilder:
                                      (BuildContext context, int _index) {
                                    return FlatButton(
                                      onPressed: () {
                                        print("form göster");
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ShowForm(
                                              loggedUser.forms[_index],
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        margin: EdgeInsets.all(10),
                                        height: 40,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white,
                                        ),
                                        child: Row(
                                          children: [
                                            SizedBox(width: 20),
                                            Expanded(
                                              child: Text(
                                                loggedUser.forms[_index]
                                                    ['formName'],
                                                style: TextStyle(
                                                  color: Colors.grey.shade700,
                                                  fontSize: 25,
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                Icons.cancel,
                                                color: Colors.red,
                                                size: 25,
                                              ),
                                              onPressed: () => deleteForm(
                                                  loggedUser.forms[_index]
                                                      ['formID']),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: FlatButton(
                      onPressed: () => {
                        Navigator.of(context).pushNamed("/create_form"),
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.green,
                        ),
                        padding: EdgeInsets.all(20),
                        child: Text(
                          "Form Oluştur",
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil("/", (route) => false);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.red,
                      ),
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Çıkış yap",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
