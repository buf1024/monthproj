import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wang_finance/news_page.dart';
import 'package:wang_finance/constants.dart';

void main() {
  runApp(MyApp());
  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '老王财讯',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: '老王财讯'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  Map<String, Widget> _widgets;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();


    _widgets = Map<String, Widget>();

    _widgets['最新资讯'] = NewsPage(
      pageType: PageType.FlashNews,
    );
    _widgets['今日数据'] = NewsPage(
      pageType: PageType.DataNews,
    );
    _widgets['老王珍藏'] = NewsPage(
      pageType: PageType.FavNews,
    );

    _tabController = TabController(length: _widgets.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
          bottom: TabBar(
              isScrollable: true,
              controller: _tabController,
              tabs: () {
                List<Widget> tabs = List<Widget>();
                _widgets.forEach((String title, Widget _) {
                  tabs.add(Tab(
                    text: title,
                  ));
                });
                return tabs;
              }()),
        ),
        body: TabBarView(
            controller: _tabController,
            children: () {
              List<Widget> tabViews = List<Widget>();
              _widgets.forEach((String _, Widget widget) {
                tabViews.add(widget);
              });
              return tabViews;
            }()));
  }
}
