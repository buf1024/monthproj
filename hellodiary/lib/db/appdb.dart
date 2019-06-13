import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:tuple/tuple.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hellodiary/db/model.dart';

class AppDb {
  static const DEF_USER = '___the_diary_default_user_fake___';

  static AppDb _instance;
  Database _database;
  var didInit = false;

  static AppDb instance() {
    if (_instance == null) {
      _instance = AppDb._internal();
    }
    return _instance;
  }
  AppDb._internal();

  Future<Database> _getDB() async {
    if (!didInit) {
      await _init();
    }
    return _database;
  }

  Future<Null> _init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "diary.db");

    _database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await _createTable(db);
          didInit = true;
        }, onUpgrade: (Database db, int oldVersion, int newVersion) async {
          await _dropTable(db);
          await _createTable(db);
          didInit = true;
        });
  }

  Future _createTable(Database db) async {
    db.transaction((Transaction txn) {
      txn.execute('''
              create table user(
                id varchar(64) primary key,
                name varchar(64) not null,
                motto varchar(64),
                image varchar(256),
                is_login integer not null,
                token varchar(64),
                create_time integer,
                update_time integer
              );
            ''');

      txn.execute('''
              create table setting(
                id integer primary key autoincrement,
                user_id varchar(64) not null,
                theme varchar(32) not null,
                background varchar(32) not null,
                protect varchar(32),
                is_auto_sync inteter not null,
                foreign key (user_id) references user(id)
              );
            ''');
      txn.execute('''
              create table notification(
                id integer primary key autoincrement,
                user_id varchar(64) not null,
                type varchar(32) not null,
                content text not null,
                receive_time integer not null,
                is_read integer not null,
                is_trash integer not null,
                foreign key (user_id) references user(id)
              );
            ''');
      txn.execute('''
              create table diary(
                id integer primary key autoincrement,
                user_id varchar(64) not null,
                title varchar(64) not null,
                create_time integer not null,
                update_time integer not null,
                location varchar(64),
                mood varchar(32),
                weather varchar(32),
                word_count integer,
                image_count integer,
                content text,
                is_sync integer,
                is_flag integer,
                is_trash integer,
                is_public integer,
                foreign key (user_id) references user(id)
              );
            ''');
      txn.rawInsert('''
              insert into user(
                id, name, motto, image, 
                is_login, token, 
                create_time, 
                update_time) 
              values(
                '$DEF_USER', '你的名字', '记录记忆那无法的忘却!', '', 
                0, '', 
                ${DateTime.now().millisecondsSinceEpoch}, 
                ${DateTime.now().millisecondsSinceEpoch}
              )
      ''');
      txn.rawInsert('''
              insert into setting(
                user_id, theme, background, protect, is_auto_sync
              ) values (
                '$DEF_USER', 'blue', '', '', 0
              )
      ''');
      txn.rawInsert('''
              insert into diary(
                user_id, title,
                create_time, update_time,
                location, mood, weather, word_count, image_count,
                content,
                is_sync, is_flag, is_trash, is_public
              ) values (
                '$DEF_USER', '欢迎光临',
                ${DateTime.now().millisecondsSinceEpoch}, ${DateTime.now().millisecondsSinceEpoch}, 
                '', 'sentiment_very_satisfied', 'wb_sunny', 16, 0,
                '[{"insert":"欢迎光临！","attributes":{"b":true}},{"insert":"\\n"},{"insert":"欢迎光临！\\n","attributes":{"b":true}},{"insert":"欢迎光临！\\n","attributes":{"b":true,"i":true}},{"insert":"\\n"}]',
                0, 0, 0, 0
              )
      ''');
    });
  }
  Future _dropTable(Database db) async {
    db.transaction((Transaction txn) {
      txn.execute('drop table user');
      txn.execute('drop table setting');
      txn.execute('drop table notification');
      txn.execute('drop table diary');
    });
  }

  Future<Diary> getDiary(int diaryId) async {
    Database database = await _getDB();

    var result = await database.rawQuery('''
      select id, user_id, title,
        create_time, update_time,
        location, mood, weather, word_count, image_count,
        content,
        is_sync, is_flag, is_trash, is_public 
      from diary
      where id = ?
    ''', [diaryId]);
    if(result != null && result.length > 0) {
      return Diary.fromMap(result[0]);
    }
    return null;
  }
  Future<List<Diary>> getDiaries(String userId, {
    DateTime dateStart, DateTime dateEnd,
    int limit = -1, int offset = -1, bool trash = false
  }) async {
    Database database = await _getDB();
    StringBuffer sb = StringBuffer();

    sb.write('''
      select id, user_id, title,
        create_time, update_time,
        location, mood, weather, word_count, image_count,
        content,
        is_sync, is_flag, is_trash, is_public 
      from diary
      where user_id = '$userId' 
    ''');

    if (dateStart != null) {
      var dateTime = DateTime(
          dateStart.year, dateStart.month, dateStart.day
      ).millisecondsSinceEpoch;
      sb.write(' and create_time >= $dateTime');
    }
    if (dateEnd != null) {
      var dateTime = DateTime(
          dateEnd.year, dateEnd.month, dateEnd.day
      ).add(Duration(days: 1)).millisecondsSinceEpoch;
      sb.write(' and create_time < $dateTime');
    }
    sb.write(' and is_trash = ${trash ? 1 : 0}');
    if (limit != -1) {
      sb.write(' limit = $limit');
    }
    if (offset != -1) {
      sb.write(' offset = $offset');
    }
    sb.write(' order by create_time desc');
    List<Diary> diaries = List<Diary>();
    var resultDiaries = await database.rawQuery(sb.toString());
    for(Map<String, dynamic> mapDiary in resultDiaries) {
      var diary = Diary.fromMap(mapDiary);
      diaries.add(diary);
    }
    return diaries;
  }

  Future<User> getUser() async {
    Database database = await _getDB();
    var result = await database.rawQuery('''
      select id, name, motto, image, is_login, token, create_time, update_time
      from user where is_login = 1
    ''');
    User user;
    if(result != null && result.length > 0) {
      user = User.fromMap(result[0]);
    } else {
      result = await database.rawQuery('''
        select id, name, motto, image, is_login, token, create_time, update_time
        from user where id = '$DEF_USER'
      ''');
      if (result == null || result.length == 0) {
        return null;
      }
      user = User.fromMap(result[0]);
    }
    result = await database.rawQuery('''
      select id, user_id, theme, background, protect, is_auto_sync
      from setting where user_id = '${user.id}'
    ''');
    user.setting = Setting.fromMap(result[0]);

    return user;
  }

  Future<int> updateUser(String userId, {
    String name,
    String motto,
    String image,
    bool isLogin,
    String token,
  }) async {
    Database database = await _getDB();
    return database.transaction((Transaction txn) async {
      StringBuffer sb = StringBuffer();
      if(name != null) {
        sb.write(''' name = '$name' ''');
      }
      if(motto != null) {
        if(sb.isNotEmpty) {
          sb.write(',');
        }
        sb.write(''' motto = '$motto' ''');
      }
      if(image != null) {
        if(sb.isNotEmpty) {
          sb.write(',');
        }
        sb.write(''' image = '$image' ''');
      }
      if(isLogin != null) {
        if(sb.isNotEmpty) {
          sb.write(',');
        }
        sb.write(''' is_login = ${isLogin ? 1 : 0} ''');
      }
      if(token != null) {
        if(sb.isNotEmpty) {
          sb.write(',');
        }
        sb.write(''' token = '$token' ''');
      }
      if(sb.isNotEmpty) {
        sb.write('''
          , update_time = ${DateTime.now().millisecondsSinceEpoch} 
          where id = '$userId'
        ''');
      } else {
        return 0;
      }

      return txn.rawUpdate('update user set ' + sb.toString());
    });
  }

  Future<int> updateSetting(String userId, {
    String theme,
    String background,
    String protect,
    bool isAutoSync,
  }) async {
    Database database = await _getDB();
    return database.transaction((Transaction txn) async {
      StringBuffer sb = StringBuffer();
      if(theme != null) {
        sb.write(''' theme = '$theme' ''');
      }
      if(background != null) {
        if(sb.isNotEmpty) {
          sb.write(',');
        }
        sb.write(''' background = '$background' ''');
      }
      if(protect != null) {
        if(sb.isNotEmpty) {
          sb.write(',');
        }
        sb.write(''' protect = '$protect' ''');
      }
      if(isAutoSync != null) {
        if(sb.isNotEmpty) {
          sb.write(',');
        }
        sb.write(''' is_auto_sync = ${isAutoSync ? 1 : 0} ''');
      }
      if(sb.isEmpty) {
        return 0;
      }

      return txn.rawUpdate('update setting set ' + sb.toString());
    });
  }

  Future<List<Notice>> getNotice(String userId, {
    isRead = false
  }) async {
    Database database = await _getDB();
    String sql = '''
      select id, user_id, type, content, receive_time, is_read, is_trash
      from notification where user_id = '$userId'
    ''' + (isRead ? ' and is_read = 1' : ' and is_read = 0');
    var result = await database.rawQuery(sql);
    List<Notice> notices = List<Notice>();
    for(Map<String, dynamic> map in result) {
      var notice = Notice.fromMap(map);
      notices.add(notice);
    }
    return notices;
  }
  Future<UserStat> getUserStat(String userId) async {
    Database database = await _getDB();
    var result = await database.rawQuery('''
      select count(1) as diary_count, sum(word_count) as word_count, sum(image_count) as image_count
      from diary where user_id = ? and is_trash = 0
      ''', [userId]);


    if(result == null || result.length == 0) {
      return null;
    }
    return UserStat.fromMap(result[0]);
  }
  Future<List<Tuple2<Diary, String>>> getDiaryImages(String userId) async {
    List<Tuple2<Diary, String>> images = List<Tuple2<Diary, String>>();
    List<Diary> diaries = await getDiaries(userId);
    for(Diary diary in diaries) {
      var content = diary.content;
      if(content.isEmpty) {
        continue;
      }
      List jsList = jsonDecode(content);

      for(Map js in jsList) {
        Map attr = js['attributes'];
        if (attr == null) {
          continue;
        }
        Map embed = attr['embed'];
        if (embed == null) {
          continue;
        }
        String type = embed['type'];
        if (type == null && type != 'image') {
          continue;
        }
        String source = embed['source'];
        if (source == null) {
          continue;
        }
        images.add(Tuple2(diary, source));
      }
    }
    return images;
  }
  Future updateDiary(Diary diary) async {
    Database database = await _getDB();
    await database.transaction((Transaction txn) async {
      await txn.rawUpdate('''
        update diary 
        set title = ?, update_time = ?, location = ?,
          mood = ?, weather = ?, word_count = ?, image_count = ?, 
          content = ?,
          is_sync = ?, is_flag = ?, is_trash = ?, is_public = ?
          where id = ?;
      ''', [
        diary.title, diary.updateTime.millisecondsSinceEpoch, diary.location,
        diary.mood, diary.weather, diary.wordCount, diary.imageCount,
        diary.content,
        diary.isSync ? 1 : 0, diary.isFlag ? 1 : 0, diary.isTrash ? 1 : 0, diary.isPublic ? 1 : 0,
        diary.id]);
    });
  }
  Future<int> insertDiary(Diary diary) async {
    Database database = await _getDB();
    int id = -1;
    await database.transaction((Transaction txn) async {
      id = await txn.rawInsert('''
          insert into diary(
            user_id, title, 
            create_time, update_time, 
            location, mood, weather, word_count, image_count, 
            content,
            is_sync, is_flag, is_trash, is_public)
          values(
            ?, ?, ?, ?, ?, ?, ?,
            ?, ?, ?, ?, ?, ?, ?
           );
        ''', [
          diary.userId, diary.title,
          diary.createTime.millisecondsSinceEpoch, diary.updateTime.millisecondsSinceEpoch,
          diary.location, diary.mood, diary.weather, diary.wordCount, diary.imageCount,
          diary.content,
          diary.isSync ? 1 : 0, diary.isFlag ? 1 : 0, diary.isTrash ? 1 : 0, diary.isPublic ? 1 : 0
      ]);
    });
    return id;
  }
}
