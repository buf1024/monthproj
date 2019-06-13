import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hellodiary/pages/home_page.dart';
import 'package:hellodiary/utils/share_pref.dart';
import 'package:hellodiary/utils/consts.dart';
import 'package:http/http.dart' as http;
import 'package:hellodiary/utils/vo.dart';
import 'package:hellodiary/bloc/index.dart';

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

    bool showGuide = SharePref.instance().getBool(Consts.SP_SHOW_GUIDE);
    if (!showGuide) {
      setState(() {
        _splashStep = _SplashStep.ShowGuide;
      });
    }
    _initGuides();
    _initAd();
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
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) {
          return HomePage();
        }));
  }

  void _startTimer() {
    _timer = Timer.periodic(
        Duration(milliseconds: Duration.millisecondsPerSecond), (Timer timer) {
      setState(() {
        _timerTick = timer.tick;
      });
      if (timer.tick > _advertisement.displayTime) {
        _timer.cancel();
        _timer = null;

        _goHome();
      }
    });
  }

  void _initAd() {
    Future<http.Response> resp = http.get(Consts.REMOTE_CONFIG_URL);
    resp.then((http.Response r) {
      var map = json.decode(r.body) as Map<String, dynamic>;
      Version version = Version.fromMap(map["version"]);
      Advertisement advertisement = Advertisement.fromMap(map["ad"]);

      DiaryBloc bloc = BlocProvider.of(context);
      bloc.version = version;
      bloc.advertisement = advertisement;

      setState(() {
        _splashStep = _SplashStep.ShowAD;
        _advertisement = advertisement;

        _startTimer();
      });
    }).catchError((e) {
      debugPrint('_initAd catchError: $e');
      _goHome();
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
                  onTap: () {
                    _goHome();
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                        left: 18.0, right: 18.0, top: 12.0, bottom: 12.0),
                    decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    child: Text(
                      '立即体验',
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
    );
  }

  Widget _buildAd() {
    if (_advertisement == null) {
      return _buildSplash();
    }
    return Stack(
      children: <Widget>[
        InkWell(
          onTap: () {
            debugPrint('ad press');
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
                imageUrl:
                    'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1558007762621&di=2026f937c50755b77ef7c938bda5596d&imgtype=0&src=http%3A%2F%2Fpic2.52pk.com%2Ffiles%2Fallimg%2F090626%2F1553504U2-2.jpg'),
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
                padding: EdgeInsets.all(3),
                child: Text(
                  '${_advertisement.displayTime - _timerTick}秒跳过',
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
