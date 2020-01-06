import 'package:flutter/material.dart';
import 'package:jdshop/pages/tabs/Cart.dart';
import 'package:jdshop/pages/tabs/Category.dart';
import 'package:jdshop/pages/tabs/Home.dart';
import 'package:jdshop/pages/tabs/User.dart';

class Tabs extends StatefulWidget {
  Tabs({Key key}) : super(key: key);

  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  int _currentIndex=1;

  List _pageList=[
    HomePage(),
    CategoryPage(),
    CartPage(),
    UserPage()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("京东商城"),
      ),
      body: this._pageList[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: this._currentIndex,
        onTap: (index){
          setState(() {
            this._currentIndex=index;
          });
        },
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.red,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text("首页")
          ),BottomNavigationBarItem(
            icon: Icon(Icons.category),
            title: Text("分类")
          ),BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            title: Text("购物车")
          ),BottomNavigationBarItem(
            icon: Icon(Icons.people),
            title: Text("我的")
          ),
        ],
      ),
    );
  }
}