import 'package:flutter/material.dart';

import '../../database_helper.dart';

class ShowLesson extends StatefulWidget {
  Map<String, dynamic> _lesson;

  ShowLesson(Map<String, dynamic> lesson) {
    this._lesson = lesson;
  }

  @override
  _ShowLessonState createState() => _ShowLessonState();
}

class _ShowLessonState extends State<ShowLesson> {
  final dbHelper = DatabaseHelper.instance;

  List<String> lessonDetailsList = [
    "Ders Adı",
    "Soru Sayısı",
    "Şık Sayısı",
    "Dersin Koordinatı X",
    "Dersin Koordinatı Y",
    "Ders Genişliği",
    "Ders Yüksekliği",
    "İlk Şık Koordinatı X",
    "İlk Şık Koordinatı Y",
    "Şık Genişliği",
    "Şıklar Arası Mesafe",
    "Doğru Cevaplar",
  ];

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
                padding: EdgeInsets.all(30),
                height: size.height - 70,
                width: size.width - 40,
                decoration: BoxDecoration(
                  color: Colors.red.shade200,
                  borderRadius: BorderRadius.all(Radius.circular(35.0)),
                ),
                child: ListView.builder(
                  itemCount: widget._lesson.length - 2,
                  itemBuilder: (BuildContext context, int _index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                      "${lessonDetailsList[_index]}: ${widget._lesson[DatabaseHelper.dbColumns['lessons'][_index + 2]]}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                      ),
                    ),
                        _index < (widget._lesson.length - 3)
                            ? Divider(height: 20, thickness: 5)
                            : SizedBox(height: 20),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
