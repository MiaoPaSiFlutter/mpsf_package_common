class MpsfLogUtils {

  //是否输入日志标识
  static bool _isLog = true;
  static String _logFlag = "Mpsf";

  static void init({bool islog = false,String logFlag ="Mpsf"}){
    _isLog = islog;
    _logFlag = logFlag;
  }


  static void e(String message){
    if(_isLog){
      print("$_logFlag | $message");
    }
  }
}
