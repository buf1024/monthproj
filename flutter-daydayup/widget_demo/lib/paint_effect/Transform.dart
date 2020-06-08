import 'dart:math';

import 'package:flutter/material.dart';
import 'package:widget_demo/wrap_widget.dart';

/*
 Transform
 比较实用widget,实现缩放/旋转/扭曲/平移/3d视角等功能。

 origin, alignment可设置观察点，观察点的不同，呈现不同的效果。
 配合动画，可以实现比较符合物理现实的效果。Transform完成这些功能是通过一个叫Matrix4的4X4矩阵完成的。
 3D实现是通过设置变换矩阵第3行第2列的值完成的，该值是一个比较小的值，如0.0001等。

关联组件：FractionalTranslation, RotatedBox

 */
class TransformWidget extends WrapWidget {
  TransformWidget()
      : super(group: 'paint&effect', title: 'Transform - 缩放/旋转/扭曲/平移/3d视角等');

  @override
  Widget child(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _M4Skew(),
        Divider(),

        _M4Scale(),
        Divider(),

        _M4Translate(),
        Divider(),

        _M4Rotation(),
        Divider(),

        _M43DView(),
      ],
    );
  }
}

class _M4Skew extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _M4SkewState();
}

class _M4SkewState extends State<_M4Skew> {
  double alpha = 0;
  double beta = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text('Matrix4.skew 扭曲'),
        Transform(
          transform: Matrix4.skew(alpha, beta),
          child: Image.asset(
            'assets/images/mine.png',
            width: 150,
            height: 150,
            fit: BoxFit.fill,
          ),
        ),
        Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text('alpha(-pi~pi): '),
                Expanded(
                  child: Slider(
                    min: -pi,
                    max: pi,
                    value: alpha,
                    divisions: 360,
                    label: '沿x旋转${((alpha/pi) * 180.0).toStringAsFixed(0)}度',
                    onChanged: (value) {
                      setState(() {
                        alpha = value;
                      });
                    },
                  ),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Text('beta(-pi~pi): '),
                Expanded(
                  child: Slider(
                    min: -pi,
                    max: pi,
                    value: beta,
                    divisions: 360,
                    label: '沿y旋转${((beta/pi) * 180.0).toStringAsFixed(0)}度',
                    onChanged: (value) {
                      setState(() {
                        beta = value;
                      });
                    },
                  ),
                )
              ],
            )
          ],
        ),
      ],
    );
  }
}

class _M4Scale extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _M4ScaleState();
}

class _M4ScaleState extends State<_M4Scale> {
  double x = 1;
  double y = 1;
  double z = 1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text('Matrix4.diagonal3Values 缩放'),
        Transform(
          transform: Matrix4.diagonal3Values(x, y, z),
          child: Image.asset(
            'assets/images/mine.png',
            width: 150,
            height: 150,
            fit: BoxFit.fill,
          ),
        ),
        Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text('x缩放(-2~2):'),
                Expanded(
                    child: Slider(
                      min: -2,
                      max: 2,
                      value: x,
                      divisions: 20,
                      label: 'x缩放${x.toStringAsFixed(2)}倍',
                      onChanged: (value) {
                        setState(() {
                          x = value;
                        });
                      },
                    )
                )
              ],
            ),
            Row(
              children: <Widget>[
                Text('y缩放(-2~2):'),
                Expanded(
                  child: Slider(
                    min: -2,
                    max: 2,
                    value: y,
                    divisions: 20,
                    label: 'y缩放${y.toStringAsFixed(2)}倍',
                    onChanged: (value) {
                      setState(() {
                        y = value;
                      });
                    },
                  ),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Text('z缩放(-2~2):'),
                Expanded(
                  child: Slider(
                    min: -2,
                    max: 2,
                    value: z,
                    divisions: 20,
                    label: 'z缩放${z.toStringAsFixed(2)}倍',
                    onChanged: (value) {
                      setState(() {
                        z = value;
                      });
                    },
                  ),
                )
              ],
            )
          ],
        ),
      ],
    );
  }
}

