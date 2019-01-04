import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  StreamController<int> controller = StreamController();

/*  controller.stream.listen((data) => print(data));

  controller.sink.add(1);
  controller.sink.add(1110);*/

  //转化后的流
  final transform =
      StreamTransformer<int, String>.fromHandlers(handleData: (value, sink) {
    if (value == 100) {
      sink.add('恭喜你猜对了！');
    } else {
      sink.addError('还没猜中，再试一次吧');
    }
  });

  controller.stream.transform(transform).listen(
        (data) => print(data),
        onError: (err) => print(err),
      );
//controller.sink.add(23);
  controller.add(100);

  /*
  * 广播流
  * */
  Stream stream = StreamController().stream.asBroadcastStream();
  
  stream.listen((data) => print(data));
  stream.listen((data) => print(data));

  controller.sink.add(100);

}
