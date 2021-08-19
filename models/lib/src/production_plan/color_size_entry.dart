import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'color_size_entry.g.dart';

///颜色尺码entry
@JsonSerializable()
class ColorSizeEntryV2Model extends ItemModel {
  ColorModel? color;

  SizeModel? size;

  int? quantity;

  ColorSizeEntryV2Model({this.color, this.size, this.quantity});

  factory ColorSizeEntryV2Model.fromJson(Map<String, dynamic> json) =>
      _$ColorSizeEntryV2ModelFromJson(json);

  Map<String, dynamic>? toJson() => _$ColorSizeEntryV2ModelToJson(this);
}
