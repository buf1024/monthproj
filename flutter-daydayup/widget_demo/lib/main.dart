import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:widget_demo/widgets.dart';
import 'package:widget_demo/wrap_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(
        title: 'Flutter Demo Home Page',
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;
  final String group;

  MyHomePage({Key key, this.title, this.group}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var list = group == null ? WidgetFactory().geGroups() : WidgetFactory().getWidgets(group);
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: list.length > 0
            ? ListView.separated(
                itemBuilder: (BuildContext context, int index) {
                  var item = list[index];
                  var title = item is WrapWidget ? item.title : item;
                  return ListTile(
                      title: Text(
                        title,
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          if (item is WrapWidget) {
                            return item;
                          }
                          return MyHomePage(title: title, group: title,);
                        }));
                      });
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider();
                },
                itemCount: list.length)
            : Center(
                child: Text('空空如也~'),
              ));
  }
}
