import 'package:bitirme_projesi/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

List<String> answerTypes = [
  "A",
  "B",
  "C",
  "D",
  "E",
  "F",
];

class FormType {
  String qrFormID = "";
  List<Lesson> lessons;
  double formWidth;
  double formHeight;

  FormType({
    @required this.lessons,
    @required this.formWidth,
    @required this.formHeight,
  });
}

class Lesson {
  String name;
  int questionAmount;
  //int partAmount = 1;
  //int questionPerPart;
  int optionAmount;
  double lessonX;
  double lessonY;
  double lessonWidth;
  double lessonHeight;
  double firstOptionX;
  double firstOptionY;
  double optionWidth;
  double optionsDistance;
  List<List<String>> userAnswers = [];
  List<String> correctAnswers = [];
//ans  opt  coords
  List<List<List<double>>> optionsCoords = [];

  Lesson({
    @required this.name,
    @required this.questionAmount,
    //this.partAmount,
    //@required this.questionPerPart,
    @required this.optionAmount,
    @required this.lessonX,
    @required this.lessonY,
    @required this.lessonWidth,
    @required this.lessonHeight,
    @required this.firstOptionX,
    @required this.firstOptionY,
    @required this.optionWidth,
    @required this.optionsDistance,
    @required this.correctAnswers,
  });

  // Save Coords of options
  void saveCoords(img.Image lessonImage) {
    double lessonRate = lessonImage.width / lessonWidth;

    for (double question = 0; question < this.questionAmount; question++) {
      this.optionsCoords.add([]);
      for (double option = 0; option < this.optionAmount; option++) {
        this.optionsCoords[question.toInt()].add([
          (this.firstOptionX + (this.optionsDistance * option)) * lessonRate,
          (this.firstOptionY + (this.optionsDistance * question)) * lessonRate,
        ]);
      }
    }
  }
}

