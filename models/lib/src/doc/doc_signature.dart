import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'doc_signature.g.dart';

///签署文档类
@JsonSerializable()
class DocSignatureModel {
  int id;

  String code;

  ///来源订单号
  String originCode;

  ///标题
  String title;

  String thirdPartyDocId;

  String content;

  String partyALabel;

  String partyBLabel;

  ///签署状态
  DocSignatureState state;

  @JsonKey(toJson: CompanyModel.toJson)
  CompanyModel partyA;

  @JsonKey(toJson: CompanyModel.toJson)
  CompanyModel partyB;

  ///模板类型
  DocTemplateType docType;

  ///签署类型
  SignMethodType signMethod;

  @JsonKey(toJson: B2BCustomerModel.toJson)
  B2BCustomerModel partyASignBy;

  @JsonKey(toJson: B2BCustomerModel.toJson)
  B2BCustomerModel partyBSignBy;

  String extraContent;

  @JsonKey(fromJson: dateTimefromMilliseconds)
  DateTime partyASignTime;

  @JsonKey(fromJson: dateTimefromMilliseconds)
  DateTime partyBSignTime;

  String partyATransactionId;

  String partyBTransactionId;

  @JsonKey(toJson: MediaModel.toJson)
  MediaModel docPdf;

  @JsonKey(toJson: MediaModel.listToJson)
  List<MediaModel> attachments;

  @JsonKey(fromJson: dateTimefromMilliseconds)
  DateTime completeTime;

  String requireSignParty;

  DocSignatureModel({
    this.id,
    this.code,
    this.originCode,
    this.title,
    this.thirdPartyDocId,
    this.content,
    this.partyALabel,
    this.partyBLabel,
    this.state,
    this.partyA,
    this.partyB,
    this.docType,
    this.signMethod,
    this.partyASignBy,
    this.partyBSignBy,
    this.extraContent,
    this.partyASignTime,
    this.partyBSignTime,
    this.partyATransactionId,
    this.partyBTransactionId,
    this.docPdf,
    this.attachments,
    this.completeTime,
    this.requireSignParty,
  });

  factory DocSignatureModel.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$DocSignatureModelFromJson(json);

  static Map<String, dynamic> toJson(DocSignatureModel model) =>
      model == null ? null : _$DocSignatureModelToJson(model);

  static List<Map<String, dynamic>> listToJson(
          List<DocSignatureModel> models) =>
      models == null
          ? null
          : models.map((e) => _$DocSignatureModelToJson(e)).toList();
}

///  签署状态
enum DocSignatureState {
  /// 待签署
  WAIT_SIGN,

  ///待甲方签署
  WAIT_PARTYA_SIGN,

  ///待乙方签署
  WAIT_PARTYB_SIGN,

  ///签署完成
  COMPLETE,

  ///已取消
  CANCELED
}

///签署状态
const DocSignatureStateLocalizedMap = {
  DocSignatureState.WAIT_SIGN: "待签署",
  DocSignatureState.WAIT_PARTYA_SIGN: "待甲方签署",
  DocSignatureState.WAIT_PARTYB_SIGN: "待乙方签署",
  DocSignatureState.COMPLETE: "签署完成",
  DocSignatureState.CANCELED: "已取消",
};

///   模板类型
enum DocTemplateType {
  /// 对账单
  ReconciliationSheet,
}

///模板类型
const DocTemplateTypeLocalizedMap = {
  DocTemplateType.ReconciliationSheet: "对账单",
};

///签署类型
enum SignMethodType {
  /// 线上生产内容在线签署
  ONLINE_FORM_SIGN,

  ///自定义文档在线签署
  ONLINE_CUSTOM_PDF_SIGN,

  ///线下签署
  OFFLINE_SIGN,
}

///模板类型
const SignMethodTypeLocalizedMap = {
  SignMethodType.ONLINE_FORM_SIGN: "线上生产内容在线签署",
  SignMethodType.ONLINE_CUSTOM_PDF_SIGN: "线上生产内容在线签署",
  SignMethodType.OFFLINE_SIGN: "线下签署",
};
