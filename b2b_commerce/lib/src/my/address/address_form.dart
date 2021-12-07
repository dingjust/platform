import 'package:b2b_commerce/src/_shared/widgets/app_bar_factory.dart';
import 'package:b2b_commerce/src/business/orders/widget/form_divider.dart';
import 'package:b2b_commerce/src/business/orders/widget/form_row.dart';
import 'package:b2b_commerce/src/business/services/text_field_border_component_V2.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'region_select.dart';

class AddressFormPage extends StatefulWidget {
  AddressFormPage({this.address, this.newlyCreated = false});

  final AddressModel address;
  final bool newlyCreated;

  @override
  AddressFormState createState() => AddressFormState();
}

class AddressFormState extends State<AddressFormPage> {
  TextEditingController _fullnameController;
  TextEditingController _cellphoneController;
  TextEditingController _line1Controller;
  FocusNode _nameFocusNode = FocusNode();
  FocusNode _cellphoneFocusNode = FocusNode();
  FocusNode _line1FocusNode = FocusNode();
  String regionCityAndDistrict;

  @override
  void initState() {
    super.initState();
    if (widget.address.defaultAddress == null)
      widget.address.defaultAddress = false;
    _fullnameController = TextEditingController(text: widget.address?.fullname);
    _cellphoneController =
        TextEditingController(text: widget.address?.cellphone);
    _line1Controller = TextEditingController(text: widget.address?.line1);
    regionCityAndDistrict =
        !widget.newlyCreated ? widget.address.regionCityAndDistrict : "请选择省市区";
  }

  _selectRegionCityAndDistrict(BuildContext context) async {
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
      widget.address.cityDistrict = result;
      widget.address.city = result.city;
      widget.address.region = result.city.region;

      regionCityAndDistrict = widget.address.region.name +
          widget.address.city.name +
          widget.address.cityDistrict.name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarFactory.buildDefaultAppBar(
        '编辑地址',
        actions: <Widget>[
          IconButton(
            icon: Text('保存', style: TextStyle(color: Colors.blue)),
            onPressed: _save,
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(12),
        child: new SingleChildScrollView(
          child: Column(
            children: [_buildCard1(), _buildCard2(), _buildDel()],
          ),
        ),
      ),
    );
  }

  Widget _buildCard1() {
    return Container(
      margin: EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          FormRow(
            title: '联系人',
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: TextFieldBorderComponentV2(
              padding: EdgeInsets.all(0),
              hideDivider: true,
              isRequired: true,
              textAlign: TextAlign.left,
              hintText: '请输入联系人姓名',
              style: TextStyle(color: Color(0xFF222222), fontSize: 14),
              controller: _fullnameController,
              focusNode: _nameFocusNode,
            ),
          ),
          FormDivider(),
          FormRow(
            title: '手机号码',
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: TextFieldBorderComponentV2(
              padding: EdgeInsets.all(0),
              hideDivider: true,
              isRequired: true,
              textAlign: TextAlign.left,
              hintText: '请输入手机号码',
              style: TextStyle(color: Color(0xFF222222), fontSize: 14),
              controller: _cellphoneController,
              focusNode: _cellphoneFocusNode,
            ),
          ),
          FormDivider(),
          FormSelectRow(
            title: '要求地区',
            val: regionCityAndDistrict,
            padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            onTap: () {
              _selectRegionCityAndDistrict(context);
            },
          ),
          FormDivider(),
          FormRow(
            title: '详细地址',
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: TextFieldBorderComponentV2(
              padding: EdgeInsets.all(0),
              hideDivider: true,
              isRequired: true,
              textAlign: TextAlign.left,
              hintText: '道路、门牌号、小区、楼栋号、单元室等',
              style: TextStyle(color: Color(0xFF222222), fontSize: 14),
              controller: _line1Controller,
              focusNode: _line1FocusNode,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard2() {
    return Container(
      margin: EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          FormRow(
              title: '默认地址',
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Switch(
                    value: widget.address.defaultAddress,
                    activeColor: Color.fromRGBO(255, 214, 12, 1),
                    onChanged: (bool val) {
                      setState(() {
                        widget.address.defaultAddress = val;
                      });
                    },
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget _buildDel() {
    if (widget.newlyCreated) {
      return Container();
    }

    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 0),
      title: FlatButton(
          color: Colors.white,
          child: Text(
            '删除地址',
            style: TextStyle(
              color: Colors.red[200],
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              side: BorderSide(
                  color: Colors.red[200], style: BorderStyle.solid, width: 1)),
          clipBehavior: Clip.antiAlias,
          materialTapTargetSize: MaterialTapTargetSize.padded,
          onPressed: () {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) {
                  return CustomizeDialog(
                    dialogType: DialogType.CONFIRM_DIALOG,
                    contentText2: '是否要删除地址？',
                    isNeedConfirmButton: true,
                    isNeedCancelButton: true,
                    dialogHeight: 210,
                    confirmAction: () {
                      Navigator.pop(context);
                      onSure();
                    },
                  );
                });
          }),
    );
  }

  void _save() async {
    if (_fullnameController.text == '' && _cellphoneController.text == '') {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return CustomizeDialog(
              dialogType: DialogType.RESULT_DIALOG,
              failTips: '联系人和联系电话不可为空',
              callbackResult: false,
              confirmAction: () {
                Navigator.of(context).pop();
              },
            );
          });
      return;
    }
    if (widget.address.region == null) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return CustomizeDialog(
              dialogType: DialogType.RESULT_DIALOG,
              failTips: '省市区不可为空',
              callbackResult: false,
              confirmAction: () {
                Navigator.of(context).pop();
              },
            );
          });
      return;
    }
    if (_line1Controller.text == '') {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return CustomizeDialog(
              dialogType: DialogType.RESULT_DIALOG,
              failTips: '详细地址不可为空',
              callbackResult: false,
              confirmAction: () {
                Navigator.of(context).pop();
              },
            );
          });
      return;
    }
    widget.address.fullname = _fullnameController.text;
    widget.address.cellphone = _cellphoneController.text;
    widget.address.line1 = _line1Controller.text;

//              widget.address.region.name=null;

