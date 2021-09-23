import 'package:models/models.dart';
import 'package:services/src/state/state.dart';

import '../../../services.dart';

///银行卡状态管理
class BankCardState extends PageState {
  List<BankCardModel> _cards;

  List<BankCardModel> get cards {
    if (_cards == null) {
      getData();
    }
    return _cards;
  }

  @override
  void getData() {
    BankCardRepository.list().then((response) {
      if (response != null && response.code == 1) {
        _cards = response.data;

        ///通知刷新
        notifyListeners();
      }
    });
  }

  @override
  void clear() {
    _cards = null;
    reset();
    notifyListeners();
  }

  @override
  loadMore() {
    // TODO: implement loadMore
    throw UnimplementedError();
  }
}
