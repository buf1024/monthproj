import 'dart:math';

import 'package:flutter/material.dart';
import 'package:widget_demo/wrap_widget.dart';

/*
 CustomPaint

 实现自绘组件的一种方式，是通过CustomPaint组件实现的。
 CustomPaint提供2D的画布Canvas，要实现自绘，需要提供画笔CustomPainter。
 CustomPainter是抽象类，所以要实现自绘，需实现CustomPainter的接口。

通常，为了防止CustomPaint组件溢出自定义区域，CustomPaint组件经常使用ClipRect组件包裹，
如果CustomPaint有child(child参数不为空)，通常情况下都会将子节点包裹在RepaintBoundary组件中，以提高性能。
所以，使用CustomPaint的结构为：

ClipRect(
  child: CustomPaint(
    painter: MyTickerPainter(),
    child: RepaintBoundary(
      child: xxx
    )
  ),
),

 */
class CustomPaintWidget extends WrapWidget {
  CustomPaintWidget() : super(group: 'paint&effect', title: 'CustomPaint - 自绘');

  @override
  Widget child(BuildContext context) {
    return Container(
      width: 320,
      height: 120,
      child: ClipRect(
        child: CustomPaint(
          painter: _MyTickerPainter(),
          child: RepaintBoundary(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  '测试',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MyTickerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var gradient = LinearGradient(colors: [Colors.pink, Colors.red]);
    var paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.0
      ..shader = gradient.createShader(Offset.zero & size);

    var pathRect = Path();

    pathRect.moveTo(0, 0);
    pathRect.lineTo(size.width, 0);
    pathRect.lineTo(size.width, size.height);
    pathRect.lineTo(0, size.height);
    pathRect.lineTo(0, 0);

    var pathArc = Path();

    for (int i = 0; i < size.height / 20; i++) {
      double dy = i * 20.0;
      pathArc.addArc(
          Rect.fromCircle(center: Offset(0, dy + 8), radius: 5.0), -pi / 2, pi);

      pathArc.addArc(
          Rect.fromCircle(center: Offset(size.width, dy + 8), radius: 5.0),
          pi / 2,
          pi);
    }

    pathArc.addArc(
        Rect.fromCircle(center: Offset(size.width * 0.7, 0), radius: 6.0),
        0,
        pi);
    pathArc.addArc(
        Rect.fromCircle(
            center: Offset(size.width * 0.7, size.height), radius: 6.0),
        -pi,
        pi);

    pathArc.addArc(
        Rect.fromCircle(center: Offset(20, 20), radius: 8.0), 0, 2 * pi);

    var path = Path.combine(PathOperation.difference, pathRect, pathArc);

    canvas.drawPath(path, paint);

    paint
      ..style = PaintingStyle.stroke
      ..color = Colors.white
      ..strokeWidth = 2.0
      ..shader = null;

    var dy = 0.0;
    while (dy <= size.height - 6) {
      canvas.drawLine(Offset(size.width * 0.7, 6 + dy),
          Offset(size.width * 0.7, 6 + dy + 4.0), paint);
      dy += 10;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
