import 'package:scoped_model/scoped_model.dart';

class CountModel extends Model {
  int _count = 0;

  get count => _count;

  //状态发生变化
  void increment() {
    _count++;
    //通知所有model子项更新状态
    notifyListeners();
  }
}