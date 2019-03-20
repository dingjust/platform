import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:services/src/user/address_repository.dart';
import 'package:services/src/user/response/address_response.dart';
import 'user_repository.dart';
import 'package:dio/dio.dart';

class AddressRepositoryImpl implements AddressRepository {
  const AddressRepositoryImpl();

  @override
  Future<AddressResponse> list(Map<String, dynamic> params) async{
    Response response = await http$.get(UserApis.addresses,data: params);
    return AddressResponse.fromJson(response.data);
  }

  @override
  Future<AddressModel> detail(String id) async{
    Response response = await http$.get(UserApis.getAddress(id));
    return AddressModel.fromJson(response.data);
  }

  @override
  Future<String> create(AddressModel form) async{
    Response response = await http$.post(UserApis.addressCreate,data: AddressModel.toJson(form));
    return response.data;
  }

  @override
  Future<String> update(AddressModel form) async{
    Response response = await http$.put(UserApis.addressUpdate,data: AddressModel.toJson(form));
    return response.data;
  }

  @override
  Future<String> delete(String id) async{
    Response response = await http$.delete(UserApis.addressDelete(id));
    return response.data;
  }
}
