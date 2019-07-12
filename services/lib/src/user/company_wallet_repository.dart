import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:services/src/user/address_repository.dart';

//钱包服务接口
class CompanyWalletRepository{
  const CompanyWalletRepository();

  ///获取当前登录公司钱包
  @override
  Future<CompanyWalletModel> getWallet() async {
    Response response = await http$.get(UserApis.getCompanyWallet);
    return CompanyWalletModel.fromJson(response.data);
  }

}
