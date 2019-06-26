import 'package:dio/dio.dart';
import 'package:services/services.dart';
import 'package:services/src/bank/bank_response.dart';
import 'package:services/src/net/http_manager.dart';

class BankRepository {
  Future<BankResponse> validateAndCacheCardInfo(String cardNo) async {
    Response response;
    try {
      response = await http$.get(Apis.cnBankCard(cardNo));
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      return BankResponse.fromJson(response.data);
    } else {
      return null;
    }
  }
}
