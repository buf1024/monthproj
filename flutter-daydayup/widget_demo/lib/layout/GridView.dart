import 'dart:math';

import 'package:flutter/material.dart';
import 'package:widget_demo/wrap_widget.dart';

/*
  GridView
 GridView 提供可垂直或水平滚动的网格视图，提供GridView.builder/GridView.count/GridView.custom/GridView.extent
 之类的构造函数一提供方便操作。

  关联组件：SingleChildScrollView, ListView, PageView, CustomScrollView

 */
class GridViewWidget extends WrapWidget {
  GridViewWidget() : super(group: 'layout -- 布局组件', title: 'GridView - 网格');

  @override
  Widget child(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 300,
      color: Colors.black.withOpacity(0.5),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, mainAxisSpacing: 5.0,
          crossAxisSpacing: 5.0
        ),
        itemCount: 100,
        itemBuilder: (BuildContext context, int index) {
          var rand = Random();
          var color = Color(0xFFFFFF00 - rand.nextInt(0xFFFF00FF));
          while(color == Colors.brown) {
            color = Color(0xFFFFFF00 - rand.nextInt(0xFFFF00FF));
          }

          return Container(
            width: 50,
            height: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle
            ),
            child: Text('${index + 1}', style: TextStyle(color: Colors.white),),
          );
        },
      ),
    );
  }
}