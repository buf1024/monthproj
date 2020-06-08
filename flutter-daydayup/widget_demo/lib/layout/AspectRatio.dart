import 'package:flutter/material.dart';
import 'package:widget_demo/wrap_widget.dart';

/*
  AspectRadio
 AspectRadio组件根据比例缩放child组件。
 需要留意的是，该组件如果直接的顶层组件是Container则不生效，需要在组件前加上对齐类组件或其他组件。

 貌似这个组件没什么用。

  关联组件：ConstrainedBox UnconstrainedBox

 */
class AspectRatioWidget extends WrapWidget {
  AspectRatioWidget() : super(group: 'layout -- 布局组件', title: 'AspectRatio - 按比例缩放组件');

  @override
  Widget child(BuildContext context) {
    return _AspectRatioWidget();
  }
}

class _AspectRatioWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AspectRatioWidgetState();
}

class _AspectRatioWidgetState extends State<_AspectRatioWidget> {
  double ratio = 1;

  Widget _buildWidget() {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(color: Colors.lightBlue),
      child: Center(
        child: AspectRatio(
          aspectRatio: ratio,
          child: Image.asset(
            'assets/images/mine.png',
          ),
        ),
      ),
    );
  }

  Widget _buildControl() {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Text('ratio(0~5):'),
            Expanded(
              child: Slider(
                value: ratio,
                min: 0.01,
                max: 5,
                onChanged: (double value) {
                  setState(() {
                    ratio = value;
                  });
                },
              ),
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

