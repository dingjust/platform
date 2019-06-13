import 'package:services/src/bank/bank_name_map.dart';
import 'package:services/src/bank/bank_repository.dart';
import 'package:services/src/bank/bank_response.dart';

class BankService {
  Future<BankResponse> getCardInfo(String cardNo) async {
    BankResponse response =
        await BankRepository().validateAndCacheCardInfo(cardNo);
    if (response != null) {
      response.bankName = BankNameMap[response.bank];
    }
    return response;
  }
}
