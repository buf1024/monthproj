import 'package:flutter/material.dart';
import 'package:widget_demo/wrap_widget.dart';

/*
 Align
 Align组件的child组件，根据对齐参数，在Align父节点对齐。

 可根据heightFactor和widthFactor设置其相对于子组件的高度宽度。
 与ClipRect组件通常与Align使用，实现剪裁效果。

  关联组件：Center， FractionallySizedBox

 */
class AlignWidget extends WrapWidget {
  AlignWidget() : super(group: 'layout -- 布局组件', title: 'Align - 对齐组件');

  @override
  Widget child(BuildContext context) {
    return _AlignWidget();
  }
}

class _AlignWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AlignWidgetState();
}

class _AlignWidgetState extends State<_AlignWidget> {
  double x = 0;
  double y = 0;

  Widget _buildWidget() {
    return Container(
      height: 200,
      width: 200,
      decoration: BoxDecoration(color: Colors.lightBlue),
      child: Align(
        alignment: Alignment(x, y),
        child: Image.asset(
          'assets/images/mine.png',
          height: 100,
          width: 100,
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Widget _buildControl() {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Text('x(-1~1):'),
            Expanded(
              child: Slider(
                value: x,
                min: -1.0,
                max: 1.0,
                onChanged: (double value) {
                  setState(() {
                    x = value;
                  });
                },
              ),
            )
          ],
        ),
        Row(
          children: <Widget>[
            RotatedBox(
              quarterTurns: 3,
              child: Text('y(-1~1):'),
            ),
            RotatedBox(
              quarterTurns: 1,
              child: Slider(
                value: y,
                min: -1.0,
                max: 1.0,
                onChanged: (double value) {
                  setState(() {
                    y = value;
                  });
                },
              ),
            ),
            Expanded(
              child: Container(),
            )
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[_buildWidget(), _buildControl()],
    );
  }
}
