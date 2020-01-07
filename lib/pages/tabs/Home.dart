import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:jdshop/model/ProductModel.dart';
import '../../services/ScreenAdapter.dart';
import '../../config/Config.dart';
import 'package:dio/dio.dart';

//轮播图类模型
import '../../model/FocusModel.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin{
  List _focusData = [];
  List _hotProductList = [];
  List _bestProductList = [];

 

  @override
  void initState() {
    super.initState();
    _getFocusData();
    _getHotProductData();
    _getBestProductData();
  }

  //获取轮播图数据
  _getFocusData() async {
    var api = '${Config.domain}api/focus';
    var result = await Dio().get(api);
    var focusList = FocusModel.fromJson(result.data);
    setState(() {
      this._focusData = focusList.result;
    });
  }

  //获取猜你喜欢得数据
  _getHotProductData() async {
    var api = '${Config.domain}api/plist?is_hot=1';
    var result = await Dio().get(api);
    var hotProductList = ProductModel.fromJson(result.data);
    setState(() {
      this._hotProductList = hotProductList.result;
    });
  }

  //获取热门列表得数据
  _getBestProductData() async {
    var api = '${Config.domain}api/plist?is_best=1';
    var result = await Dio().get(api);
    var bestProductList = ProductModel.fromJson(result.data);
    setState(() {
      this._bestProductList = bestProductList.result;
    });
  }

  //轮播图
  Widget _swiperWidget() {
    if (_focusData.length > 0) {
      return Container(
        child: AspectRatio(
          aspectRatio: 2 / 1,
          child: Swiper(
            itemBuilder: (BuildContext context, int index) {
              String pic = this._focusData[index].pic;
              return new Image.network(
                  "http://jd.itying.com/${pic.replaceAll('\\', '/')}",
                  fit: BoxFit.fill);
            },
            itemCount: this._focusData.length,
            pagination: new SwiperPagination(),
            autoplay: true,
          ),
        ),
      );
    } else {
      return Text("加载中……");
    }
  }

  Widget _titleWidget(value) {
    return Container(
      height: ScreenAdapter.height(32),
      margin: EdgeInsets.only(left: ScreenAdapter.width(20)),
      padding: EdgeInsets.only(left: ScreenAdapter.width(20)),
      decoration: BoxDecoration(
          border: Border(
              left: BorderSide(
                  color: Colors.red, width: ScreenAdapter.width(10)))),
      child: Text(value, style: TextStyle(color: Colors.black54)),
    );
  }

//猜你喜欢
  Widget _hotProductListWidget() {
    if (this._hotProductList.length > 0) {
      return Container(
        height: ScreenAdapter.height(234),
        padding: EdgeInsets.all(ScreenAdapter.width(20)),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: this._hotProductList.length,
          itemBuilder: (context, index) {
            String sPic = this._hotProductList[index].sPic;
            sPic = Config.domain + sPic.replaceAll("\\", "/");
            return Column(
              children: <Widget>[
                Container(
                  height: ScreenAdapter.height(140),
                  width: ScreenAdapter.width(140),
                  margin: EdgeInsets.only(right: ScreenAdapter.width(21)),
                  child: Image.network(sPic, fit: BoxFit.cover),
                ),
                Container(
                    padding: EdgeInsets.only(top: ScreenAdapter.height(10)),
                    height: ScreenAdapter.height(44),
                    child: Text("￥${this._hotProductList[index].price}",
                        style: TextStyle(color: Colors.red)))
              ],
            );
          },
        ),
      );
    } else {
      return Text("加载中……");
    }
  }

  //推荐商品
  Widget _recProductListWidget() {
    var itemWidth = (ScreenAdapter.getScreenWidth() - 30) / 2;

    return Container(
      padding: EdgeInsets.all(10),
      child: Wrap(
        runSpacing: 10,
        spacing: 10,
        children: this._bestProductList.map((value) {
          //图片
          String sPic = value.sPic;
          sPic = Config.domain + sPic.replaceAll('\\', '/');
          return Container(
            padding: EdgeInsets.all(10),
            width: itemWidth,
            decoration: BoxDecoration(
                border: Border.all(
                    color: Color.fromRGBO(233, 233, 233, 0.9), width: 1)),
            child: Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  child: AspectRatio(
                    //防止服务器返回的图片大小不一致导致高度不一致问题
                    aspectRatio: 1 / 1,
                    child: Image.network(sPic, fit: BoxFit.cover),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: ScreenAdapter.height(20)),
                  child: Text("${value.title}",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.black54)),
                ),
                Padding(
                  padding: EdgeInsets.only(top: ScreenAdapter.height(20)),
                  child: Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("¥${value.price}",
                            style: TextStyle(color: Colors.red, fontSize: 16)),
                      ),
                      Align(
                          alignment: Alignment.centerRight,
                          child: Text("¥${value.oldPrice}",
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14,
                                  decoration: TextDecoration.lineThrough)))
                    ],
                  ),
                )
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    return ListView(
      children: <Widget>[
        _swiperWidget(),
        SizedBox(height: ScreenAdapter.height(10)),
        _titleWidget("猜你喜欢"),
        SizedBox(height: ScreenAdapter.height(10)),
        _hotProductListWidget(),
        _titleWidget("热门推荐"),
        _recProductListWidget()
      ],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}