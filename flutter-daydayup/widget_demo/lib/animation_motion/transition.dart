import 'package:flutter/material.dart';
import 'package:widget_demo/wrap_widget.dart';

/*
Transition 为过渡效果组
 RotationTransition 旋转过渡。
ScaleTransition 缩放过渡。
PositionedTransition 摆放位置过渡, 需要包裹在Stack里面使用。RelativeRect指的是离外层容器left, top, right, bottom的距离
RelativePositionedTransition 摆放位置过渡与PositionedTransition功能一样，参考的对象不一样，需要指定一个size，相对的位置大小。
FadeTransition 淡出过渡。
SizeTransition 大小变化过渡。
DecoratedBoxTransition 装饰过渡。

  关联组件：
SizeTransition, a widget that animates its own size and clips and aligns its child.

PositionedTransition, a widget that animates its child from a start position to an end position over the lifetime of the animation.
RelativePositionedTransition, a widget that transitions its child's position based on the value of a rectangle relative to a bounding box.
AnimatedPositioned, which transitions a child's position without taking an explicit Animation argument.
RelativePositionedTransition, a widget that transitions its child's position based on the value of a rectangle relative to a bounding box.
SlideTransition, a widget that animates the position of a widget relative to its normal position.
AlignTransition, an animated version of an Align that animates its Align.alignment property.
ScaleTransition, a widget that animates the scale of a transformed widget.

Opacity, which does not animate changes in opacity.
AnimatedOpacity, which animates changes in opacity without taking an explicit Animation argument.

 */
class TransitionWidget extends WrapWidget {
  TransitionWidget()
      : super(group: 'animation -- 动画组件', title: 'Transition - 过渡类组件');

  @override
  Widget child(BuildContext context) {
    return _TransitionWidget();
  }
}

class _TransitionWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TransitionWidgetState();
}

