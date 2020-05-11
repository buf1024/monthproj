import 'package:flutter/material.dart';
import 'package:custom_paint/cust_paint.dart';
import 'package:custom_paint/shape_border.dart';
import 'package:custom_paint/lucky_paint.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MaterialButton(
              color: Colors.orangeAccent,
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return CustomPaintDemo();
                }));
              },
              child: Text(
                'CustomPaintDemo',
              ),
            ),
            MaterialButton(
              color: Colors.orangeAccent,
              shape: StadiumBorder(),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return ShapeBorderDemo();
                }));
              },
              child: Text(
                'ShapeBorderDemo',
              ),
            ),
            MaterialButton(
              color: Colors.orangeAccent,
              shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return LuckyFunDemo();
                }));
              },
              child: Text(
                '刮刮乐',
              ),
            )
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}