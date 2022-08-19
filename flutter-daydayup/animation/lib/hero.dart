import 'dart:math';

import 'package:flutter/material.dart';

class HeroAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SourcePage();
  }
}

class SourcePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SourcePageState();
}

class _SourcePageState extends State<SourcePage>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  Offset? p0, p1, p2;

  double? left, top;

  OverlayEntry? _overlayEntry;

  GlobalKey _globalKey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    animationController =
        AnimationController(duration: Duration(seconds: 5), vsync: this);
    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (_overlayEntry != null) {
          _overlayEntry!.remove();
          _overlayEntry = null;
          animationController.reset();
        }
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

      RenderBox? box = _globalKey.currentContext?.findRenderObject() as RenderBox;

      p2 = box.localToGlobal(Offset.zero);

      print('p2:$p2');
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var height = MediaQuery.of(context).size.height -
        kToolbarHeight -
        kBottomNavigationBarHeight -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    return Scaffold(
        appBar: AppBar(
          title: Text('hero动画'),
        ),
        body: Column(
          children: <Widget>[
            Container(
              height: height,
              child: ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: ListTile(
                      leading: Hero(
                        tag: 'list_$index',
                        child: MaterialButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return DestPage();
                                },
                                settings: RouteSettings(
                                    name: '$index', arguments: index)));
                          },
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/mine.png',
                              height: 60,
                              width: 60,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      title: Text('List ${index + 1}'),
                      subtitle: Text('List ${index + 1}'),
                      trailing:
                      Builder(
                        builder: (BuildContext context) {
                          return MaterialButton(
                            onPressed: () {
                              RenderBox? renderBox = context.findRenderObject() as RenderBox;

                              p0 = renderBox.localToGlobal(Offset.zero);
                              p1 = Offset(p0!.dx - 120, p0!.dy - 30);
                              print('p0:$p0, p1=$p1');

                              _overlayEntry =
                                  OverlayEntry(builder: (BuildContext context) {
                                    return RedPage(animationController, p0!, p1!, p2!);
                                  });

                              Overlay.of(context)?.insert(_overlayEntry!);
                              animationController.forward();
                            },
                            child: Icon(Icons.add),
                          );
                        },
                      ),
                    ),
                  );
                },
                itemCount: 50,
              ),
            ),
            Container(
              height: kBottomNavigationBarHeight,
              decoration: BoxDecoration(color: Colors.purple.withOpacity(0.5)),
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 50,
                  ),
                  Icon(Icons.shop, key: _globalKey,)
                ],
              ),
            )
          ],
        ));
  }
}

class RedPage extends StatefulWidget {
  final AnimationController animationController;
  final Offset p0, p1, p2;

  RedPage(this.animationController, this.p0, this.p1, this.p2);

  @override
  State<StatefulWidget> createState() => _RedPageState();
}

class _RedPageState extends State<RedPage> {
  double? left, top;

  @override
  void initState() {
    // TODO: implement initState
    widget.animationController.addListener(() {
      var t = widget.animationController.value;
      debugPrint('t=$t');
      var left =
          pow(1 - t, 2) * widget.p0.dx + 2 * t * (1 - t) * widget.p1.dx + pow(t, 2) * widget.p2.dx;
      var top =
          pow(1 - t, 2) * widget.p0.dy + 2 * t * (1 - t) * widget.p1.dy + pow(t, 2) * widget.p2.dy;

      if(mounted) {
        setState(() {
          this.left = left;
          this.top = top;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
      children: <Widget>[
        Positioned(
          left: left,
          top: top,
          child: ClipOval(
            child: Image.asset(
              'assets/images/mine.png',
              width: 60,
              height: 60,
              fit: BoxFit.fill,
            ),
          ),
        )
      ],
    );
  }
}

class DestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var width = MediaQuery.of(context).size.width;
    var index = ModalRoute.of(context)?.settings.arguments;
    print('args');
    return Scaffold(
        appBar: AppBar(
          title: Text('hero动画'),
        ),
        body: Column(
          children: <Widget>[
            Hero(
              createRectTween: (begin, end) {
                return RectTween(
                  begin: Rect.fromLTRB(
                      begin!.left, begin.top, begin.right, begin.bottom),
                  end: Rect.fromLTRB(end!.left, end.top, end.right, end.bottom),
                );
              },
              tag: 'list_$index',
              child: Container(
                width: width,
                height: 200,
                child: Image.asset(
                  'assets/images/mine.png',
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Expanded(
              child: Text('detail page'),
            )
          ],
        ));
  }
}
