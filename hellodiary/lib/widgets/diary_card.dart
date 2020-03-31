import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:zefyr/zefyr.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:intl/intl.dart';
import 'package:hellodiary/db/model.dart';
import 'package:hellodiary/utils/consts.dart';
import 'package:hellodiary/bloc/index.dart';
import 'package:hellodiary/utils/zefyr_image_delegate.dart';
import 'package:hellodiary/pages/diary_edit_page.dart';
import 'package:hellodiary/generated/i18n.dart';

class DiaryCard extends StatefulWidget {
  final Diary diary;

  DiaryCard({this.diary}) : super(key: GlobalKey());

  @override
  State createState() {
    return _DiaryCard(diary);
  }
}

class _DiaryCard extends State<DiaryCard> {
  ZefyrController _controller;
  FocusNode _focusNode;

  final Diary diary;

  // Diary diary;

  _DiaryCard(this.diary);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (diary != null) {
      if (diary.content != null && diary.content.isNotEmpty) {
        var delta = Delta.fromJson(jsonDecode(diary.content));
        final document = NotusDocument.fromDelta(delta);
        _controller = ZefyrController(document);
        _focusNode = FocusNode();
      }
    }
    if (_controller == null && _focusNode == null) {
      _controller = ZefyrController(NotusDocument());
      _focusNode = FocusNode();
    }
  }

  @override
  void dispose() {
    debugPrint('card dispose $mounted');
    super.dispose();
    _controller.dispose();
    _focusNode.dispose();
  }

  String _getPlainDeltaText(String content) {
    var delta = Delta.fromJson(jsonDecode(content));
    final document = new NotusDocument.fromDelta(delta);
    return document.toPlainText();
  }

  Widget _buildCard(BuildContext context) {
    if (diary == null) {
      return Container(
        height: 100.0,
        padding: EdgeInsets.all(4.0),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 0.5),
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
        child: Center(
          child: ListTile(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return DiaryEditPage();
              }));
            },
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 5.0),
                  child: Icon(
                    Icons.border_color,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Text(
                  S.of(context).addDiary,
                  style: TextStyle(fontSize: 23.0),
                )
              ],
            ),
          ),
        ),
      );
    }
    return Dismissible(
      key: ObjectKey(diary.id),
      direction: DismissDirection.endToStart,
      background: Container(),
      secondaryBackground: Container(
        color: Colors.redAccent,
      ),
      onDismissed: (DismissDirection direction) async {
        DiaryBloc diaryBloc = BlocProvider.of(context);
        diary.isTrash = true;
        await diaryBloc.saveDiary(diary);
        await diaryBloc.changeTab(reload: true);
        SnackBar snackBar = SnackBar(
            backgroundColor: Theme.of(context).primaryColor,
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(S.of(context).deletedDiary),
                InkWell(
                  onTap: () async {
                    diary.isTrash = false;
                    await diaryBloc.saveDiary(diary);
                    await diaryBloc.changeTab(reload: true);
                  },
                  child: Text(S.of(context).cancelDelete),
                )
              ],
            ));
        Scaffold.of(context).showSnackBar(snackBar);
      },
      child: Container(
        padding: EdgeInsets.all(4.0),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 0.5),
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                  left: 12.0, right: 12.0, top: 4.0, bottom: 4.0),
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 4.0),
                    child: Text(
                      DateFormat('dd').format(diary.createTime),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 35.0, fontWeight: FontWeight.w400),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      DateFormat(DateFormat.ABBR_WEEKDAY)
                          .format(diary.createTime),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  Container(
                    child: Text(
                      DateFormat('HH:mm:ss').format(diary.createTime),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          diary.title,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          _getPlainDeltaText(diary.content),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                ],
              ),
            ),
            Column(
              children: <Widget>[
                SizedBox(
                  height: 5.0,
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      diary.isPublic ? Icons.lock_open : Icons.lock_outline,
                      color: Theme.of(context).primaryColor,
                    ),
                    Icon(
                      iconMap[diary.weather],
                      color: Theme.of(context).primaryColor,
                    ),
                    Icon(
                      iconMap[diary.mood],
                      color: Theme.of(context).primaryColor,
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        var action = await showDialog<String>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0))),
                child: Column(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          height: 150.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15.0),
                                topRight: Radius.circular(15.0)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                child: Text(
                                  DateFormat(DateFormat.YEAR_ABBR_MONTH)
                                      .format(diary.createTime),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20.0),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.all(15.0),
                                child: Text(
                                  DateFormat('dd').format(diary.createTime),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 45.0),
                                ),
                              ),
                              Container(
                                child: Text(
                                  DateFormat('${DateFormat.WEEKDAY} HH:mm:ss')
                                      .format(diary.createTime),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15.0),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            margin: EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                debugPrint('dialog close');
                                Navigator.of(context).pop('close');
                              },
                              child: Icon(
                                Icons.close,
                                size: 30.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: ZefyrScaffold(
                        child: ZefyrEditor(
//                          enabled: false,
                          mode: ZefyrMode(
                              canEdit: false,
                              canFormat: false,
                              canSelect: true),
                          imageDelegate: MyAppZefyrImageDelegate(context),
                          controller: _controller,
                          focusNode: _focusNode,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(15.0),
                            bottomRight: Radius.circular(15.0)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
//                              Icon(
//                                Icons.location_off,
//                                color: Colors.white,
//                              ),
//                              Text(
//                                '无位置',
//                                style: TextStyle(
//                                  color: Colors.white,
//                                ),
//                              ),
                              Container(
                                margin: EdgeInsets.only(right: 10.0),
                                child: Icon(
                                  diary.isPublic
                                      ? Icons.lock_open
                                      : Icons.lock_outline,
                                  color: Colors.white,
                                ),
                              ),
                              Container(
                                  margin: EdgeInsets.only(right: 10.0),
                                  child: Icon(
                                    iconMap[diary.weather],
                                    color: Colors.white,
                                  )),
                              Container(
                                margin: EdgeInsets.only(right: 10.0),
                                child: Icon(
                                  iconMap[diary.mood],
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              SizedBox(
                                width: 12.0,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).pop('edit');
                                },
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            });
        debugPrint('action: $action');
        if (action == 'edit') {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return DiaryEditPage(diary: diary);
          }));
        }
      },
      child: _buildCard(context),
    );
  }
}
