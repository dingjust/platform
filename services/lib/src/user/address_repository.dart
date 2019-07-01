import 'package:models/models.dart';
import 'package:services/src/user/response/address_response.dart';

abstract class AddressRepository {
  //获取地址列表
  Future<List<AddressModel>> list();
  //获取地址明细
  Future<AddressModel> detail(String id);
  //创建地址
  Future<bool> create(AddressModel form);
  //更新地址
  Future<bool> update(AddressModel form);
  //删除地址
  Future<String> delete(String id);
}
