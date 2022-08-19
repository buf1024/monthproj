import 'dart:math';
import 'package:flutter/material.dart';

class CustomPaintDemo extends StatefulWidget {
  CustomPaintDemo({Key? key}) : super(key: key);

  @override
  _CustomPaintDemoState createState() => _CustomPaintDemoState();
}

class _CustomPaintDemoState extends State<CustomPaintDemo> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Center(
          child: InkWell(
            onTap: () {
              debugPrint('on tap');
            },
            child: Stack(
              children: <Widget>[
                ClipRect(
                  child: CustomPaint(
                    size: Size(320, 120),
                    painter: MyTickerPainter(),
                  ),
                ),
                Positioned.fromRect(
                    rect: Rect.fromLTRB(0, 0, 320 * 0.7, 120),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(height: 25,),
                                Text(
                                  '￥',
                                  style:
                                  TextStyle(color: Colors.white, fontSize: 15.0),
                                )
                              ],
                            ),
                            Text(
                              '200',
                              style:
                              TextStyle(color: Colors.white, fontSize: 60.0),
                            ),
                            Column(
                              children: <Widget>[
                                Text(
                                  '优',
                                  textAlign: TextAlign.end,
                                  style:
                                  TextStyle(color: Colors.white, fontSize: 13.0),
                                ),Text(
                                  '惠',
                                  textAlign: TextAlign.end,
                                  style:
                                  TextStyle(color: Colors.white, fontSize: 13.0),
                                ),Text(
                                  '券',
                                  textAlign: TextAlign.end,
                                  style:
                                  TextStyle(color: Colors.white, fontSize: 13.0),
                                ),
                              ],
                            )
                          ],
                        ),
                        Text(
                          '订单满599可使用',
                          textAlign: TextAlign.end,
                          style:
                          TextStyle(color: Colors.white70, fontSize: 13.0),
                        )
                      ],
                    )),
                Positioned.fromRect(
                  rect: Rect.fromLTRB(320 * 0.7, 0, 320, 120),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '立',
                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                      ),
                      Text(
                        '刻',
                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                      ),
                      Text(
                        '使',
                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                      ),
                      Text(
                        '用',
                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyTickerPainter extends CustomPainter {
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