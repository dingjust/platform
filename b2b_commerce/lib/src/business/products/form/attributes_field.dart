import 'dart:ui';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';
import '../apparel_product_attributes_input.dart';

class AttributesField extends StatefulWidget {
  AttributesField(this.item,{this.enabled});

  final ApparelProductModel item;
  final bool enabled;

  @override
  State<StatefulWidget> createState() => _AttributesFieldState();
}

class _AttributesFieldState extends State<AttributesField> {
  List<Attribute> _attributes = [
    Attribute('styles', '风格', StyleEnum,multiple: true),
    Attribute('fabricCompositions', '面料成分', FabricCompositionEnum,multiple: true,),
    Attribute('editionType', '版型', EditionTypeEnum),
    Attribute('pattern', '款式', PatternEnum),
    Attribute('sleeveType', '袖型', SleeveTypeEnum),
    Attribute('sleeveLength', '袖长/裤腿', SleeveLengthEnum),
    Attribute('decorativePatterns', '图案', DecorativePatternEnum,multiple: true,),
    Attribute('popularElements', '流行元素', PopularElementsEnum,multiple: true),
    Attribute('filler', '填充物', FillerEnum),
    Attribute('thickness', '厚薄', ThicknessEnum),
    Attribute('season', '季节', SeasonEnum),
    Attribute('taggable', '吊牌', TaggableEnum),
    Attribute('placket', '门襟', PlacketEnum),
  ];

  @override
  void initState() {
    if(widget.item.attributes != null){
      _attributes[0].valueSelects = widget.item.attributes.styles;
      _attributes[1].valueSelects = widget.item.attributes.fabricCompositions;
      _attributes[2].valueSelects = widget.item.attributes.editionType == null ? [] : [widget.item.attributes.editionType];
      _attributes[3].valueSelects = widget.item.attributes.pattern == null ? [] : [widget.item.attributes.pattern];
      _attributes[4].valueSelects = widget.item.attributes.sleeveType == null ? [] : [widget.item.attributes.sleeveType];
      _attributes[5].valueSelects = widget.item.attributes.sleeveLength == null ? [] : [widget.item.attributes.sleeveLength];
      _attributes[6].valueSelects = widget.item.attributes.decorativePatterns;
      _attributes[7].valueSelects = widget.item.attributes.popularElements;
      _attributes[8].valueSelects = widget.item.attributes.filler == null ? [] : [widget.item.attributes.filler];
      _attributes[9].valueSelects = widget.item.attributes.thickness == null ? [] : [widget.item.attributes.thickness];
      _attributes[10].valueSelects = widget.item.attributes.season == null ? [] : [widget.item.attributes.season];
      _attributes[11].valueSelects = widget.item.attributes.taggable == null ? [] : [widget.item.attributes.taggable.toString()];
      _attributes[12].valueSelects = widget.item.attributes.placket == null ? [] : [widget.item.attributes.placket];
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
            Map<String,dynamic> result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PositioningRollPage(
                  crossAxisCount: 3,
                  attributes: _attributes,
                  title: '选择属性',
                  enabled: widget.enabled,
                ),
              ),
            );
            if(result != null){
              result['editionType'] = ClassHandleUtil.isNotEmpty(result['editionType']) ? result['editionType'][0] : null;
              result['pattern'] = ClassHandleUtil.isNotEmpty(result['pattern']) ? result['pattern'][0] : null;
              result['sleeveType'] = ClassHandleUtil.isNotEmpty(result['sleeveType']) ? result['sleeveType'][0] : null;
              result['sleeveLength'] = ClassHandleUtil.isNotEmpty(result['sleeveLength']) ? result['sleeveLength'][0] : null;
              result['filler'] = ClassHandleUtil.isNotEmpty(result['filler']) ? result['filler'][0] : null;
              result['thickness'] = ClassHandleUtil.isNotEmpty(result['thickness']) ? result['thickness'][0] : null;
              result['season'] = ClassHandleUtil.isNotEmpty(result['season']) ? result['season'][0] : null;
              result['placket'] = ClassHandleUtil.isNotEmpty(result['placket']) ? result['placket'][0] : null;
              result['taggable'] = ClassHandleUtil.isNotEmpty(result['taggable']) ? ClassHandleUtil.strToBool(result['taggable'][0]) : null;
              var model = ApparelProductAttributesModel.fromJson(result);
              widget.item.attributes = model;
            }
          },
          child: ListTile(
            title: Text('属性'),
            trailing: Icon(Icons.chevron_right),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Divider(height: 0, color: Colors.grey[400]),
        ),
      ],
    );
  }

  Widget _buildAttributesInfo() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 17,),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '属性',
                style: const TextStyle(color: Colors.black, fontSize: 16),
              ),
              Container(
                width: MediaQueryData.fromWindow(window).size.width - 130,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    _attributesSelectText(),
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Divider(height: 0,),
        ),
      ],
    );
  }

  String _attributesSelectText(){
    String text = '';
    _attributes.forEach((attribute){
      if(ClassHandleUtil.isNotEmpty(attribute.valueSelects)){
        text += attribute.name;
        for(int i=0;i<attribute.valueSelects.length;i++){
          if(i == attribute.valueSelects.length-1){
            text += enumMap(StyleEnum, widget.item.attributes.styles[i]);
            text += '\n';
            break;
          }
          text += enumMap(StyleEnum, widget.item.attributes.styles[i]);
          text += '、';
        }
      }
    });
//    if(ClassHandleUtil.isNotEmpty(widget.item.attributes.styles)){
//      text += '风格--';
//      for(int i=0;i<widget.item.attributes.styles.length;i++){
//        if(i == widget.item.attributes.styles.length-1){
//          text += enumMap(StyleEnum, widget.item.attributes.styles[i]);
//          text += '\n';
//          break;
//        }
//        text += enumMap(StyleEnum, widget.item.attributes.styles[i]);
//        text += '、';
//      }
//    }
//    if(ClassHandleUtil.isNotEmpty(widget.item.attributes.fabricCompositions)){
//      text += '面料成分--';
//      for(int i=0;i<widget.item.attributes.fabricCompositions.length;i++){
//        if(i == widget.item.attributes.fabricCompositions.length-1){
//          text += enumMap(FabricCompositionEnum, widget.item.attributes.fabricCompositions[i]);
//          text += '\n';
//          break;
//        }
//        text += enumMap(FabricCompositionEnum, widget.item.attributes.fabricCompositions[i]);
//        text += '、';
//      }
//    }
//    if(widget.item.attributes.editionType != null){
//      text += '版型--';
//      text += enumMap(EditionTypeEnum, widget.item.attributes.editionType);
//    }
//    if(widget.item.attributes.pattern != null){
//      text += '款式--';
//      text += enumMap(PatternEnum, widget.item.attributes.pattern);
//    }
//    if(widget.item.attributes.sleeveType != null){
//      text += '袖型--';
//      text += enumMap(SleeveTypeEnum, widget.item.attributes.sleeveType);
//    }
//    if(widget.item.attributes.sleeveLength != null){
//      text += '袖长/裤腿--';
//      text += enumMap(SleeveLengthEnum, widget.item.attributes.sleeveLength);
//    }


    return text;
  }
}