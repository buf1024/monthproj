import 'dart:math';

import 'package:flutter/material.dart';

class CardAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CardWidget();
  }
}

class CardWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CardWidgetState();
}

enum _CardRotateStep {None, Front, Back}

class _CardWidgetState extends State<CardWidget> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  _CardRotateStep step = _CardRotateStep.None;

  _CardRotateStep show = _CardRotateStep.Front;

  @override
  void initState() {
    animationController = AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    animation = Tween<double>(begin: 0, end: pi).animate(animationController)
      ..addListener(() {
        if(animation.value >= pi * 0.5) {
          if(step != _CardRotateStep.Back) {
            debugPrint('animate value: set: ${animation.value}');
            setState(() {
              step = _CardRotateStep.Back;
              show = _CardRotateStep.Back;
            });
          }
        } else {
          if(step != _CardRotateStep.Front) {
            setState(() {
              step = _CardRotateStep.Front;
              show = _CardRotateStep.Front;
            });
          }
        }
      });

    super.initState();
  }


  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('卡片翻转动画演示'),
      ),
      body: Center(
        child: AnimatedBuilder(
          animation: animation,
          builder: (BuildContext context, Widget? child) {
            return Stack(
              children: <Widget>[
                buildBack(context),
                buildFront(context)
              ],
            );
          },
        ),
      ),
    );
  }

  Widget buildFront(BuildContext context) {
    if(show != _CardRotateStep.Front && step != _CardRotateStep.Front) {
      return Container(
        width: 300,
        height: 300,
      );
    }
    debugPrint('show=$show');
    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateY(animation.value),
      alignment: Alignment.center,
      child: MaterialButton(
        onPressed: () {
          animationController.forward();
        },
        child: Card(
            shape: RoundedRectangleBorder(
                side: BorderSide(),
                borderRadius: BorderRadius.all(Radius.circular(5.0))),
            elevation: 8.0,
            child: Container(
              width: 300,
              height: 300,
              child: Stack(
                children: <Widget>[
                  Image.asset(
                    'assets/images/mine.png',
                    height: 300,
                    width: 300,
                    fit: BoxFit.fill,
                  ),
                  Container(
                    height: 300,
                    width: 300,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '尼安德特人',
                          style: TextStyle(fontSize: 30.0, color: Colors.white),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }

  Widget buildBack(BuildContext context) {
    if(show != _CardRotateStep.Back && step != _CardRotateStep.Back) {
      return Container(
        width: 300,
        height: 300,
      );
    }
    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateY(-pi+animation.value),
      alignment: Alignment.center,
      child: MaterialButton(
        onPressed: () {
          debugPrint('on press');
          animationController.reverse();
        },
        child: Card(
            shape: RoundedRectangleBorder(
                side: BorderSide(),
                borderRadius: BorderRadius.all(Radius.circular(5.0))),
            elevation: 8.0,
            child: Container(
              height: 300,
              width: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(5.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          child: Image.asset(
                            'assets/images/mine.png',
                            width: 80,
                            height: 80,
                            fit: BoxFit.fill,
                          ),
                        ),
                      )
                    ],
                  ),
                  Divider(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14.0),
                    child: Text('人们说，我能发展到今天，是因为我的脑袋大。人们又说，我灭绝，是因为我眼睛太大，抑制脑袋发展。',
                      style: TextStyle(
                          fontSize: 15.0
                      ),),
                  )
                ],
              ),
            )),
      ),
    );
  }
}
