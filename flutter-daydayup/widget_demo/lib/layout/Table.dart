import 'package:flutter/material.dart';
import 'package:widget_demo/wrap_widget.dart';

/*
  Table
 Table 类似于html的table，不要用Row+Column的方式进行布局，如果需要用table，考虑这个组件。

 关联组件: Row, Column
 */
class TableWidget extends WrapWidget {
  TableWidget() : super(group: 'layout -- 布局组件', title: 'Table - 表格布局');

  @override
  Widget child(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Table(
        border: TableBorder.all(),
        defaultColumnWidth: FixedColumnWidth(100),
        children: <TableRow>[
          TableRow(children: <Widget>[
            Container(
              width: 50,
              height: 50,
              color: Colors.purple,
            ),
            Container(
              width: 30,
              height: 30,
              color: Colors.orange,
            ),
            Container(
              width: 30,
              height: 30,
              color: Colors.amber,
            ),
            Container(
              width: 30,
              height: 30,
              color: Colors.indigo,
            ),
            Container(
              width: 30,
              height: 30,
              color: Colors.blue,
            ),
            Container(
              width: 30,
              height: 30,
              color: Colors.purple,
            )
          ]),
          TableRow(children: <Widget>[
            Container(
              width: 50,
              height: 50,
              color: Colors.purple,
            ),
            Container(
              width: 30,
              height: 30,
              color: Colors.orange,
            ),
            Container(
              width: 30,
              height: 30,
              color: Colors.amber,
            ),
            Container(
              width: 30,
              height: 30,
              color: Colors.indigo,
            ),
            Container(
              width: 30,
              height: 30,
              color: Colors.blue,
            ),
            Container(
              width: 30,
              height: 30,
              color: Colors.purple,
            )
          ])
        ],
      ),
    );
  }
}
