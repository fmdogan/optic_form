import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

class FormType {
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
//ans  opt  coords
  List<List<List<double>>> optionsCoords = [];
  List<int> userAnswers = [];

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
    /// [0] - form1 type
    FormType(
      formWidth: 194,
      formHeight: 429,
      lessons: [
        Lesson(
          name: "Türkçe",
          questionAmount: 10,
          //questionPerPart: 10,
          optionAmount: 4,
          lessonX: 0,
          lessonY: 0,
          lessonWidth: 194,
          lessonHeight: 429,
          firstOptionX: 58,
          firstOptionY: 54,
          optionWidth: 28,
          optionsDistance: 40,
        ),
      ],
    ),
    ///////////////////////////////////////////////
    /// [1] - cokluform type
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
          optionWidth: 28,
          optionsDistance: 19.3,
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
        ),
      ],
    ),
    ///////////////////////////////////////////////
    /// [2] - cokluform type - Sosyal
    FormType(
      formWidth: 119,
      formHeight: 442,
      lessons: [
        Lesson(
          name: "Sosyal",
          questionAmount: 10,
          //questionPerPart: 10,
          optionAmount: 4,
          lessonX: 7,
          lessonY: 8,
          lessonWidth: 106,
          lessonHeight: 429,
          firstOptionX: 35,
          firstOptionY: 58,
          optionWidth: 17,
          optionsDistance: 19.5,
        ),
      ],
    ),
    ///////////////////////////////////////////////
    /// [3] - cokluform type - Sosyal 2
    FormType(
      formWidth: 103,
      formHeight: 422,
      lessons: [
        Lesson(
          name: "Sosyal",
          questionAmount: 10,
          //questionPerPart: 10,
          optionAmount: 4,
          lessonX: 0,
          lessonY: 0,
          lessonWidth: 106,
          lessonHeight: 429,
          firstOptionX: 33,
          firstOptionY: 50,
          optionWidth: 17,
          optionsDistance: 20,
        ),
      ],
    ),
    ///////////////////////////////////////////////
    /// [4] - multiform type - 1 - kopya
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
        ),
      ],
    ),
    ///////////////////////////////////////////////
  ]; // create forms list
  return forms[form];
}