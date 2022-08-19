
import 'package:flutter/material.dart';
import 'package:widget_demo/wrap_widget.dart';

/*
  PageView
 PageView 以页作为滚动单位的滚动view



 关联组件: PageController, SingleChildScrollView,
ListView,
GridView,
ScrollNotification and NotificationListener, (可替换ScrollController).
 */
class PageViewWidget extends WrapWidget {
  PageViewWidget()
      : super(group: 'scrolling -- 滚动组件', title: 'PageView - 页滚动');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _PageViewWidgetWidget(
        title: title,
      ),
    );
  }
}

class _PageViewWidgetWidget extends StatefulWidget {
  final String title;

  _PageViewWidgetWidget({required this.title});

  @override
  State<StatefulWidget> createState() => _PageViewWidgetWidgetState();
}

class _PageViewWidgetWidgetState extends State<_PageViewWidgetWidget>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  late List<String> tabs;

  @override
  void initState() {
    tabs = <String>[];
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
              background: PageView(
                controller: PageController(),
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        child: Image.asset(
                          'assets/images/mine.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text('这是第一页', style: TextStyle(
                          color: Colors.white,
                          fontSize: 18
                        ),),
                      )
                    ],
                  ),
                  Stack(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        child: Image.asset(
                          'assets/images/mine.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text('这是第二页', style: TextStyle(
                            color: Colors.white,
                            fontSize: 18
                        ),),
                      )
                    ],
                  )
                ],
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

  _SliverPersistentHeaderDelegate({required this.child});

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
