class MpsfGlobalConfiguration {
  static MpsfGlobalConfiguration _instance;
  // 工厂模式
  factory MpsfGlobalConfiguration() => _getInstance();
  static MpsfGlobalConfiguration get instance => _getInstance();

  static MpsfGlobalConfiguration _getInstance() {
    if (_instance == null) {
      _instance = MpsfGlobalConfiguration._internal();
    }
    return _instance;
  }

  ///返回键图标
  String backIcon;

  ///无数据图标
  String blankNoDataIcon;

  ///错误图标
  String blankErrorIcon;

  MpsfGlobalConfiguration._internal() {
    // 初始化
  }
}
