import 'package:flutter/material.dart';

abstract class WrapWidget extends StatelessWidget {
  final String group;
  final String title;

  WrapWidget({required this.group, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                child(context)
              ],
            ),
          ),
        ));
  }

  Widget child(BuildContext context) => Container();
}
