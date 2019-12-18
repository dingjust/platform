import 'package:json_annotation/json_annotation.dart';

part 'amap_response.g.dart';

/// 高德输入提示响应
@JsonSerializable()
class AmapResponse {
  @JsonKey(fromJson: _stringToInt)
  final int status;

  @JsonKey(fromJson: _stringToInt)
  final int count;

  final String info;

  final String infocode;

  @JsonKey(fromJson: _tipsFromJson)
  final List<Tip> tips;

  AmapResponse(this.status, this.count, this.info, this.infocode, this.tips);

  factory AmapResponse.fromJson(Map<String, dynamic> json) =>
      _$AmapResponseFromJson(json);

  static Map<String, dynamic> toJson(AmapResponse model) =>
      _$AmapResponseToJson(model);

  static int _stringToInt(String str) {
    return int.parse(str);
  }

  static List<Tip> _tipsFromJson(List<dynamic> tipsJson) {
    return tipsJson
        .where((map) => map['id'] is String && map['id'] != '')
        .map((map) => Tip.fromJson(map))
        .toList();
  }
}

@JsonSerializable()
class Tip {
  @JsonKey(fromJson: _idFromJson)
  final String id;

  final String name;

  final String district;

  final String adcode;

  final String location;

  @JsonKey(fromJson: _address)
  final String address;

  final String typecode;

  Tip({this.id,
    this.name,
    this.district,
    this.adcode,
    this.location,
    this.address,
    this.typecode});

  factory Tip.fromJson(Map<String, dynamic> json) => _$TipFromJson(json);

  static Map<String, dynamic> toJson(Tip model) => _$TipToJson(model);

  static String _idFromJson(var id) {
    if (id is List<dynamic>) {
      return '';
    } else {
      return id;
    }
  }

  static String _address(dynamic value) {
    if (value is List) {
      if (value.length == 0) {
        return '';
      }
    } else {
      return value.toString();
    }
  }
}

/// 高德输入提示响应
@JsonSerializable()
class AmapAroundResponse {
  @JsonKey(fromJson: _stringToInt)
  final int status;

  @JsonKey(fromJson: _stringToInt)
  final int count;

  final String info;

  final String infocode;

  final List<Tip> pois;

  AmapAroundResponse(this.status, this.count, this.info, this.infocode,
      this.pois);

  factory AmapAroundResponse.fromJson(Map<String, dynamic> json) =>
      _$AmapAroundResponseFromJson(json);

  static Map<String, dynamic> toJson(AmapAroundResponse model) =>
      _$AmapAroundResponseToJson(model);

  static int _stringToInt(String str) {
    return int.parse(str);
  }
}
