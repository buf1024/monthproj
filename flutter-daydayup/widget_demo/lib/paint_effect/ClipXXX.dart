import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:widget_demo/wrap_widget.dart';

/*
 ClipXXX剪裁组件
 剪裁组件通过剪裁边框实现特殊形状。
 组件包括: ClipRect, ClipRRect, ClipOval, ClipPath(较为耗时)
 通常ClipRect和以下组件一起使用：
  CustomPaint
  CustomSingleChildLayout
  CustomMultiChildLayout
  Align and Center (e.g., if Align.widthFactor or Align.heightFactor is less than 1.0).
  OverflowBox
  SizedOverflowBox

 剪裁区域可以通过clipper指定，可通过实现 CustomClipper<Rect/Path>抽象类提供自定义剪裁。

 ClipPath组件通常比较耗时，如非必要，不轻易使用，可以使用ClipPath.shape，实现ShapeBorder，从而实现特定的边框。
 P.S.: 很多组件提供ShapeBorder，实现该类，可以上实现不同的外框。


关联组件：DecoratedBox, Opacity

 */
class ClipWidget extends WrapWidget {
  ClipWidget()
      : super(group: 'paint&effect', title: 'Clip - 剪裁组件');

  Widget _clipRect() => ClipRect(
    child: Align(
      alignment: Alignment.topCenter,
      heightFactor: 0.5,
      child: Image.asset('assets/images/mine.png', width: 150, height: 150, fit: BoxFit.fill,),
    ),
  );

  Widget _clipRRect() => ClipRRect(
    borderRadius: BorderRadius.all(Radius.circular(20)),
    child: Image.asset('assets/images/mine.png', width: 150, height: 150, fit: BoxFit.fill,),
  );

  Widget _clipOval() => ClipOval(
    child: Image.asset('assets/images/mine.png', width: 150, height: 100, fit: BoxFit.fill,),
  );

  Widget _clipPath() => ClipPath(
    clipper: _ClipPathClipper(),
    child: Image.asset('assets/images/mine.png', width: 150, height: 100, fit: BoxFit.fill,),
  );

  Widget _clipPathShape() => ClipPath.shape(
    shape: _ClipPathShape(),
    child: Image.asset('assets/images/mine.png', width: 150, height: 100, fit: BoxFit.fill,),
  );

  @override
  Widget child(BuildContext context) {
    return Column(
      children: <Widget>[
        Text('ClipRect'),
        _clipRect(),
        SizedBox(height: 20,),

        Text('ClipRRect'),
        _clipRRect(),
        SizedBox(height: 20,),

        Text('ClipOval'),
        _clipOval(),
        SizedBox(height: 20,),

        Text('ClipPath'),
        _clipPath(),
        SizedBox(height: 20,),

        Text('ClipPathShape'),
        _clipPathShape(),
        SizedBox(height: 20,),
      ],
    );
  }
}

class _ClipPathClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()..moveTo(0, size.height/2)
      ..quadraticBezierTo(size.width/4, 0, size.width/2, size.height/2)
      ..quadraticBezierTo(size.width*3/4, size.height, size.width, size.height/2)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..lineTo(0, size.height/2);
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class _ClipPathShape extends ShapeBorder {
  @override
  // TODO: implement dimensions
  EdgeInsetsGeometry get dimensions => throw UnimplementedError();

  @override
  Path getInnerPath(Rect rect, {TextDirection textDirection}) {
    return null;
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    return Path()..moveTo(0, rect.height)
      ..lineTo(rect.width/2, 0)
      ..lineTo(rect.width, rect.height)
      ..lineTo(rect.width/2, rect.height/2)
      ..lineTo(0, rect.height);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection textDirection}) {
    // TODO: implement paint
  }

  @override
  ShapeBorder scale(double t) {
    return null;
  }

}