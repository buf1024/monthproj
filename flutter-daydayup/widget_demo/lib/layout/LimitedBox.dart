import 'package:flutter/material.dart';
import 'package:widget_demo/wrap_widget.dart';

/*
  LimitedBox
 LimitedBox 限制子组件大小，不跟随父组件变化。

 关联组件: ConstrainedBox, SizedBox
 */
class LimitedBoxWidget extends WrapWidget {
  LimitedBoxWidget() : super(group: 'layout -- 布局组件', title: 'LimitedBox - 实际大小');

  @override
  Widget child(BuildContext context) {
    return Container(
        width: 200,
        height: 200,
        color: Colors.purple,
        alignment: Alignment.bottomCenter,
        child: LimitedBox(
          maxHeight: 100,
          maxWidth: 100,
          child: Container(
            width: 100,
            height: 100,
            color: Colors.blueAccent,
          ),
        ),
    );
  }
}
