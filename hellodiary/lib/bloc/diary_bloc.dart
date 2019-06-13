import 'package:tuple/tuple.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:hellodiary/bloc/bloc_provider.dart';
import 'package:hellodiary/db/appdb.dart';
import 'package:hellodiary/db/model.dart';
import 'package:hellodiary/utils/consts.dart';
import 'package:hellodiary/utils/vo.dart';

class DiaryBloc implements BlocBase {

  BehaviorSubject<TabIndex> _tabSubject = BehaviorSubject<TabIndex>();
  Stream<TabIndex> get tabStream => _tabSubject.stream;

  BehaviorSubject<User> _userSubject = BehaviorSubject<User>();
  Stream<User> get userStream => _userSubject.stream;

  BehaviorSubject<User> _userLoadSubject = BehaviorSubject<User>();
  Stream<User> get userLoadStream => _userLoadSubject.stream;

  BehaviorSubject<UserStat> _userStatSubject = BehaviorSubject<UserStat>();
  Stream<UserStat> get userStatStream => _userStatSubject.stream;

  BehaviorSubject<int> _userNoticeSubject = BehaviorSubject<int>();
  Stream<int> get userNoticeStream => _userNoticeSubject.stream;

  BehaviorSubject<List<Tuple2<Diary, String>>> _diaryImageSubject = BehaviorSubject<List<Tuple2<Diary, String>>>();
  Stream<List<Tuple2<Diary, String>>> get diaryImageStream => _diaryImageSubject.stream;

  BehaviorSubject<Setting> _settingSubject = BehaviorSubject<Setting>();
  Stream<Setting> get settingStream => _settingSubject.stream;

  BehaviorSubject<List<DateTime>> _diaryDateSubject = BehaviorSubject<List<DateTime>>();
  Stream<List<DateTime>> get diaryDateStream => _diaryDateSubject.stream;

  BehaviorSubject<List<Diary>> _diaryViewSubject = BehaviorSubject<List<Diary>>();
  Stream<List<Diary>> get diaryViewStream => _diaryViewSubject.stream;

  BehaviorSubject<List<dynamic>> _diaryBrowserSubject = BehaviorSubject<List<dynamic>>();
  Stream<List<dynamic>> get diaryBrowserStream => _diaryBrowserSubject.stream;

  BehaviorSubject<Diary> _diarySubject = BehaviorSubject<Diary>();
  Stream<Diary> get diaryStream => _diarySubject.stream;

  User _user;
  User get user => _user;
  TabIndex _tabIndex;
  DateTime _selectDate = DateTime.now();

  bool showPicker = false;

  Version version;
  Advertisement advertisement;

  DiaryBloc() {
    changeTab(index: TabIndex.BROWSER_PAGE);
  }
  Future _loadUser() async {
    _user = await AppDb.instance().getUser();
    _userSubject.sink.add(_user);
    _settingSubject.sink.add(_user.setting);
    _userLoadSubject.sink.add(_user);
  }

  Future updateUser({
    String name,
    String motto,
    String image,
    bool isLogin,
    String token,
  }) async {
    int updated = await AppDb.instance().updateUser(_user.id,
      name: name,
      motto: motto,
      image: image,
      isLogin: isLogin,
      token: token
    );
    if(updated > 0) {
      if (name != null) {
        _user.name = name;
      }
      if (motto != null) {
        _user.motto = motto;
      }
      if (image != null) {
        _user.image = image;
      }
      if (isLogin != null) {
        _user.isLogin = isLogin;
      }
      if (token != null) {
        _user.token = token;
      }

      _userSubject.sink.add(_user);
    }
  }

