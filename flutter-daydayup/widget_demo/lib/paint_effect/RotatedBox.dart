import 'package:flutter/material.dart';
import 'package:widget_demo/wrap_widget.dart';

/*
 RotatedBox

 RotatedBox只可进行90， 180， 270，360度旋转。
 RotatedBox的child是占据其父组件的空间的，注意与Transform组件的旋转不一样。
 也没Transform组件灵活。

关联组件：Transform

 */
class RotatedBoxWidget extends WrapWidget {
  RotatedBoxWidget()
      : super(group: 'paint&effect', title: 'RotatedBox - 旋转组件');

  @override
  Widget child(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(),
      ),
      child: RotatedBox(
        quarterTurns: 1,
        child: Image.asset('assets/images/mine.png', fit: BoxFit.fill,),
      ),
    );
  }
}