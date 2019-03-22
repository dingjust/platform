import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'dto.g.dart';

/// 注册表单DTO
@JsonSerializable()
class CompanyRegisterDTO {
  /// 手机号码
  String mobileNumber;

  ///密码
  String password;

  ///名称
  String name;

  ///联系人
  String contactPerson;

  ///联系电话
  String contactPhone;

  ///地址
  @JsonKey(toJson: _addressToJson)
  AddressModel contactAddress;

  CompanyRegisterDTO(
      {this.mobileNumber,
      this.password,
      this.name,
      this.contactPerson,
      this.contactPhone,
      this.contactAddress});

  static Map<String, dynamic> _addressToJson(AddressModel contactAddress) =>
      AddressModel.toJson(contactAddress);

  factory CompanyRegisterDTO.fromJson(Map<String, dynamic> json) =>
      _$CompanyRegisterDTOFromJson(json);

  static Map<String, dynamic> toJson(CompanyRegisterDTO model) =>
      _$CompanyRegisterDTOToJson(model);
}
