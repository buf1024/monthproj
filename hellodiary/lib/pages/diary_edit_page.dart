import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:zefyr/zefyr.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:hellodiary/utils/zefyr_image_delegate.dart';
import 'package:hellodiary/utils/zefyr_toolbar_delegate.dart';
import 'package:hellodiary/db/model.dart';
import 'package:hellodiary/utils/consts.dart';
import 'package:intl/intl.dart';
import 'package:hellodiary/bloc/index.dart';
import 'package:hellodiary/generated/i18n.dart';

class DiaryEditPage extends StatefulWidget {
  final Diary diary;

  DiaryEditPage({this.diary});

  @override
  State createState() {
    return _DiaryEditPage(diary: diary);
  }
}

class _DiaryEditPage extends State<DiaryEditPage> {
  ZefyrController _controller;
  FocusNode _focusNode;
  TextEditingController _textEditingController;

  Diary diary;

  bool isModified = false;
  String mood = 'sentiment_very_satisfied';
  String weather = 'wb_sunny';
  bool isPublic = false;

  _DiaryEditPage({this.diary});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _focusNode = FocusNode();
    _textEditingController = TextEditingController();
    if (diary == null) {
      _controller = ZefyrController(NotusDocument());
    } else {
      _textEditingController.text = diary.title;
      if (diary.content != null && diary.content.isNotEmpty) {
        var delta = Delta.fromJson(jsonDecode(diary.content));
        _controller = ZefyrController(NotusDocument.fromDelta(delta));
      }
      mood = diary.mood;
      weather = diary.weather;
    }
    _textEditingController.addListener(() {
      setState(() {
        isModified = true;
      });
    });
    _controller.addListener(() {
      setState(() {
        isModified = true;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
    _focusNode.dispose();
    _textEditingController.dispose();
  }

  void onSave() {
    if (!isModified) {
      return;
    }
    var document = _controller.document;
    if (diary == null) {
      diary = Diary();
    }
    diary.title = _textEditingController.text;
    diary.content = '';
    if (document.length > 0) {
      var jsObj = document.toJson();
      diary.wordCount = 0;
      diary.imageCount = 0;
      for(Operation op in jsObj) {
        diary.wordCount += op.data.length;
        var attr = op.attributes;
        if(attr != null && attr['embed'] != null) {
          var embed = attr['embed'];
          if (embed['type'] != null && embed['type'] == 'image') {
            diary.imageCount += 1;
          }
        }
      }
      var jsStr = jsonEncode(jsObj);
      jsStr = jsStr.replaceAll('\n', '\\n');
      diary.content = jsStr;
    }
    diary.weather = weather;
    diary.mood = mood;
    diary.isPublic = isPublic;

    DiaryBloc diaryBloc = BlocProvider.of(context);
    diaryBloc.saveDiary(diary);

    setState(() {
      isModified = false;
    });
  }

  List<Widget> _buildSentiment() {
    List<String> listSentiment = [
      'sentiment_very_satisfied',
      'sentiment_satisfied',
      'sentiment_neutral',
      'sentiment_dissatisfied',
      'sentiment_very_dissatisfied'
    ];
    List<Widget> widgets = List<Widget>();
    listSentiment.forEach((iconStr) {
      Widget widget = GestureDetector(
        onTap: () {
          setState(() {
            mood = iconStr;
          });
          Navigator.pop(context);
        },
        child: Container(
          margin: EdgeInsets.all(10.0),
          child: Icon(
            iconMap[iconStr],
            color: iconStr == mood ? Colors.white : Colors.grey,
            size: 30.0,
          ),
        ),
      );
      widgets.add(widget);
    });
    return widgets;
  }

  List<Widget> _buildWeather() {
    List<String> listWeather = [
      'wb_sunny',
      'wb_cloudy',
      'ac_unit',
      'flash_on',
      'blur_on'
    ];
    List<Widget> widgets = List<Widget>();
    listWeather.forEach((iconStr) {
      Widget widget = GestureDetector(
        onTap: () {
          setState(() {
            weather = iconStr;
          });
          Navigator.pop(context);
        },
        child: Container(
          margin: EdgeInsets.all(10.0),
          child: Icon(
            iconMap[iconStr],
            color: iconStr == weather ? Colors.white : Colors.grey,
            size: 30.0,
          ),
        ),
      );
      widgets.add(widget);
    });
    return widgets;
  }

  Widget _buildExWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10.0),
      color: Theme.of(context).primaryColorLight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            child: InkWell(
              onTap: () {
                setState(() {
                  isPublic = !isPublic;
                });
              },
              child: Icon(
                isPublic ? Icons.lock_open : Icons.lock_outline,
                color: Colors.white,
                size: 20.0,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(5.0),
            child: InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: _buildSentiment(),
                        ),
                      );
                    });
              },
              child: Icon(
                iconMap[mood],
                color: Colors.white,
                size: 20.0,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(5.0),
            child: InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: _buildWeather(),
                        ),
                      );
                    });
              },
              child: Icon(
                iconMap[weather],
                color: Colors.white,
                size: 20.0,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      onWillPop: () async {
        DiaryBloc diaryBloc = BlocProvider.of(context);
        diaryBloc.changeTab(reload: true);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(DateFormat('yyyy-MM-dd').format(DateTime.now())),
          actions: <Widget>[
            InkWell(
              onTap: () {
                onSave();
              },
              child: Center(
                child: Container(
                  margin: EdgeInsets.only(right: 10.0),
                  child: Text(
                    isModified ? S.of(context).save : S.of(context).saved,
                    style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
        body: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10.0),
              child: TextField(
                controller: _textEditingController,
                decoration: InputDecoration(hintText: S.of(context).title),
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Expanded(
              child: ZefyrScaffold(
                child: ZefyrEditor(
                  imageDelegate: MyAppZefyrImageDelegate(context),
                  toolbarDelegate:
                  MyAppZefyrToolbarDelegate(extra: _buildExWidget(context)),
                  controller: _controller,
                  focusNode: _focusNode,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
