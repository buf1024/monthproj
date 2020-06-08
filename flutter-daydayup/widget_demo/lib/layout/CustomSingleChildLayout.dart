import 'package:flutter/material.dart';
import 'package:widget_demo/wrap_widget.dart';

/*
  CustomSingleChildLayout
 CustomSingleChildLayout 通过代理可用知道子组件大小，并调整显示位置。

  关联组件：

 */
class CustomSingleChildLayoutWidget extends WrapWidget {
  CustomSingleChildLayoutWidget() : super(group: 'layout -- 布局组件', title: 'CustomSingleChildLayout - 可用知道子组件大小');

  @override
  Widget child(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      color: Colors.purple,
      child: Center(
        child: CustomSingleChildLayout(
          delegate: _MySingleChildLayoutDelegate(),
          child: Image.asset(
            'assets/images/mine.png',
          ),
        ),
      ),
    );
  }
}

class _MySingleChildLayoutDelegate extends SingleChildLayoutDelegate {
  @override
  bool shouldRelayout(SingleChildLayoutDelegate oldDelegate) => true;

  @override
  Size getSize(BoxConstraints constraints) {
    return Size(100, 100);
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return Offset(20, 20);
  }


}