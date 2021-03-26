library models;

import 'package:json_annotation/json_annotation.dart';

export 'src/audit/audit_work_order.dart';
export 'src/auth/authorization.dart';
export 'src/capacity/capacity.dart';
export 'src/doc/doc_signature.dart';
export 'src/info/sales_order_refund_info.dart';
export 'src/media/media.dart';
export 'src/msg/msg.dart';
export 'src/my/guideline.dart';
export 'src/my/wallet.dart';
export 'src/order/delivery_order.dart';
export 'src/order/finance.dart';
export 'src/order/invoice.dart';
export 'src/order/order.dart';
export 'src/order/order_note.dart';
export 'src/order/payment_order.dart';
export 'src/product/materiel_product.dart';
export 'src/product/product.dart';
export 'src/production_plan/color_size_entry.dart';
export 'src/production_plan/outbound_order.dart';
export 'src/production_plan/production_order.dart';
export 'src/production_plan/production_work.dart';
export 'src/production_plan/progress_plan.dart';
export 'src/production_plan/progress_work_sheet_order.dart';
export 'src/report/report.dart';
export 'src/security/principal.dart';
export 'src/shared/shared.dart';
export 'src/subcontract/subcontract.dart';
export 'src/system/notification/message.dart';
export 'src/system/page/carousel.dart';
export 'src/system/page/plate_products.dart';
export 'src/user/b2b_group.dart';
export 'src/user/cooperator.dart';
export 'src/user/dto.dart';
export 'src/user/integral.dart';
export 'src/user/member.dart';
export 'src/user/user.dart';
export 'src/user/user_group.dart';
export 'src/user_agreement/user_agreement.dart';
export 'src/wechat/wechat.dart';
export 'src/widget/widgets.dart';

part 'models.g.dart';

abstract class ItemModel {
  int id;

// StatisticsModel statistics;
}

/// 统计
@JsonSerializable()
class StatisticsModel {
  int viewStatistics;

  int showStatistics;

  StatisticsModel({this.viewStatistics, this.showStatistics});

  factory StatisticsModel.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$StatisticsModelFromJson(json);

  static Map<String, dynamic> toJson(StatisticsModel model) =>
      model == null ? null : _$StatisticsModelToJson(model);
}

/// 枚举
@JsonSerializable()
class EnumModel {
  final dynamic code;
  final String name;

  const EnumModel(this.code, this.name);

  factory EnumModel.fromJson(Map<String, dynamic> json) =>
      _$EnumModelFromJson(json);

  static Map<String, dynamic> toJson(EnumModel model) =>
      _$EnumModelToJson(model);
}

///根据code获取name
String enumMap(dynamic enumModels, dynamic code) {
  if (code == null) {
    return '';
  }
  String text = '';
  EnumModel model = enumModels.firstWhere((enumModel) => enumModel.code == code,
      orElse: () => null);
  if (model != null) {
    text = model.name;
  }
  return text;
}

List<EnumModel> enumCodesToModels(List<String> codes, dynamic enumModels) {
  return codes.map((code) {
    return enumModels.firstWhere((enumModel) => enumModel.code == code,
        orElse: () => null);
    ;
  }).toList();
}

List<String> enumCodesToNames(List<String> codes, dynamic enumModels) {
  List<String> names = codes.map((code) {
    EnumModel model = enumModels
        .firstWhere((enumModel) => enumModel.code == code, orElse: () => null);
    if (model != null) {
      return model.name;
    } else {
      return null;
    }
  }).toList();
//
//  if(codes.length > count){
//    names = names.sublist(0,count);
//  }

  return names;
}

//格式选中的枚举（多选）
String formatEnumSelectsText(
    List<String> codes, List<EnumModel> enumModels, int count,
    {String customText}) {
  String text = '';
  if (customText != null && (codes == null || codes.length == 0)) {
    return customText;
  }

  if (codes != null) {
    text = '';
    for (int i = 0; i < codes.length; i++) {
      if (i > count - 1) {
        text += '...';
        break;
      }

      if (i == codes.length - 1) {
        text += enumMap(enumModels, codes[i]);
      } else {
        text += enumMap(enumModels, codes[i]) + '、';
      }
    }
  }

  return text;
}

