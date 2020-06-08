

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:widget_demo/wrap_widget.dart';

/*
 FloatingActionButton
 FloatingActionButton 通常应用于 Scaffold里面的floatingActionButton。

关联组件：RaisedButton, a filled button whose material elevates when pressed.
DropdownButton, which offers the user a choice of a number of options.
SimpleDialogOption, which is used in SimpleDialogs.
IconButton, to create buttons that just contain icons.
InkWell, which implements the ink splash part of a flat button.
RawMaterialButton, the widget this widget is based on.

 */
class FloatingActionButtonWidget extends WrapWidget {
  FloatingActionButtonWidget()
      : super(group: 'material -- 按钮', title: 'FloatingActionButton - 平的按钮');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.navigation),
          backgroundColor: Colors.orangeAccent,
        ),);
  }
}

