import 'package:flutter/material.dart';

import 'mpsf_base_function.dart';

abstract class MpsfBaseWidget extends StatefulWidget {
  MpsfBaseWidgetState baseWidgetState;

  MpsfBaseWidget({Key key}) : super(key: key);

  @override
  MpsfBaseWidgetState createState() {
    baseWidgetState = getState();
    return baseWidgetState;
  }

  MpsfBaseWidgetState getState();

  String getStateName() {
    return baseWidgetState.getWidgetName();
  }
}

abstract class MpsfBaseWidgetState<T extends MpsfBaseWidget> extends State<T>
    with WidgetsBindingObserver, MpsfBaseFunction {
  ///当插入渲染树的时候调用，这个函数在生命周期中只调用一次。
  ///这里可以做一些初始化工作，比如初始化State的变量。
  @override
  void initState() {
    initBaseCommon(this);
    setBackItemHiden(isHiden: false);
    WidgetsBinding.instance.addObserver(this);
    log("initState");
    onInitDatas();
    super.initState();
  }

  ///这个函数会紧跟在initState之后调用
  @override
  void didChangeDependencies() {
    log("didChangeDependencies");
    super.didChangeDependencies();
  }

  ///当组件的状态改变的时候就会调用didUpdateWidget,比如调用了setState.
  ///实际上这里flutter框架会创建一个新的Widget,绑定本State，并在这个函数中传递老的Widget。
  ///这个函数一般用于比较新、老Widget，看看哪些属性改变了，并对State做一些调整。
  ///需要注意的是，涉及到controller的变更，需要在这个函数中移除老的controller的监听，并创建新controller的监听。
  @override
  void didUpdateWidget(T oldWidget) {
    log("didUpdateWidget");
    super.didUpdateWidget(oldWidget);
  }

  ///在dispose之前，会调用这个函数。
  ///实测在组件可见状态变化的时候会调用，当组件卸载时也会先一步dispose调用。
  @override
  void deactivate() {
    log("deactivate");
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    log("build");
    return Scaffold(
      body: getBaseView(context),
    );
  }

  ///一旦到这个阶段，组件就要被销毁了，这个函数一般会移除监听，清理环境。
  @override
  void dispose() {
    log("dispose");
    onDestory();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    log('state = $state');
    //此处可以拓展 是不是从前台回到后台
    if (state == AppLifecycleState.resumed) {
      onForeground();
    } else if (state == AppLifecycleState.paused) {
      onBackground();
    }
    super.didChangeAppLifecycleState(state);
  }
}