class _M4Translate extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _M4TranslateState();
}

class _M4TranslateState extends State<_M4Translate> {
  double x = 0;
  double y = 0;
  double z = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text('Matrix4.translationValues 平移'),
        Transform(
          transform: Matrix4.translationValues(x, y, z),
          child: Image.asset(
            'assets/images/mine.png',
            width: 150,
            height: 150,
            fit: BoxFit.fill,
          ),
        ),
        Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text('x平移(-100~100):'),
                Expanded(
                  child: Slider(
                    min: -100,
                    max: 100,
                    value: x,
                    divisions: 200,
                    label: 'x平移$x',
                    onChanged: (value) {
                      setState(() {
                        x = value;
                      });
                    },
                  ),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Text('y平移(-100~100):'),
                Expanded(
                  child: Slider(
                    min: -100,
                    max: 100,
                    value: y,
                    divisions: 200,
                    label: 'y平移$y',
                    onChanged: (value) {
                      setState(() {
                        y = value;
                      });
                    },
                  ),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Text('z平移(-100~100):'),
                Expanded(
                  child: Slider(
                    min: -100,
                    max: 100,
                    value: z,
                    divisions: 200,
                    label: 'z平移$z',
                    onChanged: (value) {
                      setState(() {
                        z = value;
                      });
                    },
                  ),
                )
              ],
            )
          ],
        ),
      ],
    );
  }
}
class _M4Rotation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _M4RotationState();
}

class _M4RotationState extends State<_M4Rotation> {
  double x = 0;
  double y = 0;
  double z = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text('Matrix4.rotationX/Y/Z 旋转'),
        Transform(
          transform: Matrix4.rotationX(x)..rotateY(y)..rotateZ(z),
          child: Image.asset(
            'assets/images/mine.png',
            width: 150,
            height: 150,
            fit: BoxFit.fill,
          ),
        ),
        Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text('x旋转(-pi~pi)'),
                Expanded(
                  child: Slider(
                    min: -pi,
                    max: pi,
                    value: x,
                    divisions: 360,
                    label: 'x旋转$x',
                    onChanged: (value) {
                      setState(() {
                        x = value;
                      });
                    },
                  ),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Text('y旋转(-pi~pi)'),
                Expanded(
                  child: Slider(
                    min: -pi,
                    max: pi,
                    value: y,
                    divisions: 360,
                    label: 'y旋转$y',
                    onChanged: (value) {
                      setState(() {
                        y = value;
                      });
                    },
                  ),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Text('z旋转(-pi~pi)'),
                Expanded(
                  child: Slider(
                    min: -pi,
                    max: pi,
                    value: z,
                    divisions: 360,
                    label: 'z旋转$z',
                    onChanged: (value) {
                      setState(() {
                        z = value;
                      });
                    },
                  ),
                )
              ],
            )
          ],
        ),
      ],
    );
  }
}

class _M43DView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _M43DViewState();
}

class _M43DViewState extends State<_M43DView> {
  double y = 0;
  double v = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text('Matrix4 (3, 2)值 3d视觉 '),
        Transform(
          transform: Matrix4.identity()..setEntry(3, 2, v)..rotateY(y),
          child: Image.asset(
            'assets/images/mine.png',
            width: 150,
            height: 150,
            fit: BoxFit.fill,
          ),
        ),
        Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text('y旋转(-pi~pi):'),
                Expanded(
                  child: Slider(
                    min: -pi,
                    max: pi,
                    value: y,
                    divisions: 360,
                    label: 'x旋转${(y/pi *180).toStringAsFixed(2)}度',
                    onChanged: (value) {
                      setState(() {
                        y = value;
                      });
                    },
                  ),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Text('v透视(-0.01~0.01):'),
                Expanded(
                  child: Slider(
                    min: -0.01,
                    max: 0.01,
                    value: v,
                    divisions: 360,
                    label: 'v透视$v',
                    onChanged: (value) {
                      setState(() {
                        v = value;
                      });
                    },
                  ),
                )
              ],
            ),
          ],
        ),
      ],
    );
  }
}