import 'dart:math';

import 'package:flutter/material.dart';
import 'package:widget_demo/wrap_widget.dart';

/*
  Stack
 Stack 堆叠一起的组件，较为常用。

 关联组件: IndexedStack
 */
class StackWidget extends WrapWidget {
  StackWidget()
      : super(group: 'layout -- 布局组件', title: 'Stack - 堆叠一起的组件');

  @override
  Widget child(BuildContext context) {
    return _StackWidget();
  }
}

class _StackWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _StackWidgetState();
}

class _StackWidgetState extends State<_StackWidget> {
  int index = 0;

  @override
  void initState() {
    super.initState();
  }

  Widget _buildItem(Color color, int index, Size size) {
    return Container(
      width: size.width,
      height: size.height,
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
              while(rand == index) {
                rand = Random().nextInt(5);
              }
              index = rand;
            });
          },
          child: Text('click me', style: TextStyle(color: Colors.white),),
        ),
        Stack(
          children: <Widget>[
            _buildItem(Colors.brown, 0, Size(100, 100)),
            _buildItem(Colors.orange, 1, Size(80, 80)),
            _buildItem(Colors.purple, 2, Size(60, 60)),
            _buildItem(Colors.deepPurpleAccent, 3, Size(40, 40)),
            _buildItem(Colors.indigo, 4, Size(20, 20)),
          ],
        )
      ],
    );
  }
}
