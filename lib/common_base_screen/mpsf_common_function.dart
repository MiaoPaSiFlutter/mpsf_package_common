import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mpsf_package_common/mpsf_package_common.dart';

class MpsfBlankStatus {
  static const int ready = 0; //就绪
  static const int loading = 1; //请求中
  static const int noData = 2; //空数据
  static const int error = 3; //请求错误
}

abstract class MpsfCommonFunction {
  State stateBaseFunction;
  BuildContext contextBaseFunction;

  //空置页面
  int blankStatus = 0;
  String blankIconPath;
  String blankTitle;
  String blankDescription;

  void initBaseCommon(State state) {
    stateBaseFunction = state;
    contextBaseFunction = state.context;
  }

  /////////////🔥HolderWidget
  Widget getHolderWidget() {
    return Container(width: 0, height: 0);
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
    mpsf_log("---clickBackItem");
    finish();
  }

  void finish<T extends Object>([T result]) {
    if (Navigator.canPop(contextBaseFunction)) {
      FocusScope.of(contextBaseFunction).unfocus();
      Navigator.pop(contextBaseFunction);
    } else {
      //说明已经没法回退了 ， 可以关闭了
      finishDartPageOrApp();
    }
  }

  ///返回屏幕宽度
  double getScreenWidth() {
    return MediaQuery.of(contextBaseFunction).size.width;
  }

  ///返回屏幕高度
  double getScreenHeight() {
    return MediaQuery.of(contextBaseFunction).size.height;
  }

  ///返回AppBar高度
  double getAppBarHeight() {
    return getStatusBarHeight() + getNavigationBarHeight();
  }

  ///返回电池栏高度
  double getStatusBarHeight() {
    return MediaQuery.of(contextBaseFunction).padding.top;
  }

  ///返回导航栏高度
  double getNavigationBarHeight() {
    return 44;
  }

  ///关闭最后一个 flutter 页面 ， 如果是原生跳过来的则回到原生，否则关闭app
  void finishDartPageOrApp() {
    SystemNavigator.pop();
  }

  ///只要页面来到栈顶， 都会调用此方法，网络请求可以放在这个方法
  void onFetchData();

  void mpsf_log(String content) {
    MpsfLogUtils.e(getWidgetName() + "------:" + content);
  }

  String getWidgetName() {
    if (contextBaseFunction == null) {
      return "";
    }
    String className = contextBaseFunction.toString();
    if (className == null) {
      return "";
    }

    if (!MpsfConstant.inProduction) {
      try {
        className = className.substring(0, className.indexOf("("));
      } catch (err) {
        className = "";
      }
      return className;
    }

    return className;
  }

  String getClassName() {
    if (contextBaseFunction == null) {
      return null;
    }
    String className = contextBaseFunction.toString();
    if (className == null) {
      return null;
    }
    className = className.substring(0, className.indexOf("("));
    return className;
  }
}