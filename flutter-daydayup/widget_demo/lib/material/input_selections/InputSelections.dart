import 'dart:math';

import 'package:flutter/material.dart';
import 'package:widget_demo/wrap_widget.dart';

/*

 CheckBox 复选框，可支持三种状态。
 Radio 单选Radio
 Switch 开关
 Slider Slider滑动
 TextField 文本输入，如果用于Form里面，考虑使用TextFormField
 showDatePicker选择日期组件

 为方便，还有SwitchListTile，CheckboxListTile，CheckboxListTile类似ListTile的组件。


关联组件：SwitchListTile, which combines this widget with a ListTile so that you can give the switch a label.
Checkbox, another widget with similar semantics.
Radio, for selecting among a set of explicit values.
Slider, fo
CheckboxListTile, which combines this widget with a ListTile so that you can give the checkbox a label.
RadioListTile, which combines this widget with a ListTile so that you can give the radio button a label.

TextFormField, which integrates with the Form widget.
InputDecorator, which shows the labels and other visual elements that surround the actual text editing widget.
EditableText, which is the raw text editing control at the heart of a TextField. The EditableText widget is rarely used directly unless you are implementing an entirely different design language, such as Cupertino.
 */
class InputSelectionsWidget extends WrapWidget {
  InputSelectionsWidget()
      : super(group: 'material -- 输入选择', title: 'InputSelections - 输入选择组件');

  @override
  Widget child(BuildContext context) {
    return _InputSelectionsWidget();
  }
}

class _InputSelectionsWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _InputSelectionsWidgetState();
}

class _InputSelectionsWidgetState extends State<_InputSelectionsWidget> {
  late List<bool?> checkBoxValue;
  late bool checkBoxListTileValue;

  late List<double> radioBoxValue;
  late double radioGroupValue;
  late double radioListTileValue;

  late List<bool> switchValue;
  late bool switchListTileValue;

  late List<double> sliderValue;
  late double sliderValue2;

  late TextEditingController textEditingControllerUser;
  late TextEditingController textEditingControllerPhone;
  late String textArea;

  late DateTime dateTimePicker;

  @override
  void initState() {
    checkBoxValue = List.generate(5, (index) => false);
    checkBoxListTileValue = false;

    radioBoxValue = List.generate(5, (index) => Random().nextDouble());
    radioGroupValue = radioBoxValue.elementAt(0);
    radioListTileValue = radioBoxValue.elementAt(0);

    switchValue = List.generate(5, (index) => false);
    switchListTileValue = false;

    sliderValue = List.generate(2, (index) => 0);

    textEditingControllerUser = TextEditingController();
    textEditingControllerPhone = TextEditingController();
    textArea = '86';

    dateTimePicker = DateTime.now();

    super.initState();
  }

  @override
  void dispose() {
    textEditingControllerUser.dispose();
    textEditingControllerPhone.dispose();
    super.dispose();
  }

