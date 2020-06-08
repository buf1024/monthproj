import 'package:flutter/material.dart';
import 'package:widget_demo/wrap_widget.dart';

/*
  FittedBox
 FittedBox 根据fit参数缩放和调整位置。

  关联组件：Transform,

 */
class FittedBoxWidget extends WrapWidget {
  FittedBoxWidget() : super(group: 'layout -- 布局组件', title: 'FittedBox - 缩放和调整位置');

  @override
  Widget child(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      color: Colors.purple,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
          width: 100,
          height: 100,
          color: Colors.orangeAccent,
        ),
      ),
    );
  }
}
