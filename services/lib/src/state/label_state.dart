import 'package:models/models.dart';
import 'package:services/src/user/user_repository_impl.dart';

class LabelState {
  List<LabelModel> _labels;

  Future<List<LabelModel>> getLabels() async {
    if (_labels == null) {
      //获取所有标签
      _labels = await UserRepositoryImpl().labels();
      return _labels;
    } else {
      return _labels;
    }
  }
}
