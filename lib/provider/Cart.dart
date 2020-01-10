import 'package:flutter/material.dart';
import 'dart:convert';
import '../services/Storage.dart';

class Cart with ChangeNotifier {

  List _cartList = []; //状态
  bool _isCheckedAll = false; //是否全选
  double _allPrice = 0; //总价

  Cart() {
    this.init();
  }

  List get cartList => this._cartList;
  bool get isCheckedAll => this._isCheckedAll; //
  double get allPrice => this._allPrice; //

  //初始化的时候获取购物车数据
  init() async {
    try {
      List cartListData = json.decode(await Storage.getString('cartList'));
      this._cartList = cartListData;
    } catch (e) {
      this._cartList = [];
    }
    this._isCheckedAll = isCheckAll();
     computeAllPrice();
    notifyListeners();
  }

  updateCartList() {
    this.init();
  }

  itemCountChange() {
    Storage.setString("cartList", json.encode(this._cartList));
     computeAllPrice();
    notifyListeners();
  }

//全选反选
  checkAll(value) {
    for (var i = 0; i < _cartList.length; i++) {
      _cartList[i]["checked"] = value;
    }

    this._isCheckedAll = value;
     computeAllPrice();
    Storage.setString("cartList", json.encode(this._cartList));
    notifyListeners();
  }

  //判断是否全选
  bool isCheckAll() {
    if (_cartList.length > 0) {
      for (var i = 0; i < _cartList.length; i++) {
        if (_cartList[i]["checked"] == false) {
          return false;
        }
      }
      return true;
    }
    return false;
  }

  //监听每一项的选中事件
  itemChange() {
    if (isCheckAll() == true) {
      this._isCheckedAll = true;
    } else {
      this._isCheckedAll = false;
    }
    computeAllPrice();
    Storage.setString("cartList", json.encode(this._cartList));
    notifyListeners();
  }

  //计算总价
  computeAllPrice(){
    double tempAllPrice=0;
     for (var i = 0; i < _cartList.length; i++) {
        if (_cartList[i]["checked"] == true) {
          tempAllPrice+=_cartList[i]["price"]*_cartList[i]["count"];
        }
      }
      _allPrice=tempAllPrice;
      notifyListeners();
  }

  //删除数据
  removeItem() {
    List tempList=[];
    for (var i = 0; i < this._cartList.length; i++) {
      if (this._cartList[i]["checked"] == false) {
         tempList.add(this._cartList[i]);
      }
    }
    this._cartList=tempList;
    //计算总价
    this.computeAllPrice();
    Storage.setString("cartList", json.encode(this._cartList));
    notifyListeners();
  }
}