  Widget _checkWidget(BuildContext context) {
    bool? _checkValue() {
      if (checkBoxValue.any((element) => !element!) &&
          checkBoxValue.any((element) => element!)) {
        return false;
      }
      return checkBoxValue.reduce((value, element) => value! && element!);
    }

    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Checkbox(
                  tristate: true,
                  value: _checkValue(),
                  onChanged: (value) {
                    if (value == null) {
                      value = false;
                    }
                    setState(() {
                      checkBoxValue = checkBoxValue.map((e) => value).toList();
                    });
                  }),
              Text('Check/Uncheck All 测试')
            ],
          ),
          Column(
            children: () {
              List<Widget> widgets = <Widget>[];
              for (int i = 0; i < checkBoxValue.length; i++) {
                Widget widget = Row(
                  children: <Widget>[
                    SizedBox(
                      width: 30,
                    ),
                    Checkbox(
                      value: checkBoxValue[i],
                      onChanged: (value) {
                        setState(() {
                          checkBoxValue[i] = value;
                        });
                      },
                    ),
                    Text('Check 选项 ${i + 1}')
                  ],
                );
                widgets.add(widget);
              }
              return widgets;
            }(),
          ),
          CheckboxListTile(
            value: checkBoxListTileValue,
            onChanged: (value) {
              setState(() {
                checkBoxListTileValue = value!;
              });
            },
            title: Text('CheckboxListTile 选项'),
            subtitle: Text('CheckboxListTile 选项子标题'),
          )
        ],
      ),
    );
  }

  Widget _radioWidget(BuildContext context) {
    return Container(
      child: Column(
        children: () {
          List<Widget> widgets = <Widget>[];
          for (int i = 0; i < radioBoxValue.length; i++) {
            Widget widget = Row(
              children: <Widget>[
                Radio(
                  value: radioBoxValue[i],
                  groupValue: radioGroupValue,
                  onChanged: (value) {
                    setState(() {
                      radioGroupValue = value as double;
                    });
                  },
                ),
                Text('Radio 选项 ${i + 1}')
              ],
            );
            widgets.add(widget);
          }
          widgets.add(RadioListTile(
            value: radioListTileValue,
            groupValue: radioGroupValue,
            onChanged: (value) {},
            title: Text('RadioListTile 选项'),
            subtitle: Text('RadioListTile 选项子标题'),
          ));
          return widgets;
        }(),
      ),
    );
  }

  Widget _switchWidget(BuildContext context) {
    return Container(
      child: Column(
        children: () {
          List<Widget> widgets = <Widget>[];
          for (int i = 0; i < radioBoxValue.length; i++) {
            Widget widget = Row(
              children: <Widget>[
                Switch(
                  value: switchValue[i],
                  onChanged: (value) {
                    setState(() {
                      switchValue[i] = value;
                    });
                  },
                ),
                Text('Switch 开关 ${i + 1}'),
              ],
            );
            widgets.add(widget);
          }
          widgets.add(SwitchListTile(
            value: switchListTileValue,
            onChanged: (value) {
              setState(() {
                switchListTileValue = value;
              });
            },
            title: Text('SwitchListTile 选项'),
            subtitle: Text('SwitchListTile 选项子标题'),
          ));
          return widgets;
        }(),
      ),
    );
  }

  Widget _sliderWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: () {
          List<Widget> widgets = <Widget>[];
          for (int i = 0; i < sliderValue.length; i++) {
            Widget widget = Row(
              children: <Widget>[
                Icon(
                  Icons.volume_mute,
                  color: Colors.purple,
                ),
                Expanded(
                  child: Slider(
                    value: sliderValue[i],
                    onChanged: (value) {
                      setState(() {
                        sliderValue[i] = value;
                      });
                    },
                  ),
                ),
                Icon(Icons.volume_up, color: Colors.purple),
              ],
            );
            widgets.add(widget);
          }
          return widgets;
        }(),
      ),
    );
  }

  Widget _textFieldWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.person),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextField(
                  controller: textEditingControllerUser,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'user name'),
                ),
              )
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            children: <Widget>[
              Icon(Icons.phone),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextField(
                  controller: textEditingControllerPhone,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'phone'),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              DropdownButton(
                value: textArea,
                items: <String>['86', '852', '887', '090'].map((e) {
                  return DropdownMenuItem<String>(
                    value: e,
                    child: Text(e),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    textArea = value.toString();
                  });
                },
              )
            ],
          ),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }

  Widget _datePickerWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: <Widget>[
          TextButton(
            child: Text('选择日期'),
            onPressed: () async {
              DateTime? dt = await showDatePicker(
                  context: context,
                  initialDate: dateTimePicker,
                  firstDate: DateTime(1990),
                  lastDate: DateTime(2030));
              if (dt != null) {
                setState(() {
                  dateTimePicker = dt;
                });
              }
            },
          ),
          // FlatButton(
          //   color: Colors.orangeAccent,
          //   onPressed: () async {
          //     DateTime dt = await showDatePicker(
          //         context: context,
          //         initialDate: dateTimePicker,
          //         firstDate: DateTime(1990),
          //         lastDate: DateTime(2030));
          //     if (dt != null) {
          //       setState(() {
          //         dateTimePicker = dt;
          //       });
          //     }
          //   },
          //   child: Text('选择日期'),
          // ),
          Text(
              '你选择: ${dateTimePicker.year.toString()}-${dateTimePicker.month.toString().padLeft(2, '0')}-${dateTimePicker.day.toString().padLeft(2, '0')}'),
          SizedBox(
            height: 15,
          )
        ],
      ),
    );
  }

  Widget _widgetDemo(
      Widget Function(BuildContext) func, BuildContext context, String widget) {
    return Container(
      width: MediaQuery.of(context).size.width - 20,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.blue.withOpacity(0.8)),
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text('$widget Demo'),
          ),
          SizedBox(
            height: 5,
          ),
          func(context)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          _widgetDemo(_checkWidget, context, 'Checkbox'),
          SizedBox(
            height: 15,
          ),
          _widgetDemo(_radioWidget, context, 'Radio'),
          SizedBox(
            height: 15,
          ),
          _widgetDemo(_switchWidget, context, 'Switch'),
          SizedBox(
            height: 15,
          ),
          _widgetDemo(_sliderWidget, context, 'Slider'),
          SizedBox(
            height: 15,
          ),
          _widgetDemo(_textFieldWidget, context, 'TextField'),
          SizedBox(
            height: 15,
          ),
          _widgetDemo(_datePickerWidget, context, 'showDatePicker'),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}
