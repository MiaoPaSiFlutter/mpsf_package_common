import 'dart:convert';
import 'package:flutter/services.dart';

class MpsfLoadData {
  /// 加载本地Json数据
  static Future<MpsfResultData> loadJson(String jsonPath) async {
    MpsfResultData res;
    try {
      String responseString = await rootBundle.loadString(jsonPath);
      if (responseString == null || responseString.isEmpty) {
        res = MpsfResultData(null, false, 666);
      } else {
        var data = json.decode(responseString);
        if (data == null) {
          res = MpsfResultData(null, false, 0);
        } else {
          res = MpsfResultData(data, true, 200);
        }
      }
    } catch (e) {
      print(e);
      res = MpsfResultData(null, false, 0);
    }
    return res;
  }
}

class MpsfResultData {
  var data;
  bool result;
  int code;
  MpsfResultData(this.data, this.result, this.code);
}
