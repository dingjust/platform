import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

class OfflineOrderCooperatorInput extends StatefulWidget {
  CompanyModel model;
  String type;

  OfflineOrderCooperatorInput({this.model, this.type});

  _OfflineOrderCooperatorInputState createState() =>
      _OfflineOrderCooperatorInputState();
}

class _OfflineOrderCooperatorInputState
    extends State<OfflineOrderCooperatorInput> {
  FocusNode _factoryFocusNode = FocusNode();
  FocusNode _nameFocusNode = FocusNode();
  FocusNode _phoneFocusNode = FocusNode();
  final TextEditingController _factoryController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  TextEditingController controller = TextEditingController();
  CompanyModel company = new CompanyModel();

  @override
  void initState() {
    if (widget.model != null) {
      _factoryController.text = widget.model.name;
      _nameController.text = widget.model.contactPerson;
      _phoneController.text = widget.model.contactPhone;

      company = widget.model;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('合作商'),
            elevation: 0.5,
            brightness: Brightness.light,
            centerTitle: true,
            actions: <Widget>[
              GestureDetector(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Center(
                      child: Text(
                        '确定',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  onTap: () async {
                    //带值返回上一页
                    Navigator.of(context).pop(company);
                  })
            ]),
        body: Container(
            color: Colors.white,
            child: ListView(
              children: <Widget>[
                _buildFactoryInfo(context),
              ],
            )));
  }

  Widget _buildFactoryInfo(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(10),
            child: TextFieldComponent(
              textAlign: TextAlign.left,
              focusNode: _factoryFocusNode,
              controller: _factoryController,
              autofocus: true,
              leadingText: Text('${widget.type}名称',
                  style: TextStyle(
                    fontSize: 16,
                  )),
              hintText: widget.model == null || widget.model.name == null
                  ? '请输入${widget.type}名称'
                  : widget.model.name,
              onChanged: (value) {
                setState(() {
                  company.name = value;
                });
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(10),
            child: TextFieldComponent(
              textAlign: TextAlign.left,
              focusNode: _nameFocusNode,
              controller: _nameController,
              leadingText: Text('联系人名',
                  style: TextStyle(
                    fontSize: 16,
                  )),
              hintText:
                  widget.model == null || widget.model.contactPerson == null
                      ? '请输入联系人名'
                      : widget.model.contactPerson,
              onChanged: (value) {
                setState(() {
                  company.contactPerson = value;
                });
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(10),
            child: TextFieldComponent(
              textAlign: TextAlign.left,
              focusNode: _phoneFocusNode,
              controller: _phoneController,
              leadingText: Text('联系电话',
                  style: TextStyle(
                    fontSize: 16,
                  )),
              hintText:
                  widget.model == null || widget.model.contactPhone == null
                      ? '请输入联系电话'
                      : widget.model.contactPhone,
              inputType: TextInputType.phone,
              onChanged: (value) {
                if (_phoneController.text.length > 11) {
                  _phoneController.text = controller.text;
                } else {
                  controller.text = _phoneController.text;
                }
                setState(() {
                  company.contactPhone = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
