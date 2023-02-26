import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:widget_demo/wrap_widget.dart';

/*
  Center
 Center 子组件居中对齐。

 还是实用滴。

  关联组件：Align

 */
class CenterWidget extends WrapWidget {
  CenterWidget() : super(group: 'layout -- 布局组件', title: 'Center - 居中');

  @override
  Widget child(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      color: Colors.purple,
      child: Center(
        child: ClipRRect(
            child: Image.asset(
              'assets/images/mine.png',
              width: 100,
              height: 100,
              fit: BoxFit.fill,
            ),
            borderRadius: BorderRadius.circular(50.0)),
      ),
    );
  }
}
