import 'package:flutter/material.dart';
class Cart with ChangeNotifier{
  List _cartList=[];
  List get cartList=>this._cartList;
}