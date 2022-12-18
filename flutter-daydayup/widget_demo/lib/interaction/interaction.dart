import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:widget_demo/wrap_widget.dart';
import 'dart:math';

/*
 Interaction
Dismissible 左右滑动的widget。
Scrollable 自定义滚动，一般很少自己定义滚动, 好像也没必要自己自定义滚动。
GestureDetector 增加手势检测功能的组件。
AbsorbPointer/IgnorePointer 孩子下面的所有组件都生效或失效。
IgnorePointer本身作为孩子，也会失效，AbsorbPointer本身作为孩子，不会失效
Draggable/LongPressDraggable/DragTarget 都是配合使用的，从Draggable到DragTarget。
Draggable/LongPressDraggable的区别是响应的方式不一样，另外feedback的widget如果有文字，会有下划线，原因未知。

  关联组件：

  ListView, which is a commonly used ScrollView that displays a scrolling, linear list of child widgets.
PageView, which is a scrolling list of child widgets that are each the size of the viewport.
GridView, which is a ScrollView that displays a scrolling, 2D array of child widgets.
CustomScrollView, which is a ScrollView that creates custom scroll effects using slivers.
SingleChildScrollView, which is a scrollable widget that has a single child.
ScrollNotification and NotificationListener, which can be used to watch the scroll position without using a ScrollController.

 */
class InteractionWidget extends WrapWidget {
  InteractionWidget()
      : super(group: 'Interaction -- 交互模型', title: 'Interaction - 交互模型');

  @override
  Widget child(BuildContext context) {
    return _InteractionWidget();
  }
}

class _InteractionWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _InteractionWidgetState();
}

class _InteractionWidgetState extends State<_InteractionWidget> {
  int _dismissibleCount = 5;

  Color _color = Colors.orangeAccent;
  Color _colorAb = Colors.greenAccent;
  Color _colorIg = Colors.blueAccent;

  int _acceptSize = 0;

  @override
  void initState() {
    super.initState();
  }

