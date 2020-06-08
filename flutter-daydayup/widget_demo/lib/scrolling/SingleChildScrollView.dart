
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:widget_demo/wrap_widget.dart';

/*
  SingleChildScrollView
 SingleChildScrollView 为孩子增加滚动，如溢出了等。

 关联组件: ListView,
GridView,
PageView,
SingleChildScrollView,
 */
class SingleChildScrollViewWidget extends WrapWidget {
  SingleChildScrollViewWidget()
      : super(group: 'scrolling -- 滚动组件', title: 'SingleChildScrollView - 增加单孩子滚动');

  @override
  Widget child(BuildContext context) {
    return _SingleChildScrollViewWidget();
  }
}

class _SingleChildScrollViewWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SingleChildScrollViewWidgetState();
}

class _SingleChildScrollViewWidgetState extends State<_SingleChildScrollViewWidget> {

  List<double> data;

  @override
  void initState() {
    data = List.generate(50, (index) => index*1.0);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<Widget> _widgets(double width) {
    return data.map<Widget>((e) {
      var rand = Random();
      var color = Color(0xFFFFFF00 - rand.nextInt(0xFFFF00FF));
      return Container(
        width: width,
        height: 50,
        color: color,
        alignment: Alignment.center,
        child: Text('item $e', style: TextStyle(color: Colors.white),),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    var height = mediaQueryData.size.height -
        mediaQueryData.padding.top -
        mediaQueryData.padding.bottom - kToolbarHeight;
    var width = mediaQueryData.size.width;
    return Container(
      height: height,
      child: SingleChildScrollView(
          child: Column(
            children: _widgets(width),
          ),
      ),
    );
  }
}
