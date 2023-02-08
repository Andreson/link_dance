import 'dart:convert';

void main() {
  var params = '?"a"="12"&"b"="15"&"c"="99"';
  var index = params.indexOf("?") + 1;
  params = params
      .substring(index, params.length)
      .split("&")
      .map((param) {
    var keyValue = param.split("=").join(":");
        return keyValue;  }).join(",");
  Map valueMap = jsonDecode("{$params}");
    print("valueMap $valueMap");
    }
