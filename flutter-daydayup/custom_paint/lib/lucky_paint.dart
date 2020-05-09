import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LuckyFunDemo extends StatelessWidget {
  LuckyFunDemo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Center(
          child: LuckWidget('下次再来, 祝君好运！'),
        ),
      ),
    );
  }
}

class LuckWidget extends StatefulWidget {
  final String text;
  LuckWidget(this.text);

  @override
  State<StatefulWidget> createState() => _LuckWidgetDemoState();
}

class _LuckWidgetDemoState extends State<LuckWidget> {
  Path drawPath = Path();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (TapDownDetails details) {
        var path = Path()..addOval(details.localPosition & Size(20, 20));
        setState(() {
          drawPath = Path.combine(PathOperation.union, drawPath, path);
        });
      },
      onPanUpdate: (DragUpdateDetails details) {
        var path = Path()..addOval(details.localPosition & Size(20, 20));
        setState(() {
          drawPath = Path.combine(PathOperation.union, drawPath, path);
        });

      },
      child: Container(
        width: 320,
        height: 120,
        decoration: BoxDecoration(), // 没有这个GestureDetector大大的有问题
        child: ClipRect(
          child: CustomPaint(
            foregroundPainter: MyLuckyPainter(path: drawPath),
            child: RepaintBoundary(
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  debugPrint(
                      '$constraints, ${constraints.biggest}, ${constraints.smallest}');
                  return Container(
                    constraints: constraints,
                    child: Center(
                      child: Container(
                        constraints: constraints,
                        decoration: BoxDecoration(
                          color: Colors.lightBlue
                        ),
                        child: Center(
                          child: Text(widget.text, style: TextStyle(
                              fontSize: 20,
                              color: Colors.white
                          ),),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MyLuckyPainter extends CustomPainter {
  final Path path;

  MyLuckyPainter({@required this.path});

  @override
  void paint(Canvas canvas, Size size) {
    debugPrint('set state');
    var gradient =
        LinearGradient(colors: [Colors.deepOrange, Colors.deepOrange]);
    var paint = Paint()
      ..isAntiAlias = false
      ..style = PaintingStyle.fill
      ..shader = gradient.createShader(Offset.zero & size);

    var rect = Path()..addRect(Offset.zero & size);

    canvas.drawPath(Path.combine(PathOperation.difference, rect, path), paint);

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
