/*
Positioned(
  top: tlY < trY ? tlY : trY,
  left: tlX < blX ? tlX : blX,
  child: Container(
    width: (trX > brX ? trX : brX) - (tlX < blX ? tlX : blX),
    height: (blY > brY ? blY : brY) - (tlY < trY ? tlY : trY),
    decoration: BoxDecoration(
        color: Colors.black.withOpacity(.5),),
        //border: Border.all(color: Colors.green, width: 5)),
    child: RepaintBoundary(
      key: rbCtrl,
      child: ClipPath(
        clipper: RectangleOverlay(),
        child: Container(
          decoration: BoxDecoration(
              //color: Colors.green.withOpacity(.6),
              image: filePath.isEmpty
                  ? null
                  : DecorationImage(
                      image: FileImage(File(filePath)))),
        ),
      ),
    ),
  ),
), */