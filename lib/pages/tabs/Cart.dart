import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../provider/Cart.dart';
import '../../provider/CheckOut.dart';
import '../../services/CartServices.dart';
import '../../services/UserServices.dart';
import 'package:provider/provider.dart';
import '../../pages/Cart/CartItem.dart';
import '../../services/ScreenAdapter.dart';

class CartPage extends StatefulWidget {
  CartPage({Key key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  var _isEdit = false;

  var checkOutProvider;
  //结算
  doCheckOut() async {
    //1、获取购物车选中的数据
    List checkOutData = await CartServices.getCheckOutData();

//2、保存购物车选中的数据
    checkOutProvider.changeCheckOutListData(checkOutData);
//3、购物车有没有选中的数据
    if (checkOutData.length > 0) {
      //4、判断用户有没有登录
      var loginState = await UserServices.getUserLoginState();
      if (loginState) {
        Navigator.pushNamed(context, '/checkOut');
      } else {
        Fluttertoast.showToast(
          msg: '您还没有登录，请登录以后再去结算',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
        Navigator.pushNamed(context, '/login');
      }
    } else {
      Fluttertoast.showToast(
        msg: '购物车没有选中的数据',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    var cartProvider = Provider.of<Cart>(context);
    checkOutProvider = Provider.of<CheckOut>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("购物车"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.launch),
            onPressed: () {
              setState(() {
                _isEdit = !_isEdit;
              });
            },
          )
        ],
      ),
      body: cartProvider.cartList.length > 0
          ? Stack(
              children: <Widget>[
                ListView(
                  children: <Widget>[
                    Column(
                        children: cartProvider.cartList.map((f) {
                      return CartItem(f);
                    }).toList()),
                    SizedBox(height: 100)
                  ],
                ),
                Positioned(
                  bottom: 0,
                  width: ScreenAdapter.width(750),
                  height: ScreenAdapter.height(78),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(color: Colors.black12, width: 1)),
                        color: Colors.white),
                    child: Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: ScreenAdapter.width(60),
                                child: Checkbox(
                                  value: cartProvider.isCheckedAll,
                                  activeColor: Colors.pink,
                                  onChanged: (val) {
                                    cartProvider.checkAll(val);
                                  },
                                ),
                              ),
                              Text("全选"),
                              SizedBox(width: 20),
                              this._isEdit == false ? Text("合计：") : Text(""),
                              this._isEdit == false
                                  ? Text("${cartProvider.allPrice}",
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.red))
                                  : Text("")
                            ],
                          ),
                        ),
                        _isEdit == false
                            ? Align(
                                alignment: Alignment.centerRight,
                                child: RaisedButton(
                                  child: Text("结算",
                                      style: TextStyle(color: Colors.white)),
                                  color: Colors.red,
                                  onPressed: doCheckOut,
                                ),
                              )
                            : Align(
                                alignment: Alignment.centerRight,
                                child: RaisedButton(
                                  child: Text("删除",
                                      style: TextStyle(color: Colors.white)),
                                  color: Colors.red,
                                  onPressed: () {
                                    cartProvider.removeItem();
                                  },
                                ),
                              )
                      ],
                    ),
                  ),
                )
              ],
            )
          : Center(
              child: Text("购物车空空的..."),
            ),
    );
  }
}
