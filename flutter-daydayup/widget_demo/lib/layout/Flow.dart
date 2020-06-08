import 'package:flutter/material.dart';
import 'package:widget_demo/wrap_widget.dart';

/*
  Flow
 Flow 流式布局，通过实现delegate，可以实现children的自由布局。
 Flow是特别为transform优化过的，通过传进animation, 可以实现非常库的效果。

 paintChildren里面是delegate的主要方法，该方法context可以获知container和child大小，
 通过context.paintChild配合动画，可以自由的布局

 或许叫FreeLayout更适合点。

 关联组件: Stack CustomSingleChildLayout CustomMultiChildLayout,
 */
class FlowWidget extends WrapWidget {
  FlowWidget() : super(group: 'layout -- 布局组件', title: 'Flow - 流式自由布局');

  @override
  Widget child(BuildContext context) {
    return Container(
        width: 300,
        height: 300,
        color: Colors.purple,
        alignment: Alignment.bottomCenter,
        child: _FlowWidget());
  }
}

class _FlowWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FlowWidgetState();
}

class _FlowWidgetState extends State<_FlowWidget>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    animationController =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Flow(
      delegate: _FlowDelegate(animationController: animationController),
      children: <Widget>[
        Container(
          height: 50,
          width: 50,
          decoration:
              BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
        ),
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
        ),
        Container(
          height: 50,
          width: 50,
          decoration:
          BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
        ),
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
        ),
      ],
    );
  }
}

class _FlowDelegate extends FlowDelegate {
  AnimationController animationController;

  _FlowDelegate({this.animationController})
      : super(repaint: animationController);

  @override
  void paintChildren(FlowPaintingContext context) {
    // TODO: implement paintChildren
    var row = 0;
    for (int i = 0; i < context.childCount; i++) {
      row += (i % 2 == 0 ? 1 : 0);
      var sizeChild = context.getChildSize(i);
      var dy = sizeChild.height * (row - 1) * animationController.value;

      if (i % 2 == 0) {
        context.paintChild(i, transform: Matrix4.translationValues(0, dy, 0));
      } else {
        context.paintChild(i,
            transform: Matrix4.translationValues(
                context.size.width - sizeChild.width, dy, 0));
      }
    }
  }

  @override
  bool shouldRepaint(_FlowDelegate context) {
    return context != this;
  }
}