class _TransitionWidgetState extends State<_TransitionWidget>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;

  Animation<double> rotaAnimation;
  Animation<double> scaleAnimation;
  Animation<RelativeRect> posAnimation;
  Animation<Rect> relPosAnimation;
  Animation<double> sizeAnimation;
  Animation<Decoration> decoAnimation;

  OverlayEntry _entry;

  @override
  void initState() {
    animationController =
        AnimationController(duration: Duration(seconds: 5), vsync: this);

    rotaAnimation = CurvedAnimation(
        parent: animationController, curve: Curves.easeInOutQuad);
    scaleAnimation =
        CurvedAnimation(parent: animationController, curve: Curves.bounceInOut);

    posAnimation = RelativeRectTween(
            begin: RelativeRect.fromLTRB(0, 0, 180, 180),
            end: RelativeRect.fromLTRB(180, 180, 0, 0))
        .animate(CurvedAnimation(
            parent: animationController, curve: Curves.easeInOutCubic));

    relPosAnimation = RectTween(
            begin: Rect.fromLTRB(0, 0, 120, 120),
            end: Rect.fromLTRB(90, 90, 210, 210))
        .animate(CurvedAnimation(
            parent: animationController, curve: Curves.easeInOutCubic));

    sizeAnimation =
        CurvedAnimation(parent: animationController, curve: Curves.easeInExpo);

    decoAnimation = DecorationTween(
        begin: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          border: Border.all(
            color: const Color(0xFF000000),
            style: BorderStyle.solid,
            width: 4.0,
          ),
          borderRadius: BorderRadius.zero,
          shape: BoxShape.rectangle,
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color(0x66000000),
              blurRadius: 10.0,
              spreadRadius: 4.0,
            )
          ],
        ),
        end: BoxDecoration(
          color: const Color(0xFF000000),
          border: Border.all(
            color: const Color(0xFF202020),
            style: BorderStyle.solid,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(10.0),
          shape: BoxShape.rectangle,
          // No shadow.
        )).animate(animationController);

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (_entry == null) {
          _buildOverlay();
        }
      }
    });

    animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    if (_entry != null) {
      _entry.remove();
    }
    super.dispose();
  }

  Widget _container({Widget child, String text}) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(
        children: <Widget>[Text(text), child],
      ),
    );
  }

  Widget _buildRotationTransition() {
    return _container(
        child: RotationTransition(
          turns: rotaAnimation,
          child: Image.asset(
            'assets/images/mine.png',
            height: 120,
            width: 120,
            fit: BoxFit.contain,
          ),
        ),
        text: 'RotationTransition');
  }

  Widget _buildScaleTransition() {
    return _container(
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Image.asset(
            'assets/images/mine.png',
            height: 120,
            width: 120,
            fit: BoxFit.contain,
          ),
        ),
        text: 'ScaleTransition');
  }

  Widget _buildPositionedTransition() {
    return _container(
        child: Container(
          height: 300,
          width: 300,
          child: Stack(
            children: <Widget>[
              PositionedTransition(
                rect: posAnimation,
                child: Container(
                  height: 120,
                  width: 120,
                  child: Image.asset(
                    'assets/images/mine.png',
                    height: 120,
                    width: 120,
                    fit: BoxFit.contain,
                  ),
                ),
              )
            ],
          ),
        ),
        text: 'PositionedTransition');
  }

  Widget _buildRelativePositionedTransition() {
    return _container(
        child: Container(
          height: 300,
          width: 300,
          child: Stack(
            children: <Widget>[
              RelativePositionedTransition(
                rect: relPosAnimation,
                size: Size(300, 300),
                child: Container(
                  height: 120,
                  width: 120,
                  child: Image.asset(
                    'assets/images/mine.png',
                    height: 120,
                    width: 120,
                    fit: BoxFit.contain,
                  ),
                ),
              )
            ],
          ),
        ),
        text: 'RelativePositionedTransition');
  }

  Widget _buildSlideTransition() {
    return _container(
        child: MaterialButton(
          onPressed: () {
            Navigator.of(context).push(
              PageRouteBuilder(
                  transitionDuration: Duration(seconds: 1),
                  pageBuilder: (BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation) {
                    return TransitionWidget();
                  },
                  transitionsBuilder: (BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation,
                      Widget child) {
                    return SlideTransition(
                      position: Tween(begin: Offset(1.0, 0), end: Offset(0, 0))
                          .animate(animation),
                      child: child,
                    );
                  }),
            );
          },
          color: Colors.purple.withOpacity(0.5),
          child: Text('SlideTransition打开新页'),
        ),
        text: 'SlideTransition');
  }

  Widget _buildSizeTransition() {
    return _container(
        child: SizeTransition(
          sizeFactor: scaleAnimation,
          child: Image.asset(
            'assets/images/mine.png',
            height: 120,
            width: 120,
            fit: BoxFit.contain,
          ),
        ),
        text: 'SizeTransition');
  }

  Widget _buildDecoratedBoxTransition() {
    return _container(
        child: DecoratedBoxTransition(
          decoration: decoAnimation,
          child: Image.asset(
            'assets/images/mine.png',
            height: 120,
            width: 120,
            fit: BoxFit.contain,
          ),
        ),
        text: 'DecoratedBoxTransition');
  }

  void _buildOverlay() {
    _entry = OverlayEntry(builder: (BuildContext context) {
      var size = MediaQuery.of(context).size;
      return Stack(
        children: <Widget>[
          Positioned.fromRelativeRect(
            rect: RelativeRect.fromLTRB(
                size.width - 80, size.height - 80, 20, 20),
            child: MaterialButton(
              color: Colors.pinkAccent.withOpacity(0.8),
              shape: CircleBorder(),
              child: Icon(
                Icons.airplanemode_active,
                color: Colors.white,
                size: 22,
              ),
              onPressed: () {
                if (animationController.status == AnimationStatus.completed) {
                  animationController.reverse();
                }
                if (animationController.status == AnimationStatus.dismissed) {
                  animationController.forward();
                }
              },
            ),
          )
        ],
      );
    });
    Overlay.of(context).insert(_entry);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          _buildRotationTransition(),
          _buildScaleTransition(),
          _buildPositionedTransition(),
          _buildRelativePositionedTransition(),
          _buildSlideTransition(),
          _buildSizeTransition(),
          _buildDecoratedBoxTransition()
        ],
      ),
    );
  }
}
