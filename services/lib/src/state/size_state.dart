import 'package:flutter/cupertino.dart';
import 'package:models/models.dart';
import 'package:services/src/product/product_repository_impl.dart';

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
      sizes = sizes.where((size) => size.sequence != null && size.sequence >=1 && size.sequence <=10).toList();
      _sizeEntries = sizes.map((size){
        return ColorSizeEntryModel(code: size.code,name: size.name,customize: false,);
      }).toList();
    }
    return _sizeEntries;
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
