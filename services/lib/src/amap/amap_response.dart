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

/// 高德地理编码
@JsonSerializable()
class Geocode {
  @JsonKey(fromJson: _stringFromJson)
  final String formatted_address;

  @JsonKey(fromJson: _stringFromJson)
  final String country;

  @JsonKey(fromJson: _stringFromJson)
  final String province;

  @JsonKey(fromJson: _stringFromJson)
  final String citycode;

  @JsonKey(fromJson: _stringFromJson)
  final String city;

  @JsonKey(fromJson: _stringFromJson)
  final String adcode;

  @JsonKey(fromJson: _stringFromJson)
  final String location;

  @JsonKey(fromJson: _stringFromJson)
  final String level;

  @JsonKey(fromJson: _stringFromJson)
  final String district;

  @JsonKey(fromJson: _stringFromJson)
  final String street;

  @JsonKey(fromJson: _stringFromJson)
  final String number;

  Geocode(this.formatted_address,
      this.country,
      this.province,
      this.citycode,
      this.city,
      this.location,
      this.level,
      this.district,
      this.street,
      this.number, {
        this.adcode,
      });

  factory Geocode.fromJson(Map<String, dynamic> json) =>
      _$GeocodeFromJson(json);

  static Map<String, dynamic> toJson(Geocode model) => _$GeocodeToJson(model);

  static String _stringFromJson(var val) {
    if (val is List<dynamic>) {
      return '';
    } else {
      return val;
    }
  }
}

/// 高德地理编码响应
@JsonSerializable()
class AmapGeocodeResponse {
  @JsonKey(fromJson: _stringToInt)
  final int status;

  @JsonKey(fromJson: _stringToInt)
  final int count;

  final String info;

  final String infocode;

  final List<Geocode> geocodes;

  AmapGeocodeResponse(this.status, this.count, this.info, this.infocode,
      this.geocodes);

  factory AmapGeocodeResponse.fromJson(Map<String, dynamic> json) =>
      _$AmapGeocodeResponseFromJson(json);

  static Map<String, dynamic> toJson(AmapGeocodeResponse model) =>
      _$AmapGeocodeResponseToJson(model);

  static int _stringToInt(String str) {
    return int.parse(str);
  }
}
