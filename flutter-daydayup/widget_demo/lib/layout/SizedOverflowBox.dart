import 'package:flutter/material.dart';
import 'package:widget_demo/wrap_widget.dart';

/*
  SizedOverflowBox
 SizedOverflowBox 指定size，允许子组件允许溢出父组件，
???? todo
 关联组件: SizedSizedOverflowBox, ConstrainedBox, UnconstrainedBox, SizedBox
 */
class SizedOverflowBoxWidget extends WrapWidget {
  SizedOverflowBoxWidget() : super(group: 'layout -- 布局组件', title: 'SizedOverflowBox - 指定size允许溢出父组件');

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
        child: SizedOverflowBox(
          size: Size(50, 50),
          child: Align(
            alignment: Alignment.center,
            child: Container(
              height: 100,
              width: 250,
              color: Colors.blueAccent,
            ),
          ),
        ),
      ),
    );
  }
}
