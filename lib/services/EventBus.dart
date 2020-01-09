import 'package:event_bus/event_bus.dart';

//初始化eventbus
EventBus eventBus = EventBus();

class ProductContentEvent {
  String str;
  ProductContentEvent(String str) {
    this.str = str;
  }
}
