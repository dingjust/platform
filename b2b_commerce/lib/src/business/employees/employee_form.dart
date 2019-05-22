import 'dart:ui';

import 'package:b2b_commerce/src/common/customize_dialog.dart';
import 'package:b2b_commerce/src/common/request_data_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class EmployeeFormPage extends StatefulWidget {
  EmployeeFormPage({Key key, @required this.item, this.newlyCreated = false})
      : super(key: const Key('__employeeFormPage__'));

  B2BCustomerModel item;
  final bool newlyCreated;

  EmployeeFormPageState createState() => EmployeeFormPageState();
}

class EmployeeFormPageState extends State<EmployeeFormPage> {
  final TextEditingController _nameController = TextEditingController();
  FocusNode _nameFocusNode = FocusNode();
  final TextEditingController _mobileNumberController = TextEditingController();
  FocusNode _mobileNumberFocusNode = FocusNode();

  B2BCustomerModel _beforeItem;
  List<RegionModel> _regionSelects = [];
  List<RoleModel> _roleSelects = [];
  bool _enabled = true;


  @override
  void initState() {
    if (!widget.newlyCreated) _enabled = false;
    _nameController.text = widget.item?.name;
    _mobileNumberController.text = widget.item?.mobileNumber;

//    if (widget.item?.roles != null)
//      enumModels.addAll(widget.item.roles
//          .map((role) => EnumModel(role.uid, role.name))
//          .toList());
    if (widget.item?.roles != null) {
      for (int i = 0; i < widget.item.roles.length; i++) {
        _roleSelects.add(widget.item.roles[i]);
        _regionSelects.add(RegionModel(isocode: widget.item.roles[i].uid,name: widget.item.roles[i].name));
      }
    }

    // TODO: implement initState

    super.initState();
  }

  @override
  void dispose(){
    super.dispose();
    if(widget.newlyCreated)
    clearData();
  }

  //格式选中的角色
  String formatRoleSelectsText() {
    String text = '';

    if (_roleSelects != null) {
      text = '';
      for (int i = 0; i < _roleSelects.length; i++) {
        if (i > 2) {
          text += '...';
          break;
        }

        if (i == _roleSelects.length - 1) {
          text += _roleSelects[i].name;
        } else {
          text += _roleSelects[i].name + '、';
        }
      }
    }

    return text;
  }

  _getData(){
    if(!widget.newlyCreated)
    UserRepositoryImpl().getEmployee(widget.item.uid);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getData(),
        builder: (context, snapshot) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0.5,
              centerTitle: true,
              title: Text(widget.newlyCreated ? '添加员工' : '员工明细'),
              actions: <Widget>[
                Offstage(
                  offstage: _enabled,
                  child: IconButton(
                    icon: Text(
                      '编辑',
//                style: TextStyle(color: Color(0xffFF9516)),
                    ),
                    onPressed: () {
                      setState(() {
                        _enabled = !_enabled;
//                  FocusScope.of(context).requestFocus(_nameFocusNode);
                      });
                    },
                  ),
                )
              ],
            ),
            body: Container(
              color: Colors.grey[200],
              child: Column(
                children: <Widget>[
                  Container(
                    color: Colors.white,
                    child: TextFieldComponent(
                      controller: _nameController,
                      focusNode: _nameFocusNode,
                      leadingText: Text('姓名',
                          style: TextStyle(
                            fontSize: 16,
                          )),
                      hintText: '请输入姓名',
                      onEditingComplete: () {
                        FocusScope.of(context)
                            .requestFocus(_mobileNumberFocusNode);
                      },
                      enabled: _enabled,
                      autofocus: widget.newlyCreated,
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    child: TextFieldComponent(
                      controller: _mobileNumberController,
                      focusNode: _mobileNumberFocusNode,
                      leadingText: Text('手机号码',
                          style: TextStyle(
                            fontSize: 16,
                          )),
                      hintText: '请输入手机号码（数字）',
                      inputFormatters: [
                        WhitelistingTextInputFormatter.digitsOnly,
                      ],
                      enabled: _enabled && widget.newlyCreated,
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    child: InkWell(
                        onTap: () async {
                          if (_enabled) {
                            //获取所有角色
                            UserRepositoryImpl().roles().then((roles) {
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return RegionSelector(
                                    regions: roles.map((role) => RegionModel(isocode: role.uid,name: role.name)).toList(),
                                    regionSelects: _regionSelects,
                                    multiple: true,
                                  );
                                },
                              ).then((val) {
                                setState(() {
                                  _roleSelects = _regionSelects.map((region) => RoleModel(uid: region.isocode,name: region.name)).toList();
                                });
                              });
                            });
                          }
                        },
                        child: ShowSelectTile(
                          leadingText: '角色/岗位',
                          tralingText: formatRoleSelectsText(),
                        )),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 15),
                    child: Center(
                      child: Text(
                        '初始密码为手机号码，创建后请员工尽快修改密码',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Offstage(
                      offstage: !_enabled,
                      child: Center(
                        child: InkWell(
                          onTap: () {
                            widget.item.name = _nameController.text;
                            widget.item.mobileNumber =
                                _mobileNumberController.text;
                            widget.item.uid = _mobileNumberController.text;
                            widget.item.roles = _roleSelects;
                            if(widget.newlyCreated){
                              print('aaaaaaaaaaaaaaaaaaa---------');
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (_) {
                                    return RequestDataLoading(
                                      requestCallBack: UserRepositoryImpl()
                                          .employeeCreate(widget.item),
                                      outsideDismiss: false,
                                      loadingText: '保存中。。。',
//                                        entrance: 'createPurchaseOrder',
                                    );
                                  }).then((value) {
                                bool result = false;
                                if (value != null) {
                                  result = true;
                                  clearData();
                                }

                                showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (_) {
                                      return CustomizeDialog(
                                        dialogType: DialogType.RESULT_DIALOG,
                                        failTips: '创建员工失败',
                                        successTips: '创建员工成功',
                                        callbackResult: result,
                                        confirmAction: () {
                                          Navigator.of(context).pop();
                                          Navigator.pop(context);
                                          EmployeeBLoC.instance.getB2BCustomerData();
                                        },
                                      );
                                    });
                              });
                            }else{
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (_) {
                                    return RequestDataLoading(
                                      requestCallBack: UserRepositoryImpl()
                                          .employeeUpdate(widget.item,widget.item.uid),
                                      outsideDismiss: false,
                                      loadingText: '保存中。。。',
//                                        entrance: 'updatePurchaseOrder',
                                    );
                                  }).then((value) {
                                bool result = false;
                                if (value != null) {
                                  result = true;
                                  clearData();
                                }
                                showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (_) {
                                      return CustomizeDialog(
                                        dialogType: DialogType.RESULT_DIALOG,
                                        failTips: '编辑员工失败',
                                        successTips: '编辑员工成功',
                                        callbackResult: result,
                                        confirmAction: () {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                          EmployeeBLoC.instance.getB2BCustomerData();
                                        },
                                      );
                                    });
                              });
                            }
                          },
                          child: Container(
                            height: 40,
                            width:
                                MediaQueryData.fromWindow(window).size.width -
                                    100,
                            child: Center(child: Text('确定')),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color.fromRGBO(255, 214, 12, 1),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });

  }

  clearData(){
    widget.item.id = null;
    widget.item.name = null;
    widget.item.mobileNumber = null;
    widget.item.uid = null;
    widget.item.roles = [];
  }
}
