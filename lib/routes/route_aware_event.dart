import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class RouteAwareEvent extends RouteAware {
  VoidCallback? onDidPopNext;
  VoidCallback? onDidPop;
  VoidCallback? onDidPushNext;
  VoidCallback? onDidPush;

  @override
  void didPopNext() => onDidPopNext?.call();
  @override
  void didPop() => onDidPop?.call();
  @override
  void didPushNext() => onDidPushNext?.call();
  @override
  void didPush() => onDidPush?.call();
}

// hooks の返り値
enum RouteAwareType {
  didPush,
  didPop,
  didPopNext,
  didPushNext,
}

RouteAwareType? useRouteAwareEvent(RouteObserver routeObserver) {
  return use(_RouteAwareHook(routeObserver));
}

class _RouteAwareHook extends Hook<RouteAwareType?> {
  const _RouteAwareHook(this.routeObserver) : super();
  final RouteObserver routeObserver;

  @override
  __RouteAwareState createState() => __RouteAwareState();
}

class __RouteAwareState extends HookState<RouteAwareType?, _RouteAwareHook> {
  RouteAwareType? _state;
  final aware = RouteAwareEvent();

  @override
  void initHook() {
    super.initHook();
    aware.onDidPop = () => _state = RouteAwareType.didPop;
    aware.onDidPopNext = () => _state = RouteAwareType.didPopNext;
    aware.onDidPush = () => _state = RouteAwareType.didPush;
    aware.onDidPushNext = () => _state = RouteAwareType.didPushNext;
  }

  var firstBuild = true;
  @override
  RouteAwareType? build(BuildContext context) {
    // initHook で context を触るとエラーになるので、ここで初期化する
    // また、ここでは useEffect が使えないので、firstBuild を利用し初回のみ subscribe する
    if (firstBuild) {
      firstBuild = false;
      hook.routeObserver.subscribe(aware, ModalRoute.of(context)!);
    }
    return _state;
  }

  @override
  void dispose() {
    super.dispose();
    hook.routeObserver.unsubscribe(aware);
  }
}
