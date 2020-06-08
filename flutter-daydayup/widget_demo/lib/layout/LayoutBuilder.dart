import 'package:flutter/material.dart';
import 'package:widget_demo/wrap_widget.dart';

/*
  LayoutBuilder
 LayoutBuilder 一个可感知父容器大小的组件，可实现响应式布局。

  关联组件：SliverLayoutBuilder， Builder, StatefulBuilder,

 */
class LayoutBuilderWidget extends WrapWidget {
  LayoutBuilderWidget() : super(group: 'layout -- 布局组件', title: 'LayoutBuilder - 可感知父容器大小');

  @override
  Widget child(BuildContext context) {
    return _LayoutBuilderWidget();
  }
}

class _LayoutBuilderWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LayoutBuilderWidgetState();

}

class _LayoutBuilderWidgetState extends State<_LayoutBuilderWidget> {
  double width = 200.0;
  double height = 250.0;


  @override
  void initState() {
    super.initState();
  }

  Widget _item(double w) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Container(
        width: w,
        height: 50,
        decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.6),
            border: Border.all(color: Colors.blue.withOpacity(1))
        ),
      ),
    );
  }

  Widget _layoutSmall() {
    return Column(
      children: <Widget>[
        _item(width - 10),
        _item(width - 10),
        _item(width - 10),
        _item(width - 10),
      ],
    );
  }
  Widget _layoutLarge() {
    return Row(
      children: <Widget>[
        Column(
          children: <Widget>[
            _item(width/2 - 10),
            _item(width/2 - 10),
          ],
        ),
        Column(
          children: <Widget>[
            _item(width/2 - 10),
            _item(width/2 - 10),
          ],
        )
      ],
    );
  }
  Widget _buildWidget() {
    return Container(
        width: width,
        height: height,
        color: Colors.purple,
        child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      if(constraints.biggest.width > 250) {
        return _layoutLarge();
      }
      return _layoutSmall();
    },
    ),
    );
  }
  Widget _buildControl(BuildContext context) {
    return Slider(
      value: width,
      min: 150,
      max: MediaQuery.of(context).size.width,
      onChanged: (v) {
        setState(() {
          width = v;
        });
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return
    Column(
      children: <Widget>[
        _buildWidget(),
        SizedBox(height: 50,),
        _buildControl(context)
      ],
    );


  }

}