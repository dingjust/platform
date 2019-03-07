import 'package:flutter/material.dart';
import 'package:models/models.dart';
import '../apparel_product_stock_input.dart';
import '../apparel_product_variants_input.dart';
import '../apparel_product_size_stock_item.dart';
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
  Map<ColorModel,List<SizeStockItem>> _items = Map();
  Map<ColorModel,List<SizeStockItem>> _newItems;

  @override
  void initState() {
    if(widget.item?.variants != null){
      _colorFilters = widget.item.variants.map((variant) => variant.color).toList();
      _sizeFilters = widget.item.variants.map((variant) => variant.size).toList();
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
            dynamic result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ApparelProductVariantsInputPage(colorFilters: _colorFilters,sizeFilters: _sizeFilters,),
              ),
            );

            if(result != null){
              _colorFilters = result[0];
              _sizeFilters = result[1];
            }

            _colorFilters.forEach((color){
              widget.item.variants = _sizeFilters.map((size){
                return ApparelSizeVariantProductModel(baseProduct:widget.item.code,color: color,size:size);
              }).toList();
            });

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
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Divider(height: 0, color: Colors.grey[400]),
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
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Divider(height: 0, color: Colors.grey[400]),
        ),
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