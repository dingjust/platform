import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

import 'form/attributes_field.dart';
import 'form/color_size_stock_field.dart';
import 'form/minor_category_field.dart';
import 'form/normal_picture_field.dart';

class ApparelProductFormPage extends StatefulWidget {
  ApparelProductFormPage({Key key, @required this.item, this.isCreate = false})
      : super(key: const Key('__apparelProductFormPage__'));

  final ApparelProductModel item;
  final bool isCreate;

  ApparelProductFormState createState() => ApparelProductFormState();
}

class ApparelProductFormState extends State<ApparelProductFormPage> {
  final GlobalKey<FormState> _apparelProductForm = GlobalKey<FormState>();
  FocusNode _nameFocusNode = FocusNode();
  final TextEditingController _nameController = TextEditingController();
  FocusNode _skuIDFocusNode = FocusNode();
  final TextEditingController _skuIDController = TextEditingController();
  FocusNode _brandFocusNode = FocusNode();
  final TextEditingController _brandController = TextEditingController();
  FocusNode _priceFocusNode = FocusNode();
  TextEditingController _priceController = TextEditingController();
  FocusNode _gramWeightFocusNode = FocusNode();
  final TextEditingController _gramWeightController = TextEditingController();

  @override
  void initState() {
    _nameController.text = widget.item?.name;
    _skuIDController.text = widget.item?.skuID;
    _brandController.text = widget.item?.brand;
    _priceController.text = widget.item?.price?.toString();
    _gramWeightController.text = widget.item?.gramWeight?.toString();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
//    var bloc = BLoCProvider.of<ApparelProductBLoC>(context);
//    debugPrint(bloc.currentProduct.toString());
//    return StreamBuilder(
//        stream: bloc.detailStream,
//        initialData: bloc.currentProduct,
//        builder: (BuildContext context,
//            AsyncSnapshot<ApparelProductModel> snapshot) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        centerTitle: true,
        title: Text('编辑商品'),
        actions: <Widget>[
          IconButton(
            icon: Text(
              '确定',
              style: TextStyle(color: Color(0xffFF9516)),
            ),
            onPressed: () {
              print("${widget.item.normal}  code : ${widget.item.hashCode}");
              print("${widget.item.name} code : ${widget.item.hashCode}");
              print("${widget.item.skuID}  code : ${widget.item.hashCode}");
              print(
                  "${widget.item.minorCategory?.name} code : ${widget.item.hashCode}");
              print("${widget.item.brand} code : ${widget.item.hashCode}");
              print(widget.item.price);
              print(widget.item.gramWeight);
              if (widget.item.variants != null) {
                print(
                    'color' + widget.item?.variants[0]?.color?.name.toString());
                print('size' + widget.item?.variants[0]?.size?.name.toString());
              }
//              print(widget.item.attributes.styles[0]);
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: Form(
        key: _apparelProductForm,
        child: ListView(
          children: <Widget>[
            NormalPictureField(widget.item, widget.isCreate),
//            DetailPictureField(widget.item),
            TextFieldComponent(
              focusNode: _nameFocusNode,
              controller: _nameController,
              leadingText: '商品名称',
              hintText: '请输入商品名称',
              onChanged: (value){
                widget.item.name = value;
              },
            ),
            TextFieldComponent(
              focusNode: _skuIDFocusNode,
              controller: _skuIDController,
              leadingText: '商品货号',
              hintText: '请输入商品货号',
              onChanged: (value){
                widget.item.skuID = value;
              },
            ),
            MinorCategoryField(widget.item),
            ColorSizeStockField(widget.item),
            TextFieldComponent(
              focusNode: _brandFocusNode,
              controller: _brandController,
              leadingText: '品牌',
              hintText: '请输入品牌',
              onChanged: (value){
                widget.item.brand = value;
              },
            ),
            TextFieldComponent(
              focusNode: _priceFocusNode,
              controller: _priceController,
              inputType: TextInputType.number,
              leadingText: '供货价',
              hintText: '请输入供货价',
              onChanged: (value){
                widget.item.price = double.parse(value);
              },
            ),
            TextFieldComponent(
              focusNode: _gramWeightFocusNode,
              controller: _gramWeightController,
              inputType: TextInputType.number,
              leadingText: '重量',
              hintText: '请输入重量',
              onChanged: (value){
                widget.item.gramWeight = double.parse(value);
              },
            ),
            AttributesField(widget.item),
//            PrivacyField(widget.item),
//            PostageFreeField(widget.item),
            /*Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: ActionChip(
                      backgroundColor: Colors.red,
                      labelPadding:
                          EdgeInsets.symmetric(vertical: 4, horizontal: 22),
                      labelStyle: TextStyle(fontSize: 16),
                      label: Text('发布商品'),
                      onPressed: () {
                        // TODO:默认下架
                      },
                    ),
                  ),
                  Expanded(
                    child: ActionChip(
                      backgroundColor: Colors.orange,
                      labelPadding:
                          EdgeInsets.symmetric(vertical: 4, horizontal: 22),
                      labelStyle: TextStyle(fontSize: 16),
                      label: Text('直接上架'),
                      onPressed: () {
                        // TODO:直接上架
                      },
                    ),
                  )
                ],
              ),
            ),*/
          ],
        ),
      ),
    );
//        }
//        );
  }
}
