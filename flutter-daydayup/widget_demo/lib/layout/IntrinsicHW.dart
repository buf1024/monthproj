import 'package:flutter/material.dart';
import 'package:widget_demo/wrap_widget.dart';

/*
  IntrinsicHeight/IntrinsicWidth
 Intrinsic 子组件为实际大小，不随父组件变化而变化。


 */
class IntrinsicWidget extends WrapWidget {
  IntrinsicWidget() : super(group: 'layout -- 布局组件', title: 'Intrinsic - 实际大小');

  @override
  Widget child(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      color: Colors.purple,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: IntrinsicHeight(
          child: Container(
            height: 150,
            decoration:
                BoxDecoration(color: Colors.orangeAccent, border: Border.all()),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: IntrinsicWidth(
                child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.blueAccent,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
