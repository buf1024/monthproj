import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:widget_demo/wrap_widget.dart';

/*
  Baseline
 Baseline 子组件根据baseline对齐，可以严格设置widget按固定某条线对齐。

 还是实用滴。

  关联组件：Align Center

 */
class BaselineWidget extends WrapWidget {
  BaselineWidget() : super(group: 'layout -- 布局组件', title: 'Baseline - 基于Baseline对齐');

  @override
  Widget child(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      color: Colors.purple,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Baseline(
            baseline: 150,
            baselineType: TextBaseline.alphabetic,
            child: Text('hello', style: TextStyle(color: Colors.white),),
          ),
          Baseline(
            baseline: 150,
            baselineType: TextBaseline.alphabetic,
            child: Image.asset(
              'assets/images/mine.png',
              width: 100,
              height: 100,
              fit: BoxFit.fill,
            ),
          )
        ],
      ),
    );
  }
}