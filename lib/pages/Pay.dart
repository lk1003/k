import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jdshop/widget/JdButton.dart';
import 'package:sy_flutter_alipay/sy_flutter_alipay.dart';
import 'package:sy_flutter_wechat/sy_flutter_wechat.dart';

class PayPage extends StatefulWidget {
  PayPage({Key key}) : super(key: key);

  @override
  _PayPageState createState() => _PayPageState();
}

class _PayPageState extends State<PayPage> {

 @override
  void initState() {
    super.initState();
    // _register();
  }

  // _register() async {
  //   bool result = await SyFlutterWechat.register('wx5881fa2638a2ca60');
  //   print(result);
  // }
  var isWx = 0;
  List payList = [
    {
      "title": "支付宝支付",
      "chekced": true,
      "image": "https://www.itying.com/themes/itying/images/alipay.png"
    },
    {
      "title": "微信支付",
      "chekced": false,
      "image": "https://www.itying.com/themes/itying/images/weixinpay.png"
    }
  ];

  _pay() async {
    if (this.isWx == 0) {
      //支付宝
      // var serverApi="http://agent.itying.com/alipay/";

      // var serverData=await Dio().get(serverApi);

      // var payInfo=serverData.data;
      // var result = await SyFlutterAlipay.pay(
      //     payInfo,
      //     // urlScheme: '你的ios urlScheme', //前面配置的urlScheme
      //     // isSandbox: true //是否是沙箱环境，只对android有效
      // );
      // print(result);
    } else {
      //微信
      // var apiUrl = 'http://agent.itying.com/wxpay/';
      // var myPayInfo = await Dio().get(apiUrl);
      // Map myInfo = json.decode(myPayInfo.data);
      // print(myInfo);

      // var payInfo = {
      //   "appid": myInfo["appid"].toString(),
      //   "partnerid": myInfo["partnerid"].toString(),
      //   "prepayid": myInfo["prepayid"].toString(),
      //   "package": myInfo["package"].toString(),
      //   "noncestr": myInfo["noncestr"].toString(),
      //   "timestamp": myInfo["timestamp"].toString(),
      //   "sign": myInfo["sign"].toString(),
      // };
      // SyPayResult payResult =
      //     await SyFlutterWechat.pay(SyPayInfo.fromJson(payInfo));

      // print(payResult);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('去支付'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 400,
            padding: EdgeInsets.all(20),
            child: ListView.builder(
              itemCount: payList.length,
              itemBuilder: (context, index) {
                return Column(
                  children: <Widget>[
                    ListTile(
                      leading: Image.network("${this.payList[index]["image"]}"),
                      title: Text("${this.payList[index]["title"]}"),
                      trailing: this.payList[index]["chekced"]
                          ? Icon(Icons.check)
                          : Text(""),
                      onTap: () {
                        setState(() {
                          for (var i = 0; i < this.payList.length; i++) {
                            this.payList[i]["chekced"] = false;
                          }
                          this.payList[index]["chekced"] = true;
                          this.isWx = index;
                        });
                      },
                    ),
                    Divider()
                  ],
                );
              },
            ),
          ),
          JdButton(
            text: '支付',
            color: Colors.red,
            cb: _pay,
          )
        ],
      ),
    );
  }
}
