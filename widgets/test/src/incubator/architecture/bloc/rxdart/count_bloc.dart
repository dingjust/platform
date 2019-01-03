import 'dart:async';
import 'package:rxdart/rxdart.dart';

class CountBloc{
  int _count = 0;
  var _subject = BehaviorSubject<int>();

  int get value => _count;

  Stream<int> get stream => _subject.stream;

  increment(){
    _subject.add(++_count);
  }

  dispose(){
    _subject.close();
  }
}
