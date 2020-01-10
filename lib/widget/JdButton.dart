import 'package:flutter/material.dart';
import 'package:jdshop/services/ScreenAdapter.dart';

class JdButton extends StatelessWidget {
  final Color color;
  final String text;
  final Object cb;
  final double height;
  const JdButton(
      {Key key,
      this.color = Colors.black,
      this.text = "按钮",
      this.cb = null,
      this.height = 68})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    return InkWell(
      onTap: cb,
      child: Container(
        height: ScreenAdapter.height(this.height),
        width: double.infinity,
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
            child: Text(
          text,
          style: TextStyle(color: Colors.white),
        )),
      ),
    );
  }
}