  Future updateSetting({
    String theme,
    String background,
    String protect,
    bool isAutoSync,
  }) async {
    int updated = await AppDb.instance().updateSetting(_user.id,
        theme: theme,
        background: background,
        protect: protect,
        isAutoSync: isAutoSync
    );
    if(updated > 0) {
      var setting = _user.setting;
      if (theme != null) {
        setting.theme = theme;
      }
      if (background != null) {
        setting.background = background;
      }
      if (protect != null) {
        setting.protect = protect;
      }
      if (isAutoSync != null) {
        setting.isAutoSync = isAutoSync;
      }
    }

    _userSubject.sink.add(_user);
    _settingSubject.sink.add(_user.setting);
  }

  Future changeTab({TabIndex index, reload: false}) async {
    debugPrint('diarybloc: changeTab');
    if(_user == null) {
      await _loadUser();
    }
    if(_user == null) {
      return;
    }
    if (reload) {
      index = _tabIndex;
    }
    if (index == _tabIndex && !reload) {
      return;
    }
    await getUserStat();
    switch(index) {
      case TabIndex.BROWSER_PAGE:
        await getDiaryBrowser();
        break;
      case TabIndex.DIARY_PAGE:
        await getDiaryView(_selectDate);
        break;
      case TabIndex.MINE_PAGE:
        break;
    }
    _tabIndex = index;
    _tabSubject.sink.add(index);
  }

  Future getDiaryBrowser() async {
    List<Diary> listDiary = await AppDb.instance().getDiaries(_user.id);
    List<dynamic> listData = List<dynamic>();
    DateTime dtNext;
    listDiary.forEach((Diary diary) {
      if(dtNext == null) {
        dtNext = DateTime(diary.createTime.year, diary.createTime.month, 1);
        listData.add(dtNext);
      }
      DateTime dtFix = DateTime(diary.createTime.year, diary.createTime.month, 1);
      if (dtNext != dtFix) {
        listData.add(dtNext);
        dtNext = dtFix;
      }
      listData.add(diary);
    });
    _diaryBrowserSubject.sink.add(listData);
  }

  Future getDiaryView(DateTime dt) async {
    List<Diary> listDiary = await AppDb.instance().getDiaries(_user.id,
        dateStart: dt, dateEnd: dt);
    debugPrint('diaries: $listDiary');
    _selectDate = dt;
    _diaryViewSubject.sink.add(listDiary);
  }

  Future getUserStat() async {
    if(_user == null) {
      return;
    }
    UserStat stat = await AppDb.instance().getUserStat(_user.id);
    _userStatSubject.sink.add(stat);

    List<Notice> notices = await AppDb.instance().getNotice(_user.id);
    _userNoticeSubject.sink.add(notices.length);

    List<Tuple2<Diary, String>> images = await AppDb.instance().getDiaryImages(_user.id);

    _diaryImageSubject.sink.add(images);
  }

  Future getDiary(int id) async {
    if(_user == null) {
      debugPrint('getDiary user == null');
      return;
    }
    Diary diary = await AppDb.instance().getDiary(id);
    _diarySubject.sink.add(diary);
  }
  Future saveDiary(Diary diary) async {
    if(_user == null) {
      debugPrint('saveDiary user == null');
      return;
    }
    if(diary.createTime == null) {
      diary.createTime = DateTime.now();
    }
    diary.updateTime = DateTime.now();
    if (diary.id == null || diary.id == -1) {
      diary.userId = _user.id;
      var id = await AppDb.instance().insertDiary(diary);
      diary.id = id;
      debugPrint('save insert: diary.id = ${diary.id}');
    } else {
      await AppDb.instance().updateDiary(diary);
      debugPrint('save update: diary.id = ${diary.id}');
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _tabSubject.close();
    _userSubject.close();
    _userStatSubject.close();
    _userNoticeSubject.close();
    _diaryImageSubject.close();
    _settingSubject.close();
    _diaryDateSubject.close();
    _diaryViewSubject.close();
    _diarySubject.close();
    _diaryBrowserSubject.close();
    _userLoadSubject.close();
    debugPrint('close channel');
  }
}