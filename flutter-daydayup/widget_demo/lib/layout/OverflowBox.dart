import 'package:flutter/material.dart';
import 'package:widget_demo/wrap_widget.dart';

/*
  OverflowBox
 OverflowBox 允许子组件允许溢出父组件， 但不能溢出最大允许的长度、宽度。如
 Container->Container可能不能溢出。

 关联组件: SizedOverflowBox, ConstrainedBox, UnconstrainedBox, SizedBox
 */
class OverflowBoxWidget extends WrapWidget {
  OverflowBoxWidget() : super(group: 'layout -- 布局组件', title: 'OverflowBox - 允许溢出父组件');

  @override
  Widget child(BuildContext context) {
    return Container(
      width: 300,
      height: 300,
      color: Colors.orange,
      alignment: Alignment.center,
      child: Container(
        width: 200,
        height: 200,
        color: Colors.purple,
        child: OverflowBox(
          minHeight: 50,
          minWidth: 50,
          maxHeight: 100,
          maxWidth: 300,
          child: Container(
            height: 100,
            width: 250,
            color: Colors.blueAccent,
          ),
        ),
      ),
    );
  }
}
