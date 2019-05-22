import 'package:b2b_commerce/src/business/orders/form/contact_way_field.dart';
import 'package:b2b_commerce/src/business/orders/form/expected_delivery_date_field.dart';
import 'package:b2b_commerce/src/business/orders/form/is_invoice_field.dart';
import 'package:b2b_commerce/src/business/orders/form/is_proofing_field.dart';
import 'package:b2b_commerce/src/business/orders/form/is_provide_sample_product_field.dart';
import 'package:b2b_commerce/src/business/orders/form/machining_type_field.dart';
import 'package:b2b_commerce/src/business/orders/requirement_order_detail.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import '../../home/requirement/requirement_publish_success.dart';
import '../apparel_products.dart';
import 'form/category_field.dart';
import 'form/major_category_field.dart';
import 'form/pictures_field.dart';
import 'form/product_field.dart';
import 'form/production_areas_field.dart';

// TODO: change to RequirementOrderForm
class RequirementOrderFrom extends StatefulWidget {
  String factoryUid;
  ApparelProductModel product;

  RequirementOrderModel order;

  //是否新建
  bool isCreate;
  //是否重新发布
  bool isReview;

  RequirementOrderFrom(
      {this.product, this.order, this.factoryUid, this.isReview: false,this.isCreate = false,});

  _RequirementOrderFromState createState() => _RequirementOrderFromState();
}

class _RequirementOrderFromState extends State<RequirementOrderFrom> {
//  RequirementOrderModel model;
  bool _isShowMore = true;
  DateTime selectDate = DateTime.now();
  FocusNode _nameFocusNode = FocusNode();
  TextEditingController _nameController = TextEditingController();
  FocusNode _quantityFocusNode = FocusNode();
  TextEditingController _quantityController = TextEditingController();
  FocusNode _priceFocusNode = FocusNode();
  TextEditingController _priceController = TextEditingController();
  FocusNode _remarksFocusNode = FocusNode();
  TextEditingController _remarksController = TextEditingController();