//格式选中的枚举（单选）
String formatEnumSelectText(List<EnumModel> enumModels, List<String> enumCode) {
  String text = '';
  if (enumCode.isNotEmpty) text = enumMap(enumModels, enumCode[0]);
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
  EnumModel('K001', '薄款'),
  EnumModel('K002', '适中'),
  EnumModel('K003', '加厚'),
  EnumModel('K004', '加绒'),
  EnumModel('K005', '抓绒'),
  EnumModel('K006', '毛内胆'),
  EnumModel('K007', '棉棉内胆'),
];

/// 季节
const SeasonEnum = <EnumModel>[
  EnumModel('L001', '春季'),
  EnumModel('L002', '夏季'),
  EnumModel('L003', '秋季'),
  EnumModel('L004', '冬季'),
  EnumModel('L005', '春夏'),
  EnumModel('L006', '秋冬'),
  EnumModel('L007', '四季'),
];

//吊牌
const TaggableEnum = <EnumModel>[
  EnumModel('true', '有'),
  EnumModel('false', '沒有'),
];

/// 门襟
const PlacketEnum = <EnumModel>[
  EnumModel('M001', '拉链'),
  EnumModel('M002', '单排扣'),
  EnumModel('M003', '双排扣'),
  EnumModel('M004', '暗扣'),
  EnumModel('M005', '牛角扣'),
];

///省份
const ProvinceEnum = <EnumModel>[
  EnumModel('P01', '北京市'),
  EnumModel('P02', '天津市'),
  EnumModel('P03', '上海市'),
  EnumModel('P04', '重庆市'),
  EnumModel('P05', '河北省'),
  EnumModel('P06', '河南省'),
  EnumModel('P07', '云南省'),
  EnumModel('P08', '辽宁省'),
  EnumModel('P09', '黑龙江省'),
  EnumModel('P10', '湖南省'),
  EnumModel('P11', '安徽省'),
  EnumModel('P12', '山东省'),
  EnumModel('P13', '新疆维吾尔...'),
  EnumModel('P14', '江苏省'),
  EnumModel('P15', '浙江省'),
  EnumModel('P16', '江西省'),
  EnumModel('P17', '广西壮族...'),
  EnumModel('P18', '甘肃省'),
  EnumModel('P19', '山西省'),
  EnumModel('P20', '内蒙古'),
  EnumModel('P21', '陕西省'),
  EnumModel('P22', '吉林省'),
  EnumModel('P23', '福建省'),
  EnumModel('P24', '贵州省'),
  EnumModel('P25', '广东省'),
  EnumModel('P26', '青海省'),
  EnumModel('P27', '西藏'),
  EnumModel('P28', '四川省'),
  EnumModel('P29', '宁夏回族...'),
  EnumModel('P30', '海南省'),
  EnumModel('P31', '台湾省'),
  EnumModel('P32', '香港'),
  EnumModel('P33', '澳门'),
];

//产值规模
const ScaleRangesEnum = <EnumModel>[
  EnumModel('SR001', '0-100万'),
  EnumModel('SR002', '100万-500万'),
  EnumModel('SR003', '500万-1000万'),
  EnumModel('SR004', '1000万-5000万'),
  EnumModel('SR005', '5000万以上'),
];

//年龄段
const AgeRangesEnum = <EnumModel>[
  EnumModel('AR001', '0-6'),
  EnumModel('AR002', '7-12'),
  EnumModel('AR003', '13-17'),
  EnumModel('AR004', '18-23'),
  EnumModel('AR005', '24-30'),
  EnumModel('AR006', '31-40'),
  EnumModel('AR007', '41以上'),
];

//价格段
const PriceRangesEnum = <EnumModel>[
  EnumModel('PR001', '0-60'),
  EnumModel('PR002', '61-120'),
  EnumModel('PR003', '121-200'),
  EnumModel('PR004', '201-300'),
  EnumModel('PR005', '301-500'),
  EnumModel('PR006', '500以上'),
];

const MonthlyCapacityRangesEnum = <EnumModel>[
  EnumModel('MCR001', '0-5000件'),
  EnumModel('MCR002', '5000-10000件'),
  EnumModel('MCR003', '10000-30000件'),
  EnumModel('MCR004', '30000件以上'),
];

