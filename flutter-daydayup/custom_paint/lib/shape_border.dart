import 'package:flutter/material.dart';

class ShapeBorderDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('shape border demo'),
      ),
      body: Center(
        child: Container(
          height: 200,
          width: 100,
          child: Material(
            color: Colors.orange,
            shape: MyShapeBorder(),
            child: Center(
              child: Text('电池', style: TextStyle(color: Colors.white),),
            ),
          ),
        ),
      ),
    );
  }
}

class MyShapeBorder extends ShapeBorder {
  @override
  // TODO: implement dimensions
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(0);

  @override
  Path getInnerPath(Rect rect, { TextDirection? textDirection }) {
    // TODO: implement getInnerPath
    return Path();
  }

  @override
  Path getOuterPath(Rect rect, { TextDirection? textDirection }) {
    // TODO: implement getOuterPath
    return Path()
      ..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(8)))
      ..addRRect(RRect.fromRectAndRadius(Rect.fromCircle(center: Offset(rect.width / 2, 10), radius: 20), Radius.circular(10)));

  }

  @override
  void paint(Canvas canvas, Rect rect, { TextDirection? textDirection }) {
  }

  @override
  ShapeBorder scale(double t) {
    // TODO: implement scale
    return Border();
  }
}

