import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jdshop/services/ScreenAdapter.dart';
import 'package:jdshop/widget/JdText.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';

class ChartPage extends StatefulWidget {
  ChartPage({Key key}) : super(key: key);

  @override
  _ChartPageState createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  List messageList = [];
  IO.Socket socket;
  bool showPhotoAction = false;
  TextEditingController _message = TextEditingController();
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    //和服务器端建立连接
    this.socket = IO.io('http://192.168.8.101:3000?roomid=1', <String, dynamic>{
      'transports': ['websocket'],
      // 'extraHeaders': {'foo': 'bar'} // optional
    });
    this.socket.on('connect', (_) {
      print(
          "================================connect...=========================================");
    });

    this.socket.on('toClient', (data) {
      setState(() {
        this
            .messageList
            .add({"server": true, "title": data["title"], "url": data["url"]});
      });
      //改变滚动条的位置
      this
          ._scrollController
          .jumpTo(this._scrollController.position.maxScrollExtent + 80);
    });
  }

//广播
  _doEmit(value) async {
    this.socket.emit('toServer', {"title": value, "url": ""});
    setState(() {
      //更新本地数据
      this.messageList.add({"server": false, 'title': value, 'url': ""});
    });
    this
        ._scrollController
        .jumpTo(_scrollController.position.maxScrollExtent + 80);
  }

  //拍照
  _takePhoto() async {
    var image =
        await ImagePicker.pickImage(source: ImageSource.camera, maxWidth: 400);
    if (image == null) {
      Fluttertoast.showToast(
        msg: '上传失败',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    } else {
      this._uploadImage(image);
    }
  }

  //拍照
  _openGallery() async {
    var image =
        await ImagePicker.pickImage(source: ImageSource.gallery, maxWidth: 400);
    if (image == null) {
      Fluttertoast.showToast(
        msg: '上传失败',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    } else {
      this._uploadImage(image);
    }
  }

  //上传图片
  _uploadImage(File _imageDir) async {
    //注意：dio3.x版本为了兼容web做了一些修改，上传图片的时候需要把File类型转换成String类型，具体代码如下
    setState(() {
      //更新数据
      this.messageList.add({"server": false, 'title': "", "url": _imageDir});
    });

    var fileDir = _imageDir.path;
    FormData formData = FormData.fromMap(
        {"file": await MultipartFile.fromFile(fileDir, filename: "xxx.jpg")});
    var response = await Dio().post("http://192.168.8.101:3000/imgupload", data: formData);
    var data = response.data;
    var url = "http://192.168.8.101:3000${data['path']}";
    this.socket.emit('toServer', {"title": "", "url": url});
    this
        ._scrollController
        .jumpTo(this._scrollController.position.maxScrollExtent + 80);
    //隐藏键盘
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      this.showPhotoAction = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("客服"),
      ),
      body: Stack(
        children: <Widget>[
          InkWell(
            child: Container(
              padding: EdgeInsets.only(bottom: 100),
              child: ListView.builder(
                controller: this._scrollController,
                itemCount: this.messageList.length,
                itemBuilder: (context, index) {
                  if (this.messageList[index]['server']) {
                    var w;
                    if (this.messageList[index]["url"] != "") {
                      w = Container(
                        alignment: Alignment.centerRight,
                        width: 100,
                        height: 100,
                        child: Image.network(this.messageList[index]["url"]),
                      );
                    } else {
                      w = Text(
                        "${this.messageList[index]['title']}",
                        textAlign: TextAlign.end,
                      );
                    }
                    return ListTile(trailing: Icon(Icons.people), title: w);
                  } else {
                    var w;
                    if (this.messageList[index]["url"] != "") {
                      w = Container(
                        alignment: Alignment.centerLeft,
                        width: 100,
                        height: 100,
                        child:
                            Image.file(this.messageList[index]["url"]), //注意写法
                      );
                    } else {
                      w = Text("${this.messageList[index]['title']}");
                    }
                    return ListTile(leading: Icon(Icons.people), title: w);
                  }
                },
              ),
            ),
            onTap: () {
              setState(() {
                this.showPhotoAction = false;
                //隐藏键盘
                FocusScope.of(context).requestFocus(FocusNode());
              });
            },
          ),
          Positioned(
            bottom: 0,
            width: ScreenAdapter.width(750),
            child: Container(
              decoration: BoxDecoration(color: Colors.white),
              width: ScreenAdapter.width(750),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: JdText(
                          controller: _message,
                          onChanged: (value) {
                            _message.text = value;
                          },
                          onSubmitted: (key) {
                            this._doEmit(_message.text);
                            _message.text = '';
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(1),
                        child: Container(
                          width: ScreenAdapter.width(68),
                          height: ScreenAdapter.height(68),
                          decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(
                                  ScreenAdapter.width(68))),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                this.showPhotoAction = !this.showPhotoAction;
                              });
                            },
                            child: Icon(Icons.add),
                          ),
                        ),
                      )
                    ],
                  ),
                  this.showPhotoAction
                      ? Row(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: IconButton(
                                icon: Icon(Icons.photo_camera),
                                onPressed: () {
                                  this._takePhoto();
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: IconButton(
                                icon: Icon(Icons.photo_library),
                                onPressed: () {
                                  this._openGallery();
                                },
                              ),
                            )
                          ],
                        )
                      : Container(height: 0)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