const PopulationScaleEnum = <EnumModel>[
  EnumModel('N01', '50人以下'),
  EnumModel('N02', '51~100人'),
  EnumModel('N03', '101到200人'),
  EnumModel('N04', '200人以上'),
];

//合作方式枚举
const CooperationModesEnum = <EnumModel>[
  EnumModel('LIGHT_PROCESSING', '清加工'),
  EnumModel('LABOR_AND_MATERIAL', '包工包料'),
];

///数字枚举
const DightEnum = <EnumModel>[
  EnumModel(1, '一'),
  EnumModel(2, '二'),
  EnumModel(3, '三'),
];

//生产模式
const ProductionModesEnum = <EnumModel>[
  EnumModel('SINGLE_PIECE_PRODUCTION_LINE', '单件流水生产线'),
  EnumModel('HANGING_PRODUCTION_LINE', '吊挂生产流水线'),
  EnumModel('PIPELINE_PRODUCTION_LINE', '扎流生产线'),
];

//裁剪部
const CuttingDepartmentsEnum = <EnumModel>[
  EnumModel('COMPUTER_AUTOMATIC_CUTTING_MACHINE', '电脑全自动裁床'),
  EnumModel('MANUAL_BED_CUTTING', '手工裁床'),
  EnumModel('FULLY_AUTOMATIC_BROACHING_MACHINE', '全自动拉布机'),
  EnumModel('SHRINKING_MACHINE', '缩水机'),
  EnumModel('PRESSING_MACHINE', '压朴机'),
  EnumModel('PLATE_CHANGING_MACHINE', '改板机'),
  EnumModel('LOOSENING_MACHINE', '松布机'),
  EnumModel('CLOTH_INSPECTING_MACHINE', '验布机'),
];

//生产车间
const ProductionWorkshopsEnum = <EnumModel>[
  EnumModel('COMPUTERIZED_FLATCAR', '电脑平车'),
  EnumModel('COMPUTERIZED_THREE_LINE_OVERLOCK_SEWING_MACHINE', '电脑三线包缝机'),
  EnumModel('COMPUTER_FIVE_LINE_SEWING_MACHINE', '电脑五线拼缝机'),
  EnumModel('TWIN_NEEDLES_MACHINE', '双针车'),
  EnumModel('POCKET_HOLE_SEWING_MACHINE', '开袋机'),
  EnumModel('KNIFE_MACHINE', '刀车'),
  EnumModel('FLATLOCK_MACHINE', '冚车'),
  EnumModel('CHAIN_STITCH_FEED_OFF_ARM_MACHINE', '埋夹车'),
  EnumModel('FOUR_LINE_FLAT_SEWING_MACHINE', '四线平缝车'),
  EnumModel('FULLY_AUTOMATIC_TEMPLATE_MACHINE', '全自动模板车'),
  EnumModel('AUTOMATIC_BAG_STICKING_MACHINE', '自动贴袋车'),
  EnumModel('WOOL_FILLING_MACHINE', '充绒机'),
  EnumModel('ZIGZAG_SEWING_MACHINE', '人字车'),
];

//尾部
const LastDepartmentsEnum = [
  EnumModel('EYELET_END_MACHINE', '凤眼车'),
  EnumModel('DIRECT_EYE_MACHINE', '直眼车'),
  EnumModel('BUTTON_ATTACHING_MACHINE', '钉扣机'),
  EnumModel('JUJUBE_PRINTER_MACHINE', '打枣机'),
  EnumModel('RIVET_MACHINE', '撞钉机'),
  EnumModel('BLINDING_MACHINE', '挑脚机'),
  EnumModel('BAHT_EDGE_MACHINE', '铢边'),
  EnumModel('BRACE_MACHINE', '拉筋机'),
  EnumModel('SUCTION_LINE_MACHINE', '吸线机'),
  EnumModel('NEEDLE_INSPECTING_MACHINE', '验针机'),
];

