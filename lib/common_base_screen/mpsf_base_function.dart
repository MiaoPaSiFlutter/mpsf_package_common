import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../mpsf_package_common.dart';

class BlankPageStatus {
  static const int statusReady = 0; //就绪
  static const int statusLoading = 1; //请求中
  static const int statusNoData = 2; //空数据
  static const int statusError = 3; //请求错误
}


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
  int _blankStatus = BlankPageStatus.statusReady;

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
                  _buildBaseBlankPageStatusWidget(context)
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

  ///////////////////////////////////////////
  ////////////  BlankPageStatus   ///////////////
  ///////////////////////////////////////////
  buildBlankPageStatusWidget(BuildContext context) {
    Widget child;
    switch (_blankStatus) {
      case BlankPageStatus.statusLoading: //请求中
        child = getLoadingWidget(context);
        break;
      case BlankPageStatus.statusError: //错误
        child = getErrorWidget(context);
        break;
      case BlankPageStatus.statusNoData: //空数据
        child = getNoDataWidget(context);
        break;
      case BlankPageStatus.statusReady: //就绪
        child = _getHolderWidget();
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

  /////////////🔥LoadingWidget
  Widget getLoadingWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      color: Theme.of(context).scaffoldBackgroundColor,
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 4.0,
          backgroundColor: Colors.blue,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ),
    );
  }

  /////////////🔥ErrorWidget
  Widget getErrorWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      color: Theme.of(context).scaffoldBackgroundColor,
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: InkWell(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Text(
                  "请求失败",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /////////////🔥EmptyWidget
  Widget getNoDataWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      color: Theme.of(context).scaffoldBackgroundColor,
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: InkWell(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Text(
                  "暂无数据",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              )
            ],
          ),
        ),
      ),
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
  void setBlankStatus({int status}) {
    if (status != null) {
      if (_stateBaseFunction != null && _stateBaseFunction.mounted) {
        _stateBaseFunction.setState(() {
          _blankStatus = status;
        });
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

  _buildBaseBlankPageStatusWidget(BuildContext context) {
    return buildBlankPageStatusWidget(context);
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
