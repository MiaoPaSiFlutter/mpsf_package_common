import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../mpsf_package_common.dart';

abstract class MpsfBaseFunction {
  State _stateBaseFunction;
  BuildContext _contextBaseFunction;

  bool _isStatusBarShow = true; //电池栏是否显示
  bool _isNavigationBarShow = true; //导航栏是否显示
  //是否显示返回按钮
  bool _isBackItemShow = false;
  //标题字体大小
  String _appBarTitle;

  //界面状态
  PageStatusInfoModel _pageStatusInfo = PageStatusInfoModel(
    status: PageStatus.statusReady,
  );

  void initBaseCommon(State state) {
    _stateBaseFunction = state;
    _contextBaseFunction = state.context;
    _appBarTitle = getWidgetName();
  }

  Widget getBaseView(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: <Widget>[
          _getBaseAppBar(context),
          Expanded(
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Stack(
                children: <Widget>[
                  _buildProviderWidget(context),
                  _buildBasePageStatusWidget(context)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /////////////🔥HolderWidget
  Widget _getHolderWidget() {
    return Container(width: 0, height: 0);
  }

  /////////////🔥AppBar
  Widget _getBaseAppBar(BuildContext context) {
    return getAppBar(context);
  }

  Widget getAppBar(BuildContext context) {
    return Container(
      height: getAppBarHeight(),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          ),
          Container(
            child: Column(
              children: <Widget>[
                _isStatusBarShow
                    ? _getBaseStatusBar(context)
                    : _getHolderWidget(),
                _isNavigationBarShow
                    ? _getBaseNavigationBar(context)
                    : _getHolderWidget(),
              ],
            ),
          )
        ],
      ),
    );
  }

  /////////////🔥StatusBar
  Widget _getBaseStatusBar(BuildContext context) {
    return getStatusBar(context);
  }

  /// subclass can overwrite
  Widget getStatusBar(BuildContext context) {
    return Container(
      width: double.infinity,
      height: getStatusBarHeight(),
    );
  }

  /////////////🔥NavigationBar
  Widget _getBaseNavigationBar(BuildContext context) {
    return getNavigationBar(context);
  }

  Widget getNavigationBar(BuildContext context) {
    return Container(
      width: double.infinity,
      height: getNavigationBarHeight(),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: getNavigationBarLeftItems(context),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: getNavigationBarRightItems(context),
          ),
          Align(
            alignment: Alignment.center,
            child: getAppBarCenter(context),
          )
        ],
      ),
    );
  }

  ///导航栏左边部分 ，不满足可以自行重写
  Widget getNavigationBarLeftItems(BuildContext context) {
    List<Widget> children = [];
    if (_isBackItemShow) {
      Widget backItem = getBackItem(context);
      children.add(backItem);
    }
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }

  ///导航栏返回键
  Widget getBackItem(BuildContext context) {
    Widget child;
    if (TextUtil.isEmpty(MpsfGlobalConfiguration.instance.backIcon)) {
      child = IconButton(
        onPressed: clickBackItem,
        icon: Icon(Icons.arrow_back),
      );
    } else {
      child = GestureDetector(
        onTap: clickBackItem,
        child: MpsfImageView(
          MpsfGlobalConfiguration.instance.backIcon,
          fit: BoxFit.scaleDown,
        ),
      );
    }
    return Container(
      width: getNavigationBarHeight(),
      height: double.infinity,
      child: child,
    );
  }

  void clickBackItem() {
    log("---clickBackItem");
    finish();
  }

  void finish<T extends Object>([T result]) {
    if (Navigator.canPop(_contextBaseFunction)) {
      FocusScope.of(_contextBaseFunction).unfocus();
      Navigator.pop(_contextBaseFunction);
    } else {
      //说明已经没法回退了 ， 可以关闭了
      finishDartPageOrApp();
    }
  }

  ///导航栏右边部分 ，不满足可以自行重写
  Widget getNavigationBarRightItems(BuildContext context) {
    List<Widget> children = [];
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }

  ///导航栏appBar中间部分 ，不满足可以自行重写
  Widget getAppBarCenter(BuildContext context) {
    return Container(
      child: Text(
        _appBarTitle,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headline1,
      ),
    );
  }

  ///导航栏appBar右侧部分 ，不满足可以自行重写
  Widget getAppBarRight(BuildContext context) {
    return Container(
      width: getNavigationBarHeight(),
      height: double.infinity,
    );
  }

  ///返回屏幕宽度
  double getScreenWidth() {
    return MediaQuery.of(_contextBaseFunction).size.width;
  }

  ///返回屏幕高度
  double getScreenHeight() {
    return MediaQuery.of(_contextBaseFunction).size.height;
  }

  ///返回AppBar高度
  double getAppBarHeight() {
    return getStatusBarHeight() + getNavigationBarHeight();
  }

  ///返回电池栏高度
  double getStatusBarHeight() {
    return MediaQuery.of(_contextBaseFunction).padding.top;
  }

  ///返回导航栏高度
  double getNavigationBarHeight() {
    return 44;
  }

  ///关闭最后一个 flutter 页面 ， 如果是原生跳过来的则回到原生，否则关闭app
  void finishDartPageOrApp() {
    SystemNavigator.pop();
  }

  ///设置状态栏隐藏或者显示
  void setStatusBarVisible(bool isVisible) {
    if (_stateBaseFunction != null && _stateBaseFunction.mounted) {
      _stateBaseFunction.setState(() {
        _isStatusBarShow = isVisible;
      });
    }
  }

  ///设置导航栏隐藏或者显示
  void setNavigationBarVisible(bool isVisible) {
    if (_stateBaseFunction != null && _stateBaseFunction.mounted) {
      _stateBaseFunction.setState(() {
        _isNavigationBarShow = isVisible;
      });
    }
  }

  void setAppBarTitle(String title) {
    if (title != null) {
      if (_stateBaseFunction != null && _stateBaseFunction.mounted) {
        _stateBaseFunction.setState(() {
          _appBarTitle = title;
        });
      }
    }
  }

  ///设置页面状态
  void setPageStatus(int status) {
    if (status != null) {
      if (_stateBaseFunction != null && _stateBaseFunction.mounted) {
        _stateBaseFunction.setState(() {
          _pageStatusInfo.status = status;
        });
      }
    }
  }

  ///设置tipTitle
  void setPageStatusInfo(
      {int status, String title, String subTitle, String icon}) {
    if (title != null || subTitle != null || icon != null) {
      if (_stateBaseFunction != null && _stateBaseFunction.mounted) {
        if (status != null) _pageStatusInfo.status = status;
        if (title != null) _pageStatusInfo.title = title;
        if (subTitle != null) _pageStatusInfo.subTitle = subTitle;
        if (icon != null) _pageStatusInfo.icon = icon;
        _stateBaseFunction.setState(() {});
      }
    }
  }

  void setBackItemHiden({bool isHiden = true}) {
    // ignore: invalid_use_of_protected_member
    if (_stateBaseFunction != null && _stateBaseFunction.mounted) {
      _stateBaseFunction.setState(() {
        _isBackItemShow = !isHiden;
      });
    }
  }

  ///初始化一些变量
  void onInitDatas();

  ///只要页面来到栈顶， 都会调用此方法，网络请求可以放在这个方法
  void onFetchData();

  ///返回UI控件 相当于setContentView()
  Widget buildWidget(BuildContext context);

  ///app切回到后台
  void onBackground() {
    log("回到后台");
  }

  ///app切回到前台
  void onForeground() {
    log("回到前台");
  }

  ///页面注销方法
  void onDestory() {
    log("destory");
  }

  void log(String content) {
    print(getWidgetName() + "------:" + content);
  }

  String getWidgetName() {
    if (_contextBaseFunction == null) {
      return "";
    }
    String className = _contextBaseFunction.toString();
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

  _buildProviderWidget(BuildContext context) {
    return buildWidget(context);
  }

  _buildBasePageStatusWidget(BuildContext context) {
    return buildPageStatusWidget(context);
  }

  Widget buildPageStatusWidget(BuildContext context) {
    Widget child;

    switch (_pageStatusInfo.status) {
      case PageStatus.statusLoading: //请求中
        child = MpsfBlankLodingView(
          info: _pageStatusInfo,
        );
        break;
      case PageStatus.statusError: //错误
        child = MpsfBlankErrorView(
          info: _pageStatusInfo,
        );
        break;
      case PageStatus.statusNoData: //空数据
        child = MpsfBlankNoDataView(
          info: _pageStatusInfo,
        );
        break;
      case PageStatus.statusReady: //就绪
        child = MpsfBlankReadyView(
          info: _pageStatusInfo,
        );
        break;
      default:
    }

    return GestureDetector(
      onTap: () {
        onFetchData();
      },
      child: Container(
        child: child,
      ),
    );
  }

  String getClassName() {
    if (_contextBaseFunction == null) {
      return null;
    }
    String className = _contextBaseFunction.toString();
    if (className == null) {
      return null;
    }
    className = className.substring(0, className.indexOf("("));
    return className;
  }
}