  @override
  void initState() {
    if (!widget.isCreate || widget.isReview) {
//      model.details = widget.order.details;
      _nameController.text = widget.order.details.productName;
      _quantityController.text = widget.order.details.expectedMachiningQuantity.toString();
      _remarksController.text = widget.order.remarks;
      _priceController.text = widget.order.details.maxExpectedPrice.toString() == 'null' ? '0' : widget.order.details.maxExpectedPrice.toString();
      if (widget.order.attachments == null) {
        widget.order.attachments = [];
      }
      if (widget.order.details.pictures == null) {
        widget.order.details.pictures = [];
      }
    }

    //联系方式取当前登陆人信息
    print('${UserBLoC.instance}');
//    widget.order.details.contactPerson = UserBLoC.instance.currentUser.name;
    widget.order.details.contactPhone = UserBLoC.instance.currentUser.name;

    if (widget.product != null) {
      widget.order.details.category = widget.product.category;
      widget.order.details.pictures = widget.product.images;
    }

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
//        if (widget.isCreate) {
//          ShowDialogUtil.showAlertDialog(context, '是否确定退出', () {
////            _clearProductData();
//            Navigator.pop(context);
//            Navigator.pop(context);
//          });
//        } else {
//          Navigator.pop(context);
//        }
//        return Future.value(false);
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) {
              return CustomizeDialog(
                dialogType: DialogType.CONFIRM_DIALOG,
                contentText2: '正在创建订单，是否确认退出',
                isNeedConfirmButton: true,
                isNeedCancelButton: true,
                confirmButtonText: '退出',
                cancelButtonText: '再看看',
                dialogHeight: 180,
                confirmAction: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              );
            }
        );
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text('需求发布'),
            elevation: 0.5,
            brightness: Brightness.light,
            centerTitle: true,
            actions: <Widget>[
              /*IconButton(
                  icon: Icon(Icons.play_for_work),
                  color: Color.fromRGBO(255, 149, 22, 1),
                  onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RequirementImportProduct(),
                        ),
                      )),*/
              GestureDetector(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Center(
                      child: Text(
                        '导入产品',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  onTap: () async {
                    dynamic result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ApparelProductsPage(
                              isSelectOption: true,
                              item: widget.product,
                            ),
                      ),
                    );
                    //TODO：导入产品后的一系列操作
                    widget.product = result;
                    if (result != null) {
                      setState(() {
                        widget.order.details.pictures = widget.product.images;
                        widget.order.details.productName = widget.product.name;
                        widget.order.details.productSkuID = widget.product.skuID;
                        if (widget.product.category != null) {
                          widget.order.details.category = widget.product.category;
                        }
                      });
                    }
                  })
            ],
          ),
          body: Container(
            child: ListView(
              children: <Widget>[
                _buildBody(context),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            height: 50,
            child: RaisedButton(
              color: Color.fromRGBO(255, 214, 12, 1),
              child: Text(
                !widget.isCreate
                    ? '修改需求'
                    : '确认发布',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              onPressed: () {
                onPublish(widget.factoryUid);
              },
            ),
          )),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: <Widget>[
            _buildhead(context),
            _buildHideBody(context),
            _buildBottom(context),
          ],
        ),
      ),
    );
  }

  Widget _buildhead(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          PicturesField(
            model: widget.order,
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              // 触摸收起键盘
              _nameFocusNode.unfocus();
            },
            child: widget.product == null
                ? TextFieldComponent(
                    focusNode: _nameFocusNode,
                    controller: _nameController,
                    leadingText: Text('标题',
                        style: TextStyle(
                          fontSize: 16,
                        )),
                    hintText: '填写',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                    onChanged: (val) {
                      widget.order.details.productName = _nameController.text;
                    },
                  )
                : ProductField(widget.product),
          ),
          CategoryField(
            widget.order,
            product: widget.product,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Divider(
              height: 0,
            ),
          ),
          MajorCategoryField(widget.order),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Divider(
              height: 0,
            ),
          ),
          TextFieldComponent(
            focusNode: _quantityFocusNode,
            controller: _quantityController,
            leadingText: Text('订单数量',
                style: TextStyle(
                  fontSize: 16,
                )),
            inputFormatters: [
              DecimalInputFormat(),
            ],
            isRequired: true,
            hintText: '填写（数字）',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
//          ExpectedMachiningQuantityField(model),
          TextFieldComponent(
            focusNode: _priceFocusNode,
            controller: _priceController,
            leadingText: Text('期望价格',
                style: TextStyle(
                  fontSize: 16,
                )),
            inputFormatters: [
              DecimalInputFormat(),
            ],
            hintText: '填写（数字）',
            prefix: '￥',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
//          MaxExpectedPriceField(model),
          ExpectedDeliveryDateField(widget.order),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Divider(
              height: 0,
            ),
          ),
          ContactWayField(widget.order),
        ],
      ),
    );
  }

  Widget _buildBottom(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            color: Colors.white,
            margin: EdgeInsets.only(
              top: 3,
            ),
            padding: EdgeInsets.all(15),
            child: Column(children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "备注",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                child: TextFieldComponent(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  dividerPadding: EdgeInsets.only(),
                  focusNode: _remarksFocusNode,
                  hintText: '填写',
                  autofocus: false,
                  inputType: TextInputType.text,
                  textAlign: TextAlign.left,
                  hideDivider: true,
                  maxLines: null,
                  maxLength: 120,
                  controller: _remarksController,
                ),
              )
            ]),
          ),
