import 'package:flutter/cupertino.dart';
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
    with SingleTickerProviderStateMixin {
  double _opacity = 1.0;

  double _containerWidth = 0;
  double _containerHeight = 0;
  Color _containerColor = Colors.orangeAccent;

  CrossFadeState _crossFadeState = CrossFadeState.showFirst;

  double _fontSize = 12.0;
  Color _fontColor = Colors.redAccent;

  AnimationController _animationController;

  double _elevation = 0;
  BorderRadius _borderRadius = BorderRadius.zero;

  double _posLeft = 0;
  double _posTop = 0;

  @override
  void initState() {
    _animationController =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _container({String text, Widget child, VoidCallback onPressed}) {
    if (onPressed == null) {
      onPressed = () {};
    }
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
          _buildAnimatedPosition()
        ],
      ),
    );
  }
}
