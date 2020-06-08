import 'package:flutter/material.dart';
import 'package:widget_demo/wrap_widget.dart';

/*
  Wrap
 Wrap 主轴自动换行、列。

 关联组件: Row, Column
 */
class WrapTheWidget extends WrapWidget {
  WrapTheWidget() : super(group: 'layout -- 布局组件', title: 'Wrap - 实际大小');

  @override
  Widget child(BuildContext context) {
    return Container(
      width: 200,
      height: 500,
      color: Colors.purple,
      alignment: Alignment.bottomCenter,
      child: Wrap(
        children: <Widget>[
          Container(
            width: 100,
            height: 100,
            color: Colors.blueAccent,
          ),
          Container(
            width: 100,
            height: 100,
            color: Colors.orange,
          ),
          Container(
            width: 150,
            height: 150,
            color: Colors.brown,
          ),
          Container(
            width: 100,
            height: 100,
            color: Colors.red,
          ),
        ],
      ),
    );
  }
}
