import 'dart:math';

import 'package:flutter/material.dart';
import 'package:widget_demo/wrap_widget.dart';

/*
  ListView
 ListView 是非常常用的列表view，提供builder, custom, separated等方法。

 关联组件: SingleChildScrollView，PageView, GridView, CustomScrollView, ListBody
 */
class ListViewWidget extends WrapWidget {
  ListViewWidget()
      : super(group: 'layout -- 布局组件', title: 'ListView - List滚动列表');

  @override
  Widget child(BuildContext context) {
    return _ListViewWidget();
  }
}

class _ListViewWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ListViewWidgetState();
}

class _ListViewWidgetState extends State<_ListViewWidget> {
  late List<double> data;
  late ScrollController scrollController;

  bool showUp = false;
  bool showDown = false;

  @override
  void initState() {
    data = List<double>.generate(50, (index) => index * Random().nextDouble());
    scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.offset < 0 && !showUp) {
        data.addAll(List<double>.generate(5, (index) => index * Random().nextDouble()));
        setState(() {
          showUp = true;
        });
      }
      if (scrollController.position.extentBefore >
              scrollController.position.maxScrollExtent &&
          !showDown) {
        data.addAll(List<double>.generate(5, (index) => index * Random().nextDouble()));
        setState(() {
          showDown = true;
        });
      }
      if (scrollController.offset >= 0 &&
          scrollController.offset <=
              scrollController.position.maxScrollExtent &&
          (showDown || showUp)) {
        setState(() {
          showDown = false;
          showUp = false;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    var height = mediaQueryData.size.height -
        mediaQueryData.padding.top -
        mediaQueryData.padding.bottom -
        ((showUp || showDown) ? 80 : 0);
    return Container(
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          showUp
              ? Container(
                  height: 80,
                  child: Center(
                    child: CircularProgressIndicator(strokeWidth: 2.0),
                  ),
                )
              : Container(),
          Expanded(
            child: ListView.builder(
              itemCount: data.length,
              physics: BouncingScrollPhysics(),
              controller: scrollController,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: Text('index: $index'),
                  title: Text('title: ${data[index].toStringAsFixed(2)}'),
                  trailing: MaterialButton(
                    color: Colors.orange,
                    onPressed: () {
                      data.removeAt(index);
                      setState(() {});
                    },
                    child: Text(
                      '删除',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
          showDown
              ? Container(
                  height: 80,
                  child: Center(
                    child: CircularProgressIndicator(strokeWidth: 2.0),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
