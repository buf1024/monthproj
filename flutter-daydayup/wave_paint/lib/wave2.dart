
import 'package:flutter/material.dart';

class WaveWidget2Demo2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('水波纹'),
      ),
      body: Center(
          child: Stack(
        children: <Widget>[
          WaveWidget2(
            size: Size(200, 200),
            color: Colors.orange.withOpacity(0.8),
            ratio: 0.4,
            waveHeight: 20,
            offset: 10,
          ),
          WaveWidget2(
            size: Size(200, 200),
            color: Colors.blue.withOpacity(0.8),
            ratio: 0.4,
            waveHeight: 20,
            offset: -10,
          )
        ],
      )),
    );
  }
}

class WaveWidget2 extends StatefulWidget {
  final double ratio;
  final double offset;
  final double waveHeight;
  final Size size;
  final Color color;

  WaveWidget2(
      {required this.size,
      required this.ratio,
      required this.offset,
      required this.color,
      required this.waveHeight});

  @override
  State<StatefulWidget> createState() => _WaveWidget2State();
}

class _WaveWidget2State extends State<WaveWidget2>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void initState() {
    animationController =
        AnimationController(duration: Duration(seconds: 2), vsync: this)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              animationController.reset();
              animationController.forward();
            }
          });
    animation = Tween<double>(begin: -(widget.size.width / 4), end: widget.size.width / 4).animate(
        CurvedAnimation(parent: animationController, curve: Curves.linear));

    animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        var offset = animation.value + widget.offset;
        return ClipRect(
          child: Container(
            decoration: BoxDecoration(border: Border.all()),
            child: CustomPaint(
              size: widget.size,
              painter: WavePainter2(
                  color: widget.color,
                  ratio: widget.ratio,
                  offset: offset,
                  waveHeight: widget.waveHeight),
            ),
          ),
        );
      },
    );
  }
}

class WavePainter2 extends CustomPainter {
  final double ratio;
  final double offset;
  final Color color;
  final double waveHeight;

  WavePainter2(
      {required this.ratio,
      required this.offset,
      required this.color,
      required this.waveHeight});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color;

    var width = size.width / 4.0;

    for (var i = -2; i < 6; i++) {
      var startX = i * width + offset;
      var startY = (1 - ratio) * size.height;

      var controlX = i * width + offset + width / 2;
      var controlY = startY + (i % 2 == 0 ? -waveHeight : waveHeight);
      var pathPartArc = Path()
        ..moveTo(startX, startY)
        ..quadraticBezierTo(controlX, controlY, startX + width, startY);

      var pathPartRect = Path()
        ..addRect(Rect.fromLTRB(startX, startY, startX + width, size.height));

      var path = i % 2 == 0
          ? Path.combine(PathOperation.union, pathPartRect, pathPartArc)
          : Path.combine(PathOperation.difference, pathPartRect, pathPartArc);

      canvas.drawPath(path, paint);
    }

//    ..lineTo(size.width, size.height)..lineTo(0, size.height)..lineTo(
//    0, startY)


  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
