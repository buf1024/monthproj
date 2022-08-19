
import 'package:flutter/material.dart';
import 'package:widget_demo/wrap_widget.dart';

/*
  ScrollConfiguration
 ScrollConfiguration 可配置scroll的行为的组件，如果不设置scroll的scroll physics，通过重写
 ScrollBehavior可以提供不同的physics，随心所欲，但是很少使用。flutter提供的scroll physics有

BouncingScrollPhysics ：允许滚动超出边界，但之后内容会反弹回来。
ClampingScrollPhysics ： 防止滚动超出边界，夹住 。
AlwaysScrollableScrollPhysics ：始终响应用户的滚动。
NeverScrollableScrollPhysics ：不响应用户的滚动。

 关联组件:
 */
class ScrollConfigurationWidget extends WrapWidget {
  ScrollConfigurationWidget()
      : super(group: 'scrolling -- 滚动组件', title: 'ScrollConfiguration - Scroll配置组件');

  @override
  Widget child(BuildContext context) {
    return _ScrollConfigurationWidget();
  }
}

class _ScrollConfigurationWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ScrollConfigurationWidgetState();
}

class _ScrollConfigurationWidgetState extends State<_ScrollConfigurationWidget> {

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
      child: ScrollConfiguration(
      behavior: ScrollBehavior(),
        child: ListView.builder(
          itemCount: data.length,
          physics: const AlwaysScrollableScrollPhysics(),
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
    );
  }
}
