import 'dart:ui';

import 'package:amap_location/amap_location.dart';
import 'package:b2b_commerce/src/business/orders/form/pictures_field.dart';
import 'package:b2b_commerce/src/home/requirement/requirement_publish_success.dart';
import 'package:b2b_commerce/src/my/address/amap_search_page.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'RequirementFormMixins.dart';

class RequirementFormOrder extends StatefulWidget {
  RequirementFormOrder({
    this.formState,
  });

  final RequirementOrderFormStateV2 formState;

  _RequirementFormOrderState createState() => _RequirementFormOrderState();
}

class _RequirementFormOrderState extends State<RequirementFormOrder>
    with RequirementFormMixin {
  GlobalKey _scaffoldKey = GlobalKey();

  bool isPhoneSame = false;

  @override
  void initState() {
    //埋点>>>需求发布页面进入
    UmengPlugin.onEvent('requirement_publish_page');

    super.initForm();
    super.initCreate(widget.formState.model);
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => getLocation());

    widget.formState.model.orderType = RequirementOrderType.FINDING_ORDER;

    //设置默认联系人
    if (widget.formState?.model?.details != null) {
      if (widget.formState?.model?.details?.contactPhone == null ||
          widget.formState?.model?.details?.contactPhone == "") {
        widget.formState.model.details.contactPhone =
            UserBLoC.instance.currentUser.mobileNumber;
        widget.formState.model.details.contactPerson =
            UserBLoC.instance.currentUser.name;
        contactController.text =
            '${UserBLoC.instance.currentUser.mobileNumber}';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        ShowDialogUtil.showChoseDiglog(context, '正在创建订单，是否确认退出', () {
          Navigator.pop(context);
          Navigator.pop(context);
        });
        return Future.value(false);
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 0.5,
          centerTitle: true,
          title: Text('需求发布-抢订单'),
          actions: <Widget>[],
        ),
        body: Container(
          color: Colors.white,
          child: ListView(
            children: <Widget>[
              _buildTitleName(),
              _buildRemarks(),
              Container(
                color: Colors.white,
                child: PicturesField(
                  model: widget.formState.model,
                  description: '（补充图片可令客户厂更快了解工厂实力）',
                ),
              ),
              Divider(),
              _buildMajorCategory(),
              Divider(),
              _buildLocation(),
              _buildContactPhone(),
              _buildInfo('钉单将通过隐私电话服务保障您的信息安全'),
              _buildWechat(),
              _buildIsSame(),
              _buildSubBtn()
            ],
          ),
        ),
      ),
    );
  }

  Container _buildRemarks() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Column(children: <Widget>[
        Container(
          color: Colors.grey[100],
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: TextFieldComponent(
            padding: EdgeInsets.symmetric(vertical: 5),
            dividerPadding: EdgeInsets.only(),
            focusNode: remarksFocusNode,
            hintText: '需求描述...',
            autofocus: false,
            inputType: TextInputType.text,
            textAlign: TextAlign.left,
            hideDivider: true,
            maxLines: null,
            maxLength: 200,
            controller: remarksController,
            onChanged: (v) {
              setState(() {
                widget.formState.model.remarks = remarksController.text;
              });
            },
          ),
        )
      ]),
    );
  }

  Container _buildMajorCategory() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Row(
        children: <Widget>[
          RichText(
            text: TextSpan(children: [
              TextSpan(
                text: '擅长类别',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              TextSpan(
                text: ' *',
                style: TextStyle(fontSize: 16, color: Colors.red),
              )
            ]),
          ),
          Expanded(
            child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          height:
                              MediaQueryData.fromWindow(window).size.height / 2,
                          child: Consumer(
                            builder: (context, MajorCategoryState categoryState,
                                    _) =>
                                FutureBuilder(
                              future: categoryState.getMajorCategories(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<CategoryModel>> snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                } else {
                                  return SingleMajorCategorySelect(
                                    categories: snapshot.data,
                                    categorySelect: widget
                                        .formState.model.details.majorCategory,
                                    onItemTap: (categoryModel) {
                                      setState(() {
                                        widget.formState.model.details
                                            .majorCategory = categoryModel;
                                        Navigator.pop(context);
                                      });
                                    },
                                  );
                                }
                              },
                            ),
                          ),
                        );
                      });
                },
                child: Text(
                  '${widget.formState.model.details.majorCategory?.name ?? '选择面料类型'}',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.end,
                )),
          ),
          Icon(
            Icons.chevron_right,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  Container _buildTitleName() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: TextFieldBorderComponent(
              padding: EdgeInsets.all(0),
              hideDivider: true,
              isRequired: true,
              textAlign: TextAlign.left,
              hintText: '标题',
              controller: super.productNameController,
              focusNode: super.productNameFocusNode,
              onChanged: (v) {
                setState(() {
                  widget.formState.model.details.productName =
                      super.productNameController.text;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Container _buildContactPhone() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Row(
        children: <Widget>[
          Icon(Icons.phone),
          Container(
            width: 100,
            margin: EdgeInsets.only(left: 10),
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: '联系电话',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                TextSpan(
                  text: ' *',
                  style: TextStyle(fontSize: 16, color: Colors.red),
                )
              ]),
            ),
          ),
          Expanded(
            flex: 2,
            child: TextFieldBorderComponent(
              padding: EdgeInsets.all(0),
              hideDivider: true,
              isRequired: true,
              textAlign: TextAlign.left,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              inputType: TextInputType.number,
              hintText: '输入手机号',
              controller: super.contactController,
              focusNode: super.contactPhoneFocusNode,
              onChanged: (v) {
                setState(() {
                  widget.formState.model.details.contactPhone = v;
                  if (isPhoneSame) {
                    widget.formState.model.details.contactWeChatNo = v;
                    wechatController.text = v;
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Container _buildLocation() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Row(
        children: <Widget>[
          Container(
            width: 30,
            child: Icon(Icons.location_on),
          ),
          Expanded(
            child: GestureDetector(
                onTap: () async {
                  Tip tip = await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AmapSearchPage()));
                  List<String> locationArray = tip.location.split(',');
                  //设置定位信息
                  setState(() {
                    widget.formState.model.details
                      ..latitude = double.parse(locationArray[1])
                      ..longitude = double.parse(locationArray[0])
                      ..address = tip.address;
                  });
                },
                child: Text(
                  '${widget.formState.model.details?.address ?? '所在位置'}',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.end,
                )),
          ),
          Icon(
            Icons.chevron_right,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  Container _buildWechat() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Row(
        children: <Widget>[
          Icon(B2BIcons.wechat, color: Colors.green),
          Container(
            width: 100,
            margin: EdgeInsets.only(left: 10),
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: '微信号',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ]),
            ),
          ),
          Expanded(
            flex: 1,
            child: TextFieldBorderComponent(
              padding: EdgeInsets.all(0),
              hideDivider: true,
              isRequired: true,
              textAlign: TextAlign.left,
              hintText: '输入微信号',
              controller: super.wechatController,
              focusNode: super.wechatFocusNode,
              onChanged: (v) {
                setState(() {
                  widget.formState.model.details.contactWeChatNo = v;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubBtn() {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      height: 50,
      child: RaisedButton(
          color: Color.fromRGBO(255, 214, 12, 1),
          child: Text(
            '确认发布',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(50))),
          onPressed: () async {
            onPublish();
          }),
    );
  }

  Widget _buildInfo(String val) {
    return Padding(
        padding: EdgeInsets.only(right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('$val', style: TextStyle(fontSize: 12, color: Colors.grey))
          ],
        ));
  }

  Widget _buildIsSame() {
    return Padding(
        padding: EdgeInsets.only(right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('平台客服可以联系工厂',
                style: TextStyle(fontSize: 12, color: Colors.grey)),
            Checkbox(
              value: isPhoneSame,
              onChanged: (bool value) {
                setState(() {
                  isPhoneSame = value;
                  if (value) {
                    widget.formState.model.details.contactWeChatNo =
                        widget.formState.model.details.contactPhone;
                    wechatController.text =
                        widget.formState.model.details.contactPhone;
                  }
                });
              },
            ),
            Text('与手机同号'),
          ],
        ));
  }

  void getLocation() async {
    AmapState state = Provider.of<AmapState>(context, listen: false);

    Widget _dialog = CustomizeDialog(
      dialogType: DialogType.CONFIRM_DIALOG,
      contentText2: '钉单正在请求定位权限,请设置',
      isNeedConfirmButton: true,
      isNeedCancelButton: true,
      confirmButtonText: '去设置',
      cancelButtonText: '选择城市',
      dialogHeight: 180,
      confirmAction: () {
        state.openAppSetting().then((val) {
          Navigator.of(context).pop(val);
        });
      },
      cancelAction: () async {
        Navigator.of(context).pop();
        Tip tip = await Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => AmapSearchPage()));
        List<String> locationArray = tip.location.split(',');
        //设置定位信息
        state.setAMapLocation(
            // aOIName: tip.district.,
            longitude: double.parse(locationArray[0]),
            latitude: double.parse(locationArray[1]));
      },
    );

    AMapLocation aMapLocation = Provider.of<AmapState>(context, listen: false)
        .getAMapLocation(context: context, openDialog: _dialog);

    setState(() {
      widget.formState.model.details
        ..latitude = aMapLocation.latitude
        ..longitude = aMapLocation.longitude
        ..address = aMapLocation.formattedAddress
        ..provinceStr = aMapLocation.province
        ..cityStr = aMapLocation.city
        ..districtStr = aMapLocation.district;
    });
  }

  /// 发布
  void onPublish() async {
    if (widget.formState.model.details.productName == null) {
      ShowDialogUtil.showValidateMsg(context, '请填写标题');
      return;
    }

    if (widget.formState.model.remarks == null) {
      ShowDialogUtil.showValidateMsg(context, '请填写描述');
      return;
    }

    if (widget.formState.model.details.contactPerson == null ||
        widget.formState.model.details.contactPerson == '' ||
        widget.formState.model.details.contactPhone == null ||
        widget.formState.model.details.contactPhone == '') {
      ShowDialogUtil.showValidateMsg(context, '请完善联系方式');
      return;
    }

    if (widget.formState.model.details.majorCategory == null) {
      ShowDialogUtil.showValidateMsg(context, '请选择面料类型');
      throw Exception('请选择面料类型');
    }

    if (widget.formState.model.details.effectiveDays == -1) {
      //后台的'长期有效'值是null
      widget.formState.model.details.effectiveDays = null;
    }

    // DialogHelper.showConfirm(
    //     title: '确定发布需求?', content: '', confirm: () async {});

    ShowDialogUtil.showChoseDiglog(context, '是否确认发布', () async {
      Function cancelFunc =
          BotToast.showLoading(clickClose: true, crossPage: false);
      BaseResponse response =
          await RequirementOrderRepository.newByType(widget.formState.model);
      Navigator.of(context).pop();
      cancelFunc.call();

      if (response != null && response.code == 1) {
        BotToast.showText(text: '创建成功');
        //埋点>>>需求发布成功
        UmengPlugin.onEvent('requirement_publish_success');
        //根据code查询明
        RequirementOrderModel model = await RequirementOrderRepository()
            .getRequirementOrderDetail(response.msg);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => PublishRequirementSuccessDialog(
                model: model,
              ),
            ),
            ModalRoute.withName('/'));
      } else if (response.code == 0) {
        BotToast.showText(text: '${response.msg}');
      } else {
        Navigator.of(context).pop();
      }
    });
  }
}
