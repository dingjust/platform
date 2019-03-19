import 'package:models/models.dart';
import 'package:services/src/user/response/address_response.dart';

abstract class AddressRepository {
  //获取地址列表
  Future<AddressResponse> list(Map<String,dynamic> params);
  //获取地址明细
  Future<AddressModel> detail(String id);
  //创建地址
  Future<String> create(AddressModel form);
  //更新地址
  Future<String> update(AddressModel form);
  //删除地址
  Future<String> delete(String id);
}