  Widget _container({required String text, required Widget child, required VoidCallback onPressed}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          border: Border.all()),
      child: Column(
        children: <Widget>[
          child,
          SizedBox(
            height: 8,
          ),
          MaterialButton(
            color: Colors.purpleAccent.withOpacity(0.8),
            onPressed: onPressed,
            child: Text(text),
          )
        ],
      ),
    );
  }

  Widget _buildDismissible() {
    return _container(
        text: 'Dismissible',
        child: Container(
          height: 300,
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return Dismissible(
                key: Key('${Random().nextDouble()}'),
                onDismissed: (DismissDirection direction) {
                  setState(() {
                    _dismissibleCount -= 1;
                  });
                },
                background: Container(
                  color: Colors.orangeAccent,
                ),
                direction: DismissDirection.startToEnd,
                child: ListTile(
                  leading: Text('#$index'),
                  title: Text('主标题'),
                  subtitle: Text('副标题'),
                ),
              );
            },
            itemCount: _dismissibleCount,
          ),
        ),
        onPressed: () {
          setState(() {
            _dismissibleCount = 5;
          });
        });
  }

  Widget _buildGestureDetector() {
    return _container(
        text: 'GestureDetector',
        child: GestureDetector(
          child: Container(
            width: 200,
            height: 200,
            color: _color,
            alignment: Alignment.center,
            child: Text(
              '点我',
              style: TextStyle(color: Colors.white),
            ),
          ),
          onTap: () {
            setState(() {
              if (_color == Colors.orangeAccent) {
                _color = Colors.purpleAccent;
              } else {
                _color = Colors.orangeAccent;
              }
            });
          },
        ),
        onPressed: () {});
  }

  Widget _buildAbsorbPointer() {
    return _container(
        text: 'AbsorbPointer',
        child: GestureDetector(
          child: AbsorbPointer(
            absorbing: true,
            child: GestureDetector(
              child: Container(
                width: 200,
                height: 200,
                color: _color,
                alignment: Alignment.center,
                child: Text(
                  '点我孩子不生效，本身生效',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              onTap: () {
                setState(() {
                  if (_colorAb == Colors.greenAccent) {
                    _color = Colors.indigo;
                  } else {
                    _color = Colors.greenAccent;
                  }
                });
              },
            ),
          ),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('AbsorbPointer 本身会响应事件'),
              duration: Duration(milliseconds: 500),
            ));
          },
        ),
        onPressed: () {});
  }

  Widget _buildIgnorePointer() {
    return _container(
        text: 'IgnorePointer',
        child: GestureDetector(
          child: IgnorePointer(
            ignoring: true,
            child: GestureDetector(
              child: Container(
                width: 200,
                height: 200,
                color: _colorIg,
                alignment: Alignment.center,
                child: Text(
                  '点我孩子不生效，本身也不生效',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              onTap: () {
                setState(() {
                  if (_colorIg == Colors.blueAccent) {
                    _colorIg = Colors.tealAccent;
                  } else {
                    _colorIg = Colors.blueAccent;
                  }
                });
              },
            ),
          ),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('IgnorePointer 本身不响应事件'),
            ));
          },
        ),
        onPressed: () {});
  }

  Widget _buildDrag() {
    return _container(
        text: 'Draggable/DragTarget/LongPressDraggable',
        child: Row(
          children: <Widget>[
            Container(
              height: 200,
              width: 120,
              color: Colors.lightBlueAccent,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Draggable(
                    child: Container(
                      width: 80,
                      height: 30,
                      color: Colors.orangeAccent,
                      alignment: Alignment.center,
                      child: Text('Draggable', style: TextStyle(color: Colors.white),),
                    ),
                    childWhenDragging: Container(
                      width: 80,
                      height: 30,
                      decoration: BoxDecoration(
                          color: Colors.orangeAccent,
                          borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                      alignment: Alignment.center,
                      child: Text('Dragging', style: TextStyle(color: Colors.white),),
                    ),
                    feedback: Container(
                      width: 80,
                      height: 30,
                      color: Colors.pinkAccent,
                      alignment: Alignment.center,
                      child: Text('Dragging', style: TextStyle(color: Colors.white),),
                    ),
                  ),
                  LongPressDraggable(
                    child: Container(
                      width: 80,
                      height: 30,
                      color: Colors.orangeAccent,
                      alignment: Alignment.center,
                      child: Text('LongPressDraggable', style: TextStyle(color: Colors.white),),
                    ),
                    childWhenDragging: Container(
                      width: 80,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.orangeAccent,
                        borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                      alignment: Alignment.center,
                      child: Text('Dragging', style: TextStyle(color: Colors.white),),
                    ),
                    feedback: Container(
                      width: 80,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.pinkAccent,
                      ),
                      alignment: Alignment.center,
                      child: Text('Dragging', style: TextStyle(color: Colors.white, fontSize: 10),),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Icon(Icons.arrow_right),
            ),
            Container(
              height: 200,
              width: 120,
              color: Colors.pinkAccent,
              child: DragTarget(
                builder: (BuildContext context, List candidateData, List<dynamic> rejectedData) {
                  return SingleChildScrollView(
                    child: Column(
                      children: List.generate(_acceptSize, (index) => index).map((e) {
                        return Container(
                          margin: EdgeInsets.all(5),
                          width: 80,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.yellow,
                          ),
                          alignment: Alignment.center,
                          child: Text('DraggTarget', style: TextStyle(color: Colors.white, fontSize: 10),),
                        );
                      }).toList(),
                    ),
                  );
                },
                onAccept: (data) {
                  _acceptSize += 1;
                },
              ),
            ),
          ],
        ),
        onPressed: () {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildDismissible(),
        _buildGestureDetector(),
        _buildAbsorbPointer(),
        _buildIgnorePointer(),
        _buildDrag()
      ],
    );
  }
}
