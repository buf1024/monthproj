import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:widget_demo/wrap_widget.dart';

/*

 Card 提供类似于卡片的容器，在里面可以为所欲为。
 CircularProgressIndicator 圆形进度条
 LinearProgressIndicator 圆形进度条
 Tooltip 提示语，好像没什么用，难以显示
 DataTable 表格控件，有点类似Table, 不过Table只用于布局，DataTable用于数据处理，
 如果数据量大，考虑用PaginatedDataTable，分页的。
Icon 图标
Image 图片，可以来自 ImageProvider.
或Image.asset 来自程序本身
或Image.network, 来自网络
或Image.file, 文件
或Image.memory, 内存

Chip家族，圆角的一些小组件，包括各种变形，基本上在RawChip增加或减少一些功能。
RawChip 始祖
Chip 用于显示的Chip
InputChip 输入
ChoiceChip 选择
FilterChip 可以替代CheckBox或Switch的
ActionChips 点击动作

关联组件：LinearProgressIndicator, which displays progress along a line.
RefreshIndicator,

DataColumn, which describes a column in the data table.
DataRow, which contains the data for a row in the data table.
DataCell, which contains the data for a single cell in the data table.
PaginatedDataTable, which shows part of the data in a data table and provides controls for paging through the remainder of the d

IconButton, for interactive icons.
Icons, for the list of available icons for use with this class.
IconTheme, which provides ambient configuration for icons.
ImageIcon, fo

Icon, which shows an image from a font.
new Ink.image, which is the preferred way to show an image in a material application (especially if the image is in a Material and will have an InkWell on top of it).
Image, the class in the dart:ui library.

CircleAvatar, which shows images or initials of people.
Wrap, A widget that displays its children in multiple horizontal or vertical runs.
 */
class InformationDisplaysWidget extends WrapWidget {
  InformationDisplaysWidget()
      : super(group: 'material -- 信息显示', title: 'InformationDisplays - 信息显示');

  @override
  Widget child(BuildContext context) {
    return _InformationDisplaysWidget();
  }
}

class _InformationDisplaysWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _InformationDisplaysWidgetState();
}

