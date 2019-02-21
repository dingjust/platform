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
export 'src/order/invoice.dart';
export 'src/wechat/wechat.dart';
export 'src/widget/widgets.dart';

part 'models.g.dart';

abstract class ItemModel {
  int id;
}

/// 枚举
@JsonSerializable()
class EnumModel {
  final String code;
  final String name;

  const EnumModel(this.code, this.name);

  factory EnumModel.fromJson(Map<String, dynamic> json) =>
      _$EnumModelFromJson(json);

  static Map<String, dynamic> toJson(EnumModel model) =>
      _$EnumModelToJson(model);
}

///根据code获取name
String enumMap(dynamic enumModels,String code){
  String text = '';
  EnumModel model = enumModels.firstWhere((enumModel) => enumModel.code == code,orElse: () => null);
  if(model != null){
    text = model.name;
  }
  return text;
}

///风格
const StyleEnum = <EnumModel>[
  EnumModel('FG0001', '潮流'),
  EnumModel('FG0002', '简约'),
  EnumModel('FG0003', '都市'),
  EnumModel('FG0004', '复古休闲'),
  EnumModel('FG0005', '运动'),
  EnumModel('FG0006', '甜美'),
  EnumModel('FG0007', '田园'),
  EnumModel('FG0008', '淑女'),
  EnumModel('FG0009', '民族'),
  EnumModel('FG0010', '学院'),
  EnumModel('FG0011', '布衣'),
  EnumModel('FG0012', '中性'),
  EnumModel('FG0013', 'OL'),
  EnumModel('FG0014', '日系'),
  EnumModel('FG0015', '韩版'),
  EnumModel('FG0016', '欧美'),
  EnumModel('FG0017', '中国风'),
  EnumModel('FG0018', '商务'),
  EnumModel('FG0019', '英伦'),
  EnumModel('FG0020', '街头'),
  EnumModel('FG0021', '户外'),
  EnumModel('FG0022', '波西米亚'),
  EnumModel('FG0023', '工装'),
];

///面料成分
const FabricCompositionEnum = <EnumModel>[
  EnumModel('B001', '纯棉'),
  EnumModel('B002', '涤纶'),
  EnumModel('B003', '锦纶（尼龙）'),
  EnumModel('B004', '麻'),
  EnumModel('B005', '氨纶'),
  EnumModel('B006', '腈纶'),
  EnumModel('B007', '羊绒/羊毛'),
  EnumModel('B008', '海马毛'),
  EnumModel('B009', '羊驼毛'),
  EnumModel('B010', 'PU'),
  EnumModel('B011', '真皮'),
  EnumModel('B012', '其他'),
  EnumModel('B013', '棉麻'),
];

///版型
const EditionTypeEnum = <EnumModel>[
  EnumModel('C001', '紧身'),
  EnumModel('C002', '修身'),
  EnumModel('C003', '合体'),
  EnumModel('C004', '宽松'),
];

///款式
const PatternEnum = <EnumModel>[
  EnumModel('D001', '双面款'),
  EnumModel('D002', '假两件'),
  EnumModel('D003', '常规款'),
  EnumModel('D004', '短款'),
  EnumModel('D005', '中长款'),
  EnumModel('D006', '加长款'),
];

/// 袖型
const SleeveTypeEnum = <EnumModel>[
  EnumModel('E001', '蝙蝠袖'),
  EnumModel('E002', '插肩袖/连肩袖'),
  EnumModel('E003', '常规袖'),
  EnumModel('E004', '罗文收口袖'),
  EnumModel('E005', '牛角袖'),
  EnumModel('E006', '泡泡袖'),
  EnumModel('E007', '荷叶袖'),
  EnumModel('E008', '灯笼袖'),
  EnumModel('E009', '羊腿袖'),
  EnumModel('E010', '和服袖'),
  EnumModel('E011', '其他'),
];

/// 袖长/裤腿
const SleeveLengthEnum = <EnumModel>[
  EnumModel('F001', '中袖/五分袖'),
  EnumModel('F002', '无袖'),
  EnumModel('F003', '盖肩袖'),
  EnumModel('F004', '七分袖'),
  EnumModel('F005', '短袖'),
  EnumModel('F006', '长袖'),
  EnumModel('F007', '九分袖'),
  EnumModel('F008', '加长袖'),
  EnumModel('F009', '其他'),
];

/// 图案
const DecorativePatternEnum = <EnumModel>[
  EnumModel('G001', '几何'),
  EnumModel('G002', '纯色'),
  EnumModel('G003', '动物'),
  EnumModel('G004', '字母/数字/文字'),
  EnumModel('G005', '动漫/卡通'),
  EnumModel('G006', '涂鸦'),
  EnumModel('G007', '植物'),
  EnumModel('G008', '头像'),
  EnumModel('G009', '格子'),
  EnumModel('G010', '拼接色'),
  EnumModel('G011', '迷彩'),
  EnumModel('G012', '条纹'),
  EnumModel('G013', '其他'),
];

/// 流行元素
const PopularElementsEnum = <EnumModel>[
  EnumModel('H001', '铆钉'),
  EnumModel('H002', '亮片'),
  EnumModel('H003', '拉链'),
  EnumModel('H004', '流苏'),
  EnumModel('H005', '镂空'),
  EnumModel('H006', '绣花'),
  EnumModel('H007', '镶钻'),
  EnumModel('H008', '做旧/洗水'),
  EnumModel('H009', '印花'),
  EnumModel('H010', '植绒'),
  EnumModel('H011', '蕾丝'),
  EnumModel('H012', '其他'),
];

/// 填充物
const FillerEnum = <EnumModel>[
  EnumModel('J001', '鸭绒'),
  EnumModel('J002', '鹅绒'),
  EnumModel('J003', '洗水棉'),
  EnumModel('J004', '珍珠棉'),
  EnumModel('J005', '太空棉'),
  EnumModel('J006', '涤纶棉'),
];

/// 厚薄
const ThicknessEnum = <EnumModel>[
  EnumModel('K001','薄款'),
  EnumModel('K002','适中'),
  EnumModel('K003','加厚'),
  EnumModel('K004','加绒'),
  EnumModel('K005','抓绒'),
  EnumModel('K006','毛内胆'),
  EnumModel('K007','棉棉内胆'),
];

/// 季节
const SeasonEnum = <EnumModel>[
  EnumModel('L001','春季'),
  EnumModel('L002','夏季'),
  EnumModel('L003','秋季'),
  EnumModel('L004','冬季'),
  EnumModel('L005','春夏'),
  EnumModel('L006','秋冬'),
  EnumModel('L007','四季'),
];

/// 门襟
const PlacketEnum = <EnumModel>[
  EnumModel('M001','拉链'),
  EnumModel('M001','单排扣'),
  EnumModel('M001','双排扣'),
  EnumModel('M001','暗扣'),
  EnumModel('M001','牛角扣'),
];

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

  factory PaginationData.fromJson(Map<String, dynamic> json) =>
      _$PaginationDataFromJson(json);

  static Map<String, dynamic> toJson(PaginationData model) =>
      _$PaginationDataToJson(model);
}
