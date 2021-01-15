import 'package:flutter/material.dart';

class FormType {
  int questionAmount;
  int optionAmount;
  double formWidth;
  double formHeight;
  double optionWidth;
  double firstOptionX;
  double firstOptionY;
  double betweenOptions;

  FormType({
    @required this.questionAmount,
    @required this.optionAmount,
    @required this.formWidth,
    @required this.formHeight,
    @required this.optionWidth,
    @required this.firstOptionX,
    @required this.firstOptionY,
    @required this.betweenOptions,
  });
}
