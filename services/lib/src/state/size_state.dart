import 'package:models/models.dart';
import 'package:services/services.dart';

class SizeState {
  List<SizeModel> _sizes;

  List<ColorSizeEntryModel> _sizeEntries;

  Future<List<SizeModel>> getAllSizes() async {
    if (_sizes == null) {
      //获取所有标签
      _sizes = await ProductRepositoryImpl().sizes();
      return _sizes;
    } else {
      return _sizes;
    }
  }

  /// 获取部分尺码(序列号1-8)
  Future<List<ColorSizeEntryModel>> getPartSizes() async {
    if (_sizeEntries == null) {
      //获取所有标签
      var sizes = await ProductRepositoryImpl().sizes();

      _sizeEntries = sizes.map((size) {
        return ColorSizeEntryModel(
          code: size.code,
          name: size.name,
          customize: false,
        );
      }).toList();
    }
    return _sizeEntries;
  }

  ///比较尺码顺序
  int compare(String o1, String o2) {
    if (_sizes == null || _sizes.isEmpty) {
      return 0;
    }
    //查找对应Model
    SizeModel size1 =
        _sizes.firstWhere((element) => element.code == o1, orElse: () => null);
    SizeModel size2 =
        _sizes.firstWhere((element) => element.code == o2, orElse: () => null);
    return (size1?.sequence ?? -1) - (size2?.sequence ?? -1);
  }

  List<SizeModel> get sizes => _sizes;

  set sizes(List<SizeModel> value) {
    _sizes = value;
  }

  List<ColorSizeEntryModel> get sizeEntries => _sizeEntries;

  set sizeEntries(List<ColorSizeEntryModel> value) {
    _sizeEntries = value;
  }
}
