import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
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
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
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
        Text('Matrix4.skew'),
        Transform(
          transform: Matrix4.skew(alpha, beta),
          child: Image.asset(
            'assets/images/mine.png',
            width: 180,
            height: 150,
            fit: BoxFit.fill,
          ),
        ),
        Column(
          children: <Widget>[
            Slider(
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
            Slider(
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
        Text('Matrix4.diagonal3Values'),
        Transform(
          transform: Matrix4.diagonal3Values(x, y, z),
          child: Image.asset(
            'assets/images/mine.png',
            width: 180,
            height: 150,
            fit: BoxFit.fill,
          ),
        ),
        Column(
          children: <Widget>[
            Slider(
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
            ),
            Slider(
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
            Slider(
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
        Text('Matrix4.diagonal3Values'),
        Transform(
          transform: Matrix4.translationValues(x, y, z),
          child: Image.asset(
            'assets/images/mine.png',
            width: 180,
            height: 150,
            fit: BoxFit.fill,
          ),
        ),
        Column(
          children: <Widget>[
            Slider(
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
            Slider(
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
            Slider(
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
        Text('Matrix4.rotationX Y Z'),
        Transform(
          transform: Matrix4.rotationX(x)..rotateY(y)..rotateZ(z),
          child: Image.asset(
            'assets/images/mine.png',
            width: 180,
            height: 150,
            fit: BoxFit.fill,
          ),
        ),
        Column(
          children: <Widget>[
            Slider(
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
            Slider(
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
            Slider(
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
        Text('Matrix4.3Dview'),
        Transform(
          transform: Matrix4.identity()..setEntry(3, 2, v)..rotateY(y),
          child: Image.asset(
            'assets/images/mine.png',
            width: 180,
            height: 150,
            fit: BoxFit.fill,
          ),
        ),
        Column(
          children: <Widget>[
            Slider(
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
            Slider(
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
          ],
        ),
      ],
    );
  }
}