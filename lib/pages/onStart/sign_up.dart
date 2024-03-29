import 'dart:ui';

import 'package:bitirme_projesi/database_helper.dart';
import 'package:flutter/material.dart';

import '../../login_data.dart';
import 'on_start.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final dbHelper = DatabaseHelper.instance;

  TextEditingController signUpNickCtrl = TextEditingController(); // ID ctrl
  TextEditingController signUpMailCtrl = TextEditingController(); // Mail ctrl
  TextEditingController signUpPwCtrl = TextEditingController(); // Password ctrl
  FocusNode signUpNickNode = FocusNode();
  FocusNode signUpMailNode = FocusNode();
  FocusNode signUpPwNode = FocusNode();

  bool isSignUpAdmin = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Center(
      child: Container(
        //width: size.width * 2 / 3,
        padding: EdgeInsets.symmetric(horizontal: size.width * 1 / 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Kaydol",
              style: TextStyle(
                fontSize: size.width / 8,
                color: Colors.grey.shade800,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: size.height / 15),
            TextField(
              controller: signUpNickCtrl,
              focusNode: signUpNickNode,
              showCursor: true,
              decoration: InputDecoration(
                icon: Icon(Icons.account_circle_outlined, size: 35),
                labelText: "Kullanıcı Adı",
              ),
              onSubmitted: (idText) => {
                FocusScope.of(context).requestFocus(signUpMailNode),
              },
            ),
            TextField(
              controller: signUpMailCtrl,
              focusNode: signUpMailNode,
              showCursor: true,
              decoration: InputDecoration(
                icon: Icon(Icons.mail_outline, size: 35),
                labelText: "E-mail",
              ),
              onSubmitted: (mailText) => {
                FocusScope.of(context).requestFocus(signUpPwNode),
              },
            ),
            TextField(
              controller: signUpPwCtrl,
              focusNode: signUpPwNode,
              showCursor: true,
              decoration: InputDecoration(
                icon: InkWell(
                  onTap: () {},
                  child: Icon(Icons.lock_open, size: 35),
                ),
                labelText: "Şifre",
              ),
              onSubmitted: (pwText) => {},
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isSignUpAdmin = false;
                    });
                  },
                  child: Row(
                    children: [
                      Icon(
                        isSignUpAdmin
                            ? Icons.radio_button_off
                            : Icons.radio_button_on,
                      ),
                      SizedBox(width: 5),
                      Text(
                        "Öğrenci",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isSignUpAdmin = true;
                    });
                  },
                  child: Row(
                    children: [
                      Icon(
                        isSignUpAdmin
                            ? Icons.radio_button_on
                            : Icons.radio_button_off,
                      ),
                      SizedBox(width: 5),
                      Text(
                        "Admin",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(width: 20),
                IconButton(
                  icon: Icon(Icons.arrow_back_ios_rounded),
                  color: Colors.grey.shade800,
                  iconSize: 100,
                  onPressed: () => {
                    FocusScope.of(context).unfocus(),
                    onStartPageCtrl.previousPage(
                      duration: Duration(milliseconds: 800),
                      curve: Curves.ease,
                    ),
                  },
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward_ios_rounded),
                  color: Colors.grey.shade800,
                  iconSize: 100,
                  onPressed: registerButton,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void registerButton() async {
    FocusScope.of(context).unfocus();

    var _checkMail =
        await dbHelper.doesExist('users', 'mail', signUpMailCtrl.text);
    var _checkNick =
        await dbHelper.doesExist('users', 'userName', signUpNickCtrl.text);
    if (_checkMail.isEmpty && _checkNick.isEmpty) {
      Map<String, dynamic> _row = {
        DatabaseHelper.dbColumns['users'][1]: signUpNickCtrl.text,
        DatabaseHelper.dbColumns['users'][2]: signUpMailCtrl.text,
        DatabaseHelper.dbColumns['users'][3]: signUpPwCtrl.text,
        DatabaseHelper.dbColumns['users'][4]:
            isSignUpAdmin ? 'admin' : 'student',
      };
      dbHelper.insert('users', _row);
      print("Kayıt tamamlandı");

      await dbHelper
          .fetchRow('users', 'userName', signUpNickCtrl.text)
          .then((_result) => {
                loggedUser = LoggedUser(
                  _result['userID'],
                  _result['userName'],
                  _result['mail'],
                  _result['userType'],
                ),
                isSignUpAdmin
                    ? Navigator.pushNamed(context, "/admin_main")
                    : Navigator.pushNamed(context, "/student_main"),
              });
    } else {
      print("Bu mail veya kullanıcı adı zaten kullanılmaktadır");
    }

    var allRows = await dbHelper.queryAllRows('users');
    print('Tüm kullanıcılar:');
    allRows.forEach((row) => print(row));
  }
}
