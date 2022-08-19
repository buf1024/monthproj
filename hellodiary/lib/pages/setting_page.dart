import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info/package_info.dart';
import 'package:hellodiary/generated/i18n.dart';
import 'package:hellodiary/pages/password_page.dart';
import 'package:hellodiary/bloc/index.dart';
import 'package:hellodiary/db/model.dart';
import 'package:hellodiary/utils/colors.dart';
import 'package:hellodiary/utils/consts.dart';
import 'package:hellodiary/utils/share_pref.dart';
import 'package:hellodiary/pages/about_page.dart';
import 'package:hellodiary/utils/vo.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingPage extends StatefulWidget {
  @override
  State createState() {
    return _SettingPage();
  }
}

class _SettingPage extends State<SettingPage> {
  Map<String, String> _languages = {'': '', 'CN': 'zh', 'TW': 'zh', 'US': 'en'};
  String _versionNumber = "0.0.0";

  @override
  void initState() {
    super.initState();

    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        _versionNumber = packageInfo.version;
      });
    });
  }

  String _getLanguageText(String key) {
    switch (key) {
      case '':
        return S.of(context).followSysLang;
      case 'CN':
        return '简体中文';
      case 'TW':
        return '繁體中文';
      case 'US':
        return 'English';
    }
    return '';
  }

  List<Widget> _buildLanguages() {
    return _languages.keys.map((String key) {
      DiaryBloc diaryBloc = BlocProvider.of(context);
      return ListTile(
        title: Text(_getLanguageText(key)),
        onTap: () async {
          Map<String, String> lang = Map();
          lang[Consts.SP_LOCALE_LANGUAGE] = _languages[key];
          lang[Consts.SP_LOCALE_COUNTRY] = key;
          SharePref.instance().putJson(Consts.SP_LOCALE, lang);
          diaryBloc.updateSetting();
          Navigator.pop(context);
        },
      );
    }).toList();
  }

  void _passChanged(String newPass) {
    DiaryBloc diaryBloc = BlocProvider.of(context);
    diaryBloc.updateSetting(protect: newPass);

    setState(() {});
  }
  void _getImage(ImageSource source) async {
    DiaryBloc bloc = BlocProvider.of(context);

    bloc.showPicker = true;
    File file = await ImagePicker.pickImage(source: source);
    if (file != null) {
      await bloc.updateSetting(background: file.path);
    }
    bloc.showPicker = false;
    Navigator.pop(context);
  }

  Widget _buildWidget(BuildContext context) {
    DiaryBloc diaryBloc = BlocProvider.of(context);

    return StreamBuilder(
        stream: diaryBloc.userStream,
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
          User user = snapshot.hasData ? snapshot.data : null;
          Setting setting = user != null ? user.setting : null;
          return ListView(children: <Widget>[
            Container(
              decoration: BoxDecoration(color: Colors.white),
              child: ListTile(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          height: 250,
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            children: _buildLanguages(),
                          ),
                        );
                      });
                },
                title: Text(S.of(context).language),
                trailing: Container(
                    height: 36.0,
                    width: 36.0,
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 20.0,
                    )),
              ),
            ),
            Container(
              height: 16.0,
            ),
            Container(
              decoration: BoxDecoration(color: Colors.white),
              child: ExpansionTile(
//            leading: Icon(Icons.color_lens),
                title: Text(S.of(context).theme),
                children: <Widget>[
                  Wrap(
                    children: themeColor.keys.map((String key) {
                      return Container(
                          padding: EdgeInsets.only(
                              left: 3.0, right: 3.0, top: 6.0, bottom: 6.0),
                          child: InkWell(
                            onTap: () {
                              diaryBloc.updateSetting(theme: key);
                            },
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  width: 36.0,
                                  height: 36.0,
                                  decoration: BoxDecoration(
                                    color: themeColor[key],
                                  ),
                                ),
                                Container(
                                  width: 36.0,
                                  height: 36.0,
                                  child:
                                      (setting != null && setting.theme == key)
                                          ? Icon(
                                              Icons.check,
                                              size: 36.0,
                                              color: Colors.white,
                                            )
                                          : null,
                                )
                              ],
                            ),
                          ));
                    }).toList(),
//                    <Widget>[
//
//                      ),
//                      Container(
//                        padding: EdgeInsets.all(3.0),
//                        child: InkWell(
//                          onTap: () {},
//                          child: Container(
//                            width: 36.0,
//                            height: 36.0,
//                            decoration: BoxDecoration(
//                              color: Colors.blue,
//                            ),
//                          ),
//                        ),
//                      ),
//                    ],
                  )
                ],
              ),
            ),
            Container(
              height: 16.0,
            ),
            Container(
              decoration: BoxDecoration(color: Colors.white),
              child: ListTile(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          height: 135,
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                leading: Icon(Icons.camera),
                                title: Text(S.of(context).camera),
                                onTap: () async {
                                  _getImage(ImageSource.camera);
                                  },
                              ),
                              ListTile(
                                leading: Icon(Icons.image),
                                title: Text(S.of(context).gallery),
                                onTap: () async {
                                  _getImage(ImageSource.gallery);
                                },
                              ),
                            ],
                          ),
                        );
                      });
                },
                title: Text(S.of(context).background),
                trailing: Container(
                  width: 36.0,
                  height: 36.0,
                  child: (setting == null || setting.background.isEmpty)
                      ? Image.asset('assets/images/background.png', fit: BoxFit.fill,)
                      : Image.file(File(setting.background), fit: BoxFit.fill,),
                ),
              ),
            ),
            Container(
              height: 16.0,
            ),
            Container(
              decoration: BoxDecoration(color: Colors.white),
              child: ListTile(
                title: Text(S.of(context).protect),
                trailing: Container(
                  height: 36.0,
                  child: Switch(
                      value: setting == null ? false : setting.protect.isNotEmpty,
                      onChanged: (bool value) {
                        if (value) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (BuildContext context) {
                                return PasswordPage(cb: _passChanged,);
                              }));
                          return;
                        }
                        _passChanged('');
                      }),
                ),
              ),
            ),
            Container(
              height: 16.0,
            ),
            Container(
              decoration: BoxDecoration(color: Colors.white),
              child: ListTile(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (BuildContext context) {
                        return AboutPage();
                      }));
                },
                title: Text(S.of(context).about),
                trailing: Container(
                  height: 36.0,
                  width: 36.0,
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 20.0,
                  ),
                ),
              ),
            ),
            Container(
              height: 16.0,
            ),
            Container(
              decoration: BoxDecoration(color: Colors.white),
              child: ListTile(
                onTap: () {
                  DiaryBloc bloc = BlocProvider.of(context);
                  Version ver = bloc.version;
                  if (ver != null) {
                    var verSvr = ver.version.split('.');
                    var verLocal = _versionNumber.split('.');
                    var min = verSvr.length > verLocal.length ? verLocal.length : verSvr.length;
                    bool hasNew = false;
                    for(int i=0; i<min; i++) {
                      if (int.parse(verSvr[i]) > int.parse(verLocal[i])) {
                        hasNew = true;
                        break;
                      }
                    }
                    if (hasNew) {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          var chg = ver.changeLog;
                          return AlertDialog(
                            title: Text(S.of(context).newVersion(ver.version)),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: (chgs) {
                                  List<Widget> widgets = List<Widget>();
                                  widgets.add(Text(S.of(context).chgLog));
                                  widgets.add(Text(''));
                                  for(var c in chgs) {
                                    widgets.add(Text(c));
                                  }
                                  return widgets;
                                }(chg.split('\n')),
                              ),
                            ),
                            actions: <Widget>[
                              FlatButton(
                                child: Text(S.of(context).update),
                                onPressed: () async {
                                  debugPrint('onupdate press: ${ver}');
                                  if(await canLaunch(ver.releaseURL)) {
                                    await launch(ver.releaseURL);
                                    Navigator.of(context).pop();
                                  } else {
                                    debugPrint('can not launch ${ver.releaseURL}');
                                    SnackBar snackBar = SnackBar(
                                        backgroundColor: Theme.of(context).primaryColor,
                                        content: Text(S.of(context).openUrlFailed));
                                    Scaffold.of(context).showSnackBar(snackBar);

                                    Navigator.of(context).pop();
                                  }
                                },
                              ),
                              FlatButton(
                                child: Text(S.of(context).cancel),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          );
                        },
                      );
                    } else {
                      SnackBar snackBar = SnackBar(
                          backgroundColor: Theme.of(context).primaryColor,
                          content: Text(S.of(context).newestVersion(_versionNumber)));
                      Scaffold.of(context).showSnackBar(snackBar);
                    }
                  } else {
                    SnackBar snackBar = SnackBar(
                        backgroundColor: Theme.of(context).primaryColor,
                        content: Text(S.of(context).tryLater));
                    Scaffold.of(context).showSnackBar(snackBar);
                  }
                },
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(S.of(context).version),
                    Text(
                      S.of(context).currentVersion(_versionNumber),
                      style: TextStyle(fontSize: 12.0, color: Colors.grey),
                    )
                  ],
                ),
                trailing: Container(
                  height: 36.0,
                  width: 36.0,
                  child: Container(
                    height: 36.0,
                    width: 36.0,
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 20.0,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: 16.0,
            ),
            SizedBox(
              height: 50.0,
            ),
//            Container(
//              decoration: BoxDecoration(color: Colors.white),
//              child: ListTile(
//                onTap: () {},
//                title: Center(
//                    child: Text(
//                  '注册/登录',
//                  style: TextStyle(color: Colors.redAccent),
//                )),
//              ),
//            ),
          ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      // resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text(S.of(context).setting),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
        ),
        child: _buildWidget(context),
      ),
    );
  }
}
