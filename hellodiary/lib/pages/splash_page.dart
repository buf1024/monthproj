import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:rxdart/rxdart.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hellodiary/pages/home_page.dart';
import 'package:hellodiary/utils/share_pref.dart';
import 'package:hellodiary/utils/consts.dart';
import 'package:http/http.dart' as http;
import 'package:hellodiary/utils/vo.dart';
import 'package:hellodiary/bloc/index.dart';
import 'package:hellodiary/generated/i18n.dart';
import 'package:url_launcher/url_launcher.dart';

class SplashPage extends StatefulWidget {
  @override
  State createState() => _SplashPageState();
}

enum _SplashStep { ShowSplash, ShowGuide, ShowAD }

class _SplashPageState extends State<SplashPage> {
  List<String> _guideImages = [
    'assets/images/1.png',
    'assets/images/2.png',
    'assets/images/3.png',
    'assets/images/4.png',
  ];
  List<Widget> _guideWidgets = List<Widget>();
  _SplashStep _splashStep = _SplashStep.ShowSplash;
  Timer _timer;

  int _timerTick = 0;
  Advertisement _advertisement;

//  int _skipAdTime = 0;
//  int _showAdTime = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // 需要延长才能获取到值，不解
    Stream.value(1).delay(new Duration(milliseconds: 500)).listen((_) {
      bool showGuide = SharePref.instance().getBool(Consts.SP_SHOW_GUIDE);
      debugPrint('showGuide: $showGuide');
      if (!showGuide) {
        setState(() {
          _splashStep = _SplashStep.ShowGuide;
        });
      }
      Map map = SharePref.instance().getJson(Consts.SP_SHOW_AD);
      if (map != null) {
        DiaryBloc bloc = BlocProvider.of(context);

        Version version = Version.fromMap(map["version"]);
        Advertisement advertisement = Advertisement.fromMap(map["ad"]);

        bloc.version = version;
        bloc.advertisement = advertisement;

        _advertisement = advertisement;
      }
      _initAd(showGuide);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
  }

  void _goHome() {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
      return HomePage();
    }));
  }

  void _startTimer() {
    _timer = Timer.periodic(
        Duration(milliseconds: Duration.millisecondsPerSecond), (Timer timer) {
      setState(() {
        _timerTick = timer.tick;
      });
      if (timer.tick >= _advertisement.displayTime) {
        _timer.cancel();
        _timer = null;

        _goHome();
      }
    });
  }

  void _initAd(bool showGuide) {
    Future<http.Response> resp = http.get(Consts.REMOTE_CONFIG_URL);
    resp.then((http.Response r) {
      var map = json.decode(r.body) as Map<String, dynamic>;
      Version version = Version.fromMap(map["version"]);
      Advertisement advertisement = Advertisement.fromMap(map["ad"]);

      debugPrint('remote: $map, version: $version');
      DiaryBloc bloc = BlocProvider.of(context);
      bloc.version = version;
      bloc.advertisement = advertisement;
      _advertisement = advertisement;
      if (showGuide) {
        setState(() {
          _splashStep = _SplashStep.ShowAD;
          _startTimer();
        });
      }
      SharePref.instance().putJson(Consts.SP_SHOW_AD, map);
    }).catchError((e) {
      debugPrint('_initAd catchError: $e');
      if (_advertisement != null) {
        setState(() {
          _splashStep = _SplashStep.ShowAD;
          _startTimer();
        });
      } else {
        _goHome();
      }
    });
  }

  void _initGuides() {
    for (int i = 0; i < _guideImages.length; i++) {
      if (i == _guideImages.length - 1) {
        _guideWidgets.add(Stack(
          children: <Widget>[
            Image.asset(
              _guideImages[i],
              fit: BoxFit.fill,
              width: double.infinity,
              height: double.infinity,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.only(bottom: 50.0),
                child: InkWell(
                  onTap: () async {
                    await SharePref.instance()
                        .putBool(Consts.SP_SHOW_GUIDE, true);
                    _goHome();
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                        left: 18.0, right: 18.0, top: 12.0, bottom: 12.0),
                    decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    child: Text(
                      S.of(context).useIt,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
      } else {
        _guideWidgets.add(Image.asset(
          _guideImages[i],
          fit: BoxFit.fill,
          width: double.infinity,
          height: double.infinity,
        ));
      }
    }
  }

  Widget _buildSplash() {
    return Image.asset(
      'assets/images/splash.png',
      fit: BoxFit.fill,
      width: double.infinity,
      height: double.infinity,
    );
  }

  Widget _buildGuide() {
    if (_guideWidgets == null || _guideWidgets.length == 0) {
      _initGuides();
    }
    return Swiper(
      itemBuilder: (BuildContext context, int index) {
        return _guideWidgets[index];
      },
      itemCount: _guideWidgets.length,
      pagination: SwiperPagination(),
      onIndexChanged: (int index) {
        debugPrint('onIndexChanged');
      },
      onTap: (int index) {
        debugPrint('onTap');
      },
      loop: false,
    );
  }

  Widget _buildAd() {
    if (_advertisement == null) {
      return _buildSplash();
    }
    return Stack(
      children: <Widget>[
        InkWell(
          onTap: () async {
            debugPrint('ad press');
            if (await canLaunch(_advertisement.tapUrl)) {
              await launch(_advertisement.tapUrl);
            }
          },
          child: Container(
            alignment: Alignment.center,
            child: CachedNetworkImage(
                fit: BoxFit.fill,
                placeholder: (BuildContext context, String url) {
                  return Image.asset(
                    'assets/images/splash.png',
                    fit: BoxFit.fill,
                    width: double.infinity,
                    height: double.infinity,
                  );
                },
                errorWidget: (BuildContext context, String url, Object error) {
                  return Image.asset(
                    'assets/images/splash.png',
                    fit: BoxFit.fill,
                    width: double.infinity,
                    height: double.infinity,
                  );
                },
                imageUrl: _advertisement.mediaUrl),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: InkWell(
              onTap: () {
                debugPrint('skip ontap');
              },
              child: Container(
                margin: EdgeInsets.only(top: 20.0),
                padding: EdgeInsets.only(top: 3, bottom: 3, left: 8, right: 8),
                child: Text(
                  S.of(context).skipTime('${_advertisement.displayTime - _timerTick}'),
                  textAlign: TextAlign.center,
                ),
                decoration: BoxDecoration(
                    color: Colors.grey[500],
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    border: Border.all()),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Material(
      child: Stack(
        children: <Widget>[
          Offstage(
            offstage: !(_splashStep == _SplashStep.ShowSplash),
            child: _buildSplash(),
          ),
          Offstage(
            offstage: !(_splashStep == _SplashStep.ShowGuide),
            child: _buildGuide(),
          ),
          Offstage(
            offstage: !(_splashStep == _SplashStep.ShowAD),
            child: _buildAd(),
          ),
        ],
      ),
    );
  }
}
