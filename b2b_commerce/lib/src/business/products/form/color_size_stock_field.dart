import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class ColorSizeStockField extends StatefulWidget {
  ColorSizeStockField(this.item);

  final ApparelProductModel item;

  @override
  State<StatefulWidget> createState() => _ColorSizeStockFieldState();
}

class _ColorSizeStockFieldState extends State<ColorSizeStockField> {
  List<ColorModel> _colorFilters = <ColorModel>[];
  List<SizeModel> _sizeFilters = <SizeModel>[];
  List<ColorModel> _colors;
  List<SizeModel> _sizes;
//  Map<ColorModel,List<SizeStockItem>> _items = Map();
//  Map<ColorModel,List<SizeStockItem>> _newItems;

  @override
  void initState() {
    List<String> colorCodes = [];
    List<String> sizeCodes = [];
    _colorFilters.clear();
    _sizeFilters.clear();
    if(widget.item?.variants != null){
      widget.item.variants.forEach((variant){
        if(!colorCodes.contains(variant.color.code)) {
          colorCodes.add(variant.color.code);
          _colorFilters.add(variant.color);
        }
        if(!sizeCodes.contains(variant.size.code)){
          sizeCodes.add(variant.size.code);
          _sizeFilters.add(variant.size);
        }
      });
    }

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        InkWell(
          onTap: () async{

            await ProductRepositoryImpl().colors().then((colors)=>_colors = colors);
            await ProductRepositoryImpl().sizes().then((sizes)=>_sizes = sizes);

            dynamic result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ColorSizeSelectPage(colorFilters: _colorFilters,sizeFilters: _sizeFilters,colors: _colors,sizes: _sizes,),
              ),
            );

            if(result != null){
              _colorFilters = result[0];
              _sizeFilters = result[1];
            }

//            print(_colorFilters);
//            print(_sizeFilters);

            List<ApparelSizeVariantProductModel> variants = [];
            _colorFilters.forEach((color){
              variants.addAll(_sizeFilters.map((size){
                return ApparelSizeVariantProductModel(baseProduct:widget.item.code,color: color,size:size);
              }).toList());
            });
            widget.item.variants = variants;

            //选择完颜色，生成库存item
//            _newItems = Map.from(_items);
//            _items.clear();
//            _colorFilters.forEach((color){
//              ColorModel itemColor = _newItems.keys.firstWhere((key) => key.code == color.code,orElse: ()=>null);
//
//              if(itemColor != null){
//                _items[itemColor] = _sizeFilters.map((size){
//                  SizeStockItem item = _newItems[itemColor].firstWhere((sizeStockItem) => sizeStockItem.size.code == size.code,orElse: ()=>null);
//                  if(item != null){
//                    return item;
//                  }else{
//                    return SizeStockItem(size: size);
//                  }
//                }).toList();
//              }else{
//                _items[color] = _sizeFilters.map((size) => SizeStockItem(size: size)).toList();
//              }
//            });

          },
          child: ShowSelectTile(
            leadingText: '颜色/尺码',
            tralingText: colorSizeSelectText(),
          ),
        ),
//        InkWell(
//          onTap: () async{
//            if(_colorFilters.length <= 0){
//              showDialog(
//                context: context,
//                builder: (context) => AlertDialog(
//                  title: Text('请先选择颜色尺码'),
//                ),
//              );
//              return;
//            }else{
//              if(_sizeFilters.length <=0 ){
//                showDialog(
//                  context: context,
//                  builder: (context) => AlertDialog(
//                    title: Text('请选择尺码'),
//                  ),
//                );
//                return;
//              }
//            }
//
//            dynamic result = await Navigator.push(
//              context,
//              MaterialPageRoute(
//                builder: (context) => ApparelProductStockInputPage(items: _items,),
//              ),
//            );
//
//            if(result != null){
//              _items = result;
//            }
//          },
//          child: ListTile(
//            title: Text('库存'),
//            trailing: Icon(Icons.chevron_right),
//          ),
//        ),
      ],
    );
  }

  //格式化选中的颜色尺码
  String colorSizeSelectText() {
    String text = '';
    if(_colorFilters.length > 0){
      for(int i=0;i < _colorFilters.length;i++){
        if(i > 1){
          text += '...';
          break;
        }

        if(i == _colorFilters.length-1){
          text += _colorFilters[i].name;
        }else{
          text += _colorFilters[i].name + '、';
        }
      }
    }
    if(_colorFilters.length >0 || _sizeFilters.length>0) text += '/';

    if(_sizeFilters.length > 0){
      for(int i=0;i<_sizeFilters.length;i++){
        if(i > 1){
          text += '...';
          break;
        }

        if(i == _sizeFilters.length-1){
          text += _sizeFilters[i].name;
        }else{
          text += _sizeFilters[i].name + '、';
        }
      }
    }

    return text;
  }
}