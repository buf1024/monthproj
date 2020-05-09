import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WaveWidgetDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('水波纹'),
      ),
      body: Center(
          child: Stack(
        children: <Widget>[
          WaveWidget(
            size: Size(200, 200),
            color: Colors.orange.withOpacity(0.8),
            ratio: 0.4,
            waveHeight: 40,
            startHeight: 10,
          ),
          WaveWidget(
            size: Size(200, 200),
            color: Colors.blue.withOpacity(0.8),
            ratio: 0.4,
            waveHeight: 40,
            startHeight: -10,
          )
        ],
      )),
    );
  }
}

class WaveWidget extends StatefulWidget {
  final double ratio;
  final double waveHeight;
  final double startHeight;
  final Size size;
  final Color color;

  WaveWidget(
      {@required this.size,
      @required this.ratio,
      @required this.waveHeight,
      @required this.color,
      this.startHeight = 0.0});

  @override
  State<StatefulWidget> createState() => _WaveWidgetState();
}

class _WaveWidgetState extends State<WaveWidget>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;

  @override
  void initState() {
    animationController =
        AnimationController(duration: Duration(seconds: 5), vsync: this)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              animationController.reverse();
            }
            if (status == AnimationStatus.dismissed) {
              animationController.forward();
            }
          });
    animation = Tween<double>(begin: -1, end: 1).animate(
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
      builder: (BuildContext context, Widget child) {
        var height =
            animation.value * (widget.waveHeight / 2) + widget.startHeight;
        if (height > widget.waveHeight / 2) {
          height = widget.waveHeight - height;
        }
        if(height < -widget.waveHeight / 2) {
          height = -widget.waveHeight - height;
        }
        return ClipRect(
          child: Container(
            decoration: BoxDecoration(border: Border.all()),
            child: CustomPaint(
              size: widget.size,
              painter: WavePainter(
                  color: widget.color,
                  ratio: widget.ratio,
                  waveHeight: height),
            ),
          ),
        );
      },
    );
  }
}

class WavePainter extends CustomPainter {
  final double ratio;
  final double waveHeight;
  final Color color;

  WavePainter(
      {@required this.ratio, @required this.waveHeight, @required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color;

    var path = Path();

    var startY = size.height * (1.0 - ratio) + waveHeight;
    var endY = size.height * (1.0 - ratio) - waveHeight;
    var controlX = size.width / 2.0;
    var controlY = waveHeight > 0
        ? (size.height * (1.0 - ratio) - waveHeight)
        : (size.height * (1.0 - ratio) + waveHeight);

    path
      ..moveTo(0, startY)
      ..quadraticBezierTo(controlX, controlY, size.width, endY)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..lineTo(0, startY);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
