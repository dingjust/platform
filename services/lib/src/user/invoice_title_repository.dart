import 'package:models/models.dart';
import 'package:services/src/user/response/address_response.dart';

abstract class InvoiceTitleRepository {
  //获取发票抬头列表
  Future<List<InvoiceTitleModel>> list();
  //获取发票抬头明细
  Future<InvoiceTitleModel> detail(int id);
  //创建发票抬头
  Future<String> create(InvoiceTitleModel form);
  //更新发票抬头
  Future<String> update(InvoiceTitleModel form);
  //删除发票抬头
  Future<String> delete(int id);
}
