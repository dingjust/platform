import 'package:b2b_commerce/src/business/orders/quote_order_detail.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class RequirementQuoteOrderFrom extends StatefulWidget {
  RequirementOrderModel model;
  QuoteModel quoteModel;
  bool update;
  RequirementQuoteOrderFrom(
      {@required this.model, this.quoteModel, this.update = false});

  _RequirementQuoteOrderFromState createState() =>
      _RequirementQuoteOrderFromState();
}

class _RequirementQuoteOrderFromState extends State<RequirementQuoteOrderFrom> {
  TextEditingController _fabricController = TextEditingController();
  TextEditingController _excipientsController = TextEditingController();
  TextEditingController _processingController = TextEditingController();
  TextEditingController _otherController = TextEditingController();
  TextEditingController _remarksController = TextEditingController();
  TextEditingController _sampleController = TextEditingController();

  double fabric = 0.0;
  double excipients = 0.0;
  double processing = 0.0;
  double other = 0.0;
  double totalPrice = 0.0;
  double sample = 0.0;
  List<MediaModel> attachments = [];
  DateTime expectedDeliveryDate = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    if (widget.quoteModel != null) {
      _fabricController.text = widget.quoteModel.unitPriceOfFabric.toString();
      _excipientsController.text =
          widget.quoteModel.unitPriceOfExcipients.toString();
      _processingController.text =
          widget.quoteModel.unitPriceOfProcessing.toString();
      _otherController.text = widget.quoteModel.costOfOther.toString();
      _remarksController.text = widget.quoteModel.remarks;
      _sampleController.text = widget.quoteModel.costOfSamples.toString();
      expectedDeliveryDate = widget.quoteModel.expectedDeliveryDate;

      if (widget.update) {
        attachments = widget.quoteModel.attachments;
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          centerTitle: true,
          elevation: 0.5,
          title: Text('填写报价'),
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
                  '提交报价',
                  style: TextStyle(
                    fontSize: 20,
                    color: Color.fromRGBO(36, 38, 41, 1),
                  ),
                ),
              )),
          onPressed: () async {
            QuoteModel model;
            if (widget.update) {
              model = widget.quoteModel;
            } else {
              //新建
              model = QuoteModel();
            }
            //拼装数据
            model.unitPriceOfFabric = fabric;
            model.unitPriceOfExcipients = excipients;
            model.unitPriceOfProcessing = processing;
            model.costOfOther = other;
            model.costOfSamples = sample;
            model.requirementOrderRef = widget.model.code;
            model.remarks = _remarksController.text;
            model.expectedDeliveryDate = expectedDeliveryDate;
            model.attachments = attachments;

            String response = await QuoteOrderRepository().quoteCreate(model);

            if (response == '') {
              showDialog<void>(
                context: context,
                barrierDismissible: true, // user must tap button!
                builder: (context) {
                  return AlertDialog(
                    title: Text('报价失败'),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('确定'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            } else {
              showDialog<void>(
                context: context,
                barrierDismissible: true, // user must tap button!
                builder: (context) {
                  return AlertDialog(
                    title: Text('报价成功'),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('确定'),
                        onPressed: () async {
                          Navigator.of(context).pop();
                          //查询明细
                          QuoteModel detailModel = await QuoteOrderRepository()
                              .getquoteDetail(response);
                          if (detailModel != null) {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    QuoteOrderDetailPage(item: detailModel)));
                          }
                        },
                      ),
                    ],
                  );
                },
              );
            }
          },
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

    if (widget.model.details.pictures == null) {
      _pictureWidget = Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Color.fromRGBO(243, 243, 243, 1)),
        child: Icon(
          B2BIcons.noPicture,
          color: Color.fromRGBO(200, 200, 200, 1),
          size: 25,
        ),
      );
    } else {
      if (widget.model.details.pictures.isEmpty) {
        _pictureWidget = Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Color.fromRGBO(243, 243, 243, 1)),
          child: Icon(
            B2BIcons.noPicture,
            color: Color.fromRGBO(200, 200, 200, 1),
            size: 25,
          ),
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
                          '暂无产品',
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
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              child: Text(
                '报价明细',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          InputRow(
              label: '面料单价',
              field: TextField(
                autofocus: false,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.right,
                controller: _fabricController,
                onChanged: _countTotalPrice,
                //只能输入数字
                decoration: InputDecoration(
                  hintText: '填写',
                  border: InputBorder.none,
                ),
              )),
          InputRow(
              label: '辅料单价',
              field: TextField(
                autofocus: false,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.right,
                controller: _excipientsController,
                onChanged: _countTotalPrice,
                //只能输入数字
                inputFormatters: <TextInputFormatter>[
                  WhitelistingTextInputFormatter.digitsOnly,
                ],
                decoration:
                    InputDecoration(hintText: '填写', border: InputBorder.none),
              )),
          InputRow(
              label: '加工单价',
              field: TextField(
                autofocus: false,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.right,
                onChanged: _countTotalPrice,
                controller: _processingController,
                //只能输入数字
                inputFormatters: <TextInputFormatter>[
                  WhitelistingTextInputFormatter.digitsOnly,
                ],
                decoration:
                    InputDecoration(hintText: '填写', border: InputBorder.none),
              )),
          InputRow(
              label: '其他单价',
              field: TextField(
                autofocus: false,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.right,
                onChanged: _countTotalPrice,
                controller: _otherController,
                //只能输入数字
                inputFormatters: <TextInputFormatter>[
                  WhitelistingTextInputFormatter.digitsOnly,
                ],
                decoration:
                    InputDecoration(hintText: '填写', border: InputBorder.none),
              )),
          Container(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '生产单价：',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey),
                  ),
                  Text(
                    '￥${totalPrice ?? 0}',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.red),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget _buildProofingInfo() {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: InputRow(
          hasBottom: false,
          label: '打样费',
          field: TextField(
            autofocus: false,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.right,
            controller: _sampleController,
            //只能输入数字
            inputFormatters: <TextInputFormatter>[
              WhitelistingTextInputFormatter.digitsOnly,
            ],
            decoration:
                InputDecoration(hintText: '填写', border: InputBorder.none),
          )),
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
              trailing: Text(
                expectedDeliveryDate == null
                    ? '选择'
                    : DateFormatUtil.formatYMD(expectedDeliveryDate),
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey),
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
      child: InputRow(
          hasBottom: false,
          label: '备注',
          field: TextField(
            autofocus: false,
            textAlign: TextAlign.right,
            controller: _remarksController,
            decoration:
                InputDecoration(hintText: '填写', border: InputBorder.none),
          )),
    );
  }

  void _countTotalPrice(String value) {
    setState(() {
      fabric = double.parse(
          _fabricController.text == '' ? '0' : _fabricController.text);
      excipients = double.parse(
          _excipientsController.text == '' ? '0' : _excipientsController.text);
      processing = double.parse(
          _processingController.text == '' ? '0' : _processingController.text);
      other = double.parse(
          _otherController.text == '' ? '0' : _otherController.text);
      totalPrice = fabric + excipients + processing + other;
      sample = double.parse(
          _sampleController.text == '' ? '0' : _sampleController.text);
    });
  }

  //打开日期选择器
  void _showDatePicker() {
    _selectDate(context);
  }

  //生成日期选择器
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime _picked = await showDatePicker(
        context: context,
        initialDate: expectedDeliveryDate,
        firstDate: new DateTime(1990),
        lastDate: new DateTime(2999));

    if (_picked != null) {
      setState(() {
        expectedDeliveryDate = _picked;
      });
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