FormType getFormData(int form) {
  List<FormType> forms = [
    /// [0] - form 0 - tekli
    FormType(
      formWidth: 194,
      formHeight: 429,
      lessons: [
        Lesson(
          name: "Türkçe",
          //questionPerPart: 10,
          questionAmount: 10,
          optionAmount: 4,
          lessonX: 0,
          lessonY: 0,
          lessonWidth: 194,
          lessonHeight: 429,
          firstOptionX: 58,
          firstOptionY: 54,
          optionWidth: 28,
          optionsDistance: 40,
          correctAnswers: ["A", "C", "B", "B", "A", "D", "A", "C", "C", "D"],
        ),
      ],
    ),
    ///////////////////////////////////////////////
    /// [1] - form 1 - coklu
    FormType(
      formWidth: 400,
      formHeight: 426,
      lessons: [
        Lesson(
          name: "Türkçe",
          questionAmount: 10,
          //questionPerPart: 10,
          optionAmount: 4,
          lessonX: 0,
          lessonY: 33,
          lessonWidth: 200,
          lessonHeight: 392,
          firstOptionX: 61,
          firstOptionY: 20,
          optionWidth: 28,
          optionsDistance: 40,
          correctAnswers: ["C", "B", "D", "B", "A", "B", "D", "C", "B", "D"],
        ),
        Lesson(
          name: "Sosyal",
          questionAmount: 10,
          //questionPerPart: 10,
          optionAmount: 4,
          lessonX: 200,
          lessonY: 33,
          lessonWidth: 200,
          lessonHeight: 392,
          firstOptionX: 60,
          firstOptionY: 20,
          optionWidth: 28,
          optionsDistance: 40,
          correctAnswers: ["B", "C", "B", "A", "D", "D", "A", "A", "C", "B"],
        ),
      ],
    ),
    ///////////////////////////////////////////////
    /// [2] - form 2 - coklu
    FormType(
      formWidth: 798,
      formHeight: 429,
      lessons: [
        Lesson(
          name: "TÜRKÇE",
          questionAmount: 10,
          //questionPerPart: 10,
          optionAmount: 4,
          lessonX: 0,
          lessonY: 34,
          lessonWidth: 199.4,
          lessonHeight: 395,
          firstOptionX: 60,
          firstOptionY: 20,
          optionWidth: 28,
          optionsDistance: 40,
          correctAnswers: ["B", "B", "A", "C", "A", "B", "D", "B", "C", "B"],
        ),
        Lesson(
          name: "MATEMATİK",
          questionAmount: 10,
          //questionPerPart: 10,
          optionAmount: 4,
          lessonX: 199,
          lessonY: 34,
          lessonWidth: 199.4,
          lessonHeight: 395,
          firstOptionX: 60,
          firstOptionY: 20,
          optionWidth: 28,
          optionsDistance: 40,
          correctAnswers: ["C", "B", "B", "B", "C", "D", "A", "C", "A", "D"],
        ),
        Lesson(
          name: "FEN",
          questionAmount: 10,
          //questionPerPart: 10,
          optionAmount: 4,
          lessonX: 399,
          lessonY: 34,
          lessonWidth: 199.4,
          lessonHeight: 395,
          firstOptionX: 60,
          firstOptionY: 20,
          optionWidth: 28,
          optionsDistance: 40,
          correctAnswers: ["A", "C", "B", "B", "C", "D", "D", "B", "C", "C"],
        ),
        Lesson(
          name: "SOSYAL",
          questionAmount: 10,
          //questionPerPart: 10,
          optionAmount: 4,
          lessonX: 598,
          lessonY: 34,
          lessonWidth: 199.4,
          lessonHeight: 395,
          firstOptionX: 60,
          firstOptionY: 20,
          optionWidth: 28,
          optionsDistance: 40,
          correctAnswers: ["A", "C", "B", "B", "A", "C", "D", "C", "C", "D"],
        ),
      ],
    ),
    ///////////////////////////////////////////////
    ////// [3] - form 3 - coklu
    FormType(
      formWidth: 553,
      formHeight: 323,
      lessons: [
        Lesson(
          name: "Türkçe",
          questionAmount: 10,
          //questionPerPart: 10,
          optionAmount: 5,
          lessonX: 3,
          lessonY: 17,
          lessonWidth: 174,
          lessonHeight: 304,
          firstOptionX: 38,
          firstOptionY: 15,
          optionWidth: 21,
          optionsDistance: 30.4,
          correctAnswers: ["B", "C", "B", "D", "B", "D", "D", "E", "C", "D"],
        ),
        Lesson(
          name: "Matematik",
          questionAmount: 10,
          //questionPerPart: 10,
          optionAmount: 5,
          lessonX: 190,
          lessonY: 17,
          lessonWidth: 174,
          lessonHeight: 304,
          firstOptionX: 38,
          firstOptionY: 15,
          optionWidth: 21,
          optionsDistance: 30.4,
          correctAnswers: ["C", "C", "E", "D", "A", "A", "C", "B", "C", "D"],
        ),
        Lesson(
          name: "İngilizce",
          questionAmount: 10,
          //questionPerPart: 10,
          optionAmount: 5,
          lessonX: 377,
          lessonY: 17,
          lessonWidth: 174,
          lessonHeight: 304,
          firstOptionX: 38,
          firstOptionY: 15,
          optionWidth: 21,
          optionsDistance: 30.4,
          correctAnswers: ["A", "D", "D", "B", "B", "A", "A", "D", "C", "D"],
        ),
      ],
    ), // [3] - form 3
    ///////////////////////////////////////////////
    /// [4] - form 4 - coklu
    FormType(
      formWidth: 488,
      formHeight: 443,
      lessons: [
        Lesson(
          name: "Türkçe",
          questionAmount: 20,
          //questionPerPart: 10,
          optionAmount: 4,
          lessonX: 11,
          lessonY: 8,
          lessonWidth: 109,
          lessonHeight: 423,
          firstOptionX: 34,
          firstOptionY: 52,
          optionWidth: 17,
          optionsDistance: 19.2,
          correctAnswers: [
            "A",
            "C",
            "B",
            "B",
            "B",
            "D",
            "A",
            "C",
            "A",
            "D",
            "A",
            "B",
            "B",
            "B",
            "C",
            "D",
            "A",
            "C",
            "B",
            "B"
          ],
        ),
        Lesson(
          name: "Sosyal",
          questionAmount: 10,
          //questionPerPart: 10,
          optionAmount: 4,
          lessonX: 133,
          lessonY: 8,
          lessonWidth: 106,
          lessonHeight: 429,
          firstOptionX: 33,
          firstOptionY: 53,
          optionWidth: 17,
          optionsDistance: 19.1,
          correctAnswers: ["A", "C", "C", "D", "B", "B", "A", "B", "C", "C"],
        ),
        Lesson(
          name: "Din",
          questionAmount: 10,
          //questionPerPart: 10,
          optionAmount: 4,
          lessonX: 252,
          lessonY: 9,
          lessonWidth: 105,
          lessonHeight: 428,
          firstOptionX: 35,
          firstOptionY: 52,
          optionWidth: 17,
          optionsDistance: 19.3,
          correctAnswers: ["C", "B", "B", "D", "C", "B", "A", "C", "A", "A"],
        ),
        Lesson(
          name: "İngilizce",
          questionAmount: 10,
          //questionPerPart: 10,
          optionAmount: 4,
          lessonX: 373,
          lessonY: 9,
          lessonWidth: 105,
          lessonHeight: 428,
          firstOptionX: 34,
          firstOptionY: 52,
          optionWidth: 17,
          optionsDistance: 19.3,
          correctAnswers: ["A", "C", "B", "B", "D", "D", "C", "D", "C", "D"],
        ),
      ],
    ), // [3] - form 3
    ///////////////////////////////////////////////
  ]; // create forms list
  return forms[form];
}