//          RemarksField(model),
          Column(
            children: <Widget>[
              Container(
                margin:
                    EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 10),
                child: Row(
                  children: <Widget>[
                    Text(
                      '附件',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              EditableAttachments(
                list: widget.order.attachments,
                maxNum: 5,
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHideBody(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 20),
      child: Center(
        child: Column(
          children: <Widget>[
            ProductionAreasField(widget.order),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Divider(
                height: 0,
              ),
            ),
            MachiningTypeField(widget.order),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Divider(
                height: 0,
              ),
            ),
            IsProofingField(widget.order),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Divider(
                height: 0,
              ),
            ),
            IsProvideSampleProductField(widget.order),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Divider(
                height: 0,
              ),
            ),
            IsInvoiceField(widget.order),
          ],
        ),
      ),
    );
  }

  //是否展开更多
  Widget _buildHideTips(BuildContext context) {
    return GestureDetector(
        child: Container(
          child: Align(
              alignment: Alignment.centerRight,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(''),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      '继续完善需求信息，更加精准匹配工厂',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Text(
                    '更多条件',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFFFF9516),
                    ),
                  ),
                  Icon(
                    _isShowMore
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_up,
                    color: Color(0xFFFF9516),
                    size: 28,
                  ),
                ],
              )),
          decoration: BoxDecoration(
            color: Color.fromRGBO(242, 242, 242, 1),
          ),
        ),
        onTap: () {
          setState(() {
            _isShowMore = !_isShowMore;
          });
        });
  }

  /// 发布
  void onPublish(String factoryUid) async {
    bool isSubmit = false;
    if (widget.isReview) {
      widget.order.code = '';
    }
    widget.order.details.expectedMachiningQuantity =
        ClassHandleUtil.transInt(_quantityController.text);
    widget.order.details.maxExpectedPrice =
        ClassHandleUtil.removeSymbolRMBToDouble(_priceController.text);
    widget.order.remarks = _remarksController.text;

    if (widget.order.details.category == null) {
      isSubmit = _showValidateMsg(context, '产品品类不可以为空');
    }else if (widget.order.details.expectedMachiningQuantity == null) {
      isSubmit = _showValidateMsg(context, '订单数量不可以为空');
    }else if (widget.order.details.expectedDeliveryDate == null) {
      isSubmit = _showValidateMsg(context, '交货时间不可以为空');
    }else if(widget.order.details.expectedDeliveryDate.isBefore(DateTime.now())){
      isSubmit = _showValidateMsg(context, '交货时间不可比当前时间小');
    } else if (widget.order.details.contactPerson == null ||
        widget.order.details.contactPerson == '' ||
        widget.order.details.contactPhone == null ||
        widget.order.details.contactPhone == '') {
      isSubmit = _showValidateMsg(context, '联系方式不可以为空');
    }else{
      isSubmit = true;
    }
    if(isSubmit){
      if(widget.isCreate){
        String code = await RequirementOrderRepository().publishNewRequirement(
            widget.order, factoryUid, factoryUid != null ? true : false);
        if (code != null && code != '') {
          widget.order.code = code;
          //根据code查询明
          RequirementOrderModel model =
          await RequirementOrderRepository().getRequirementOrderDetail(code);
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => PublishRequirementSuccessDialog(
                  model: model,
                ),
              ),
              ModalRoute.withName('/'));
        }
      }else{
        String code = await RequirementOrderRepository().updateRequirement(widget.order);
        if (code != null) {
          //根据code查询明
          RequirementOrderModel model =
          await RequirementOrderRepository().getRequirementOrderDetail(code);

          List<QuoteModel> quotes = await RequirementOrderRepository()
              .getRequirementOrderQuotes(code: model.code, page: 0, size: 1);

          if (model != null && quotes != null) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => RequirementOrderDetailPage(
                    order: model,
                    quotes: quotes,
                  ),
                ),
                ModalRoute.withName('/'));
          }
        } else {
          showDialog<void>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('更新失败'),
              );
            },
          );
        }
      }
    }
  }

  bool _showValidateMsg(BuildContext context,String message){
    _validateMessage(context, '${message}');
    return false;
  }

  Future<void> _validateMessage(BuildContext context,String message) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return CustomizeDialog(
            dialogType: DialogType.RESULT_DIALOG,
            failTips: '${message}',
            callbackResult: false,
            outsideDismiss: true,
          );
        }
    );
  }

  ///完善信息
//  void onUpdate() async {
//
//    if (code != null) {
//      //根据code查询明
//      RequirementOrderModel model =
//          await RequirementOrderRepository().getRequirementOrderDetail(code);
//
//      List<QuoteModel> quotes = await RequirementOrderRepository()
//          .getRequirementOrderQuotes(code: model.code, page: 0, size: 1);
//
//      if (model != null && quotes != null) {
//        Navigator.of(context).pushAndRemoveUntil(
//            MaterialPageRoute(
//              builder: (context) => RequirementOrderDetailPage(
//                    order: model,
//                    quotes: quotes,
//                  ),
//            ),
//            ModalRoute.withName('/'));
//      }
//    } else {
//      showDialog<void>(
//        context: context,
//        builder: (context) {
//          return AlertDialog(
//            title: Text('更新失败'),
//          );
//        },
//      );
//    }
//  }
}
