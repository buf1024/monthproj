import 'dart:math';

import 'package:flutter/material.dart';
import 'package:widget_demo/wrap_widget.dart';

/*
手动写动画，需要写Controller还有Animation，包裹在AnimationBuilder里面，简单的widget写起来
啰嗦。这种就封装的简单组件，通常以Animated开通，一般有两个必选参数Curves表示动画曲线，还是Duration表示动画时长。

AnimatedOpacity 透明动画。
AnimatedContainer 容器动画。
AnimatedCrossFade 两个内部孩子交换淡出效果
AnimatedDefaultTextStyle 文本的TextStyle改变时动画效果。
AnimatedModalBarrier 类似对话框的罩层。 -- 使用ColorTween不要使用Tween<Color>泛型
AnimatedPhysicalModel 增加物理层，borderRadius 和 elevation 这两个属性有动画。
AnimatedPositioned Positioned动画版本。
AnimatedSize 自动在孩子的size变化应用动画。 貌似变小不会显示动画。
AnimatedWidget 是要传入一个 Listenable的，通常是AnimatedController, 也可以是ChangeNotifier或ValueNotifier等Listenable.
  需要继承AnimatedWidget实现动画。貌似用起来没有AnimatedBuilder或TweenBuilder方便
AnimatedList 增加或删除item增加动画效果的List。通过 AnimatedListState 控制状态。
  通过提高GlobalKey<AnimatedListState>或AnimatedList.of 可获取状态。

AnimationBuilder和TweenAnimationBuilder性质是一致的，都是完全手工控制动画，只是传的参数不一样一个是Listenable一个是Tween

  关联组件：
AnimatedPadding, which is a subset of this widget that only supports animating the padding.
AnimatedPositioned, which, as a child of a Stack, automatically transitions its child's position over a given duration whenever the given position changes.
AnimatedAlign, which automatically transitions its child's position over a given duration whenever the given alignment changes.
AnimatedSwitcher, which switches out a child for a new one with a customizable transition.
AnimatedCrossFade, which fades between two children and interpolates their sizes.
FadeTransition, an explicitly animated version of this widget, where an Animation is provided by the caller instead of being built in.
SliverAnimatedOpacity, for automatically transitioning a sliver's opacity over a given duration whenever the given opacity changes.
AnimatedSize, the lower-level widget which AnimatedCrossFade uses to automatically change size.

 */
class AnimatedTheWidget extends WrapWidget {
  AnimatedTheWidget()
      : super(group: 'animation -- 动画组件', title: 'Animated - 封装动画组件');

  @override
  Widget child(BuildContext context) {
    return _AnimatedTheWidget();
  }
}

class _AnimatedTheWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AnimatedTheWidgetState();
}

