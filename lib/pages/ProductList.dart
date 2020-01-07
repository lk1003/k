import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jdshop/config/Config.dart';
import 'package:jdshop/model/ProductModel.dart';
import 'package:jdshop/services/ScreenAdapter.dart';
import 'package:jdshop/widget/LoadingWidget.dart';

class ProductListPage extends StatefulWidget {
  Map arguments;
  ProductListPage({Key key, this.arguments}) : super(key: key);

  @override
  _ProductListPageState createState() => _ProductListPageState(arguments);
}

class _ProductListPageState extends State<ProductListPage> {
  Map arguments;
  //分页
  int _page = 1;
  //每页有多少条数据
  int _pageSize = 8;
  //数据
  List _productList = [];
  /*
  排序:价格升序 sort=price_1 价格降序 sort=price_-1  销量升序 sort=salecount_1 销量降序 sort=salecount_-1
  */
  String _sort = "";

  //解决重复请求的问题
  bool flag = true;

  //是否有数据

  bool _hasMore = true;
  //用于上拉分页
  ScrollController _scrollController = new ScrollController();
  //Scaffold key
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  /*二级导航数据*/
  List _subHeaderList = [
    {
      "id": 1,
      "title": "综合",
      "fileds": "all",
      "sort":
          -1, //排序     升序：price_1     {price:1}        降序：price_-1   {price:-1}
    },
    {"id": 2, "title": "销量", "fileds": 'salecount', "sort": -1},
    {"id": 3, "title": "价格", "fileds": 'price', "sort": -1},
    {"id": 4, "title": "筛选"}
  ];
  //二级导航选中判断
  int _selectHeaderId = 1;

  _ProductListPageState(Map arguments) {
    this.arguments = arguments;
  }

  @override
  void initState() {
    super.initState();
    _getProductListData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >
          _scrollController.position.maxScrollExtent - 20) {
        if (flag && _hasMore) {
          _getProductListData();
        }
      }
    });
  }

  _getProductListData() async {
    setState(() {
      this.flag = false;
    });

    var api =
        '${Config.domain}api/plist?cid=${widget.arguments["cid"]}&page=${this._page}&sort=${this._sort}&pageSize=${this._pageSize}';

    print(api);
    var result = await Dio().get(api);

    var productList = new ProductModel.fromJson(result.data);

    print(productList.result.length);

    if (productList.result.length < this._pageSize) {
      setState(() {
        // this._productList = productList.result;
        this._productList.addAll(productList.result);
        this._hasMore = false;
        this.flag = true;
      });
    } else {
      setState(() {
        // this._productList = productList.result;
        this._productList.addAll(productList.result);
        this._page++;
        this.flag = true;
      });
    }
  }

  //显示加载中的圈圈
  Widget _showMore(index) {
    if (this._hasMore) {
      return (index == this._productList.length - 1)
          ? LoadingWidget()
          : Text("");
    } else {
      return (index == this._productList.length - 1)
          ? Text("--我是有底线的--")
          : Text("");
      ;
    }
  }

  Widget _productListWidget() {
    if (_productList.length > 0) {
      return Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(top: ScreenAdapter.height(80)),
        child: ListView.builder(
          controller: _scrollController,
          itemCount: _productList.length,
          itemBuilder: (context, index) {
            //处理图片
            String pic = this._productList[index].pic;
            pic = Config.domain + pic.replaceAll('\\', '/');
            return Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                        height: ScreenAdapter.height(180),
                        width: ScreenAdapter.width(180),
                        child: Image.network("${pic}", fit: BoxFit.cover)),
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: ScreenAdapter.height(180),
                        margin: EdgeInsets.only(left: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("${this._productList[index].title}",
                                maxLines: 2, overflow: TextOverflow.ellipsis),
                            Row(
                              children: <Widget>[
                                Container(
                                  height: ScreenAdapter.height(36),
                                  margin: EdgeInsets.only(right: 10),
                                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),

                                  //注意 如果Container里面加上decoration属性，这个时候color属性必须得放在BoxDecoration
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color.fromRGBO(230, 230, 230, 0.9),
                                  ),

                                  child: Text("4g"),
                                ),
                                Container(
                                  height: ScreenAdapter.height(36),
                                  margin: EdgeInsets.only(right: 10),
                                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color.fromRGBO(230, 230, 230, 0.9),
                                  ),
                                  child: Text("126"),
                                ),
                              ],
                            ),
                            Text("¥${this._productList[index].price}",
                                style:
                                    TextStyle(color: Colors.red, fontSize: 16))
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                Divider(height: 20),
                _showMore(index)
              ],
            );
          },
        ),
      );
    } else {
      //加载中
      return LoadingWidget();
    }
  }

  //显示header Icon
  Widget _showIcon(id) {
    if (id == 2 || id == 3) {
      if (this._subHeaderList[id - 1]["sort"] == 1) {
        return Icon(Icons.arrow_drop_down);
      }
      return Icon(Icons.arrow_drop_up);
    }
    return Text("");
  }

  //导航改变的时候触发
  _subHeaderChange(id) {
    setState(() {
      if (id == 4) {
        _scaffoldKey.currentState.openEndDrawer();
      } else {
        this._sort =
            "${this._subHeaderList[id - 1]["fileds"]}_${this._subHeaderList[id - 1]["sort"]}";

        //重置分页
        this._page = 1;
        //重置数据
        this._productList = [];
        //改变sort排序
        this._subHeaderList[id - 1]['sort'] =
            this._subHeaderList[id - 1]['sort'] * -1;
        //回到顶部
        _scrollController.jumpTo(0);
        //重置_hasMore
        this._hasMore = true;
        //重新请求
        this._getProductListData();
      }
      this._selectHeaderId = id;
    });
  }

  Widget _subHeaderWidget() {
    return Positioned(
      top: 0,
      height: ScreenAdapter.height(80),
      width: ScreenAdapter.width(750),
      child: Container(
        height: ScreenAdapter.height(80),
        width: ScreenAdapter.width(750),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    width: 1, color: Color.fromRGBO(233, 233, 233, 0.9)))),
        child: Row(
            children: this._subHeaderList.map((value) {
          return Expanded(
            flex: 1,
            child: InkWell(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    0, ScreenAdapter.height(16), 0, ScreenAdapter.height(16)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "${value["title"]}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: (this._selectHeaderId == value["id"])
                              ? Colors.red
                              : Colors.black54),
                    ),
                    _showIcon(value["id"])
                  ],
                ),
              ),
              onTap: () {
                _subHeaderChange(value["id"]);
              },
            ),
          );
        }).toList()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('商品列表'),
          actions: <Widget>[Text("")],
        ),
        endDrawer: Drawer(
          child: Container(
            child: Text("data"),
          ),
        ),
        body: Stack(
          children: <Widget>[_productListWidget(), _subHeaderWidget()],
        ));
  }
}
