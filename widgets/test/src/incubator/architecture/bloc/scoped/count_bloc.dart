import 'dart:async';

class CountBloc{
  int _count = 0;
  var _controller = StreamController<int>.broadcast();

  int get value => _count;

  Stream<int> get stream => _controller.stream;

  increment(){
    _controller.sink.add(++_count);
  }

  dispose(){
    _controller.close();
  }
}
