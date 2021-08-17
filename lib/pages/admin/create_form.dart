////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//import 'package:bitirme_projesi/pages/admin/create_form_companents.dart';
import 'package:bitirme_projesi/pages/admin/create_form_companents.dart';
//import 'package:bitirme_projesi/pages/admin/admin_main.dart';
import 'package:flutter/material.dart';

//GlobalKey createFormScaffoldKey = GlobalKey();
PageController createFormPVCtrl = PageController();

class CreateForm extends StatefulWidget {
  @override
  _CreateFormState createState() => _CreateFormState();
}

class _CreateFormState extends State<CreateForm> {
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    node = FocusScope.of(context);
    getTextFieldsList();
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        //formListKey.currentState.setState(() {});
        Navigator.pop(context);
      },
      child: SafeArea(
        child: Scaffold(
          //key: createFormScaffoldKey,
          body: Container(
            height: size.height,
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: PageView(
              controller: createFormPVCtrl,
              physics: new NeverScrollableScrollPhysics(),
              children: [
                CreateFormPage(),
                AddLessonPage(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
