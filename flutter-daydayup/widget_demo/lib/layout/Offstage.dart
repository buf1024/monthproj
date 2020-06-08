import 'package:flutter/material.dart';
import 'package:widget_demo/wrap_widget.dart';

/*
  Offstage
 Offstage 使子组件是否展示。
  应用场景：更加不同的状态显示不同的页面
 关联组件: Visibility TickerMode
 */
class OffstageWidget extends WrapWidget {
  OffstageWidget() : super(group: 'layout -- 布局组件', title: 'Offstage - 是否展示');

  @override
  Widget child(BuildContext context) {
    return _OffstageWidget();
  }
}

class _OffstageWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _OffstageWidgetState();
}

class _OffstageWidgetState extends State<_OffstageWidget> {
  bool offstage = false;

  Widget _buildWidget() => Container(
        width: 200,
        height: 200,
        color: Colors.purple,
        child: Stack(
          children: <Widget>[
            Align(
                alignment: Alignment.bottomCenter,
                child: Offstage(
                  offstage: offstage,
                  child: Container(
                    width: 150,
                    height: 150,
                    color: Colors.blueAccent,
                  ),
                )),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: 100,
                height: 100,
                color: Colors.orangeAccent,
              ),
            ),
          ],
        ),
      );

  Widget _buildControl() => MaterialButton(
        onPressed: () {
          this.setState(() {
            offstage = !offstage;
          });
        },
        color: Colors.orangeAccent,
        child: Text(
          'offset = $offstage',
          style: TextStyle(color: Colors.white),
        ),
      );

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: <Widget>[
        _buildWidget(),
        SizedBox(
          height: 20,
        ),
        _buildControl()
      ],
    );
  }
}
