import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class MyBrandBaseFormPage extends StatefulWidget {
  BrandModel brand;
  MyBrandBaseFormPage(this.brand);

  @override
  State createState() => MyBrandBaseFormPageState();
}

class MyBrandBaseFormPageState extends State<MyBrandBaseFormPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _brandController = TextEditingController();
  TextEditingController _coopController = TextEditingController();
  List<MediaModel> medias = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('基本资料'),
        centerTitle: true,
        elevation: 0.5,
        actions: <Widget>[
          IconButton(icon: Text('确定',style: TextStyle(color: Color.fromRGBO(255, 214, 12, 1)),), onPressed: (){

          })
        ],
      ),
      body: Container(
        color: Colors.grey[200],
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
              child: Text(
                '上传图片',
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.grey,
                ),
              ),
            ),
            EditableAttachments(list: medias),
            Container(
              color: Colors.white,
              child: TextFieldComponent(
                leadingText: '公司名称',
                controller: _nameController,
                leadingColor: Colors.grey,
              ),
            ),
            SizedBox(height: 3,),
            Container(
              color: Colors.white,
              child: TextFieldComponent(
                leadingText: '品牌名称',
                controller: _brandController,
                leadingColor: Colors.grey,
              ),
            ),
            SizedBox(height: 3,),
            Container(
              color: Colors.white,
              child: TextFieldComponent(
                leadingText: '合作品牌',
                controller: _coopController,
                leadingColor: Colors.grey,
              ),
            ),
            SizedBox(height: 3,),
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
              child: Row(
                children: <Widget>[
                  Expanded(child: Text('产值规模',style: TextStyle(color: Colors.grey,fontSize: 16,),)),
                  Text(widget.brand.scaleRange == null ? '' : ScaleRangesLocalizedMap[widget.brand.scaleRange]),
                  Icon(Icons.chevron_right),
                ],
              ),
            ),
            SizedBox(height: 3,),
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
              child: Row(
                children: <Widget>[
                  Expanded(child: Text('优势类目',style: TextStyle(color: Colors.grey,fontSize: 16,),)),
                  Text(formatCategorySelectText(widget.brand.adeptAtCategories),),
                  Icon(Icons.chevron_right),
                ],
              ),
            ),
            SizedBox(height: 3,),
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
              child: Row(
                children: <Widget>[
                  Expanded(child: Text('风格',style: TextStyle(color: Colors.grey,fontSize: 16,),)),
                  Text(formatEnumSelectsText(widget.brand.styles, StyleEnum, 4),),
                  Icon(Icons.chevron_right),
                ],
              ),
            ),
            SizedBox(height: 3,),
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
              child: Row(
                children: <Widget>[
                  Expanded(child: Text('年龄段',style: TextStyle(color: Colors.grey,fontSize: 16,),)),
                  Text( formatAgeRangesText(widget.brand.ageRanges),),
                  Icon(Icons.chevron_right),
                ],
              ),
            ),
            SizedBox(height: 3,),
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
              child: Row(
                children: <Widget>[
                  Expanded(child: Text('春夏款价格端',style: TextStyle(color: Colors.grey,fontSize: 16,),)),
                  Text(formatPriceRangesText(widget.brand.priceRange1s),),
                  Icon(Icons.chevron_right),
                ],
              ),
            ),
            SizedBox(height: 3,),
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
              child: Row(
                children: <Widget>[
                  Expanded(child: Text('秋冬款价格端',style: TextStyle(color: Colors.grey,fontSize: 16,),)),
                  Text(formatPriceRangesText(widget.brand.priceRange2s),),
                  Icon(Icons.chevron_right),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formatCategorySelectText(List<CategoryModel> categorys) {
    String text = '';
    if (categorys != null && categorys.isNotEmpty) {
      categorys.forEach((category) {
        text += category.name;
      });
    }
    return text;
  }
  String formatAgeRangesText(List<AgeRanges> ageRanges) {
    String text = '';
    if (ageRanges != null && ageRanges.isNotEmpty) {
      ageRanges.forEach((ageRange) {
        text += '  '+AgeRangesLocalizedMap[ageRange];
      });
    }
    return text;
  }
  String formatPriceRangesText(List<PriceRanges> priceRanges) {
    String text = '';
    if (priceRanges != null && priceRanges.isNotEmpty) {
      priceRanges.forEach((priceRange) {
        text += '  ￥'+PriceRangesLocalizedMap[priceRange];
      });
    }
    return text;
  }
}
