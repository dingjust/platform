import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class RequirementQuoteOrderForm extends StatefulWidget {
  RequirementOrderModel model;
  QuoteModel quoteModel;
  bool update;
  RequirementQuoteOrderForm(
      {@required this.model, this.quoteModel, this.update = false});

  _RequirementQuoteOrderFormState createState() =>
      _RequirementQuoteOrderFormState();
}

class _RequirementQuoteOrderFormState extends State<RequirementQuoteOrderForm> {
  TextEditingController _fabricController = TextEditingController();
  TextEditingController _excipientsController = TextEditingController();
  TextEditingController _processingController = TextEditingController();
  TextEditingController _otherController = TextEditingController();
  TextEditingController _remarksController = TextEditingController();
  TextEditingController _sampleController = TextEditingController();
  TextEditingController _unitPriceController = TextEditingController();
  FocusNode _fabricFocusNode = FocusNode();
  FocusNode _excipientsFocusNode = FocusNode();
  FocusNode _processingFocusNode = FocusNode();
  FocusNode _otherFocusNode = FocusNode();
  FocusNode _remarksFocusNode = FocusNode();
  FocusNode _sampleFocusNode = FocusNode();
  FocusNode _unitPriceFocusNode = FocusNode();
  List<MediaModel> attachments = [];
  DateTime expectedDeliveryDate = DateTime.now();
  DateTime quoteDate;
  bool isHide = true;

  GlobalKey _scaffoldKey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState

    if (widget.update && widget.quoteModel != null) {
      _fabricController.text =
          widget.quoteModel.unitPriceOfFabric?.toString() ?? '';
      _excipientsController.text =
          widget.quoteModel.unitPriceOfExcipients?.toString() ?? '';
      _processingController.text =
          widget.quoteModel.unitPriceOfProcessing?.toString() ?? '';
      _otherController.text = widget.quoteModel.costOfOther?.toString() ?? '';
      _remarksController.text = widget.quoteModel.remarks;
      _sampleController.text =
          widget.quoteModel.costOfSamples?.toString() ?? '';
      _unitPriceController.text = widget.quoteModel.unitPrice?.toString() ?? '';
      quoteDate = widget.quoteModel.expectedDeliveryDate??'';
    } else {
      expectedDeliveryDate = widget.model.details.expectedDeliveryDate;
    }

