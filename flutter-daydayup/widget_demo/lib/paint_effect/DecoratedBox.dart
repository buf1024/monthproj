import 'package:flutter/material.dart';
import 'package:widget_demo/wrap_widget.dart';

/*
 DecoratedBox
 装饰组件，通常decoration为BoxDecoration

BoxDecoration提供背景颜色，图片，边框，圆角，渐变，阴影等装饰。

 Container也提供decoration可实现同样的功能。


 */
class DecoratedBoxWidget extends WrapWidget {
  DecoratedBoxWidget()
      : super(group: 'paint&effect', title: 'DecoratedBox - 装饰组件');

  @override
  Widget child(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: DecoratedBox(
        decoration: BoxDecoration(
            border: Border.all(),
            gradient: LinearGradient(colors: <Color>[
              const Color(0xFFEEEEEE),
              const Color(0xFF111133),
            ]),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.black, offset: Offset(2, 2), blurRadius: 5)
            ]),
        child: Opacity(
          opacity: 0.2,
          child: Image.asset(
            'assets/images/mine.png',
            height: 200,
            width: 200,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
