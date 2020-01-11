import 'package:crypto/crypto.dart';
import 'dart:convert';

class SignServices {
  static getSign(json) {
    var attrKes = json.keys.toList();
    attrKes.sort();
    String addressStr="";
    for (var i = 0; i < attrKes.length; i++) {
      addressStr += "${attrKes[i]}${json[attrKes[i]]}";
    }
    return md5.convert(utf8.encode(addressStr)).toString();
  }
}
