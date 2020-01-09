import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:jdshop/services/EventBus.dart';
import 'package:jdshop/widget/LoadingWidget.dart';
import '../services/ScreenAdapter.dart';
import '../widget/JdButton.dart';
import 'ProductContent/ProductContentFirst.dart';
import 'ProductContent/ProductContentSecond.dart';
import 'ProductContent/ProductContentThird.dart';
import '../config/Config.dart';
import 'package:dio/dio.dart';
import '../model/ProductContentModel.dart';

class ProductContentPage extends StatefulWidget {
  Map arguments;
  ProductContentPage({Key key, this.arguments}) : super(key: key);

  @override
  _ProductContentPageState createState() => _ProductContentPageState();
}

class _ProductContentPageState extends State<ProductContentPage> {
  List _productContentList = [];

  @override
  void initState() {
    super.initState();
    this._getContentData();
  }

  _getContentData() async {
    var api = '${Config.domain}api/pcontent?id=${widget.arguments['id']}';

    print(api);
    var result = await Dio().get(api);
    var productContent = new ProductContentModel.fromJson(result.data);
    setState(() {
      this._productContentList.add(productContent.result);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: ScreenAdapter.width(400),
                child: TabBar(
                  indicatorColor: Colors.red,
                  indicatorSize: TabBarIndicatorSize.label,
                  tabs: <Widget>[
                    Tab(
                      child: Text("商品"),
                    ),
                    Tab(
                      child: Text("详情"),
                    ),
                    Tab(
                      child: Text("评价"),
                    )
                  ],
                ),
              )
            ],
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.more_horiz),
              onPressed: () {
                showMenu(
                    context: context,
                    position: RelativeRect.fromLTRB(
                        ScreenAdapter.width(600), 76, 10, 0),
                    items: [
                      PopupMenuItem(
                        child: Row(
                          children: <Widget>[Icon(Icons.home), Text('首页')],
                        ),
                      ),
                      PopupMenuItem(
                        child: Row(
                          children: <Widget>[Icon(Icons.search), Text("搜索")],
                        ),
                      )
                    ]);
              },
            )
          ],
        ),
        body: this._productContentList.length > 0
            ? Stack(
                children: <Widget>[
                  TabBarView(
                    children: <Widget>[
                      ProductContentFirst(this._productContentList),
                      ProductContentSecond(this._productContentList),
                      ProductContentThird()
                    ],
                  ),
                  Positioned(
                    width: ScreenAdapter.width(750),
                    height: ScreenAdapter.width(88),
                    bottom: 0,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                              top: BorderSide(color: Colors.black26, width: 1)),
                          color: Colors.white),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 100,
                            height: ScreenAdapter.height(76),
                            child: Column(
                              children: <Widget>[
                                Icon(Icons.shopping_cart),
                                Text("购物车")
                              ],
                            ),
                          ),
                          Expanded(
                              flex: 1,
                              child: JdButton(
                                color: Color.fromRGBO(253, 1, 0, 0.9),
                                text: "加入购物车",
                                cb: () {
                                  if (this._productContentList[0].attr.length >
                                      0) {
                                    //广播
                                    eventBus.fire(ProductContentEvent("加入购物车"));
                                  } else {}
                                },
                              )),
                          Expanded(
                            flex: 1,
                            child: JdButton(
                              cb: () {
                                print('立即购买');
                                if (this._productContentList[0].attr.length >
                                    0) {
                                  //广播
                                  eventBus.fire(ProductContentEvent("立即购买"));
                                } else {}
                              },
                              color: Color.fromRGBO(255, 165, 0, 0.9),
                              text: "立即购买",
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              )
            : LoadingWidget(),
      ),
    );
  }
}
