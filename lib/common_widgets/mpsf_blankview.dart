import 'package:flutter/material.dart';
import '../mpsf_package_common.dart';

class PageStatus {
  static const int statusReady = 0; //就绪
  static const int statusLoading = 1; //请求中
  static const int statusNoData = 2; //空数据
  static const int statusError = 3; //请求错误
}

class PageStatusInfoModel {
  int status;
  String title;
  String subTitle;
  String icon;
  Widget lottie;

  PageStatusInfoModel({this.status, this.title, this.subTitle, this.icon});
}