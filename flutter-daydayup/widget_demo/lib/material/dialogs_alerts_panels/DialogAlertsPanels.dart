import 'package:flutter/material.dart';
import 'package:widget_demo/wrap_widget.dart';

/*
 AlertDialog 和 SimpleDialog都是内部设置好布局让你踩的了，Dialog完全可以自定义。

 AlertDialog 有title，有内容有滚动, 还有actions。
 SimpleDialog 则通常（不是必须）和SimpleDialogOption使用
 BottomSheet 类似于对话框一样，只不过是在底部的。
 SnackBar 在底部的一部分提示语，可以定义action
 ExpansionPanel 可展开的面板只可做为ExpansionPanelList孩子使用


 showModalBottomSheet/showBottomSheet 一个是模态的一个是非模态的。
 通过设置高度可以限制BottomSheet的高度，默认底部对齐的。
showBottomSheet/showSnackBar 有时会出现 "No Scaffold widget found." 错误，据说是BuildContext不正确导致，
通过Builder组件包裹，即可正常显示

关联组件：SimpleDialog, which handles the scrolling of the contents but has no actions.
Dialog, on which AlertDialog and SimpleDialog are based.
CupertinoAlertDialog, an iOS-styled alert dialog.
showDialog, w

 */
class DialogAlertsPanelsWidget extends WrapWidget {
  DialogAlertsPanelsWidget()
      : super(
            group: 'material -- 提示类', title: 'DialogAlertsPanels - 对话框/提示/面板等');

  void _alertDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('AlertDialog - 标题'),
            content: Text('内容 - AlertDialog'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                    textStyle: TextStyle(color: Colors.white),
                    foregroundColor: Colors.orangeAccent),
                child: Text('取消'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                    textStyle: TextStyle(color: Colors.white),
                    foregroundColor: Colors.orangeAccent),
                child: Text('确定'),
              ),
            ],
          );
        });
  }

  void _simpleDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text('SimpleDialog - 标题'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('我是一个选项'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('我也是一个选项'),
              ),
            ],
          );
        });
  }

  void _dialog(BuildContext context) {
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
                      'Dialog自定义对话框标题',
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
                        child: Text(
                          '取消',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      MaterialButton(
                        color: Colors.red,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          '确定',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  void _bottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 300,
            color: Colors.orangeAccent,
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.share),
                  title: Text('分享'),
                ),
                ListTile(
                  leading: Icon(Icons.link),
                  title: Text('链接'),
                ),
                ListTile(
                  leading: Icon(Icons.edit),
                  title: Text('编辑'),
                ),
              ],
            ),
          );
        });
  }

  void _snackBart(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('撤销吗?'),
      action: SnackBarAction(
        label: '撤销',
        onPressed: () {},
      ),
    ));
  }

  @override
  Widget child(BuildContext context) {
    return Column(
      children: <Widget>[
        TextButton(
          style: TextButton.styleFrom(
              textStyle: TextStyle(color: Colors.white),
              foregroundColor: Colors.orangeAccent),
          onPressed: () => _alertDialog(context),
          child: Text('显示AlertDialog'),
        ),
        TextButton(
          style: TextButton.styleFrom(
              textStyle: TextStyle(color: Colors.white),
              foregroundColor: Colors.purple),
          onPressed: () => _simpleDialog(context),
          child: Text('显示自定义SimpleDialog'),
        ),
        TextButton(
          style: TextButton.styleFrom(
              textStyle: TextStyle(color: Colors.white),
              foregroundColor: Colors.brown),
          onPressed: () => _dialog(context),
          child: Text('显示自定义Dialog'),
        ),
        Divider(),
        Builder(
          builder: (BuildContext context) {
            return TextButton(
              style: TextButton.styleFrom(
                  textStyle: TextStyle(color: Colors.white),
                  foregroundColor: Colors.redAccent),
              onPressed: () => _bottomSheet(context),
              child: Text('显示BottomSheeet'),
            );
          },
        ),
        Builder(builder: (BuildContext context) {
          return TextButton(
            style: TextButton.styleFrom(
                textStyle: TextStyle(color: Colors.white),
                foregroundColor: Colors.cyan),
            onPressed: () => _snackBart(context),
            child: Text('显示SnackBart'),
          );
        }),
        Divider(),
        Container(
          padding: EdgeInsets.only(left: 15, right: 15),
          child: ExpansionPanelList(
            children: <ExpansionPanel>[
              ExpansionPanel(
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return Container(
                      child: Row(
                        children: <Widget>[
                          Text('我是折叠的标题1'),
                          isExpanded ? Divider() : Container()
                        ],
                      ),
                    );
                  },
                  body: Column(
                    children: <Widget>[
                      Text('我是展开后的内容1'),
                      Text('我是展开后的内容2'),
                      Text('我是展开后的内容3'),
                    ],
                  )),
              ExpansionPanel(
                  isExpanded: true,
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return Container(
                      child: Row(
                        children: <Widget>[
                          Text('我是折叠的标题2'),
                          isExpanded ? Divider() : Container()
                        ],
                      ),
                    );
                  },
                  body: Column(
                    children: <Widget>[
                      Text('我是展开后的内容1'),
                      Text('我是展开后的内容2'),
                      Text('我是展开后的内容3'),
                    ],
                  ))
            ],
          ),
        ),
      ],
    );
  }
}
