import 'package:bitirme_projesi/form_class.dart';
import 'package:flutter/material.dart';

PageController formResultPVCtrl = PageController(
  viewportFraction: 0.8,
);

// ignore: must_be_immutable
class FormResult extends StatefulWidget {
  FormType form;
  FormResult({Key key, @required this.form}) : super(key: key);

  @override
  _FormResultState createState() => _FormResultState(form: form);
}

class _FormResultState extends State<FormResult> {
  FormType form;
  _FormResultState({@required this.form});

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        //form.lessons.forEach((_lessonsElement) {
        //  _lessonsElement.userAnswers = [];
        //});
      },
      child: SafeArea(
        child: Scaffold(
          body: Container(
            //height: _size.height,
            //width: _size.width,
            child: PageView.builder(
                controller: formResultPVCtrl,
                //scrollDirection: Axis.vertical,
                itemCount: form.lessons.length,
                itemBuilder: (context, formResultPVIndex) {
                  List<List<String>> _userAnswers =
                      form.lessons[formResultPVIndex].userAnswers;
                  List<String> _correctAnswers =
                      form.lessons[formResultPVIndex].correctAnswers;
                  return Container(
                    padding: EdgeInsets.symmetric(
                        vertical: _size.width - (_size.width * .8) - 40, horizontal: 10),
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.green,
                            width: 5,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(35.0)),
                        ),
                        child: Column(
                          children: [
                            Text(
                              // Lesson name
                              form.lessons[formResultPVIndex].name,
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SingleChildScrollView(
                              // Not sure about SCSW widget. Need a test with more than 30 questions.
                              // Height may need to be limited.
                              child: Center(
                                child: Container(
                                  height: 30 *
                                      form.lessons[formResultPVIndex]
                                          .questionAmount
                                          .toDouble(),
                                  width: 30 +
                                      form.lessons[formResultPVIndex]
                                              .questionAmount
                                              .toDouble() *
                                          (10 + 25),
                                  child: ListView.builder(
                                    // Questions Listview
                                    itemCount: form.lessons[formResultPVIndex]
                                        .questionAmount,
                                    itemBuilder: (context, questionLVIndex) {
                                      return Row(
                                        // Options Line Row
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: _size.width / 12,
                                            child: Text(
                                              (questionLVIndex + 1).toString() +
                                                  ". ",
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          ),
                                          Container(
                                            height: 30,
                                            width: form.lessons[formResultPVIndex]
                                                    .optionAmount
                                                    .toDouble() *
                                                (10 + 25),
                                            child: ListView.builder(
                                              // Options Listview
                                              scrollDirection: Axis.horizontal,
                                              itemCount: form
                                                  .lessons[formResultPVIndex]
                                                  .optionAmount,
                                              itemBuilder:
                                                  (context, optionLVIndex) {
                                                return Row(
                                                  // Options' Row
                                                  children: [
                                                    SizedBox(width: 10),
                                                    Container(
                                                      height: 25,
                                                      width: 25,
                                                      decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color: (!_userAnswers[
                                                                          questionLVIndex]
                                                                      .contains(answerTypes[
                                                                          optionLVIndex]) &&
                                                                  answerTypes[optionLVIndex] !=
                                                                      _correctAnswers[
                                                                          questionLVIndex])
                                                              ? Colors.transparent
                                                              : (_userAnswers[questionLVIndex].contains(
                                                                          answerTypes[
                                                                              optionLVIndex]) &&
                                                                      answerTypes[
                                                                              optionLVIndex] !=
                                                                          _correctAnswers[
                                                                              questionLVIndex])
                                                                  ? Colors.red
                                                                  : (_userAnswers[questionLVIndex].contains(answerTypes[optionLVIndex]) &&
                                                                          answerTypes[optionLVIndex] ==
                                                                              _correctAnswers[
                                                                                  questionLVIndex])
                                                                      ? Colors
                                                                          .green
                                                                      : Colors
                                                                          .yellow,
                                                          border: Border.all(
                                                              color: Colors.black,
                                                              width: 2)),
                                                      child: Center(
                                                        child: Text(
                                                          answerTypes[
                                                              optionLVIndex],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ); // Options' Row
                                              },
                                            ), // Options Listview
                                          )
                                        ],
                                      ); // Options Line Row
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ),
      ),
    );
  }
}
