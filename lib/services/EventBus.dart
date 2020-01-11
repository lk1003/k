import 'package:event_bus/event_bus.dart';

//初始化eventbus
EventBus eventBus = EventBus();

//商品详情广播数据
class ProductContentEvent {
  String str;
  ProductContentEvent(String str) {
    this.str = str;
  }
}

//用户中心广播
class UserEvent {
  String str;
  UserEvent(String str) {
    this.str = str;
  }
}

//地址广播
class AddressEvent{
  String str;
  AddressEvent(String str){
    this.str=str;
  }
}


//修改地址广播
class CheckOutEvent{
  String str;
  CheckOutEvent(String str){
    this.str=str;
  }
}
