import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:models/models.dart';

import 'user_group.dart';

part 'member.g.dart';

/// 会员
@JsonSerializable()
class MembershipModel extends ItemModel {
  CustomerModel? customer;
  CompanyModel? company;
  MemberRating? level;

  MembershipModel(
      {@required this.customer,
      @required this.company,
      this.level = MemberRating.C});

  factory MembershipModel.fromJson(Map<String, dynamic> json) =>
      _$MembershipModelFromJson(json);

  Map<String, dynamic> toJson() => _$MembershipModelToJson(this);
}

/// 会员请求
@JsonSerializable()
class MemberRequestModel extends ItemModel {
  CustomerModel? customer;
  CompanyModel? company;

  MemberRequestModel({@required this.customer, @required this.company});

  factory MemberRequestModel.fromJson(Map<String, dynamic> json) =>
      _$MemberRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$MemberRequestModelToJson(this);
}

/// 会员等级
enum MemberRating { A, B, C }
