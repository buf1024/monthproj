import 'package:flutter/material.dart';
import 'package:widget_demo/wrap_widget.dart';

/*
  Padding
 Padding 内边框，Container可实现此功能。

 关联组件: Container
 */
class PaddingWidget extends WrapWidget {
  PaddingWidget() : super(group: 'layout -- 布局组件', title: 'Padding - 内边框');

  @override
  Widget child(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      color: Colors.purple,
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.all(30),
        child: Container(
          width: 200,
          height: 200,
          color: Colors.blueAccent,
        ),
      ),
    );
  }
}
