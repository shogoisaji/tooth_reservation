import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'route_obserber.g.dart';

@Riverpod(keepAlive: true)
RouteObserver routeObserver(RouteObserverRef ref) => RouteObserver();
