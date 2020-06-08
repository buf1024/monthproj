import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:widget_demo/wrap_widget.dart';

/*
 ButtonBar
 ButtonBar 就是默认靠右对齐一行的buttons，而且会换行，也就是方便手工布局buttons。
通常与对话框一起使用，当然手写Dialog相对麻烦点，建议用AlertDialog或SimpleDialog。

关联组件：RaisedButton, a kind of button.
FlatButton, another kind of button.
Card, at the bottom of which it is common to place a ButtonBar.
Dialog, which uses a ButtonBar for its actions.
ButtonBarTheme, which configures the ButtonBar.

 */
class ButtonBarWidget extends WrapWidget {
  ButtonBarWidget()
      : super(group: 'material -- 按钮', title: 'ButtonBar - 一行button');

  @override
  Widget child(BuildContext context) {
    return MaterialButton(
      color: Colors.orangeAccent,
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                backgroundColor: Colors.blue.withOpacity(0.8),
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                child: Container(
                  width: 200,
                  height: 200,
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.orangeAccent,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '对话框标题',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: 50,
                                alignment: Alignment.center,
                                child: Text(
                                  '对话框内容1',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              Divider(),
                              Container(
                                height: 50,
                                alignment: Alignment.center,
                                child: Text(
                                  '对话框内容2',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              Divider(),
                              Container(
                                height: 50,
                                alignment: Alignment.center,
                                child: Text(
                                  '对话框内容3',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              Divider(),
                              Container(
                                height: 50,
                                alignment: Alignment.center,
                                child: Text(
                                  '对话框内容4',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              Divider(),
                              Container(
                                height: 50,
                                alignment: Alignment.center,
                                child: Text(
                                  '对话框内容5',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              Divider(),
                            ],
                          ),
                        ),
                      ),
                      ButtonBar(
                        children: <Widget>[
                          MaterialButton(
                            color: Colors.purple,
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('取消', style: TextStyle(color: Colors.white),),
                          ),
                          MaterialButton(
                            color: Colors.red,
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('确定', style: TextStyle(color: Colors.white),),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            });
      },
      child: Text(
        'showDialog',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
