import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:widget_demo/wrap_widget.dart';

/*
  Container
 Container 最最常用的组件，容器类组件，可应对齐，背景，装饰，M4变换等万能组件。
  包括很多组件的功能。

  如果Container的child为空或者某些装饰属性为空，这样的Container被认为是空的透明组件。

  关联组件：AspectRatio

 */
class ContainerWidget extends WrapWidget {
  ContainerWidget() : super(group: 'layout -- 布局组件', title: 'Container - 容器组件');

  @override
  Widget child(BuildContext context) {
    return Container(
      width: 300,
      height: 300,
      color: Colors.purple,
      child: Center(
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
              color: Colors.orangeAccent,
              gradient: LinearGradient(
                  colors: <Color>[Colors.blueAccent, Colors.red]
              ),
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              border: Border.all(),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    offset: Offset(5, 5),
                    blurRadius: 8
                )
              ]
          ),
        ),
      ),
    );
  }
}