    if (widget.newlyCreated) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return RequestDataLoading(
              requestCallBack: AddressRepositoryImpl().create(widget.address),
              outsideDismiss: false,
              loadingText: '保存中。。。',
              entrance: '0',
            );
          }).then((value) {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) {
              return CustomizeDialog(
                dialogType: DialogType.RESULT_DIALOG,
                successTips: '地址创建成功',
                failTips: '地址创建失败',
                callbackResult: value,
                confirmAction: () {
                  Navigator.of(context).pop();
                },
              );
            }).then((v) {
          Navigator.of(context).pop();
          AddressBLoC.instance.getAddressData();
        });
      });
    } else {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return RequestDataLoading(
              requestCallBack: AddressRepositoryImpl().update(widget.address),
              outsideDismiss: false,
              loadingText: '保存中。。。',
              entrance: '0',
            );
          }).then((value) {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) {
              return CustomizeDialog(
                dialogType: DialogType.RESULT_DIALOG,
                successTips: '地址修改成功',
                failTips: '地址修改失败',
                callbackResult: value,
                confirmAction: () {
                  Navigator.of(context).pop();
                },
              );
            }).then((v) {
          Navigator.of(context).pop();
          AddressBLoC.instance.getAddressData();
        });
      });
    }
  }

  void onSure() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return RequestDataLoading(
            requestCallBack:
            AddressRepositoryImpl().delete(widget.address.id.toString()),
            outsideDismiss: false,
            loadingText: '删除。。。',
            entrance: '',
          );
        }).then((value) {
      AddressBLoC.instance.addresses.clear();
      AddressBLoC.instance.getAddressData();
      Navigator.pop(context);
    });
  }
}
