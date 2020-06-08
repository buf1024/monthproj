import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:widget_demo/wrap_widget.dart';

/*
 PopupMenuButton
 PopupMenuButton 弹出菜单。

关联组件：PopupMenuItem, a popup menu entry for a single value.
PopupMenuDivider, a popup menu entry that is just a horizontal line.
CheckedPopupMenuItem, a popup menu item with a checkmark.
showMenu, a method to dynamically show a popup menu at a given location.

 */
class PopupMenuButtonWidget extends WrapWidget {
  PopupMenuButtonWidget()
      : super(group: 'material -- 按钮', title: 'PopupMenuButton - 弹出的button');

  @override
  Widget child(BuildContext context) {
    return _PopupMenuButtonWidget();
  }
}

class _PopupMenuButtonWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PopupMenuButtonWidgetState();
}

class _PopupMenuButtonWidgetState extends State<_PopupMenuButtonWidget> {
  String selectValue;

  @override
  void initState() {
    selectValue = 'one';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      initialValue: selectValue,
      onSelected: (value) {
        setState(() {
          selectValue = value;
        });
      },
      icon: Icon(Icons.arrow_downward),
      itemBuilder: (BuildContext context) {
        return <String>['one', 'two', 'three', 'four'].map((e) {
          return PopupMenuItem<String>(
            value: e,
            child: Container(
              child: Text(e),
            ),
          );
        }).toList();
      },
    );
  }
}
