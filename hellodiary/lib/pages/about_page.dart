import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:hellodiary/generated/i18n.dart';
import 'package:intl/intl.dart';

class AboutPage extends StatelessWidget {
  final String kBlog = 'https://luoguochun.cn';
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text(S.of(context).about),
        elevation: 0,
      ),
      body: Column(children: <Widget>[
        Container(
            height: 200.0,
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                    onTap: () async {
                      if(await canLaunch(kBlog)) {
                        await launch(kBlog, forceSafariVC: false, forceWebView: false);
                      } else {
                        debugPrint('can not lauch url: $kBlog');
                      }
                    },
                    child: Stack(
                      children: <Widget>[
                        Container(
                          height: 100.0,
                          width: 100.0,
                          child: CircleAvatar(
                            backgroundColor: Colors.grey,
                            backgroundImage: AssetImage('assets/images/avatar.png'),
                          ),
                        ),
                        Container(
                          height: 100.0,
                          width: 100.0,
                          decoration: BoxDecoration(
                              border: Border.all(width: 2.0, color: Colors.white),
                              borderRadius: BorderRadius.all(Radius.circular(50.0))
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15.0),
                    child: Column(
                      children: <Widget>[
                        Text('BUF1024!', style: TextStyle(
                            fontSize: 25.0,
                            color: Colors.white
                        ),),
                        Text('the lost c/c++ develper', style: TextStyle(
                            color: Colors.white
                        ),)
                      ],
                    ),
                  )
                ],
              ),
            )),
        Expanded(
          child: Markdown(
            data: _getNotes(),
            styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
              p: TextStyle(
                color: Colors.black87,
                fontSize: 19.0
              )
            ),
            onTapLink: (String href) async {
              if(await canLaunch(href)) {
                await launch(href, forceSafariVC: false, forceWebView: false);
              } else {
                debugPrint('can not lauch url: $href');
              }
            },
          ),
        )
      ]),
    );
  }
  String _getNotes() {
    String locale = Intl.defaultLocale;
    if (locale == "zh_TW") {
      return _getNotes_zh_TW();
    }
    if (locale == "zh_CN") {
      return _getNotes_zh_CN();
    }
    if (locale == "en_US") {
      return _getNotes_en_US();
    }
    if (locale == null) {
      locale = '';
    }
    debugPrint('locale: $locale');
    var lang = locale.split("_");
    if(lang.length > 0) {
      var l = lang[0];
      if (l == 'zh') {
        return _getNotes_zh_CN();
      }
      if (l == 'en') {
        return _getNotes_en_US();
      }
    }
    return _getNotes_en_US();
  }
  String _getNotes_zh_TW() {
    return '''
# [hellodiary](https://github.com/buf1024/monthproj/tree/master/hellodiary)
這是模仿電影《你的名字。》(君の名は。)裡面的日記應用，react-native編寫過相同的應用（不完整）[thediary](https://github.com/buf1024/monthproj/tree/master/thediary)，而這裡是flutter實現。為什麼寫兩個一樣的東西？為了可比性，畢竟react native的坑太多。

當然，flutter在學習中，而且用的是很零星的時間，很多東西都不熟悉，使用也不規範，所以錯誤也難免。

主要技術點，使用的flutter中的bloc設計模式，不過在還沒全面了解bloc最佳實踐之前，就進行了編碼，使用的姿態也可能是錯的。

按照大神的說法，比如每個頁面都有其自己的bloc，這裡為了簡單，只使用一個bloc，所有的頁面共享這個bloc，而且這個bloc又自帶狀態管理，沒有使用相應的工具對狀態獨立出來管理，顯得稍微混亂。等等其他。

不過，雖然dart使用起來開始不太適應，不過看舊了，也慢慢接受，上手還算簡單。
    ''';
  }
  String _getNotes_en_US() {
    return '''
# [hellodiary](https://github.com/buf1024/monthproj/tree/master/hellodiary)
This is the copy of Diary app in "Your Name."(君の名は。)，I used react-native implement the same funciton（incomplete version）[thediary](https://github.com/buf1024/monthproj/tree/master/thediary)，but here, use flutter. Why implement the same thing in different technology stack? for comparable，after all react native has so much potention bug。

Of course，flutter is studying，and use litte spare time，lots of things is unfamilar，and misuse，so there is no guarantee the practice here is correct.

Main technology，flutter bloc pattern，but before fully understand bloc，I start to code, so the way to use bloc maybe wrong.

Accordding to flutter guru，for example, every page should have its owe bloc，but here, for simplicity，I use ony one bloc，every page share this bloc，and also this bloc have state，use no state management tool the deal with state，seems choas, and so thoers。

Maybe the first time use dart feel uncomfortable，but after a while, it is acceptable, and dart is very simple.
    
        ''';
  }
  String _getNotes_zh_CN() {
    return '''
# [hellodiary](https://github.com/buf1024/monthproj/tree/master/hellodiary)
这是模仿电影《你的名字。》(君の名は。)里面的日记应用，react-native编写过相同的应用（不完整）[thediary](https://github.com/buf1024/monthproj/tree/master/thediary)，而这里是flutter实现。为什么写两个一样的东西？为了可对比性，毕竟react native的坑太多。

当然，flutter在学习中，而且用的是很零星的时间，很多东西都不熟悉，使用也不规范，所以错误也难免。

主要技术点，使用的flutter中的bloc设计模式，不过在没全面了解bloc最佳实践之前，就进行了编码，使用的姿态也可能是错的。

按照大神的说法，比如每一个页面都有其自己的bloc，这里为了简单，只使用了一个bloc，所以的页面都共享这个bloc，而且这个bloc又自带了状态管理，没有使用相应的工具对状态独立出来管理，显得稍微混乱。等等其他。

不过，虽然dart使用起来开始不太适应，不过看久，也慢慢接受，上手还算简单。
    ''';
  }
}
