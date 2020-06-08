import 'package:flutter/material.dart';
import 'package:widget_demo/wrap_widget.dart';

/*
  FractionallySizeBox
 FractionallySizeBox 根据分数调整child所占的空间。

  关联组件：Transform,

 */
class FractionallySizedBoxWidget extends WrapWidget {
  FractionallySizedBoxWidget() : super(group: 'layout -- 布局组件', title: 'FractionallySizedBox - 调整空间');

  @override
  Widget child(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      color: Colors.purple,
      child: FractionallySizedBox(
        heightFactor: 0.1,
        widthFactor: 0.5,
        child: Container(
          color: Colors.orangeAccent,
        ),
      ),
    );
  }
}
