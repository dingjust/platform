import 'package:b2b_commerce/src/business/apparel_products.dart';
import 'package:b2b_commerce/src/business/products/form/prices_field.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'form/attributes_field.dart';
import 'form/color_size_stock_field.dart';
import 'form/minor_category_field.dart';
import 'form/normal_picture_field.dart';

class ApparelProductFormPage extends StatefulWidget {
  ApparelProductFormPage({Key key, @required this.item, this.isCreate = false,this.status = 'ALL',})
      : super(key: const Key('__apparelProductFormPage__'));

  final ApparelProductModel item;
  final bool isCreate;
  String status;

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
    print(widget.item.code);
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
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.5,
          centerTitle: true,
          title: Text('编辑商品'),
          actions: <Widget>[
            IconButton(
              icon: Text(
                '确定',
                style: TextStyle(),
              ),
              onPressed: () async {
                if (widget.item.name == null) {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            content: Text('请输入商品名称'),
                          ));
                  return;
                } else if (widget.item.skuID == null) {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            content: Text('请输入商品货号'),
                          ));
                  return;
                } else if (widget.item.category == null) {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            content: Text('请输入商品类别'),
                          ));
                  return;
                }
                if (widget.item.attributes == null)
                  widget.item.attributes = ApparelProductAttributesModel();
                if (widget.isCreate) {
                  String code =
                      await ProductRepositoryImpl().create(widget.item);
                  if (code != null) {
                    widget.item.name = null;
                    widget.item.skuID = null;
                    widget.item.attributes = null;
                    widget.item.category = null;
                    widget.item.brand = null;
                    widget.item.variants = null;
                    widget.item.price = null;
                    widget.item.gramWeight = null;
                    widget.item.images = null;
                  }
                } else {
                  await ProductRepositoryImpl().update(widget.item);
                }

                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => ApparelProductsPage()
                    ), ModalRoute.withName('/'));
                ApparelProductBLoC.instance.filterByStatuses(widget.status);
//              print(widget.item.attributes.styles[0]);
              },
            )
          ],
        ),
        body: Form(
          key: _apparelProductForm,
          child: ListView(
            children: <Widget>[
              NormalPictureField(widget.item),
//            DetailPictureField(widget.item),
              TextFieldComponent(
                style: TextStyle(fontSize: 16,color: Colors.grey,),
                focusNode: _nameFocusNode,
                controller: _nameController,
                leadingText: '商品名称',
                hintText: '请输入商品名称',
                textInputAction: TextInputAction.next,
                onChanged: (value) {
                  widget.item.name = value;
                },
                onEditingComplete: (){
                  FocusScope.of(context).requestFocus(_skuIDFocusNode);
                },
              ),
              TextFieldComponent(
                style: TextStyle(fontSize: 16,color: Colors.grey,),
                focusNode: _skuIDFocusNode,
                controller: _skuIDController,
                leadingText: '商品货号',
                hintText: '请输入商品货号',
                textInputAction: TextInputAction.next,
                onChanged: (value) {
                  widget.item.skuID = value;
                },
                onEditingComplete: (){
                  FocusScope.of(context).requestFocus(_brandFocusNode);
                },
              ),
              MinorCategoryField(widget.item),
              ColorSizeStockField(widget.item),
              TextFieldComponent(
                style: TextStyle(fontSize: 16,color: Colors.grey,),
                focusNode: _brandFocusNode,
                controller: _brandController,
                leadingText: '品牌',
                hintText: '请输入品牌',
                textInputAction: TextInputAction.next,
                onChanged: (value) {
                  widget.item.brand = value;
                },
                onEditingComplete: (){
                  if(UserBLoC.instance.currentUser.type == UserType.BRAND) {
                    FocusScope.of(context).requestFocus(_priceFocusNode);
                  }else if(UserBLoC.instance.currentUser.type == UserType.FACTORY){
                    FocusScope.of(context).requestFocus(_gramWeightFocusNode);
                  }
                },
              ),
              Offstage(
                offstage: UserBLoC.instance.currentUser.type != UserType.BRAND,
                child: TextFieldComponent(
                  style: TextStyle(fontSize: 16,color: Colors.grey,),
                  focusNode: _priceFocusNode,
                  controller: _priceController,
                  inputType: TextInputType.number,
                  leadingText: '供货价',
                  hintText: '请输入供货价',
                  textInputAction: TextInputAction.next,
                  onChanged: (value) {
                    widget.item.price = double.parse(value);
                  },
                  onEditingComplete: (){
                    FocusScope.of(context).requestFocus(_gramWeightFocusNode);
                  },
                ),
              ),
              Offstage(
                offstage: UserBLoC.instance.currentUser.type != UserType.FACTORY,
                child: PricesField(widget.item),
              ),
              TextFieldComponent(
                style: TextStyle(fontSize: 16,color: Colors.grey,),
                focusNode: _gramWeightFocusNode,
                controller: _gramWeightController,
                inputType: TextInputType.number,
                leadingText: '重量（kg）',
                hintText: '请输入重量',
                onChanged: (value) {
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
                        backgroundColor: Color.fromRGBO(255,214,12, 1),
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
      ),
    );
//        }
//        );
  }
}
