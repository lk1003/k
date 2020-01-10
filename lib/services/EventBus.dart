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
