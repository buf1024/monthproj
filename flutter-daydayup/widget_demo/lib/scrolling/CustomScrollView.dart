import 'dart:math';

import 'package:flutter/material.dart';
import 'package:widget_demo/wrap_widget.dart';

/*
  CustomScrollView
 CustomScrollView Sliver家族是专为CustomScrollView使用的。
 单一个组件需要滚动，滚动里面包括滚动，也就是嵌套滚动时，原来的ListView，
 SingleChildScrollView等组件是不能正常工作的。这就需要Sliver家族的组件。
 CustomScrollView就为了实现这类效果而特制定的。
 CustomScrollView的子组件必须是Sliver家族组件。
 Sliver家族组件和非Sliver家族组件的区别是，非Sliver家族有滚动模型，
 Sliver家族组件没有，滚动模型由CustomScrollView。

CustomScrollView配合Sliver家族可实现一系列很酷的效果。。

滚动的view都可以通过NotificationListener<ScrollNotification>包装在父节点，从而获取通知

 关联组件: SliverList
SliverFixedExtentList
SliverGrid
SliverPadding
SliverAppBar
ScrollNotification
IndexedSemantics
 */
class CustomScrollViewWidget extends WrapWidget {
  CustomScrollViewWidget()
      : super(group: 'scrolling -- 滚动组件', title: 'CustomScrollView - sliver滚动');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(title),
              background: Image.asset(
                'assets/images/mine.png',
                fit: BoxFit.fill,
              ),
            ),
          ),
          SliverGrid(
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
              var rand = Random();
              var color = Color(0xFFFFFF00 - rand.nextInt(0xFFFF00FF));
              return Container(
                color: color,
                alignment: Alignment.center,
                child: Text(
                  'Grid ${index + 1}',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }, childCount: 52),
          ),
          SliverPadding(
            padding: EdgeInsets.only(top: 15),
          ),
          SliverFixedExtentList(
            itemExtent: 50,
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
              var rand = Random();
              var color = Color(0xFFFFFF00 - rand.nextInt(0xFFFF00FF));
              return Container(
                color: color,
                alignment: Alignment.center,
                child: Text(
                  'List ${index + 1}',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }, childCount: 8),
          )
        ],
      ),
    );
  }
}
