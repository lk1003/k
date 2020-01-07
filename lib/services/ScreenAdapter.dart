import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScreenAdapter {
  static init(context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
  }

  static height(double height) {
    return ScreenUtil.getInstance().setHeight(height);
  }

  static width(double width) {
    return ScreenUtil.getInstance().setWidth(width);
  }

  static getScreenHeight() {
    return ScreenUtil.screenHeightDp;
  }

  static getScreenWidth() {
    return ScreenUtil.screenWidthDp;
  }

  static size(double value){
   return ScreenUtil.getInstance().setSp(value);  
  }
}
