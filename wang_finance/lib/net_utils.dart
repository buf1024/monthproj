import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart' show md5;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class NetUtils {
  static Future<String> get(String url, {Map<String, dynamic> params}) async {
    params = sign(params: params);
    if (params != null && params.isNotEmpty) {
      StringBuffer sb = new StringBuffer("?");
      params.forEach((key, value) {
        sb.write("$key" + "=" + "$value" + "&");
      });
      String paramStr = sb.toString();
      paramStr = paramStr.substring(0, paramStr.length - 1);
      url += paramStr;
    }

    debugPrint('url: $url');
    http.Response res = await http.get(url, headers: getCommonHeader());
    return res.body;
  }

  // post请求
  static Future<String> post(String url, {Map<String, dynamic> params}) async {
    params = sign(params: params);
    Map<String, String> body = Map<String, String>();
    params.forEach((String key, dynamic value) {
      body[key] = value.toString();
    });
    http.Response res = await http.post(url, body: body, headers: getCommonHeader());
    return res.body;
  }

  static Map<String, dynamic> sign({Map<String, dynamic> params}) {
    params['appid'] = '001';
    params['memnum'] = '001';
    params['session'] = '';
    params['timestamp'] = (DateTime.now().millisecondsSinceEpoch / 1000).truncate().toString();
    params['nonceStr'] = Random().nextInt(1000000).toString();
    params['signMethod'] = 'md5';
    params['v'] = '1.0';

    var keys = params.keys.toList();
    keys.sort();
    StringBuffer sb = new StringBuffer('');
    keys.forEach((key) {
      if (params[key] == null || params[key] == '') {
        debugPrint('${params[key]}');
        return;
      }
      sb.write("$key" + "=" + "${params[key]}" + "&");
    });
    String paramStr = sb.toString();
    paramStr = paramStr.substring(0, paramStr.length - 1);

    if (paramStr.length > 0) {
      paramStr = paramStr + '&key=' + 'XRl24S6YLxlULDMn';
    } else {
      paramStr = 'key=' + 'XRl24S6YLxlULDMn';
    }

    var bytes = utf8.encode(paramStr);
    params['sign'] = md5.convert(bytes).toString().toUpperCase();

    return params;
  }

  static Map<String, String> getCommonHeader() {
    Map<String, String> header = new Map();
    header['User-Agent'] = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.86 Safari/537.36';
    header['Host'] = '127.0.0.1:16888';
    return header;
  }
}