class _InformationDisplaysWidgetState
    extends State<_InformationDisplaysWidget> {
  bool choiceChipSelected = false;
  bool filterChipSelected = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _cardColl(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Card(
      color: Colors.purple.withOpacity(0.6),
      shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.purple.withOpacity(0.6)),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      elevation: 2,
      child: Container(
        width: width,
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(30),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/mine.png',
                  width: 100,
                  height: 100,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Container(
              height: 200,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Tooltip(
                    child: Text(
                      'Cafe dino',
                      style: TextStyle(color: Colors.indigo, fontSize: 18),
                    ),
                    message: '不是好的tooltip',
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.star,
                        color: Colors.redAccent,
                        size: 15,
                      ),
                      Icon(
                        Icons.star,
                        color: Colors.redAccent,
                        size: 15,
                      ),
                      Icon(
                        Icons.star_half,
                        color: Colors.redAccent,
                        size: 15,
                      ),
                      Icon(
                        Icons.star_border,
                        color: Colors.redAccent,
                        size: 15,
                      ),
                      Icon(
                        Icons.star_border,
                        color: Colors.redAccent,
                        size: 15,
                      )
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: Container(
                      height: 1,
                      child: LinearProgressIndicator(
                        backgroundColor: Colors.purple,
                      ),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Center(
                          child: ClipOval(
                        child: Image.asset(
                          'assets/images/mine.png',
                          width: 100,
                          height: 100,
                          fit: BoxFit.fill,
                        ),
                      )),
                      Expanded(
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 1,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _chipPadding(Widget child) {
    return Container(
      margin: EdgeInsets.all(5),
      child: child,
    );
  }

  Widget _chipWidget(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Card(
      color: Colors.purple.withOpacity(0.6),
      shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.purple.withOpacity(0.6)),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Container(
        width: width,
        padding: EdgeInsets.all(10),
        child: Wrap(
          children: <Widget>[
            _chipPadding(RawChip(label: Text('RawChip'))),
            _chipPadding(Chip(
              avatar: CircleAvatar(
                child: Text('H'),
              ),
              label: Text('Chip'),
            )),
            _chipPadding(InputChip(
              avatar: CircleAvatar(
                child: Text('H'),
              ),
              label: Text('InputChip'),
              onPressed: () {},
            )),
            _chipPadding(ChoiceChip(
              selected: choiceChipSelected,
              onSelected: (value) {
                setState(() {
                  choiceChipSelected = value;
                });
              },
              label: Text('ChoiceChip'),
            )),
            _chipPadding(FilterChip(
              selected: filterChipSelected,
              onSelected: (value) {
                setState(() {
                  filterChipSelected = value;
                });
              },
              avatar: CircleAvatar(
                child: Text('F'),
              ),
              label: Text('FilterChip'),
            )),
            _chipPadding(ActionChip(
              onPressed: () {},
              avatar: CircleAvatar(
                child: Text('A'),
              ),
              label: Text('ActionChip'),
            )),
          ],
        ),
      ),
    );
  }

  Widget _dataTableWidget(BuildContext context) {
    var width = MediaQuery
        .of(context)
        .size
        .width;
    return Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Container(
          width: width,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: <DataColumn>[
                DataColumn(label: Text('编号')),
                DataColumn(label: Text('年级')),
                DataColumn(label: Text('分数')),
                DataColumn(label: Text('排名')),
                DataColumn(label: Text('编号')),
                DataColumn(label: Text('年级')),
                DataColumn(label: Text('分数')),
                DataColumn(label: Text('排名')),
              ],
              rows: <DataRow>[
                DataRow(
                    cells: <DataCell>[
                      DataCell(Text('1')),
                      DataCell(Text('以地方')),
                      DataCell(Text('50')),
                      DataCell(Text('50')),
                      DataCell(Text('1')),
                      DataCell(Text('以地方')),
                      DataCell(Text('50')),
                      DataCell(Text('50')),
                    ]
                ),
                DataRow(
                    cells: <DataCell>[
                      DataCell(Text('1')),
                      DataCell(Text('以地方')),
                      DataCell(Text('50')),
                      DataCell(Text('50')),
                      DataCell(Text('1')),
                      DataCell(Text('以地方')),
                      DataCell(Text('50')),
                      DataCell(Text('50')),
                    ]
                ),
                DataRow(
                    cells: <DataCell>[
                      DataCell(Text('1')),
                      DataCell(Text('以地方')),
                      DataCell(Text('50')),
                      DataCell(Text('50')),
                      DataCell(Text('1')),
                      DataCell(Text('以地方')),
                      DataCell(Text('50')),
                      DataCell(Text('50')),
                    ]
                ),
                DataRow(
                    cells: <DataCell>[
                      DataCell(Text('1')),
                      DataCell(Text('以地方')),
                      DataCell(Text('50')),
                      DataCell(Text('50')),
                      DataCell(Text('1')),
                      DataCell(Text('以地方')),
                      DataCell(Text('50')),
                      DataCell(Text('50')),
                    ]
                ),
                DataRow(
                    cells: <DataCell>[
                      DataCell(Text('1')),
                      DataCell(Text('以地方')),
                      DataCell(Text('50')),
                      DataCell(Text('50')),
                      DataCell(Text('1')),
                      DataCell(Text('以地方')),
                      DataCell(Text('50')),
                      DataCell(Text('50')),
                    ]
                ),
              ],
            ),
          ),
        )
    );
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          _cardColl(context),
          SizedBox(
            height: 10,
          ),
          _chipWidget(context),
          SizedBox(
            height: 10,
          ),
          _dataTableWidget(context)
        ],
      ),
    );
  }
}
