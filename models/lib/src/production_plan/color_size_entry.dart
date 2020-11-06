import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'color_size_entry.g.dart';

///颜色尺码entry
@JsonSerializable()
class ColorSizeEntryV2Model extends ItemModel {
  @JsonKey(toJson: ColorModel.toJson)
  ColorModel color;

  @JsonKey(toJson: SizeModel.toJson)
  SizeModel size;

  int quantity;

  ColorSizeEntryV2Model({this.color, this.size, this.quantity});

  factory ColorSizeEntryV2Model.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$ColorSizeEntryV2ModelFromJson(json);

  Map<String, dynamic> toJson() => _$ColorSizeEntryV2ModelToJson(this);

  static List<Map<String, dynamic>> listToJson(
          List<ColorSizeEntryV2Model> models) =>
      models == null ? null : models.map((e) => e.toJson()).toList();
}
