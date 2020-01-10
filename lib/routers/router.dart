import 'package:flutter/material.dart';
import 'package:jdshop/pages/tabs/Cart.dart';
import '../pages/tabs/Tabs.dart';

import '../pages/Search.dart';
import '../pages/ProductList.dart';
import '../pages/ProductContent.dart';
import '../pages/Login.dart';

import '../pages/RegisterFirst.dart';
import '../pages/RegisterSecond.dart';
import '../pages/RegisterThird.dart';

//配置路由
final routes = {
  '/': (context) => Tabs(),
  '/search': (context) => SearchPage(),
  '/cart': (context) => CartPage(),
  '/login': (context) => LoginPage(),
  '/registerFirst': (context) => RegisterFirstPage(),
  '/registerSecond': (context,{arguments}) => RegisterSecondPage(arguments: arguments),
  '/registerThird': (context,{arguments}) => RegisterThirdPage(arguments: arguments),
  '/productList': (context, {arguments}) =>
      ProductListPage(arguments: arguments),
  '/productContent': (context, {arguments}) =>
      ProductContentPage(arguments: arguments),
};

//固定写法
var onGenerateRoute = (RouteSettings settings) {
// 统一处理
  final String name = settings.name;
  final Function pageContentBuilder = routes[name];
  if (pageContentBuilder != null) {
    if (settings.arguments != null) {
      final Route route = MaterialPageRoute(
          builder: (context) =>
              pageContentBuilder(context, arguments: settings.arguments));
      return route;
    } else {
      final Route route =
          MaterialPageRoute(builder: (context) => pageContentBuilder(context));
      return route;
    }
  }
};