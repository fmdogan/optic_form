import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PositionedCorner extends StatefulWidget {
  double x, y;

  PositionedCorner({Key key, @required this.x, this.y} ) : super(key: key);

  @override
  State createState() => _PositionedCornerState(x: x, y: y);
}

class _PositionedCornerState extends State<PositionedCorner> {
  double x, y;

  _PositionedCornerState({@required this.x, this.y});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: x,
      top: y,
      child: GestureDetector(
        onPanUpdate: (DragUpdateDetails details) {
          Offset _newPosition = details.globalPosition;
          setState(() {
            x = _newPosition.dx - 20;
            y = _newPosition.dy - 20;
          });
        },
        child: cornerDot(),
      ),
    );
  }

  Widget cornerDot() {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.green.withOpacity(0.6),
      ),
      child: Center(
        child: Container(
          height: 5,
          width: 5,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
