import 'dart:ui';

import 'package:bitirme_projesi/database_helper.dart';
import 'package:bitirme_projesi/login_data.dart';
import 'package:flutter/material.dart';

import 'on_start.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final dbHelper = DatabaseHelper.instance;

  TextEditingController loginIdCtrl = TextEditingController(); // ID controller
  TextEditingController loginPwCtrl =
      TextEditingController(); // Password controller
  FocusNode loginIdNode = FocusNode();
  FocusNode loginPwNode = FocusNode();

  bool isLoginAdmin = false;
  bool isLocked = true;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      //width: size.width * 2 / 3,
      padding: EdgeInsets.symmetric(horizontal: size.width * 1 / 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Giriş Yap",
            style: TextStyle(
              fontSize: size.width / 8,
              color: Colors.grey.shade800,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: size.height / 15),
          TextField(
            controller: loginIdCtrl,
            focusNode: loginIdNode,
            showCursor: true,
            decoration: InputDecoration(
              icon: Icon(Icons.account_circle_outlined, size: 35),
              labelText: "Kullanıcı Adı",
            ),
            onSubmitted: (idText) => {
              FocusScope.of(context).requestFocus(loginPwNode),
            },
          ),
          TextField(
            controller: loginPwCtrl,
            focusNode: loginPwNode,
            showCursor: true,
            obscureText: isLocked ? true : false,
            obscuringCharacter: "*",
            decoration: InputDecoration(
              icon: InkWell(
                onTap: () {
                  setState(() {
                    if (FocusScope.of(context).focusedChild == loginPwNode)
                      isLocked = !isLocked;
                  });
                },
                child: Icon(
                    isLocked ? Icons.lock_outline : Icons.lock_open_outlined,
                    size: 35),
              ),
              labelText: "Şifre",
            ),
            onSubmitted: (pwText) => {},
          ),
          SizedBox(height: 15),
          IconButton(
            icon: Icon(Icons.arrow_forward_ios_rounded), //forward_rounded
            color: Colors.grey.shade800,
            iconSize: 100,
            onPressed: loginButton,
          ),
          SizedBox(height: 20),
          InkWell(
            child: Text(
              "Yeni Hesap Oluştur",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            onTap: () => {
              FocusScope.of(context).unfocus(),
              onStartPageCtrl.nextPage(
                duration: Duration(milliseconds: 800),
                curve: Curves.ease,
              ),
            },
          ),
          SizedBox(height: 8),
          InkWell(
            child: Text(
              "Şifremi Unuttum",
              style: TextStyle(fontSize: 17),
            ),
            onTap: () => {},
          ),
        ],
      ),
    );
  }

  void loginButton() async {
    FocusScope.of(context).unfocus();

    dbHelper.fetchRow('users', 'userName', loginIdCtrl.text).then(
      (_result) async {
        if (_result.isNotEmpty && _result['password'] == loginPwCtrl.text) {
          loggedUser = LoggedUser(
            _result['userID'],
            _result['userName'],
            _result['mail'],
            _result['userType'],
          );

          print('Tüm kullanıcılar:');
          await dbHelper
              .queryAllRows('users')
              .then((_users) => _users.forEach((_user) => print(_user)));

          //loggedUserID = _result['userID'];
          print("Giriş yapıldı. Kullanıcı ID: ${loggedUser.id}");
          _result['userType'] == 'admin'
              ? Navigator.pushNamed(context, "/admin_main")
              : Navigator.pushNamed(context, "/student_main");
        } else {
          print("Kullanıcı adı veya şifre hatalı");
        }
      },
    );
  }
}
