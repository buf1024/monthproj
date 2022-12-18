import 'package:flutter/material.dart';
import 'package:widget_demo/wrap_widget.dart';

/*
 DropdownButton
 DropdownButton 下拉菜单。

关联组件：RaisedButton, a kind of button.
FlatButton, another kind of button.
Card, at the bottom of which it is common to place a DropdownButton.
Dialog, which uses a DropdownButton for its actions.
DropdownButtonTheme, which configures the DropdownButton.

 */
class DropdownButtonWidget extends WrapWidget {
  DropdownButtonWidget()
      : super(group: 'material -- 按钮', title: 'DropdownButton - 下拉button');

  @override
  Widget child(BuildContext context) {
    return _DropdownButtonWidget();
  }
}

class _DropdownButtonWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DropdownButtonWidgetState();
}

class _DropdownButtonWidgetState extends State<_DropdownButtonWidget> {
  late String selectValue;

  @override
  void initState() {
    selectValue = 'one';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      value: selectValue,
      onChanged: (value) {
        setState(() {
          selectValue = value.toString();
        });
      },
      icon: Icon(Icons.archive),
      items: <String>['one', 'two', 'three', 'four'].map((e) {
        return DropdownMenuItem<String>(
          value: e,
          child: Container(
            child: Text(e),
          ),
        );
      }).toList(),
    );
  }
}
