import 'package:flutter/material.dart';
import 'package:widget_demo/wrap_widget.dart';

/*
  SizedBox
 SizedBox 指定长宽box。

 关联组件: ConstrainedBox, UnconstrainedBox, FractionallySizedBox, AspectRatio, FittedBox
 */
class SizedBoxWidget extends WrapWidget {
  SizedBoxWidget() : super(group: 'layout -- 布局组件', title: 'SizedBox - 指定长宽');

  @override
  Widget child(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      color: Colors.purple,
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: 100,
        width: 100,
        child: Container(
          color: Colors.blueAccent,
        ),
      ),
    );
  }
}
