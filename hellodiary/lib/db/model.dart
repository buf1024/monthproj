import 'package:meta/meta.dart';

class User {
  String id;
  String name;
  String motto;
  String image;
  bool isLogin;
  String token;
  DateTime createTime;
  DateTime updateTime;

  Setting setting;

  User(
      {@required this.id,
      this.name,
      this.motto,
      this.image,
      this.isLogin,
      this.token,
      this.createTime,
      this.updateTime});

  User.fromMap(Map<String, dynamic> map)
      : this(
            id: map['id'],
            name: map['name'],
            motto: map['motto'],
            image: map['image'],
            isLogin: map['is_login'] == 0 ? false : true,
            token: map['token'],
            createTime: DateTime.fromMillisecondsSinceEpoch(map['create_time']),
            updateTime: DateTime.fromMillisecondsSinceEpoch(map['update_time']));

  @override
  String toString() {
    return 'User{id: $id, name: $name, motto: $motto, image: $image, isLogin: $isLogin, token: $token, createTime: $createTime, updateTime: $updateTime, setting: $setting}';
  }


}

class Setting {
  int id;
  String userId;
  String theme;
  String background;
  String protect;
  bool isAutoSync;

  Setting(
      {this.id,
      @required this.userId,
      this.theme,
      this.background,
      this.protect,
      this.isAutoSync});

  Setting.fromMap(Map<String, dynamic> map)
      : this(
            id: map['id'],
            userId: map['user_id'],
            theme: map['theme'],
            background: map['background'],
            protect: map['protect'],
            isAutoSync: map['is_auto_sync'] == 0 ? false : true);

  @override
  String toString() {
    return 'Setting{id: $id, userId: $userId, theme: $theme, background: $background, protect: $protect, isAutoSync: $isAutoSync}';
  }


}

class Notice {
  int id;
  String userId;
  String type;
  String content;
  DateTime receiveTime;
  bool isRead;
  bool isTrash;

  Notice(
      {this.id,
      @required this.userId,
      @required this.type,
      @required this.content,
      this.receiveTime,
      this.isRead,
      this.isTrash});

  Notice.fromMap(Map<String, dynamic> map)
      : this(
            id: map['id'],
            userId: map['user_id'],
            type: map['type'],
            content: map['content'],
            receiveTime: DateTime.fromMillisecondsSinceEpoch(map['receive_time']),
            isRead: map['is_read'] == 0 ? false : true,
            isTrash: map['is_trash'] == 0 ? false : true);

  @override
  String toString() {
    return 'Notice{id: $id, userId: $userId, type: $type, content: $content, receiveTime: $receiveTime, isRead: $isRead, isTrash: $isTrash}';
  }

}

class Diary {
  int id;
  String userId;
  String title;
  DateTime createTime;
  DateTime updateTime;
  String location;
  String mood;
  String weather;
  int wordCount;
  int imageCount;
  String content;
  bool isSync;
  bool isFlag;
  bool isTrash;
  bool isPublic;

  Diary(
      {this.id,
      this.userId,
      this.title,
      this.createTime,
      this.updateTime,
      this.location = '',
      this.mood,
      this.weather,
      this.wordCount,
      this.imageCount,
      this.content,
      this.isSync = false,
      this.isFlag = false,
      this.isTrash = false,
      this.isPublic = false});

  Diary.fromMap(Map<String, dynamic> map)
      : this(
          id: map['id'],
          userId: map['user_id'],
          title: map['title'],
          createTime: DateTime.fromMillisecondsSinceEpoch(map['create_time']),
          updateTime: DateTime.fromMillisecondsSinceEpoch(map['update_time']),
          location: map['location'],
          mood: map['mood'],
          weather: map['weather'],
          wordCount: map['word_count'],
          imageCount: map['image_count'],
          content: map['content'],
          isSync: map['is_sync'] == 0 ? false : true,
          isFlag: map['is_flag'] == 0 ? false : true,
          isTrash: map['is_trash'] == 0 ? false : true,
          isPublic: map['is_public'] == 0 ? false : true,
        );

  @override
  String toString() {
    return 'Diary{id: $id, userId: $userId, title: $title, createTime: $createTime, updateTime: $updateTime, location: $location, mood: $mood, weather: $weather, wordCount: $wordCount, imageCount: $imageCount, content: $content, isSync: $isSync, isFlag: $isFlag, isTrash: $isTrash, isPublic: $isPublic}';
  }
}

//---------
class UserStat {
  int diaryCount;
  int wordCount;
  int imageCount;

  UserStat({this.diaryCount, this.wordCount, this.imageCount});

  UserStat.fromMap(Map<String, dynamic> map)
      : this(
      diaryCount: map['diary_count'],
      wordCount: map['word_count'],
      imageCount: map['image_count']
  );

  @override
  String toString() {
    return 'UserStat{diaryCount: $diaryCount, wordCount: $wordCount, imageCount: $imageCount}';
  }
}

