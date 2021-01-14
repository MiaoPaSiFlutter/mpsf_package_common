import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../mpsf_package_common.dart';


abstract class MpsfBaseFunction {
  State _stateBaseFunction;
  BuildContext _contextBaseFunction;

  bool _isTopBarShow = true; //状态栏是否显示
  bool _isAppBarShow = true; //导航栏是否显示

  Color _topBarColor;
  Color _appBarColor;
  Color _appBarContentColor;

  //标题字体大小
  double _appBarCenterTextSize; //根据需求变更
  String _appBarTitle;

  //界面状态
  PageStatus _pageStatus = PageStatus.STATUS_NODATA;
  String _tipTitle = "无数据";

  //是否显示返回按钮
  bool _isBackIconShow = false;

  FontWeight _fontWidget = FontWeight.w600; //错误页面和空页面的字体粗度

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
          _isTopBarShow ? _getBaseTopBar(context) : _getHolderWidget(),
          _isAppBarShow ? _getBaseAppBar(context) : _getHolderWidget(),
          Expanded(
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Stack(
                children: <Widget>[
                  _buildProviderWidget(context),
                  _buildPageStatusWidget(context)
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

  /////////////🔥TopBar
  Widget _getBaseTopBar(BuildContext context) {
    return getTopBar(context);
  }

  /// subclass can overwrite
  Widget getTopBar(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: _topBarColor != null ? _topBarColor : themeData.primaryColor,
      ),
      height: getTopBarHeight(),
      width: double.infinity,
    );
  }

  double getTopBarHeight() {
    return MediaQuery.of(_contextBaseFunction).padding.top;
  }

  /////////////🔥AppBar
  Widget _getBaseAppBar(BuildContext context) {
    return getAppBar(context);
  }

  Widget getAppBar(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: _appBarColor != null ? _appBarColor : themeData.primaryColor,
      ),
      height: getAppBarHeight(),
      width: double.infinity,
      child: Row(
        children: <Widget>[
          getAppBarLeft(context),
          Expanded(child: getAppBarCenter(context)),
          getAppBarRight(context)
        ],
      ),
    );
  }

  ///导航栏appBar左边部分 ，不满足可以自行重写
  Widget getAppBarLeft(BuildContext context) {
    Widget child;
    if (_isBackIconShow) {
      if (TextUtil.isEmpty(MpsfGlobalConfiguration.instance.backIcon)) {
        child = IconButton(
          onPressed: clickAppBarBack,
          tooltip: 'Back',
          icon: Icon(Icons.arrow_back),
        );
      } else {
        child = GestureDetector(
          onTap: clickAppBarBack,
          child: MpsfImageView(
            MpsfGlobalConfiguration.instance.backIcon,
            fit: BoxFit.scaleDown,
          ),
        );
      }
    }

    return Container(
      width: getAppBarHeight(),
      height: double.infinity,
      child: child,
    );
  }

  void clickAppBarBack() {
    log("---⬅️clickAppBarBack");
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

  ///导航栏appBar中间部分 ，不满足可以自行重写
  Widget getAppBarCenter(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Container(
      child: Text(
        _appBarTitle,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: _appBarCenterTextSize != null
              ? _appBarCenterTextSize
              : themeData.textTheme.headline1.fontSize,
          color: _appBarContentColor != null
              ? _appBarContentColor
              : themeData.textTheme.headline1.color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  ///导航栏appBar右侧部分 ，不满足可以自行重写
  Widget getAppBarRight(BuildContext context) {
    return Container(
      width: getAppBarHeight(),
      height: double.infinity,
    );
  }

  ///////////////////////////////////////////
  ////////////  PageStatus   ///////////////
  ///////////////////////////////////////////

  /////////////🔥LoadingWidget
  Widget _getBaseLoadingWidget(BuildContext context) {
    return getLoadingWidget(context);
  }

  Widget getLoadingWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 100),
      color: Theme.of(context).scaffoldBackgroundColor,
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: CircularProgressIndicator(
          // 圆形进度条
          strokeWidth: 4.0,
          backgroundColor: Colors.blue,
          valueColor: AlwaysStoppedAnimation<Color>(_appBarColor),
        ),
      ),
    );
  }

  /////////////🔥ErrorWidget
  Widget _getBaseErrorWidget(BuildContext context) {
    return getErrorWidget(context);
  }

  Widget getErrorWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 150, 0, 0),
      color: Theme.of(context).scaffoldBackgroundColor,
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: InkWell(
          onTap: onClickErrorWidget,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text(_tipTitle,
                      style: TextStyle(fontWeight: _fontWidget))),
            ],
          ),
        ),
      ),
    );
  }

  void onClickErrorWidget() {
    onFetchData(); //此处 默认onResume 就是 调用网络请求，
  }

  /////////////🔥EmptyWidget
  Widget _getBaseNoDataWidget(BuildContext context) {
    return getNoDataWidget(context);
  }

  Widget getNoDataWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 150, 0, 0),
      color: Theme.of(context).scaffoldBackgroundColor,
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text(_tipTitle,
                      style: TextStyle(fontWeight: _fontWidget)))
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

  ///返回appbar高度，也就是导航栏高度
  double getAppBarHeight() {
    return 44;
  }

  ///关闭最后一个 flutter 页面 ， 如果是原生跳过来的则回到原生，否则关闭app
  void finishDartPageOrApp() {
    SystemNavigator.pop();
  }

  ///设置状态栏隐藏或者显示
  void setTopBarVisible(bool isVisible) {
    if (_stateBaseFunction != null && _stateBaseFunction.mounted) {
      _stateBaseFunction.setState(() {
        _isTopBarShow = isVisible;
      });
    }
  }

  ///默认这个状态栏下，设置颜色
  void setTopBarBackColor(Color color) {
    if (_stateBaseFunction != null && _stateBaseFunction.mounted) {
      _stateBaseFunction.setState(() {
        _topBarColor = color == null ? _topBarColor : color;
      });
    }
  }

  ///设置导航栏的字体以及图标颜色
  void setAppBarContentColor(Color contentColor) {
    if (contentColor != null) {
      if (_stateBaseFunction != null && _stateBaseFunction.mounted) {
        _stateBaseFunction.setState(() {
          _appBarContentColor = contentColor;
        });
      }
    }
  }

  ///设置导航栏隐藏或者显示
  void setAppBarVisible(bool isVisible) {
    if (_stateBaseFunction != null && _stateBaseFunction.mounted) {
      _stateBaseFunction.setState(() {
        _isAppBarShow = isVisible;
      });
    }
  }

  ///默认这个导航栏下，设置颜色
  void setAppBarBackColor(Color color) {
    if (_stateBaseFunction != null && _stateBaseFunction.mounted) {
      _stateBaseFunction.setState(() {
        _appBarColor = color == null ? _appBarColor : color;
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
  void setPageStatus(PageStatus status) {
    if (status != null) {
      if (_stateBaseFunction != null && _stateBaseFunction.mounted) {
        // ignore: invalid_use_of_protected_member
        _stateBaseFunction.setState(() {
          _pageStatus = status;
        });
      }
    }
  }

  ///设置tipTitle
  void setTipTitle(String title) {
    if (title != null) {
      if (_stateBaseFunction != null && _stateBaseFunction.mounted) {
        _stateBaseFunction.setState(() {
          _tipTitle = title;
        });
      }
    }
  }

  void setBackIconHiden({bool isHiden = true}) {
    // ignore: invalid_use_of_protected_member
    if (_stateBaseFunction != null && _stateBaseFunction.mounted) {
      _stateBaseFunction.setState(() {
        _isBackIconShow = !isHiden;
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

  _buildPageStatusWidget(BuildContext context) {
    switch (_pageStatus) {
      case PageStatus.STATUS_LOADING: //请求中
        return _getBaseLoadingWidget(context);
        break;
      case PageStatus.SERVER_ERROR: //错误
        return _getBaseErrorWidget(context);
        break;
      case PageStatus.STATUS_NODATA: //空数据
        return _getBaseNoDataWidget(context);
        break;
      case PageStatus.STATUS_READY: //就绪
        return _getHolderWidget();
        break;
      default:
    }
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

/// 界面状态
enum PageStatus {
  STATUS_LOADING, //请求中
  SERVER_ERROR, //请求错误
  STATUS_READY, //就绪
  STATUS_NODATA, //空数据
}
