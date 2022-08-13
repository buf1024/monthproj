

import 'package:flutter/material.dart';
import 'package:widget_demo/wrap_widget.dart';

/*
 FlatButton
 FlatButton 平的Button, elevation为0，elevation可理解为仰角。
 IconButton 设置icon的button
 OutlineButton 轮廓的button
 RaisedButton 按下弹起反应的button

关联组件：RaisedButton, a filled button whose material elevates when pressed.
DropdownButton, which offers the user a choice of a number of options.
SimpleDialogOption, which is used in SimpleDialogs.
IconButton, to create buttons that just contain icons.
InkWell, which implements the ink splash part of a flat button.
RawMaterialButton, the widget this widget is based on.

 */
class XXXButtonWidget extends WrapWidget {
  XXXButtonWidget()
      : super(group: 'material -- 按钮', title: 'Button - 按钮类');

  void onPress(BuildContext context, String button) {
    showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(
        title: Text('$button - 标题'),
        content: Text('内容 - $button'),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.pop(context),
            color: Colors.orangeAccent,
            textColor: Colors.white,
            child: Text('取消'),
          ),
          FlatButton(
            onPressed: () => Navigator.pop(context),
            color: Colors.orangeAccent,
            textColor: Colors.white,
            child: Text('确定'),
          ),
        ],
      );
    });
  }

  @override
  Widget child(BuildContext context) {
    return Column(
      children: <Widget>[
        FlatButton(
          color: Colors.orangeAccent,
          textColor: Colors.white,
          onPressed: () {
            onPress(context, 'FlatButton');
          },
          child: Text('FlatButton'),
        ),
        IconButton(
          icon: Icon(Icons.assistant_photo),
          color: Colors.purple,
          onPressed: () {
            onPress(context, 'IconButton');
          },
        ),
        // OutlineButton(
        //   color: Colors.deepPurpleAccent,
        //   onPressed: () {
        //     onPress(context, 'OutlineButton');
        //   },
        //   child: Text('OutlineButton'),
        // ),
        // RaisedButton(
        //   color: Colors.redAccent,
        //   textColor: Colors.white,
        //   onPressed: () {
        //     onPress(context, 'RaisedButton');
        //   },
        //   child: Text('RaisedButton'),
        // ),
      ],
    );
  }
}

