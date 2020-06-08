import 'package:flutter/material.dart';
import 'package:widget_demo/wrap_widget.dart';

/*
 Opacity

 透明组件，给child组件增加透明度，单纯的透明效果，BackdropFilter可实现高斯模糊。

 */
class OpacityWidget extends WrapWidget {
  OpacityWidget()
      : super(group: 'paint&effect', title: 'Opacity - 透明组件');

  @override
  Widget child(BuildContext context) {
    return Opacity(
      opacity: 0.5,
      child: Image.asset('assets/images/mine.png', height: 200, width: 200, fit: BoxFit.fill,),
    );
  }
}