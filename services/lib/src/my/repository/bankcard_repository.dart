import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/src/api/user.dart';
import 'package:services/src/net/http_manager.dart';

class BankCardRepository {
  ///绑定银行卡
  Future<bool> bindingBankCard(BankCardModel model) async {
    Response response;
    try {
      response = await http$.post(UserApis.bankCard,
          data: BankCardModel.toJson(model),
          options: Options(headers: {'ignoreAlert': 1}));
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  /// 查询公司银行卡
  Future<BankCardModel> getBankCards() async {
    Response response;
    try {
      response = await http$.get(UserApis.bankCard);
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      BankCardModel model = BankCardModel.fromJson(response.data);
      return model;
    } else {
      return null;
    }
  }
}
