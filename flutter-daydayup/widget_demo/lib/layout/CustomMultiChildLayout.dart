import 'package:flutter/material.dart';
import 'package:widget_demo/wrap_widget.dart';

/*  CustomMultiChildLayout
 自定义布局，通过实现delegate，可以实现children的自由布局。

CustomMultiChildLayout的孩子需要id标识，通常将孩子包裹于LayoutId组件。
delegate里面，重写的performLayout，对每一个child需要调用layoutChild确定child大小，和
positionChild确定位置。

 或许叫FreeLayout更适合点, 使用起来并不是很方便。

 关联组件: CustomSingleChildLayout, Stack, Flow
 */

enum MyId { ID_1, ID_2, ID_3 }

class CustomMultiChildLayoutWidget extends WrapWidget {
  CustomMultiChildLayoutWidget()
      : super(group: 'layout -- 布局组件', title: 'CustomMultiChildLayout - 自由布局');

  @override
  Widget child(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      color: Colors.purple,
      alignment: Alignment.bottomCenter,
      child: CustomMultiChildLayout(
        delegate: _MultiChildLayoutDelegate(),
        children: <Widget>[
          LayoutId(
            id: MyId.ID_1,
            child: Container(
              height: 50,
              width: 50,
              decoration:
                  BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
            ),
          ),
          LayoutId(
              id: MyId.ID_2,
              child: Container(
                height: 50,
                width: 50,
                decoration:
                    BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
              )),
          LayoutId(
              id: MyId.ID_3,
              child: Container(
                height: 50,
                width: 50,
                decoration:
                    BoxDecoration(color: Colors.amber, shape: BoxShape.circle),
              )),
        ],
      ),
    );
  }
}

class _MultiChildLayoutDelegate extends MultiChildLayoutDelegate {
  @override
  void performLayout(Size size) {
    // TODO: implement performLayout
    layoutChild(MyId.ID_1, BoxConstraints.loose(size));
    positionChild(MyId.ID_1, Offset(0, 0));

    var sizeChild = layoutChild(MyId.ID_2, BoxConstraints.loose(size));
    positionChild(MyId.ID_2, Offset(0, size.height - sizeChild.height));

    sizeChild = layoutChild(MyId.ID_3, BoxConstraints.loose(size));
    positionChild(
        MyId.ID_3,
        Offset(size.width / 2 - sizeChild.width / 2,
            size.height / 2 - sizeChild.height / 2));
  }

  @override
  bool shouldRelayout(MultiChildLayoutDelegate oldDelegate) => false;
}
