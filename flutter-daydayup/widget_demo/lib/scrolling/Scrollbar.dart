
import 'package:flutter/material.dart';
import 'package:widget_demo/wrap_widget.dart';

/*
  Scrollbar
 Scrollbar 滚动条。

 关联组件: ListView, GridView
 */
class ScrollbarWidget extends WrapWidget {
  ScrollbarWidget()
      : super(group: 'scrolling -- 滚动组件', title: 'Scrollbar -滚动条');

  @override
  Widget child(BuildContext context) {
    return _ScrollbarWidget();
  }
}

class _ScrollbarWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ScrollbarWidgetState();
}

class _ScrollbarWidgetState extends State<_ScrollbarWidget> {

  List<double> data;

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
      child: Scrollbar(
        isAlwaysShown: true,
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
