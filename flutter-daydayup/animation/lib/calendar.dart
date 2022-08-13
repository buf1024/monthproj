import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';

class CalendarAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ignore: todo
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('翻转动画演示'),
      ),
      body: Center(
        child: CalendarWidget(),
      ),
    );
  }
}

enum _CalendarAnimateStatus { None, TopDown, BottomDown }
enum _CalendarLayer { Top, Bottom }

class CalendarWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;
  Animation<double> animationView;
  _CalendarAnimateStatus animateStatus = _CalendarAnimateStatus.None;

  Timer tm;

  int value = 0;

  @override
  void initState() {
    animationController =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this)
          ..addStatusListener((state) {
            if (state == AnimationStatus.completed) {
              setState(() {
                animateStatus = _CalendarAnimateStatus.BottomDown;
              });
              animationController.reverse();
            }
            if (state == AnimationStatus.dismissed) {
              setState(() {
                animateStatus = _CalendarAnimateStatus.None;
                if (value == 9) {
                  value = 0;
                } else {
                  value = value + 1;
                }
              });
            }
          });
    animationView =
        Tween<double>(begin: 0.0001, end: 0.003).animate(animationController);
    animation =
        Tween<double>(begin: 0, end: pi * 0.5).animate(animationController);
    
    tm = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        animateStatus = _CalendarAnimateStatus.TopDown;
      });
      animationController.forward();
    });
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    tm.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text('demo'),
        AnimatedBuilder(
          animation: animationController,
          builder: (BuildContext context, Widget child) {
            return Stack(
              children: buildStackWidget(),
            );
          },
        ),
      ],
    );
  }

  List<Widget> buildStackWidget() {
    if (animateStatus == _CalendarAnimateStatus.TopDown ||
        animateStatus == _CalendarAnimateStatus.None) {
      return <Widget>[
        _buildNumber(
            context, value == 9 ? 0 : value + 1, _CalendarLayer.Bottom),
        _buildNumber(context, value, _CalendarLayer.Top),
      ];
    }
    return <Widget>[
      _buildNumber(context, value, _CalendarLayer.Top),
      _buildNumber(context, value == 9 ? 0 : value + 1, _CalendarLayer.Bottom),
    ];
  }

  Widget _buildPartNumber(BuildContext context, int n) {
    return Container(
      width: 150,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.black,
      ),
      child: Center(
          child: Text(
        '$n',
        style: TextStyle(fontSize: 180, color: Colors.white),
      )),
    );
  }

  Widget _buildNumber(BuildContext context, int n, _CalendarLayer layer) {
    Widget upWidget() {
      Matrix4 upM4 = Matrix4.identity();
      if (animateStatus == _CalendarAnimateStatus.None) {
        if (layer == _CalendarLayer.Bottom) {
          return Container(
            height: 100,
            width: 150,
          );
        }
      }

      if (animateStatus == _CalendarAnimateStatus.TopDown) {
        if (layer == _CalendarLayer.Top) {
          upM4
            ..setEntry(3, 2, animationView.value)
            ..rotateX(animation.value);
        }
      }
      if (animateStatus == _CalendarAnimateStatus.BottomDown) {
        if (layer == _CalendarLayer.Top) {
          upM4
            ..setEntry(3, 2, 0.0001)
            ..rotateX(pi * 0.5);
        }
      }
      return ClipRect(
        child: Align(
            alignment: Alignment.topCenter,
            heightFactor: 0.5,
            child: Transform(
              transform: upM4,
              origin: Offset(75, 100),
              child: _buildPartNumber(context, n),
            )),
      );
    }

    Widget downWidget() {
      Matrix4 downM4 = Matrix4.identity();
      if (animateStatus == _CalendarAnimateStatus.None ||
          animateStatus == _CalendarAnimateStatus.TopDown) {
        if (layer == _CalendarLayer.Bottom) {
          return Container(
            height: 100,
            width: 150,
          );
        }
      }
      if (animateStatus == _CalendarAnimateStatus.BottomDown) {
        if (layer == _CalendarLayer.Bottom) {
          downM4
            ..setEntry(3, 2, animationView.value)
            ..rotateX(-animation.value);
        }
      }
      return ClipRect(
          child: Align(
        alignment: Alignment.bottomCenter,
        heightFactor: 0.5,
        child: Transform(
          transform: downM4,
          origin: Offset(75, 100),
          child: _buildPartNumber(context, n),
        ),
      ));
    }

    return Column(
      children: <Widget>[
        upWidget(),
        SizedBox(
          height: 3.0,
        ),
        downWidget()
      ],
    );
  }
}
