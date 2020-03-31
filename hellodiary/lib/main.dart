import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:hellodiary/generated/i18n.dart';
import 'package:hellodiary/bloc/index.dart';
import 'package:hellodiary/pages/splash_page.dart';
import 'package:hellodiary/db/model.dart';
import 'package:hellodiary/utils/colors.dart';
import 'package:hellodiary/utils/share_pref.dart';
import 'package:hellodiary/utils/consts.dart';

void main() {
  runApp(
      BlocProvider(
        bloc: DiaryBloc(),
        child: MyApp(),
      )
  );

  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  }
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  @override
  State createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  Color _theme = Colors.blue;
  Color _themeAccent = Colors.blueAccent;
  Locale _locale;

  Locale _deviceLocale;

  void switchLocale() {
    debugPrint('switchLocale');
    Map map = SharePref.instance().getJson(Consts.SP_LOCALE);
    setState(() {
      if (map == null) {
        _locale = null;
      } else {
        debugPrint('switchLocale: $map');
        var lang = map[Consts.SP_LOCALE_LANGUAGE];
        var country = map[Consts.SP_LOCALE_COUNTRY];
        debugPrint('$lang}_${country}');
        if(lang.isEmpty || country.isEmpty) {
          _locale = null;
          if (_deviceLocale != null) {
            Intl.defaultLocale = '${_deviceLocale.languageCode}_${_deviceLocale.countryCode}';
          }
        } else {
          _locale = Locale(lang, country);
          Intl.defaultLocale = '${lang}_$country';
        }
        var str = DateFormat(DateFormat.WEEKDAY).format(DateTime.now());
        debugPrint('$str');
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    switchLocale();

    DiaryBloc diaryBloc = BlocProvider.of(context);
    diaryBloc.settingStream.listen((Setting setting) {
      if(themeColor.containsKey(setting.theme) &&
          themeColor[setting.theme] != _theme
      ) {
        setState(() {
          _theme = themeColor[setting.theme];
          _themeAccent = themeAccentColor[setting.theme];
        });
      }
      switchLocale();
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    DiaryBloc diaryBloc = BlocProvider.of(context);
    diaryBloc.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData.light().copyWith(
            primaryColor: _theme,
            accentColor: _themeAccent,
            primaryColorLight: _theme,
            indicatorColor: Colors.white,
          ),
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          localeResolutionCallback: (Locale locale, Iterable<Locale> supported) {
            final Locale languageLocale = new Locale(locale.languageCode, "");
            if (supported.contains(locale)) {
              _deviceLocale = locale;
              Intl.defaultLocale = '${_deviceLocale.languageCode}_${_deviceLocale.countryCode}';
              return locale;
            } else if (supported.contains(languageLocale)) {
              return languageLocale;
            } else {
              return const Locale('en', '');
            }
          },
//          S.delegate.resolution(
//            fallback: const Locale('en', '')
//          ),
          locale: _locale,
//          home: HomePage(),
          home: SplashPage(),
        );
  }
}