    if (widget.update) {
      attachments = widget.quoteModel.attachments;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          brightness: Brightness.light,
          centerTitle: true,
          elevation: 0.5,
          title: Text(widget.update ? '修改报价' : '填写报价'),
        ),
        body: Container(
            color: Color.fromRGBO(245, 245, 245, 1),
            margin: EdgeInsets.only(bottom: 70),
            child: ListView(
              children: <Widget>[
                _buildRequirementInfo(),
                _buildQuoteInfo(),
                _buildProofingInfo(),
                _buildConfirmationDeliveryDate(),
                _buildAccessory(),
                _buildRemarks()
              ],
            )),
        floatingActionButton: FloatingActionButton.extended(
          icon: Container(
            width: 0,
            child: Icon(
              null,
              color: Colors.white,
            ),
          ),
          label: Container(
              width: 300,
              child: Center(
                child: Text(
                  widget.update ? '修改报价' : '提交报价',
                  style: TextStyle(
                    fontSize: 20,
                    color: Color.fromRGBO(36, 38, 41, 1),
                  ),
                ),
              )),
          onPressed: onSubmit,
          backgroundColor: Colors.amberAccent,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        backgroundColor: Colors.white);
  }

  Widget _buildRequirementInfo() {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 15),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          _buildEntries(),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: Text(
                      '交货时间',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Text(
                    DateFormatUtil.formatYMD(expectedDeliveryDate),
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildEntries() {
    Widget _pictureWidget;

    if (widget.model.details?.pictures == null) {
      _pictureWidget = Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Color.fromRGBO(243, 243, 243, 1)),
        child: Icon(B2BIcons.noPicture,
            color: Color.fromRGBO(200, 200, 200, 1), size: 60),
      );
    } else {
      if (widget.model.details.pictures.isEmpty) {
        _pictureWidget = Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Color.fromRGBO(243, 243, 243, 1)),
          child: Icon(B2BIcons.noPicture,
              color: Color.fromRGBO(200, 200, 200, 1), size: 60),
        );
      } else {
        _pictureWidget = Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              image: DecorationImage(
                image: NetworkImage(
                    '${GlobalConfigs.IMAGE_BASIC_URL}${widget.model.details.pictures[0].url}'),
                fit: BoxFit.cover,
              )),
        );
      }
    }

    return Container(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Row(
        children: <Widget>[
          _pictureWidget,
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              height: 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  widget.model.details.productName != null
                      ? Text(
                          widget.model.details.productName,
                          style: TextStyle(fontSize: 15),
                          overflow: TextOverflow.ellipsis,
                        )
                      : Text(
                          ' ',
                          style: TextStyle(fontSize: 15, color: Colors.red),
                        ),
                  widget.model.details.productSkuID != null
                      ? Container(
                          padding: EdgeInsets.fromLTRB(3, 1, 3, 1),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '货号：${widget.model.details.productSkuID}',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        )
                      : Container(),
                  Container(
                    padding: EdgeInsets.fromLTRB(3, 1, 3, 1),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 243, 243, 1),
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      "${widget.model.details.majorCategory?.name}   ${widget.model.details.category?.name}   ${widget.model.details.expectedMachiningQuantity}件",
                      style: TextStyle(
                          fontSize: 15,
                          color: Color.fromRGBO(255, 133, 148, 1)),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQuoteInfo() {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Column(
        children: <Widget>[
          TextFieldComponent(
            padding: EdgeInsets.symmetric(vertical: 5),
            dividerPadding: EdgeInsets.only(),
            focusNode: _unitPriceFocusNode,
            leadingText: '生产单价￥',
            hintText: '必填',
            autofocus: false,
            inputType: TextInputType.number,
            textAlign: TextAlign.right,
            controller: _unitPriceController,
          ),
          _buildProductHide(context),
          _buildPriceEntries(context),
        ],
      ),
    );
  }

  Widget _buildProductHide(BuildContext context) {
    return GestureDetector(
        child: Container(
          margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
          child: Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    "报价明细",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  Icon(
                    isHide
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_up,
                    color: Colors.grey,
                    size: 28,
                  ),
                ],
              )),
        ),
        onTap: () {
          setState(() {
            isHide = !isHide;
          });
        });
  }

  Widget _buildPriceEntries(BuildContext context){
    return Offstage(
      offstage: isHide,
      child: Container(
          child:Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 20),
                child:
                TextFieldComponent(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  dividerPadding: EdgeInsets.only(),
                  focusNode: _fabricFocusNode,
                  leadingText: '面料单价￥',
                  hintText: '填写',
                  autofocus: false,
                  inputType: TextInputType.number,
                  textAlign: TextAlign.right,
                  controller: _fabricController,
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 20),
                child:
                TextFieldComponent(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  dividerPadding: EdgeInsets.only(),
                  focusNode: _excipientsFocusNode,
                  leadingText: '辅料单价￥',
                  hintText: '填写',
                  autofocus: false,
                  inputType: TextInputType.number,
                  textAlign: TextAlign.right,
                  controller: _excipientsController,
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 20),
                child:TextFieldComponent(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  dividerPadding: EdgeInsets.only(),
                  focusNode: _processingFocusNode,
                  leadingText: '加工单价￥',
                  hintText: '填写',
                  autofocus: false,
                  inputType: TextInputType.number,
                  textAlign: TextAlign.right,
                  controller: _processingController,
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 20),
                child: TextFieldComponent(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  dividerPadding: EdgeInsets.only(),
                  focusNode: _otherFocusNode,
                  leadingText: '其他单价￥',
                  hintText: '填写',
                  autofocus: false,
                  inputType: TextInputType.number,
                  textAlign: TextAlign.right,
                  controller: _otherController,
                ),
              )
            ],
          )
      ),
    );
  }

  Widget _buildProofingInfo() {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: TextFieldComponent(
        padding: EdgeInsets.symmetric(vertical: 5),
        dividerPadding: EdgeInsets.only(),
        focusNode: _sampleFocusNode,
        leadingText: '打样费￥',
        hintText: '填写',
        autofocus: false,
        inputType: TextInputType.number,
        textAlign: TextAlign.right,
        controller: _sampleController,
      ),
    );
  }

  Widget _buildConfirmationDeliveryDate() {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          Container(
              child: GestureDetector(
            child: ListTile(
              leading: Text(
                '确认交货日期',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing:
              quoteDate == null
                  ? Text(
                '必选',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey),
              )
                  : Text(
                DateFormatUtil.formatYMD(quoteDate),
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black),
              ),
            ),
                onTap: () {
                  _showDatePicker();
                },
              )),
        ],
      ),
    );
  }

  Widget _buildAccessory() {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: Column(children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "附件",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ),
        Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.only(left: 10),
              child: EditableAttachments(list: attachments),
            )),
      ]),
    );
  }

  Widget _buildRemarks() {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: TextFieldComponent(
        padding: EdgeInsets.symmetric(vertical: 5),
        dividerPadding: EdgeInsets.only(),
        focusNode: _remarksFocusNode,
        leadingText: '备注',
        hintText: '填写',
        autofocus: false,
        inputType: TextInputType.text,
        textAlign: TextAlign.right,
        controller: _remarksController,
      ),
    );
  }

  // void _countTotalPrice(String value) {
  //   setState(() {
  //     fabric = double.parse(
  //         _fabricController.text == '' ? '0' : _fabricController.text);
  //     excipients = double.parse(
  //         _excipientsController.text == '' ? '0' : _excipientsController.text);
  //     processing = double.parse(
  //         _processingController.text == '' ? '0' : _processingController.text);
  //     other = double.parse(
  //         _otherController.text == '' ? '0' : _otherController.text);
  //     unitPrice = fabric + excipients + processing + other;
  //     sample = double.parse(
  //         _sampleController.text == '' ? '0' : _sampleController.text);
  //   });
  // }

  //打开日期选择器
  void _showDatePicker() {
    _selectDate(context);
  }

  //生成日期选择器
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime _picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: new DateTime(1999),
        lastDate: new DateTime(2999));

    if (_picked != null) {
      setState(() {
        quoteDate = _picked;
      });
    }
  }

  void onSubmit() {
    if (_unitPriceController.text.isEmpty) {
      (_scaffoldKey.currentState as ScaffoldState).showSnackBar(
        SnackBar(
          content: Text('请选择生产单价'),
          duration: Duration(seconds: 1),
        ),
      );
    } else {
      showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (context) {
          return AlertDialog(
            title: Text('确定报价？'),
            actions: <Widget>[
              FlatButton(
                child: Text('取消',style: TextStyle(
                  color: Colors.grey
                ),),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('确定',style: TextStyle(
                    color: Colors.black
                )),
                onPressed: () async {
                  await onSure();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void onSure() async {
    QuoteModel model;
    if (widget.update) {
      model = widget.quoteModel;
    } else {
      //新建
      model = QuoteModel();
    }
    //拼装数据
    model.unitPriceOfFabric = _fabricController.text.isEmpty
        ? 0
        : double.parse(_fabricController.text);
    model.unitPriceOfExcipients = _processingController.text.isEmpty
        ? 0
        : double.parse(_excipientsController.text);
    model.unitPriceOfProcessing = _processingController.text.isEmpty
        ? 0
        : double.parse(_processingController.text);
    model.costOfOther =
        _otherController.text.isEmpty ? 0 : double.parse(_otherController.text);
    model.costOfSamples = _sampleController.text.isEmpty
        ? 0
        : double.parse(_sampleController.text);
    model.requirementOrder = RequirementOrderModel(code: widget.model.code);
    model.remarks = _remarksController.text;
    model.expectedDeliveryDate = quoteDate;
    model.attachments = attachments;
    model.unitPrice = double.parse(_unitPriceController.text);
    String response;
    if (widget.update) {
      model.code = widget.quoteModel.code;
      response = await QuoteOrderRepository().quoteUpdate(model);
    } else {
      response = await QuoteOrderRepository().quoteCreate(model);
    }

    Navigator.of(context).pop();

    if (response == '') {
      showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (context) {
          return AlertDialog(
            title: Text(widget.update ? '修改成功' : '报价成功'),
            actions: <Widget>[
              FlatButton(
                child: Text('确定',style: TextStyle(
                    color: Colors.black
                )),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      if (!widget.update) {
        //查询明细
        QuoteModel detailModel =
            await QuoteOrderRepository().getQuoteDetails(response);
        widget.quoteModel = detailModel;
        Navigator.of(context).pop(detailModel);
      } else {
        //成功回调传递
        Navigator.of(context).pop(true);
      }
    }
  }
}

class InputRow extends StatelessWidget {
  final String label;

  final TextField field;

  final bool hasBottom;

  const InputRow(
      {Key key,
      @required this.label,
      @required this.field,
      this.hasBottom = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      decoration: BoxDecoration(
          border: hasBottom
              ? Border(
                  bottom: BorderSide(
                      width: 0.5, color: Color.fromRGBO(200, 200, 200, 1)))
              : Border()),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 100,
            margin: EdgeInsets.only(right: 20),
            child: Text(
              label,
              style:
                  TextStyle(color: Color.fromRGBO(36, 38, 41, 1), fontSize: 18),
            ),
          ),
          Expanded(
            flex: 1,
            child: field,
          )
        ],
      ),
    );
  }
}
