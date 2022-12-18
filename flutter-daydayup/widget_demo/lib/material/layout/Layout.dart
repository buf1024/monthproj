import 'package:flutter/material.dart';
import 'package:widget_demo/wrap_widget.dart';

/*
 Stepper展示步骤的组件，Divider线条

 */
class LayoutWidget extends WrapWidget {
  LayoutWidget() : super(group: 'material -- 布局', title: 'Layout - 部分布局');

  @override
  Widget child(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Column(
      children: <Widget>[
        Container(
          width: width,
          height: 50,
          color: Colors.purple,
        ),
        Divider(),
        Stepper(currentStep: 1, steps: <Step>[
          Step(
              title: Text('This is a title1'),
              subtitle: Text('this is a子标题'),
              content: Text('内容')),
          Step(
              title: Text('This is a title2'),
              subtitle: Text('this is a子标题'),
              content: Text('内容2')),
        ])
      ],
    );
  }
}
