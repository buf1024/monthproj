import 'package:flutter/material.dart';
import 'package:widget_demo/wrap_widget.dart';

/*
  ListBody
 ListBody 主轴顺序排列，适应交叉轴，有点类似ListView， 只是无滚动。
 很少使用，几乎没用。

 关联组件: SingleChildScrollView，Column， Row，ListView
 */
class ListBodyWidget extends WrapWidget {
  ListBodyWidget()
      : super(group: 'layout -- 布局组件', title: 'ListBody - 主轴顺序排列，适应交叉轴');

  @override
  Widget child(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      color: Colors.purple,
      alignment: Alignment.bottomCenter,
      child: ListView(children: <Widget>[
        ListBody(
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
              width: 100,
              height: 100,
              color: Colors.amber,
            ),
            Container(
              width: 100,
              height: 100,
              color: Colors.deepPurpleAccent,
            ),
          ],
        )
      ]),
    );
  }
}