class _AnimatedTheWidgetState extends State<_AnimatedTheWidget>
    with TickerProviderStateMixin {
  double _opacity = 1.0;

  double _containerWidth = 0;
  double _containerHeight = 0;
  Color _containerColor = Colors.orangeAccent;

  CrossFadeState _crossFadeState = CrossFadeState.showFirst;

  double _fontSize = 12.0;
  Color _fontColor = Colors.redAccent;

  late AnimationController _animationController;

  double _elevation = 0;
  BorderRadius _borderRadius = BorderRadius.zero;

  double _posLeft = 0;
  double _posTop = 0;

  Size _size = Size(120, 120);

  late AnimationController _widgetAnimationController;

  GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  List<int> _list = List.generate(3, (index) => index);

  @override
  void initState() {
    _animationController =
        AnimationController(duration: Duration(seconds: 1), vsync: this);

    _widgetAnimationController =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _widgetAnimationController.dispose();
    super.dispose();
  }

  Widget _container({required String text, required Widget child, required VoidCallback onPressed}) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
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

  Widget _buildAnimatedOpacity() {
    return _container(
        text: 'AnimatedOpacity',
        child: Container(
          child: AnimatedOpacity(
            opacity: _opacity,
            curve: Curves.easeInExpo,
            duration: Duration(seconds: 1),
            child: Image.asset(
              'assets/images/mine.png',
              width: 120,
              height: 120,
              fit: BoxFit.fill,
            ),
          ),
        ),
        onPressed: () {
          setState(() {
            _opacity = _opacity == 0.0 ? 1.0 : 0.0;
          });
        });
  }

  Widget _buildAnimatedContainer() {
    return _container(
        text: 'AnimatedContainer',
        child: Container(
          child: AnimatedContainer(
            width: _containerWidth,
            height: _containerHeight,
            curve: Curves.easeInOutCubic,
            duration: Duration(seconds: 1),
            decoration: BoxDecoration(
              border: Border.all(),
              color: _containerColor,
            ),
          ),
        ),
        onPressed: () {
          setState(() {
            if (_containerWidth <= 50) {
              _containerWidth = 150;
              _containerHeight = 150;
              _containerColor = Colors.purpleAccent;
            } else {
              _containerWidth = 50;
              _containerHeight = 50;
              _containerColor = Colors.orangeAccent;
            }
          });
        });
  }

  Widget _buildAnimatedCrossFade() {
    return _container(
        text: 'AnimatedCrossFade',
        child: Container(
          child: AnimatedCrossFade(
            firstChild: Column(
              children: <Widget>[
                Image.asset(
                  'assets/images/mine.png',
                  width: 80,
                  height: 80,
                  fit: BoxFit.fill,
                ),
                Text('第一个孩子')
              ],
            ),
            secondChild: Column(
              children: <Widget>[
                Image.asset(
                  'assets/images/mine.png',
                  width: 120,
                  height: 120,
                  fit: BoxFit.fill,
                ),
                Text('第二个孩子')
              ],
            ),
            firstCurve: Curves.easeIn,
            secondCurve: Curves.easeOut,
            duration: Duration(milliseconds: 500),
            crossFadeState: _crossFadeState,
          ),
        ),
        onPressed: () {
          setState(() {
            if (_crossFadeState == CrossFadeState.showFirst) {
              _crossFadeState = CrossFadeState.showSecond;
            } else {
              _crossFadeState = CrossFadeState.showFirst;
            }
          });
        });
  }

  Widget _buildAnimatedDefaultTextstyle() {
    return _container(
        text: 'AnimatedDefaultTextStyle',
        child: Container(
          height: 120,
          width: 120,
          decoration: BoxDecoration(
            border: Border.all(),
          ),
          child: AnimatedDefaultTextStyle(
            style: TextStyle(fontSize: _fontSize, color: _fontColor),
            curve: Curves.linear,
            duration: Duration(milliseconds: 500),
            child: Text('DefaultTextStyle动画'),
          ),
        ),
        onPressed: () {
          setState(() {
            if (_fontSize == 12.0) {
              _fontSize = 20;
              _fontColor = Colors.blue;
            } else {
              _fontSize = 12;
              _fontColor = Colors.red;
            }
          });
        });
  }

  Widget _buildAnimatedModalBarrier() {
    return _container(
        text: 'AnimatedModalBarrier',
        child: Container(
          height: 120,
          width: 120,
          decoration: BoxDecoration(
            border: Border.all(),
          ),
          child: AnimatedModalBarrier(
            color: ColorTween(begin: Colors.blue, end: Colors.red)
                .animate(_animationController),
            dismissible: false,
          ),
        ),
        onPressed: () {
          setState(() {
            if (_animationController.status == AnimationStatus.completed) {
              _animationController.reverse();
            } else {
              _animationController.forward();
            }
          });
        });
  }

  Widget _buildAnimatedPhysicalModel() {
    return _container(
        text: 'AnimatedPhysicalModel',
        child: Container(
          height: 120,
          width: 120,
          child: AnimatedPhysicalModel(
              child: Container(
                child: Image.asset(
                  'assets/images/mine.png',
                  width: 80,
                  height: 80,
                  fit: BoxFit.contain,
                ),
              ),
              shape: BoxShape.rectangle,
              elevation: _elevation,
              borderRadius: _borderRadius,
              color: Colors.purpleAccent,
              animateColor: true,
              shadowColor: Colors.black,
              duration: Duration(seconds: 1)),
        ),
        onPressed: () {
          setState(() {
            if (_elevation == 0) {
              _elevation = 6;
              _borderRadius = BorderRadius.all(Radius.circular(20));
            } else {
              _elevation = 0;
              _borderRadius = BorderRadius.zero;
            }
          });
        });
  }

  Widget _buildAnimatedPosition() {
    return _container(
        text: 'AnimatedPositioned',
        child: Container(
            height: 200,
            width: 200,
            child: Stack(
              children: <Widget>[
                AnimatedPositioned(
                    left: _posLeft,
                    top: _posTop,
                    child: Container(
                      color: Colors.purpleAccent,
                      child: Image.asset(
                        'assets/images/mine.png',
                        width: 80,
                        height: 80,
                        fit: BoxFit.contain,
                      ),
                    ),
                    duration: Duration(seconds: 1)),
              ],
            )),
        onPressed: () {
          setState(() {
            if (_posLeft == 0) {
              _posLeft = 120;
              _posTop = 120;
            } else {
              _posLeft = 0;
              _posTop = 0;
            }
          });
        });
  }

  Widget _buildAnimatedSize() {
    return _container(
        text: 'AnimatedSize',
        child: Container(
          child: AnimatedSize(
            duration: Duration(milliseconds: 500),
            child: Container(
              width: _size.width,
              height: _size.height,
              color: Colors.purpleAccent,
//            child: Image.asset(
//              'assets/images/mine.png',
//              fit: BoxFit.contain,
//            ),
            ),
            vsync: this,
          ),
        ),
        onPressed: () {
          setState(() {
            if (_size == Size(50, 50)) {
              _size = Size(120, 120);
            } else {
              _size = Size(50, 50);
            }
          });
        });
  }

  Widget _buildAnimatedWidget() {
    return _container(
        text: 'AnimatedWidget',
        child: _AnimatedWidget(
          controller: Tween<double>(begin: 0.5, end: 1)
              .animate(_widgetAnimationController),
        ),
        onPressed: () {
          setState(() {
            if (_widgetAnimationController.status ==
                AnimationStatus.completed) {
              _widgetAnimationController.reverse();
            } else {
              _widgetAnimationController.forward();
            }
          });
        });
  }

  Widget _buildAnimatedList() {
    return _container(
        text: 'AnimatedList',
        child: Container(
          height: 200,
          child: AnimatedList(
            key: _listKey,
            itemBuilder:
                (BuildContext context, int index, Animation<double> animation) {
              return SlideTransition(
                position: Tween(begin: Offset(1.0, 0.0), end: Offset(0, 0))
                    .animate(animation),
                child: ListTile(
                  leading: Text('#$index'),
                  title: Text('主标题'),
                  subtitle: Text('副标题'),
                  trailing: MaterialButton(
                    onPressed: () {
                      print('onPressed delete');
                      _listKey.currentState?.removeItem(index,
                          (context, animation) {
                        return SlideTransition(
                            position: Tween(
                                    begin: Offset(0.0, 0.0),
                                    end: Offset(1.0, 0))
                                .animate(animation),
                            child: ListTile(
                              leading: Text('#$index'),
                              title: Text('主标题'),
                              subtitle: Text('副标题'),
                            ));
                      });
                      _list.removeAt(index);
                    },
                    child: Text('删除'),
                  ),
                ),
              );
            },
            initialItemCount: _list.length,
          ),
        ),
        onPressed: () {
          print('onPressed add: ${_list.length}');
          _listKey.currentState
              ?.insertItem(_list.length, duration: Duration(milliseconds: 500));
          _list.add(_list.length);
        });
  }

  Widget _buildAnimationBuilder() {
    return _container(
        text: 'AnimationBuilder',
        child: Container(
          child: _AnimationBuilderWidget(),
        ),
        onPressed: () {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          _buildAnimatedOpacity(),
          _buildAnimatedContainer(),
          _buildAnimatedCrossFade(),
          _buildAnimatedDefaultTextstyle(),
          _buildAnimatedModalBarrier(),
          _buildAnimatedPhysicalModel(),
          _buildAnimatedPosition(),
          _buildAnimatedSize(),
          _buildAnimatedWidget(),
          _buildAnimatedList(),
          _buildAnimationBuilder(),
        ],
      ),
    );
  }
}

