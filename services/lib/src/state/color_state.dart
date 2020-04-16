import 'package:models/models.dart';
import 'package:services/services.dart';

class ColorState{

  List<ColorModel> _colors;

  List<ColorSizeModel> _colorEntries;

  Future<List<ColorModel>> getAllColors() async {
    if (_colors == null) {
      //获取所有标签
      _colors = await ProductRepositoryImpl().colors();
      return _colors;
    } else {
      return _colors;
    }
  }

  ///获取部分颜色
  Future<List<ColorSizeModel>> getPartColors() async {
    if (_colorEntries == null) {
      //获取所有标签
      var colors = await ProductRepositoryImpl().colors();
      // colors = colors.sublist(0,20);
      _colorEntries = colors.map((color){
        return ColorSizeModel(colorCode: color.code,colorName: color.name,customize: false);
      }).toList();
    }
    return _colorEntries;
  }

  List<ColorModel> get colors => _colors;

  set colors(List<ColorModel> value) {
    _colors = value;
  }

  List<ColorSizeModel> get colorEntries => _colorEntries;

  set colorEntries(List<ColorSizeModel> value) {
    _colorEntries = value;
  }


}
