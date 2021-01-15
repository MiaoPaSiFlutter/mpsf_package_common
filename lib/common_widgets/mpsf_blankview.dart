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

  PageStatusInfoModel({this.status, this.title, this.subTitle, this.icon});
}

class MpsfBlankReadyView extends StatelessWidget {
  final PageStatusInfoModel info;
  const MpsfBlankReadyView({Key key, this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class MpsfBlankLodingView extends StatelessWidget {
  final PageStatusInfoModel info;
  const MpsfBlankLodingView({Key key, this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 100),
      color: Theme.of(context).scaffoldBackgroundColor,
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 4.0,
          backgroundColor: Colors.blue,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
        ),
      ),
    );
  }
}

class MpsfBlankErrorView extends StatelessWidget {
  final PageStatusInfoModel info;
  const MpsfBlankErrorView({Key key, this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget iconchild;
    String icon;
    if (!TextUtil.isEmpty(info.icon)) {
      icon = info.icon;
    } else {
      icon = MpsfGlobalConfiguration.instance.blankErrorIcon;
    }
    if (!TextUtil.isEmpty(icon)) {
      iconchild = MpsfImageView(icon, fit: BoxFit.scaleDown);
    } else {
      iconchild = Container();
    }

    return Container(
      padding: EdgeInsets.fromLTRB(0, 150, 0, 0),
      color: Theme.of(context).scaffoldBackgroundColor,
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: InkWell(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              iconchild,
              Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Text(
                  info.title ?? "请求失败",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MpsfBlankNoDataView extends StatelessWidget {
  final PageStatusInfoModel info;
  const MpsfBlankNoDataView({Key key, this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget iconchild;
    String icon;
    if (!TextUtil.isEmpty(info.icon)) {
      icon = info.icon;
    } else {
      icon = MpsfGlobalConfiguration.instance.blankNoDataIcon;
    }
    if (!TextUtil.isEmpty(icon)) {
      iconchild = Container(
        width: 120,
        child: MpsfImageView(icon, fit: BoxFit.contain),
      );
    } else {
      iconchild = Container();
    }

    return Container(
      padding: EdgeInsets.fromLTRB(0, 150, 0, 0),
      color: Theme.of(context).scaffoldBackgroundColor,
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: InkWell(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              iconchild,
              Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Text(
                  info.title ?? "暂无数据",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
