import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class AppDb {
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
    String path = join(documentsDirectory.path, "fav.db");

    _database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          db.transaction((Transaction txn) {
            txn.execute('''
              create table fav(
                id integer primary key autoincrement,
                update_time integer,
                news_time integer,
                news_id varchar(64),
                news_type integer,
                news varchar(10240)
              );
            ''');
          });
          didInit = true;
        }, onUpgrade: (Database db, int oldVersion, int newVersion) async {});
  }

  Future<List<Map<String, dynamic>>> getFav() async {
    Database database = await _getDB();
    var result = await database.rawQuery('''
      select id, update_time, news_time, news_type, news_id, news from fav order by news_time desc;
    ''');
    return result;
  }

  Future<bool> isExists(String newsId) async {
    Database database = await _getDB();
    var result = await database.rawQuery('''
      select count(id) as count from fav where news_id = '$newsId';
    ''');
    var count = result[0]['count'];
    return count > 0;
  }

  Future delFav(int id) async {
    Database database = await _getDB();
    await database.transaction((Transaction txn) async {
      await txn.rawDelete('''
        delete from fav where id = $id;
      ''');
    });
  }



  Future insertFav(int newsTime, int type, String newsId, String news) async {
    Database database = await _getDB();
    var exists = await isExists(newsId);
    if(exists) return;
    await database.transaction((Transaction txn) async {
      var now = (DateTime
          .now()
          .millisecondsSinceEpoch / 1000).truncate();
      await
      txn.rawInsert('''
        insert into fav(update_time, news_time, news_type, news_id, news) 
        values($now, $newsTime, $type, '$newsId', '$news');
      ''');
    });
  }
}