//设计
const FactoryDesignsEnum = [
  EnumModel('SUPPORTED', '支持'),
  EnumModel('NOT_SUPPORTED', '不支持')
];
//打板
const FactoryPatternsEnum = [
  EnumModel('SUPPORTED', '支持'),
  EnumModel('NOT_SUPPORTED', '不支持')
];
//免费打样
const FactoryFreeProofingsEnum = [
  EnumModel('SUPPORTED', '支持'),
  EnumModel('NOT_SUPPORTED', '不支持')
];
//质量等级
//const SalesMarketsEnum = [
//  EnumModel('A_CHAIN', '一线连锁'),
//  EnumModel('REGIONAL_CHAIN', '区域连锁'),
//  EnumModel('STALL_WHOLESALE', '档口批发'),
//  EnumModel('ELECTRONIC_COMMERCE_QUALITY', '电商品质'),
//  EnumModel('WHOLESALE_TRADE', '外贸批发'),
//];

//发布方式
const PublishingModesEnum = [
  EnumModel('PUBLIC', '公开发布'),
  EnumModel('PRIVATE', '私密发布'),
];

//有效期限
const EffectiveDaysEnum = [
  EnumModel('7', '7天'),
  EnumModel('15', '15天'),
  EnumModel('30', '30天'),
  EnumModel('90', '90天'),
  EnumModel('-1', '长期有效'),
];

//质量等级
const FactoryQualityLevelsEnum = [
  EnumModel('A_CHAIN', '一线大牌'),
  EnumModel('REGIONAL_CHAIN', '区域品牌'),
  EnumModel('STALL_WHOLESALE', '档口精品'),
  EnumModel('ELECTRONIC_COMMERCE_QUALITY', '电商品质'),
  EnumModel('WHOLESALE_TRADE', '外贸跑量'),
];

//转包类型
const SubContractTypeEnum = [
  EnumModel('SUBCONTRACT', '转包'),
  EnumModel('CUTTING_PIECE', '裁片'),
];

//优先级
const PriorityLevelEnum = [
  EnumModel('1', '普通'),
  EnumModel('2', '加急'),
  EnumModel('3', '特急'),
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

//对应接口的fields参数
class QuoteOrderOptions {
  static const BASIC = "BASIC";
  static const DEFAULT = "DEFAULT";
  static const FULL = "FULL";
  static const BASIC_LESS = "BASIC_LESS";
}

class PurchaseOrderOptions {
  static const BASIC = "BASIC";
  static const DEFAULT = "DEFAULT";
  static const FULL = "FULL";
  static const BASIC_LESS = "BASIC_LESS";
}

class RequirementOrderOptions {
  static const BASIC = "BASIC";
  static const DEFAULT = "DEFAULT";
  static const FULL = "FULL";
  static const BASIC_LESS = "BASIC_LESS";
}

class ProofingOrderOptions {
  static const BASIC = "BASIC";
  static const DEFAULT = "DEFAULT";
  static const FULL = "FULL";
  static const BASIC_LESS = "BASIC_LESS";
}

class ApparelProductOptions {
  static const BASIC = "BASIC";
  static const DEFAULT = "DEFAULT";
  static const FULL = "FULL";
  static const BASIC_FACTORIES = "BASIC_FACTORIES";
  static const BASIC_FACTORIES_LESS = "BASIC_FACTORIES_LESS";
  static const DETAIL_FACTORIES = "DETAIL_FACTORIES";
  static const DETAIL = "DETAIL";
}

class FactoryOptions {
  static const BASIC = "BASIC";
  static const DEFAULT = "DEFAULT";
  static const FULL = "FULL";
  static const BASIC_UID_NAME = "BASIC_UID_NAME";
  static const BASE = "BASE";
  static const CONTACT = "CONTACT";
  static const CERTIFICATE = "CERTIFICATE";
}

class BrandOptions {
  static const BASIC = "BASIC";
  static const DEFAULT = "DEFAULT";
  static const FULL = "FULL";
  static const BASIC_UID_NAME = "BASIC_UID_NAME";
  static const CONTACT = "CONTACT";
  static const CERTIFICATE = "CERTIFICATE";
}

class SalesOptions {
  static const BASIC = "BASIC";
  static const DEFAULT = "DEFAULT";
  static const FULL = "FULL";
  static const BASIC_UID_NAME = "BASIC_UID_NAME";
  static const CONTACT = "CONTACT";
  static const CERTIFICATE = "CERTIFICATE";
}
