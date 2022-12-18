import 'package:flutter/material.dart';
import 'package:widget_demo/wrap_widget.dart';

/*
 FractionalTranslation
 按比例进行移动，Transform里 transform 为Matrix4.translationValues可实现一样的功能

 关联组件：Transform

 */
class FractionalTranslationWidget extends WrapWidget {
  FractionalTranslationWidget()
      : super(group: 'paint&effect', title: 'FractionalTranslation - 偏移/移动');

  @override
  Widget child(BuildContext context) {
    return Container(
      height: 200,
      width: 200,
      decoration: BoxDecoration(border: Border.all()),
      child: FractionalTranslation(
        translation: Offset(0.1, 0.1),
        child: Image.asset(
          'assets/images/mine.png',
          height: 200,
          width: 200,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
