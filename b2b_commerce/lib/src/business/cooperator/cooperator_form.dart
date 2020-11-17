import 'package:b2b_commerce/src/_shared/widgets/company_select.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

class CooperatorForm extends StatefulWidget {
  CooperatorForm({Key key}) : super(key: key);

  @override
  _CooperatorFormState createState() => _CooperatorFormState();
}

class _CooperatorFormState extends State<CooperatorForm> {
  CooperatorModel form;

  FocusNode _titleFocusNode = FocusNode();
  TextEditingController _titleController = TextEditingController();

  @override
  void initState() {
    form = CooperatorModel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            '添加合作商',
            style: TextStyle(
                color: Color(0xff455a64), fontWeight: FontWeight.bold),
          ),
          elevation: 0.5,
        ),
        body: Container(
            child: ListView(
          children: <Widget>[
            _buildBasicInfo(),
            _buildAccountInfo(),
            _buildRelationInfo()
          ],
        )),
      ),
    );
  }

  Widget _buildRelationInfo() {
    return Container();
  }

  Widget _buildAccountInfo() {
    return Container();
  }

  Widget _buildBasicInfo() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Row(
            children: [
              Text(
                '基本信息',
                style: TextStyle(color: Colors.grey),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 2, 0, 0),
            child: Column(
              children: [
                Row(
                  children: [Text('合作商名称')],
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFieldBorderComponent(
                        padding: EdgeInsets.all(0),
                        hideDivider: true,
                        isRequired: true,
                        textAlign: TextAlign.left,
                        hintText: '填写',
                        controller: _titleController,
                        focusNode: _titleFocusNode,
                        onChanged: (v) {
                          form.name = _titleController.text;
                        },
                      ),
                    ),
                    Container(
                      height: 48,
                      margin: EdgeInsets.only(left: 10),
                      child: FlatButton(
                        color: Color.fromRGBO(255, 214, 12, 1),
                        onPressed: () async {
                          CompanyModel company = await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => CompanySelectPage(),
                            ),
                          );

                          form.name = company.name;
                          form.partner.approvalStatus = company.approvalStatus;
                          form.partner.contactPerson = company.contactPerson;
                          form.partner.contactPhone = company.contactPhone;
                          form.partner.contactUid = company.contactUid;
                          form.partner.id = company.id;
                          form.partner.name = company.name;
                          form.partner.uid = company.uid;
                        },
                        child: Text(
                          '选择平台用户',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
