import 'dart:math';

import 'package:flutter/material.dart';
import 'package:widget_demo/wrap_widget.dart';

/*
  IndexedStack
 IndexedStack 和Stack一样，只不过提供了index显示，可理解为index为最后一个就是Stack。

 关联组件: Stack
 */
class IndexedStackWidget extends WrapWidget {
  IndexedStackWidget()
      : super(group: 'layout -- 布局组件', title: 'IndexedStack - 指定Index的Stack');

  @override
  Widget child(BuildContext context) {
    return _IndexedStackWidget();
  }
}

class _IndexedStackWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _IndexedStackWidgetState();
}

class _IndexedStackWidgetState extends State<_IndexedStackWidget> {
  int index = 0;

  @override
  void initState() {
    super.initState();
  }

  Widget _buildItem(Color color, int index) {
    return Container(
      width: 50,
      height: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: color,
      ),
      child: Text(
        '${index + 1}',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        RawMaterialButton(
          fillColor: Colors.red,
          onPressed: () {
            setState(() {
              var rand = Random().nextInt(5);
              while (rand == index) {
                rand = Random().nextInt(5);
              }
              index = rand;
            });
          },
          child: Text(
            'click me',
            style: TextStyle(color: Colors.white),
          ),
        ),
        IndexedStack(
          index: index,
          children: <Widget>[
            _buildItem(Colors.brown, 0),
            _buildItem(Colors.orange, 1),
            _buildItem(Colors.purple, 2),
            _buildItem(Colors.deepPurpleAccent, 3),
            _buildItem(Colors.indigo, 4),
          ],
        )
      ],
    );
  }
}
