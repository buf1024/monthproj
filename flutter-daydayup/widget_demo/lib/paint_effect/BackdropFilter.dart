import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:widget_demo/wrap_widget.dart';

/*
 BackdropFilter
 对该组件的下层组件模糊。
 如果child为空，并不会进行模糊。如果child不为空，并不会对child进行模糊，child在模糊之上。
 如果需要单纯模糊，需要可以增加一个Container的child，设置color背景。
 通常将BackdropFilter放于Stack布局的最外层，用Position进行全部或局部模糊。
 通常的应用结构如示例

关联组件：DecoratedBox, Opacity

 */
class BackdropFilterWidget extends WrapWidget {
  BackdropFilterWidget()
      : super(group: 'paint&effect', title: 'BackdropFilter - 背景模糊/高斯模糊');

  @override
  Widget child(BuildContext context) {
    return _BackdropFilterWidget();
  }
}

class _BackdropFilterWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BackdropFilterWidgetState();
}

class _BackdropFilterWidgetState extends State<_BackdropFilterWidget> {
  double sigmaX = 0;
  double sigmaY = 0;

  Widget _buildBackdropFilterWidget() => Stack(
        children: <Widget>[
          Image.asset(
            'assets/images/mine.png',
            width: 200,
            height: 200,
            fit: BoxFit.fill,
          ),
          Positioned.fill(
              child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
                  child: Container(
                    color: Colors.black.withOpacity(0),
                  )))
        ],
      );

  Widget _buildControlWidget() => Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text('sigmaX:'),
              Expanded(
                child: Slider(
                  value: sigmaX,
                  min: 0,
                  max: 2 * pi,
                  label: 'sigmaX: $sigmaX',
                  onChanged: (double value) {
                    setState(() {
                      sigmaX = value;
                    });
                  },
                ),
              )
            ],
          ),
          Row(
            children: <Widget>[
              Text('sigmaY:'),
              Expanded(
                child: Slider(
                  value: sigmaY,
                  min: 0,
                  max: 2 * pi,
                  label: 'sigmaY: $sigmaY',
                  onChanged: (double value) {
                    setState(() {
                      sigmaY = value;
                    });
                  },
                ),
              )
            ],
          )
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[_buildBackdropFilterWidget(), _buildControlWidget()],
    );
  }
}
