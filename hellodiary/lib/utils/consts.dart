import 'package:flutter/material.dart';

enum TabIndex {
  BROWSER_PAGE,
  DIARY_PAGE,
  MINE_PAGE
}

class Consts {
  static const String SP_LOCALE = 'SP_LOCALE';
  static const String SP_LOCALE_LANGUAGE = 'LANGUAGE';
  static const String SP_LOCALE_COUNTRY = 'COUNTRY';

  static const String SP_SHOW_GUIDE = 'SP_SHOW_GUIDE';
  static const String SP_REMOTE_CONFIG = 'SP_REMOTE_CONFIG';

  static const String REMOTE_CONFIG_URL = 'https://raw.githubusercontent.com/buf1024/monthproj/master/hellodiary/release/config.json';
}

Map<String, IconData> iconMap = {
  'sentiment_very_satisfied': Icons.sentiment_very_satisfied,
  'sentiment_satisfied': Icons.sentiment_satisfied,
  'sentiment_neutral': Icons.sentiment_neutral,
  'sentiment_dissatisfied': Icons.sentiment_dissatisfied,
  'sentiment_very_dissatisfied': Icons.sentiment_very_dissatisfied,
  'wb_sunny': Icons.wb_sunny,
  'wb_cloudy': Icons.wb_cloudy,
  'ac_unit': Icons.ac_unit,
  'flash_on': Icons.flash_on,
  'blur_on': Icons.blur_on,
};

String versionNumber = "0.0.1";