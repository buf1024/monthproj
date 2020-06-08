import 'dart:math';

import 'package:flutter/material.dart';
import 'package:widget_demo/wrap_widget.dart';

/*
  NestedScrollView
 NestedScrollView 是嵌套scroll的，最常用的情景是  headerSliverBuilder是，SliverAppBar里面包括  TabBar，
 body是tabview。当然也没必要是这样，比如只是想隐藏一下header。

NestedScrollView配合Sliver家族可实现一系列很酷的效果。。

滚动的view都可以通过NotificationListener<ScrollNotification>包装在父节点，从而获取通知


 关联组件: CustomScrollView
SliverAppBar
 */
class NestedScrollViewWidget extends WrapWidget {
  NestedScrollViewWidget()
      : super(group: 'scrolling -- 滚动组件', title: 'NestedScrollView - 嵌套滚动');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _NestedScrollViewWidget(
        title: title,
      ),
    );
  }
}

class _NestedScrollViewWidget extends StatefulWidget {
  final String title;

  _NestedScrollViewWidget({this.title});

  @override
  State<StatefulWidget> createState() => _NestedScrollViewWidgetState();
}

class _NestedScrollViewWidgetState extends State<_NestedScrollViewWidget>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  List<String> tabs;

  @override
  void initState() {
    tabs = List<String>();
    tabs.add('Tab 1');
    tabs.add('Tab 2');
    tabs.add('Tab 3');
    tabs.add('Tab 4');
    tabController = TabController(length: tabs.length, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            expandedHeight: 200,
            forceElevated: innerBoxIsScrolled,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(widget.title),
              background: Image.asset(
                'assets/images/mine.png',
                fit: BoxFit.fill,
              ),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverPersistentHeaderDelegate(
                child: TabBar(
                    controller: tabController,
                    tabs: tabs.map((e) {
                      return Container(
                        height: 50,
                        alignment: Alignment.center,
                        child: Text(
                          e,
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }).toList())),
          )
        ];
      },
      body: TabBarView(
        controller: tabController,
        children: tabs.map((e) {
          return Center(
            child: Text(
              '$e\'s tab view',
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _SliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  final TabBar child;

  _SliverPersistentHeaderDelegate({this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: child,
    );
  }

  @override
  double get maxExtent => child.preferredSize.height;

  @override
  double get minExtent => child.preferredSize.height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
