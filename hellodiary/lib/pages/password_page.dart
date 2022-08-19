import 'dart:convert';
// import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:hellodiary/generated/i18n.dart';
import 'package:hex/hex.dart';

class PasswordPage extends StatefulWidget {
  final bool isCheckRole;
  final String pass;
  final ValueChanged<String> cb;

  PasswordPage({this.isCheckRole = false, this.pass, this.cb});

  @override
  State createState() {
    return _PasswordPage(isCheckRole: isCheckRole, pass: pass, cb: cb);
  }
}

class _PasswordPage extends State<PasswordPage> {
  final bool isCheckRole;
  final String pass;
  final ValueChanged<String> cb;

  bool isChecked = false;

  List<int> checkList = [-1, -1, -1, -1];

  List<int> inputList = [-1, -1, -1, -1];

  String message = '';

  _PasswordPage({this.isCheckRole, this.pass, this.cb});

  @override
  void initState() {
    super.initState();
  }

  Widget _buildNumber(int value) {
    return InkWell(
      onTap: () {
        var index = inputList.indexWhere((v) {
          return v == -1;
        });
        if (index >= 0) {
          inputList[index] = value;
          setState(() {
          });
          if(index == inputList.length - 1) {
            if(isCheckRole) {
              var passInput = inputList.join('');
              // check pass
              var passInputMD5 = md5.convert(Utf8Encoder().convert(passInput));
              // if (hex.encode(passInputMD5.bytes) == pass) {
              if(HEX.encode(passInputMD5.bytes) == pass) {
                isChecked = true;
                Navigator.of(context).pop();
              } else {
                setState(() {
                  message = S.of(context).incorrectPass;
                  inputList = [-1, -1, -1, -1];
                });
              }
            } else {
              if (checkList[0] == -1) {
                setState(() {
                  checkList.setAll(0, inputList);
                  inputList = [-1, -1, -1, -1];
                  message = S.of(context).reenterPass;
                });
              } else {
                for(var i=0; i<checkList.length; i++) {
                  if (checkList[i] != inputList[i]) {
                    message = S.of(context).mismatchPass;
                    return;
                  }
                }
                if(cb != null) {
                  var passInput = inputList.join('');
                  var passInputMD5 = md5.convert(Utf8Encoder().convert(passInput));
                  var md5Str = HEX.encode(passInputMD5.bytes);
                  cb(md5Str);
                }
                Navigator.of(context).pop();
              }
            }
          } else {
            setState(() {
              message = '';
            });
          }
        }
      },
      child: Container(
        height: 80.0,
        width: 80.0,
        margin: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.blueGrey),
            borderRadius: BorderRadius.all(Radius.circular(40.0))),
        child: Center(
          child: Text(
            '$value',
            style: TextStyle(fontSize: 50.0, color: Colors.blueGrey[700]),
          ),
        ),
      ),
    );
  }

  Widget _buildNumberRow(BuildContext context, int start, int end) {
    List<Widget> widgets = <Widget>[];
    for (int i = start; i <= end; i++) {
      widgets.add(_buildNumber(i));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: widgets,
    );
  }

  Widget _buildBackspace() {
    var exists = inputList.indexWhere((v) {
      return v != -1;
    }) != -1;
    if (exists) {
      return Center(
          child: InkWell(
            onTap: () {
              var index = inputList.lastIndexWhere((v) {
                return v != -1;
              });
              if (index >= 0) {
                setState(() {
                  inputList[index] = -1;
                });
              }
            },
            child: Icon(
              Icons.backspace,
              size: 30,
            ),
          ));
    }
    return Container();
  }
  List<Widget> _buildFeedback(BuildContext context) {
    List<Widget> widgets = <Widget>[];
    inputList.forEach((v) {
      if(v != -1) {
        widgets.add(Container(
          height: 14.0,
          width: 14.0,
          margin: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.all(Radius.circular(7.0))),
        ));
      } else {
        widgets.add(Container(
          height: 14.0,
          width: 14.0,
          margin: EdgeInsets.all(5.0),
          decoration: BoxDecoration(border: Border(bottom: BorderSide())),
        ));
      }
    });
    return widgets;
  }
  Widget _buildPassword(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 100,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _buildFeedback(context),
        ),
        SizedBox(
          height: 50,
        ),
        _buildNumberRow(context, 1, 3),
        _buildNumberRow(context, 4, 6),
        _buildNumberRow(context, 7, 9),
        Center(
            child: InkWell(
          onTap: () {},
          child: _buildNumber(0),
        )),
        SizedBox(
          height: 20,
        ),
        _buildBackspace(),
        SizedBox(
          height: 20,
        ),
        Center(
          child: Text(
            message,
            style: TextStyle(color: Colors.redAccent),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      onWillPop: () async {
        if(isCheckRole) {
          return isChecked;
        }
        return true;
      },
      child: Scaffold(
        // resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          centerTitle: true,
          title: Text(S.of(context).password),
        ),
        body: _buildPassword(context),
      )
    );
  }
}
