import 'package:b2b_commerce/src/_shared/widgets/company_select.dart';
import 'package:b2b_commerce/src/business/cooperator/components/cooperator_selection_row.dart';
import 'package:b2b_commerce/src/business/cooperator/components/form_sumbit_btn.dart';
import 'package:b2b_commerce/src/my/address/region_select.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
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
  FocusNode _contactPersonFocusNode = FocusNode();
  TextEditingController _contactPersonController = TextEditingController();
  FocusNode _contactPhoneFocusNode = FocusNode();
  TextEditingController _contactPhoneController = TextEditingController();
  FocusNode _remarksFocusNode = FocusNode();
  TextEditingController _remarksController = TextEditingController();
  FocusNode _addressFocusNode = FocusNode();
  TextEditingController _addressController = TextEditingController();
  FocusNode _addressDetailFocusNode = FocusNode();
  TextEditingController _addressDetailController = TextEditingController();

  FocusNode _accountNameFocusNode = FocusNode();
  TextEditingController _accountNameController = TextEditingController();
  FocusNode _taxNumberFocusNode = FocusNode();
  TextEditingController _taxNumberController = TextEditingController();
  FocusNode _bankOfDepositFocusNode = FocusNode();
  TextEditingController _bankOfDepositController = TextEditingController();
  FocusNode _bankAccountFocusNode = FocusNode();
  TextEditingController _bankAccountController = TextEditingController();

  FocusNode _financeFocusNode = FocusNode();
  TextEditingController _financeController = TextEditingController();
  FocusNode _progressFocusNode = FocusNode();
  TextEditingController _progressController = TextEditingController();
  FocusNode _reconciliationFocusNode = FocusNode();
  TextEditingController _reconciliationController = TextEditingController();

  @override
  void initState() {
    form = CooperatorModel();
    form.address = AddressModel();
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
          actions: <Widget>[
            FormSumbitBtn(form: form)
          ],
        ),
        body: Container(
          child: ListView(
            children: <Widget>[
              _buildBasicInfo(),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
              ),
              _buildAccountInfo(),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
              ),
              _buildRelationInfo(),
              Container(
                height: 50,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRelationInfo() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Row(
            children: [
              Text(
                '关联方案',
                style: TextStyle(color: Colors.grey),
              )
            ],
          ),
          CooperatorSelectionRow(
            titleText: Text('绑定财务方案'),
            hintText: '',
            controller: _financeController,
            focusNode: _financeFocusNode,
            trailing: form.payPlan == null
                ? Container()
                : IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        _financeController.text = '';
                        form.payPlan = null;
                      });
                    },
                  ),
            onPressed: () {
              // TODO 选择财务方案
            },
            buttonText: '选择财务方案',
          ),
          CooperatorSelectionRow(
            titleText: Text('绑定节点方案'),
            hintText: '',
            controller: _progressController,
            focusNode: _progressFocusNode,
            trailing: form.progressPlan == null
                ? Container()
                : IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        _progressController.text = '';
                        form.progressPlan = null;
                      });
                    },
                  ),
            onPressed: () {
              // TODO 选择节点方案
            },
            buttonText: '选择节点方案',
          ),
          CooperatorSelectionRow(
            titleText: Text('绑定对账方案'),
            hintText: '',
            controller: _reconciliationController,
            focusNode: _reconciliationFocusNode,
            trailing: form.progressPlan == null
                ? Container()
                : IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        _reconciliationController.text = '';
                        form.payPlan = null;
                      });
                    },
                  ),
            onPressed: () {
              // TODO 选择对账方案
            },
            buttonText: '选择对账方案',
          ),
        ],
      ),
    );
  }

  Widget _buildAccountInfo() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Row(
            children: [
              Text(
                '公账信息',
                style: TextStyle(color: Colors.grey),
              )
            ],
          ),
          _inputRow(
            title: Text('户名'),
            focusNode: _accountNameFocusNode,
            controller: _accountNameController,
            onChange: (v) {
              form.accountName = v;
            },
          ),
          _inputRow(
            title: Text('税号'),
            focusNode: _taxNumberFocusNode,
            controller: _taxNumberController,
            onChange: (v) {
              form.taxNumber = v;
            },
          ),
          _inputRow(
            title: Text('开户行'),
            focusNode: _bankOfDepositFocusNode,
            controller: _bankOfDepositController,
            onChange: (v) {
              form.bankOfDeposit = v;
            },
          ),
          _inputRow(
            title: Text('银行账号'),
            focusNode: _bankAccountFocusNode,
            controller: _bankAccountController,
            onChange: (v) {
              form.bankAccount = v;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfo() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Row(children: [
            Text(
              '基本信息',
              style: TextStyle(color: Colors.grey),
            )
          ]),
          _buildCooperatorRow(),
          _inputRow(
            title: Text.rich(TextSpan(children: [
              TextSpan(text: '联系人'),
              TextSpan(text: ' *', style: TextStyle(color: Colors.red))
            ])),
            focusNode: _contactPersonFocusNode,
            controller: _contactPersonController,
            onChange: (v) {
              form.contactPerson = v;
            },
          ),
          _inputRow(
            title: Text.rich(TextSpan(children: [
              TextSpan(text: '联系方式'),
              TextSpan(text: ' *', style: TextStyle(color: Colors.red))
            ])),
            focusNode: _contactPhoneFocusNode,
            controller: _contactPhoneController,
            onChange: (v) {
              form.contactPhone = v;
            },
          ),
          _buildIdentityRow(),
          _inputRow(
            title: Text('备注'),
            focusNode: _remarksFocusNode,
            controller: _remarksController,
            onChange: (v) {
              form.remarks = v;
            },
          ),
          _buildAdressRow(),
        ],
      ),
    );
  }

  Widget _buildAdressRow() {
    return Column(
      children: [
        CooperatorSelectionRow(
          titleText: Text.rich(TextSpan(children: [
            TextSpan(text: '所在区域'),
            TextSpan(text: ' *', style: TextStyle(color: Colors.red))
          ])),
          hintText: '省市区',
          controller: _addressController,
          trailing: form.address.region == null
              ? Container()
              : IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      _addressController.text = '';
                      form.address.region = null;
                      form.address.city = null;
                      form.address.cityDistrict = null;
                    });
                  },
                ),
          focusNode: _addressFocusNode,
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RegionSelectPage(RegionRepositoryImpl()),
              ),
            ) as DistrictModel;

            if (result == null) {
              return;
            }

            setState(() {
              form.address.cityDistrict = result;
              form.address.city = result.city;
              form.address.region = result.city.region;
              _addressController.text =
                  result.city.region.name + result.city.name + result.name;
            });
          },
          buttonText: '选择省市区',
        ),
        Container(
          margin: EdgeInsets.fromLTRB(10, 5, 0, 0),
          child: Column(
            children: [
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: TextFieldBorderComponent(
                      padding: EdgeInsets.all(0),
                      hideDivider: true,
                      isRequired: true,
                      textAlign: TextAlign.left,
                      hintText: '详细地址',
                      controller: _addressDetailController,
                      focusNode: _addressDetailFocusNode,
                      onChanged: (v) {
                        form.address.line1 = v;
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIdentityRow() {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 2, 0, 0),
      child: Column(
        children: [
          Row(children: [
            Text.rich(TextSpan(children: [
              TextSpan(text: '身份类型'),
              TextSpan(text: ' *', style: TextStyle(color: Colors.red))
            ]))
          ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(
              _statuses.length,
              (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      form.category = _statuses[index];
                    });
                  },
                  child: Row(
                    children: <Widget>[
                      Radio(
                        value: _statuses[index],
                        groupValue: form.category,
                        onChanged: (v) {
                          setState(() {
                            form.category = _statuses[index];
                          });
                        },
                      ),
                      Container(
                        child: Text(
                          CooperatorCategoryLocalizedMap[_statuses[index]],
                          softWrap: false,
                          overflow: TextOverflow.visible,
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCooperatorRow() {
    return CooperatorSelectionRow(
      titleText: Text.rich(TextSpan(children: [
        TextSpan(text: '合作商名称'),
        TextSpan(text: ' *', style: TextStyle(color: Colors.red))
      ])),
      enabled: form.partner == null,
      trailing: form.partner == null
          ? Container()
          : IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                setState(
                  () {
                    _titleController.text = '';
                    form.name = null;
                    form.partner = null;
                  },
                );
              },
            ),
      focusNode: _titleFocusNode,
      controller: _titleController,
      onChanged: (v) {
        form.name = _titleController.text;
      },
      onPressed: () async {
        CompanyModel company = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CompanySelectPage(),
          ),
        );
        if (company != null) {
          setState(() {
            _titleController.text = company.name;
            form.name = company.name;
            form.partner = company;
          });
        }
      },
      buttonText: '选择平台用户',
    );
  }

  Widget _inputRow(
      {Widget title,
      FocusNode focusNode,
      TextEditingController controller,
      ValueChanged onChange}) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 5, 0, 0),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 2),
            child: Row(
              children: [title],
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: TextFieldBorderComponent(
                  padding: EdgeInsets.all(0),
                  hideDivider: true,
                  isRequired: true,
                  textAlign: TextAlign.left,
                  hintText: '填写',
                  controller: controller,
                  focusNode: focusNode,
                  onChanged: (v) {
                    onChange(v);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

const _statuses = [
  CooperatorCategory.CUSTOMER,
  CooperatorCategory.FABRIC_SUPPLIER,
  CooperatorCategory.SUPPLIER
];
