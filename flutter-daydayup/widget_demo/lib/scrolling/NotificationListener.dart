import 'package:flutter/material.dart';
import 'package:widget_demo/wrap_widget.dart';

/*
  NotificationListener
 NotificationListener 获取通知的父组件，通过提高该父组件，如果子组件对应的监听发生，则会调用该组件回调。

 比如滚动的监听，当然也可以不提供改监听，也是可以获取的。



 关联组件:
SliverAppBar
 */
class NotificationListenerWidget extends WrapWidget {
  NotificationListenerWidget()
      : super(group: 'scrolling -- 滚动组件', title: 'NotificationListener - 通知滚动');

  @override
  Widget child(BuildContext context) {
    return _NotificationListenerWidget();
  }
}

class _NotificationListenerWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NotificationListenerWidgetState();
}

class _NotificationListenerWidgetState
    extends State<_NotificationListenerWidget> {
  double progress = 0.0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    var height = mediaQueryData.size.height -
        mediaQueryData.padding.top -
        mediaQueryData.padding.bottom -
        kToolbarHeight;
    return Container(
        height: height,
        child: Stack(
          children: <Widget>[
            NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification notification) {
                double progress = notification.metrics.pixels /
                    notification.metrics.maxScrollExtent;
                setState(() {
                  this.progress = progress * 100;
                });
                return false;
              },
              child: ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: Text('$index'),
                    title: Text('$index item'),
                  );
                },
                itemCount: 100,
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.all(30),
                child: Container(
                  height: 60,
                  width: 60,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.purple),
                  child: Text(
                    '${progress.toStringAsFixed(2)}%',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
