import 'package:b2b_commerce/src/home/requirement/fast_publish_requirement.dart';
import 'package:b2b_commerce/src/home/requirement/requirement_publish_success.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

class RequirementNumPick extends StatefulWidget {
  FastRequirementForm fastRequirementForm;

  RequirementNumPick({Key key, this.fastRequirementForm}) : super(key: key);

  _RequirementNumPickState createState() => _RequirementNumPickState();
}

class _RequirementNumPickState extends State<RequirementNumPick> {
  GlobalKey _formKey = new GlobalKey<FormState>();
  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    TextFormField numTextField = TextFormField(
        controller: widget.fastRequirementForm.requirementNum,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(hintText: '输入', border: InputBorder.none),
        validator: (v) {
          return v.trim().length > 0 && int.parse(v) > 0 ? null : "数量大于0";
        });
    TextFormField personTextField = TextFormField(
        controller: widget.fastRequirementForm.contactPerson,
        decoration: InputDecoration(hintText: '输入', border: InputBorder.none),
        validator: (v) {
          return v.trim().length > 0 ? null : "请填写联系人";
        });
    TextFormField phoneTextField = TextFormField(
        controller: widget.fastRequirementForm.phone,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(hintText: '输入', border: InputBorder.none),
        validator: (v) {
          return v.trim().length > 0 ? null : "请填写电话（手机）";
        });

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text('数量'),
          centerTitle: true,
        ),
        body: Form(
          key: _formKey,
          autovalidate: true,
          child: ListView(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                color: Color.fromRGBO(245, 244, 243, 1),
                child: Row(
                  children: <Widget>[
                    Text(
                      '已填选结果: ${widget.fastRequirementForm.categories[0].name}  ${DateFormatUtil.formatYMD(widget.fastRequirementForm.deliveryDate)}',
                      style: TextStyle(
                          color: Color.fromRGBO(100, 100, 100, 1),
                          fontSize: 18),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Column(
                  children: <Widget>[
                    _buildInputRow(label: '需求数量', textField: numTextField),
                    Divider(),
                    _buildContact(),
                    _buildInputRow(label: '填写联系人', textField: personTextField),
                    _buildInputRow(label: '电话(手机)', textField: phoneTextField),
                    _buildButton()
                  ],
                ),
              )
            ],
          ),
        ));
  }

  Widget _buildInputRow({String label, TextFormField textField}) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Row(
        children: <Widget>[
          Container(
            width: 100,
            child: Text(
              label,
              style:
                  TextStyle(color: Color.fromRGBO(36, 38, 41, 1), fontSize: 18),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration:
                  BoxDecoration(color: Color.fromRGBO(245, 245, 245, 1)),
              child: textField,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildContact() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 20, 0, 30),
      child: Row(
        children: <Widget>[
          Text(
            '联系方式  ',
            style: TextStyle(
                color: Color.fromRGBO(150, 150, 150, 1), fontSize: 18),
          ),
          Text(
            '（必填）',
            style: TextStyle(color: Color.fromRGBO(255, 45, 45, 1)),
          ),
        ],
      ),
    );
  }

  Widget _buildButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
            width: double.infinity,
            height: 50,
            margin: EdgeInsets.fromLTRB(0, 200, 0, 10),
            child: Builder(builder: (context) {
              return FlatButton(
                color: Color.fromRGBO(255, 214, 12, 1),
                child: Text(
                  '确定发布',
                  style: TextStyle(
                    color: Color.fromRGBO(36, 38, 41, 1),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                onPressed: () async {
                  if (Form.of(context).validate()) {
                    //验证通过提交数据
                    // 组合成Model
                    RequirementOrderModel requirementOrder =
                        RequirementOrderModel(
                      details: RequirementInfoModel(
                          category: widget.fastRequirementForm.categories[0],
                          contactPerson:
                              widget.fastRequirementForm.contactPerson.text,
                          contactPhone: widget.fastRequirementForm.phone.text,
                          expectedDeliveryDate:
                              widget.fastRequirementForm.deliveryDate,
                          expectedMachiningQuantity: int.parse(
                              widget.fastRequirementForm.requirementNum.text)),
                    );

                    String code = await RequirementOrderRepository()
                        .publishNewRequirement(requirementOrder);

                    requirementOrder.code = code;

                    ///清空表单数据
                    resetFastRequirementForm(widget.fastRequirementForm);

                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) =>
                                PublishRequirementSuccessDialog(
                                  model: requirementOrder,
                                )),
                        ModalRoute.withName('/'));
                  } else {
                    showDialog(
                        context: context,
                        child: SimpleDialog(
                          // title: Text('请填写必要信息'),
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                              child: Text('请填写必要信息'),
                            ),
                          ],
                        ));
                  }
                },
              );
            })),
        Text(
          '蕉衣会尽快与您联系',
          style: TextStyle(color: Color.fromRGBO(255, 68, 68, 1)),
        )
      ],
    );
  }

  ///重置表单数据
  void resetFastRequirementForm(FastRequirementForm fastRequirementForm) {
    fastRequirementForm = FastRequirementForm(
        categories: [],
        deliveryDate: DateTime.now(),
        contactPerson: TextEditingController(),
        phone: TextEditingController(),
        requirementNum: TextEditingController());
  }
}
