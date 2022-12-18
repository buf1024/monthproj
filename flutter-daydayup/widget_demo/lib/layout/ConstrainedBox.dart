import 'package:flutter/material.dart';
import 'package:widget_demo/wrap_widget.dart';

/*
  ConstrainedBox
 ConstrainedBox 增加限制。
  需要留意的是，该组件如果直接的顶层组件是Container则不生效，需要在组件前加上对齐类组件或其他组件。
  或者设置container align属性。


 和AspectRatio一样，貌似没什么鸟用。

  关联组件：AspectRatio

 */
class ConstrainedBoxWidget extends WrapWidget {
  ConstrainedBoxWidget()
      : super(group: 'layout -- 布局组件', title: 'ConstrainedBox - 限制组件');

  @override
  Widget child(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      color: Colors.purple,
      child: Container(
        width: 100,
        height: 100,
        alignment: Alignment.center,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 50, maxWidth: 50),
          child: Image.asset(
            'assets/images/mine.png',
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
