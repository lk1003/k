import 'package:flutter/material.dart';
import 'package:jdshop/pages/tabs/Cart.dart';
import 'package:jdshop/pages/tabs/Category.dart';
import 'package:jdshop/pages/tabs/Home.dart';
import 'package:jdshop/pages/tabs/User.dart';
import 'package:jdshop/services/ScreenAdapter.dart';
import 'package:jpush_flutter/jpush_flutter.dart';

class Tabs extends StatefulWidget {
  Tabs({Key key}) : super(key: key);

  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  int _currentIndex = 0;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    this._pageController = new PageController(initialPage: this._currentIndex);
    initJpush();
  }

//监听极光推送 (自定义的方法)
  //https://github.com/jpush/jpush-flutter-plugin/blob/master/documents/APIs.md
  initJpush() async {
    JPush jpush = new JPush();
    //获取注册的id
    jpush.getRegistrationID().then((rid) {
      print("获取注册的id:$rid");
    });
    //初始化
    jpush.setup(
      appKey: "17d78ecf32c322db169a1d98",
      channel: "theChannel",
      production: false,
      debug: true, // 设置是否打印 debug 日志
    );

    //设置别名  实现指定用户推送
    jpush.setAlias("jg123").then((map) {
      print("设置别名成功");
    });

    //iOS10+ 可以通过该方法来设置推送是否前台展示，是否触发声音，是否设置应用角标 badge
    jpush.applyPushAuthority(new NotificationSettingsIOS(
      sound: true,
      alert: true,
      badge: true));

    try {
      //监听消息通知
      jpush.addEventHandler(
        // 接收通知回调方法。
        onReceiveNotification: (Map<String, dynamic> message) async {
          print("flutter onReceiveNotification: $message");
        },
        // 点击通知回调方法。
        onOpenNotification: (Map<String, dynamic> message) async {
          print("flutter onOpenNotification: $message");
        },
        // 接收自定义消息回调方法。
        onReceiveMessage: (Map<String, dynamic> message) async {
          print("flutter onReceiveMessage: $message");
        },
      );
    } catch (e) {
      print('极光sdk配置异常');
    }
  }

  List<Widget> _pageList = [HomePage(), CategoryPage(), CartPage(), UserPage()];
  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    return Scaffold(
      body: PageView(
        controller: this._pageController,
        children: this._pageList,
        onPageChanged: (index) {
          setState(() {
            this._currentIndex = index;
          });
        },
        physics: NeverScrollableScrollPhysics(), //禁止滑动
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: this._currentIndex,
        onTap: (index) {
          setState(() {
            this._currentIndex = index;
            this._pageController.jumpToPage(index);
          });
        },
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.red,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("首页")),
          BottomNavigationBarItem(
              icon: Icon(Icons.category), title: Text("分类")),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), title: Text("购物车")),
          BottomNavigationBarItem(icon: Icon(Icons.people), title: Text("我的")),
        ],
      ),
    );
  }
}
