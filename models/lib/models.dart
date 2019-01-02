library models;

import 'package:json_annotation/json_annotation.dart';

export 'src/media/media.dart';
export 'src/order/order.dart';
export 'src/product/product.dart';
export 'src/report/report.dart';
export 'src/security/principal.dart';
export 'src/system/notification/message.dart';
export 'src/user/member.dart';
export 'src/user/user.dart';
export 'src/user/user_group.dart';

part 'models.g.dart';

abstract class ItemModel {
  int pk;
}

/// 枚举
@JsonSerializable()
class EnumModel {
  final String code;
  final String name;

  const EnumModel(this.code, this.name);

  factory EnumModel.fromJson(Map<String, dynamic> json) => _$EnumModelFromJson(json);

  static Map<String, dynamic> toJson(EnumModel model) => _$EnumModelToJson(model);
}

/// 分页数据
@JsonSerializable()
class PaginationData {
  int currentPage;
  int pageSize;
  int numberOfPages;
  int totalNumberOfResults;
  bool needsTotal;

  PaginationData({
    this.currentPage,
    this.pageSize,
    this.numberOfPages,
    this.totalNumberOfResults,
    this.needsTotal,
  });

  factory PaginationData.fromJson(Map<String, dynamic> json) => _$PaginationDataFromJson(json);

  static Map<String, dynamic> toJson(PaginationData model) => _$PaginationDataToJson(model);
}