class LessonToSave {
  String name;
  String questionAmount;
  String optionAmount;
  String lessonX;
  String lessonY;
  String lessonWidth;
  String lessonHeight;
  String firstOptionX;
  String firstOptionY;
  String optionWidth;
  String optionsDistance;
  String correctAnswers;

  LessonToSave({
    @required this.name,
    @required this.questionAmount,
    @required this.optionAmount,
    @required this.lessonX,
    @required this.lessonY,
    @required this.lessonWidth,
    @required this.lessonHeight,
    @required this.firstOptionX,
    @required this.firstOptionY,
    @required this.optionWidth,
    @required this.optionsDistance,
    @required this.correctAnswers,
  });
}

Future<FormType> getForm(int _formID) async {
  print("FormID: $_formID");
  FormType form;
  List<Lesson> _lessons = [];

  final dbHelper = DatabaseHelper.instance;

  dbHelper
      .fetchLessons(_formID)
      .then((value) => {
            value.forEach((element) {
              String _answersInLine = element['correctAnswers'];
              List<String> _answers = _answersInLine.split(" ");
              
              print(element['lessonName']);
              _lessons.add(Lesson(
                name: element['lessonID'],
                //questionPerPart: 10,
                questionAmount: element['questionAmount'],
                optionAmount: element['optionAmount'],
                lessonX: element['lessonX'],
                lessonY: element['lessonY'],
                lessonWidth: element['lessonWidth'],
                lessonHeight: element['lessonHeight'],
                firstOptionX: element['firstOptionX'],
                firstOptionY: element['firstOptionY'],
                optionWidth: element['optionWidth'],
                optionsDistance: element['optionsDistance'],
                correctAnswers: _answers,
              ));
            })
          })
      .whenComplete(() => {
            dbHelper.fetchForm(_formID).then((value) => {
              print(value[0]['formName']),
              print(value[0]['formHeight']),
                  form = FormType(
                    formWidth: value[0]['formWidth'],
                    formHeight: value[0]['formHeight'],
                    lessons: _lessons,
                  )
                }),
          });
  /*FormType form = FormType(
    formWidth: _formData[0]['formWidth'],
    formHeight: _formData[0]['formHeight'],
    lessons: _lessons,
  );*/
  return form;
}
