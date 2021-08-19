import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'b2b_group.g.dart';

///部门
@JsonSerializable()
class B2BDeptModel extends ItemModel {
  ///部门名称
  String? name;

  ///排序
  int? sort;

  ///父节点
  List<B2BDeptModel>? parentList;

  ///父节点
  B2BDeptModel? parent;

  ///职能
  List<B2BDeptFunctionType>? functionTypeList;

  ///负责人
  B2BCustomerModel? manager;

  ///下级部门列表
  List<B2BDeptModel>? children;

  ///已删除
  bool? deleted;

  ///所属公司
  CompanyModel? belongTo;

  ///深度
  int? depth;

  ///父节点id
  int? parentId;

  B2BDeptModel(
      {this.name,
      this.sort,
      this.parentList,
      this.parent,
      this.functionTypeList,
      this.manager,
      this.children,
      this.deleted,
      this.belongTo,
      this.depth,
      this.parentId});

  factory B2BDeptModel.fromJson(Map<String, dynamic> json) =>
      _$B2BDeptModelFromJson(json);

  Map<String, dynamic> toJson() => _$B2BDeptModelToJson(this);
}

///部门职能
enum B2BDeptFunctionType {
  ///管理类
  MANAGER,

  ///商品类
  PRODUCT,

  ///销售类
  MARKET,

  ///生产类
  PRODUCTION,

  ///采购类
  PURCHASE,

  ///财务类
  FINANCE
}

///部门职能
const B2BDeptFunctionTypeLocalizedMap = {
  B2BDeptFunctionType.MANAGER: "管理类",
  B2BDeptFunctionType.PRODUCT: "商品类",
  B2BDeptFunctionType.MARKET: "销售类",
  B2BDeptFunctionType.PRODUCTION: "生产类",
  B2BDeptFunctionType.PURCHASE: "采购类",
  B2BDeptFunctionType.FINANCE: "财务类"
};
