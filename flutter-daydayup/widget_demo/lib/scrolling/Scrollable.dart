
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:widget_demo/wrap_widget.dart';

/*
  Scrollable
 Scrollable 手工构造Scrollable, 比较少用。

 关联组件:
 */
class ScrollableWidget extends WrapWidget {
  ScrollableWidget()
      : super(group: 'scrolling -- 滚动组件', title: 'Scrollable - 手工构造滚动');

  @override
  Widget child(BuildContext context) {
    return _ScrollableWidget();
  }
}

class _ScrollableWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ScrollableWidgetState();
}

class _ScrollableWidgetState extends State<_ScrollableWidget> {

  late List<double> data;

  @override
  void initState() {
    data = List.generate(50, (index) => index*1.0);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    var height = mediaQueryData.size.height -
        mediaQueryData.padding.top -
        mediaQueryData.padding.bottom - kToolbarHeight;
    return Container(
      height: height,
      child: Scrollable(
          viewportBuilder: (BuildContext context, ViewportOffset position) {
            print('postion: $position');
            return Container(
              width: 500,
              color: Colors.purple,
            );
          }
        ),
      );
  }
}
