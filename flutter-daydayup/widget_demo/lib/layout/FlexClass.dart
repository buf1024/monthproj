import 'package:flutter/material.dart';
import 'package:widget_demo/wrap_widget.dart';

/*
  FlexClass
 Flex, Row, Column是Flutter世界里的flex布局。
 Row/Column分布是flex-direction的行/列形式。
 flex参考：
 https://www.ruanyifeng.com/blog/2015/07/flex-grammar.html
 https://www.ruanyifeng.com/blog/2015/07/flex-examples.html

  Expand/Flexible/Spacer

   Expand, Flexible, Spacer是如何布局flex里面的组件的。
   如：Expand默认占据剩余(也可根据flex设置占据不同空间）所有空间，
   Flexible可设置flex计算各个组件默认空，Spacer空白填充剩余（也可根据flex设置占据不同空间）空间

 */
class FlexClassWidget extends WrapWidget {
  FlexClassWidget() : super(group: 'layout -- 布局组件', title: 'Flex, Row, Column - flex布局');

  @override
  Widget child(BuildContext context) {
    return Container(
      height: 300,
      width: MediaQuery.of(context).size.width,
      child: Column(
//      direction: Axis.vertical,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                height: 50,
                width: 100,
                color: Colors.blueAccent,
                child: Text('Flex Row, 居左', style: TextStyle(color: Colors.white),),
              ),
              Spacer(),
              Container(
                height: 50,
                width: 100,
                color: Colors.blueAccent,
                child: Text('Flex Row, 居右', style: TextStyle(color: Colors.white),),
              ),
            ],
          ),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 100,
                  width: 50,
                  color: Colors.blueAccent,
                  child: Text('Flex Column, 居中', style: TextStyle(color: Colors.white),),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