class _AnimatedWidget extends AnimatedWidget {
  final Animation<double> controller;

  _AnimatedWidget({required this.controller}) : super(listenable: controller);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120 * controller.value,
      height: 120 * controller.value,
      color: Colors.orangeAccent,
      child: Image.asset(
        'assets/images/mine.png',
        fit: BoxFit.contain,
      ),
    );
  }
}

class _AnimationBuilderWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AnimationBuilderWidgetState();
}

class _AnimationBuilderWidgetState extends State<_AnimationBuilderWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    animationController =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  double _x() {
    var x = animationController.value * (300-10);
    return x;
  }

  double _y() {
    var y = sin(2 * pi * animationController.value) * 100 + 100;
    return y;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget? child) {
        return Container(
          width: 300,
          height: 300,
          child: Column(
            children: <Widget>[
              Container(
                width: 300,
                height: 200,
                decoration: BoxDecoration(border: Border.all()),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: _x(),
                      top: _y(),
                      child: ClipOval(
                        child: Container(
                          width: 10,
                          height: 10,
                          color: Colors.orangeAccent,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              MaterialButton(
                onPressed: () {
                  print('on press ${animationController.status}');
                  if (animationController.status == AnimationStatus.completed) {
                    animationController.reverse();
                  }
                  if (animationController.status == AnimationStatus.dismissed) {
                    animationController.forward();
                  }
                  setState(() {});
                },
                color: Colors.purpleAccent,
                child: Text('重新开始'),
              )
            ],
          ),
        );
      },
    );
  }
}
