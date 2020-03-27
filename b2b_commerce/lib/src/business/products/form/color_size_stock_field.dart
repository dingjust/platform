import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class ColorSizeStockField extends StatefulWidget {
  ColorSizeStockField(this.item,{this.enabled});

  final ApparelProductModel item;
  final bool enabled;

  @override
  State<StatefulWidget> createState() => _ColorSizeStockFieldState();
}

class _ColorSizeStockFieldState extends State<ColorSizeStockField> {
  List<ColorModel> _colorFilters = <ColorModel>[];
  List<SizeModel> _sizeFilters = <SizeModel>[];
  List<ColorModel> _colors;
  List<SizeModel> _sizes;

  @override
  void initState() {
    ProductRepositoryImpl().colors().then((colors)=>_colors = colors);
    ProductRepositoryImpl().sizes().then((sizes)=>_sizes = sizes);
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
        !widget.enabled ? _buildColorSizeSelectedInfo() : InkWell(
          onTap: () async{
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

            List<ApparelSizeVariantProductModel> variants = [];
            _colorFilters.forEach((color){
              variants.addAll(_sizeFilters.map((size){
                return ApparelSizeVariantProductModel(baseProduct:widget.item.code,color: color,size:size);
              }).toList());
            });
            widget.item.variants = variants;

          },
          child: ShowSelectTile(
            isRequired: widget.enabled,
            leadingText: '颜色/尺码',
            tralingText: colorSizeSelectText(),
            isShowIcon: widget.enabled,
          ),
        ),
      ],
    );
  }

  Widget _buildColorSizeSelectedInfo() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 17,),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Wrap(
                children: <Widget>[
                  Text(
                    '颜色/尺码',
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ],
              ),
              Container(
                width: MediaQueryData.fromWindow(window).size.width - 130,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    colorSizeSelectInfo(),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),
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

  //格式化选中的颜色尺码(明细)
  String colorSizeSelectInfo() {
    String text = '';
    if(_colorFilters.length > 0){
      text += '颜色--';
      for(int i=0;i < _colorFilters.length;i++){
        if(i == _colorFilters.length-1){
          text += _colorFilters[i].name + '\n';
        }else{
          text += _colorFilters[i].name + '、';
        }
      }
    }

    if(_sizeFilters.length > 0){
      text += '尺码--';
      for(int i=0;i<_sizeFilters.length;i++){
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