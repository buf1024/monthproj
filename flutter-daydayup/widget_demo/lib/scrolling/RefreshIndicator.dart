
import 'package:flutter/material.dart';
import 'package:widget_demo/wrap_widget.dart';

/*
  RefreshIndicator
 RefreshIndicator 刷新组件，通过包括Scroll提供下拉刷新功能呢。

 关联组件:
 */
class RefreshIndicatorWidget extends WrapWidget {
  RefreshIndicatorWidget()
      : super(group: 'scrolling -- 滚动组件', title: 'RefreshIndicator - 刷新组件');

  @override
  Widget child(BuildContext context) {
    return _RefreshIndicatorWidget();
  }
}

class _RefreshIndicatorWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RefreshIndicatorWidgetState();
}

class _RefreshIndicatorWidgetState extends State<_RefreshIndicatorWidget> {

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
      child: RefreshIndicator(
        onRefresh: () async {
          return await Future.delayed(Duration(seconds: 2));
        },
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
