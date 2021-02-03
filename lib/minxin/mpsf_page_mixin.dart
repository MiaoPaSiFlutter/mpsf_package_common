import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mpsf_package_common/mpsf_package_common.dart';

@optionalTypeArgs
mixin MpsfPageMixin<T extends StatefulWidget> on State<T> {
  /// [生命周期]
  @override
  void initState() {
    mpsflog("[page]initState");
    super.initState();
    onFetchData();
  }
  void onFetchData() {}

  @override
  void didChangeDependencies() {
    mpsflog("[page]didChangeDependencies");
    super.didChangeDependencies();
  }

  @override
  void deactivate() {
    mpsflog("[page]deactivate");
    super.deactivate();
  }

  @override
  void dispose() {
    mpsflog("[page]dispose");
    super.dispose();
  }

  /// [日志打印]
  void mpsflog(String content) {
    MpsfLogUtils.e(getWidgetName() + "------:" + content);
  }

  String getWidgetName() {
    if (context == null) {
      return "";
    }
    String className = context.toString();
    if (className == null) {
      return "";
    }

    if (!inProduction) {
      try {
        className = className.substring(0, className.indexOf("("));
      } catch (err) {
        className = "";
      }
      return className;
    }

    return className;
  }

  /// [常用数值获取]
  double getHeightPx(double height) =>
      ScreenUtil.getInstance().getHeightPx(height);

  double getWidthPx(double width) => ScreenUtil.getInstance().getWidthPx(width);

  ///屏幕宽度
  double getScreenWidth() => ScreenUtil.getInstance().screenWidth;

  ///屏幕高度
  double getScreenHeight() => ScreenUtil.getInstance().screenHeight;

  ///得到适配后的字号
  double getSp(double fontSize) => ScreenUtil.getInstance().getSp(fontSize);

  ///返回AppBar高度
  double getAppBarHeight() {
    return getStatusBarHeight() + getNavigationBarHeight();
  }

  ///返回电池栏高度
  double getStatusBarHeight() {
    return MediaQuery.of(context).padding.top;
  }

  ///返回导航栏高度
  double getNavigationBarHeight() {
    return 44;
  }

  /// [常用Widget获取]
  ///占位widget
  Widget getSizeBox({double width = 1, double height = 1}) {
    return SizedBox(
      width: width,
      height: height,
    );
  }

  ///导航栏返回键
  Widget getBackItem() {
    return Container(
      width: getNavigationBarHeight(),
      height: double.infinity,
      child: IconButton(
        onPressed: clickBackItem,
        icon: Icon(Icons.arrow_back),
      ),
    );
  }

  void clickBackItem() {
    mpsflog("---clickBackItem");
    finish();
  }

  void finish<T extends Object>([T result]) {
    if (Navigator.canPop(context)) {
      FocusScope.of(context).unfocus();
      Navigator.pop(context);
    } else {
      //说明已经没法回退了 ， 可以关闭了
      finishDartPageOrApp();
    }
  }

  ///关闭最后一个 flutter 页面 ， 如果是原生跳过来的则回到原生，否则关闭app
  void finishDartPageOrApp() {
    SystemNavigator.pop();
  }


  ///[空置页面]
  int blankStatus = 0;
  String blankIconPath;
  String blankTitle;
  String blankDescription;
}

class MpsfBlankStatus {
  static const int ready = 0; //就绪
  static const int loading = 1; //请求中
  static const int noData = 2; //空数据
  static const int error = 3; //请求错误
}