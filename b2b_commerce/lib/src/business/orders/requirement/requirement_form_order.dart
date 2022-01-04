import 'dart:ui';

import 'package:b2b_commerce/src/_shared/widgets/app_bar_factory.dart';
import 'package:b2b_commerce/src/business/orders/form/pictures_field.dart';
import 'package:b2b_commerce/src/business/orders/widget/form_divider.dart';
import 'package:b2b_commerce/src/business/orders/widget/form_row.dart';
import 'package:b2b_commerce/src/business/services/text_field_border_component_V2.dart';
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

  final TextStyle titleTextStyle =
      const TextStyle(color: Color(0xff000000), fontSize: 14);

  @override
  void initState() {
    //埋点>>>需求发布页面进入
    // UmengPlugin.onEvent('requirement_publish_page');

    super.initForm();
    super.initCreate(widget.formState.model);
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((_) => getLocation());

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
        appBar: AppBarFactory.buildDefaultAppBar('需求发布-抢订单'),
        body: Container(
          color: Color(0xFFF7F7F7),
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: ListView(
            children: <Widget>[
              _buildCard1(),
              _buildCard2(),
              _buildCard3(),
              _buildCard7(),
              _buildCard8(),
              _buildSubBtn()
            ],
          ),
        ),
      ),
    );
  }

  Container _buildRemarks() {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 14),
      child:
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
        Container(
          width: 80,
          padding: EdgeInsets.only(top: 15),
          child: Text(
            '需求描述',
            style: titleTextStyle,
          ),
        ),
        Expanded(
            child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: TextFieldComponent(
            padding: EdgeInsets.symmetric(vertical: 0),
            dividerPadding: EdgeInsets.only(),
            focusNode: remarksFocusNode,
            hintText: '需求描述...',
            autofocus: false,
            inputType: TextInputType.text,
            textAlign: TextAlign.left,
            hideDivider: true,
            maxLines: null,
            maxLength: 200,
            style: TextStyle(color: Color(0xFF222222), fontSize: 14),
            controller: remarksController,
            onChanged: (v) {
              widget.formState.model.remarks = remarksController.text;
            },
          ),
        ))
      ]),
    );
  }

  Widget _buildTitleName() {
    return FormRow(
      title: '标题',
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: TextFieldBorderComponentV2(
        padding: EdgeInsets.all(0),
        hideDivider: true,
        isRequired: true,
        textAlign: TextAlign.left,
        hintText: '标题',
        controller: super.productNameController,
        focusNode: super.productNameFocusNode,
        style: TextStyle(color: Color(0xFF222222), fontSize: 14),
        onChanged: (v) {
          widget.formState.model.details.productName =
              super.productNameController.text;
        },
      ),
    );
  }

  Widget _buildWechat() {
    return Row(
      children: [
        Expanded(
          child: TextFieldBorderComponentV2(
            padding: EdgeInsets.all(0),
            hideDivider: true,
            isRequired: true,
            textAlign: TextAlign.left,
            hintText: '输入微信号',
            style: TextStyle(color: Color(0xFF222222), fontSize: 14),
            controller: super.wechatController,
            focusNode: super.wechatFocusNode,
            onChanged: (v) {
              widget.formState.model.details.contactWeChatNo = v;
            },
          ),
        ),
        Container(
          margin: EdgeInsets.only(right: 4),
          child: B2BCheckbox(
            value: isPhoneSame,
            onChanged: (value) {
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
        ),
        Text('与手机同号', style: TextStyle(fontSize: 14, color: Color(0xFF222222)))
      ],
    );
  }

  Widget _buildSubBtn() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 18),
      child: FlatButton(
          color: Color.fromRGBO(255, 214, 12, 1),
          padding: EdgeInsets.symmetric(vertical: 13),
          child: Text(
            '确认发布',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(50))),
          onPressed: () async {
            onPublish();
          }),
    );
  }

  Widget _buildCard1() {
    return Container(
      margin: EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          _buildTitleName(),
          FormDivider(),
          _buildRemarks(),
        ],
      ),
    );
  }

  Widget _buildCard2() {
    return Container(
      margin: EdgeInsets.only(top: 12),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text(
              '添加图片',
              style: TextStyle(fontSize: 14),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 8),
            child: Text(
              '补充图片，可令工厂更快了解需求',
              style: TextStyle(color: Color(0xFF999999), fontSize: 12),
            ),
          ),
          PicturesField(
            model: widget.formState.model,
            description: '（补充图片可令工厂更快了解需求）',
          ),
        ],
      ),
    );
  }

  Widget _buildCard3() {
    return Container(
      margin: EdgeInsets.only(top: 12),
      // padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FormSelectRow(
              title: '擅长类别',
              padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
              onTap: _onSelectMajorCategory,
              val: widget.formState.model.details.majorCategory?.name),
          FormDivider(),
          _buildLocation(),
        ],
      ),
    );
  }

  Widget _buildCard7() {
    return Container(
      margin: EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        FormRow(
          title: '联系电话',
          padding: EdgeInsets.fromLTRB(20, 0, 20, 5),
          child: TextFieldBorderComponentV2(
            padding: EdgeInsets.all(0),
            hideDivider: true,
            isRequired: true,
            textAlign: TextAlign.left,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            inputType: TextInputType.number,
            hintText: '输入手机号',
            style: TextStyle(color: Color(0xFF222222), fontSize: 14),
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
        FormDivider(),
        Container(
          padding: EdgeInsets.fromLTRB(20, 8, 20, 8),
          child: Text(
            '钉单将通过隐私电话服务保障您的信息安全',
            style: TextStyle(color: Color(0xFF999999), fontSize: 12),
          ),
        )
      ]),
    );
  }

  Widget _buildCard8() {
    return Container(
      margin: EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        FormRow(
            title: '微信号',
            padding: EdgeInsets.fromLTRB(20, 0, 20, 5),
            child: _buildWechat()),
        FormDivider(),
        Container(
          padding: EdgeInsets.fromLTRB(20, 8, 20, 8),
          child: Text(
            '平台客服可以联系你匹配工厂',
            style: TextStyle(color: Color(0xFF999999), fontSize: 12),
          ),
        )
      ]),
    );
  }

  Widget _buildLocation() {
    return FormSelectRow(
      title: '所在地区',
      val: '${widget.formState.model.details?.address ?? ''}',
      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      onTap: () async {
        Tip tip = await Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => AmapSearchPage()));
        List<String> locationArray = tip.location.split(',');
        //设置定位信息
        setState(() {
          widget.formState.model.details
            ..latitude = double.parse(locationArray[1])
            ..longitude = double.parse(locationArray[0])
            ..address = tip.address;
        });
      },
    );
  }

  ///选择面料类型
  void _onSelectMajorCategory() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: MediaQueryData
                .fromWindow(window)
                .size
                .height / 2,
            child: Consumer(
              builder: (context, MajorCategoryState categoryState, _) =>
                  FutureBuilder(
                    future: categoryState.getMajorCategories(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<CategoryModel>> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        return SingleMajorCategorySelect(
                          categories: snapshot.data,
                          categorySelect:
                          widget.formState.model.details.majorCategory,
                          onItemTap: (categoryModel) {
                            setState(() {
                              widget.formState.model.details.majorCategory =
                                  categoryModel;
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
  }

  // void getLocation() async {
  //   AmapState state = Provider.of<AmapState>(context, listen: false);

  //   Widget _dialog = CustomizeDialog(
  //     dialogType: DialogType.CONFIRM_DIALOG,
  //     contentText2: '钉单正在请求定位权限,请设置',
  //     isNeedConfirmButton: true,
  //     isNeedCancelButton: true,
  //     confirmButtonText: '去设置',
  //     cancelButtonText: '选择城市',
  //     dialogHeight: 180,
  //     confirmAction: () {
  //       state.openAppSetting().then((val) {
  //         Navigator.of(context).pop(val);
  //       });
  //     },
  //     cancelAction: () async {
  //       Navigator.of(context).pop();
  //       Tip tip = await Navigator.of(context)
  //           .push(MaterialPageRoute(builder: (context) => AmapSearchPage()));
  //       List<String> locationArray = tip.location.split(',');
  //       //设置定位信息
  //       state.setAMapLocation(
  //           // aOIName: tip.district.,
  //           longitude: double.parse(locationArray[0]),
  //           latitude: double.parse(locationArray[1]));
  //     },
  //   );

  //   AMapLocation aMapLocation = Provider.of<AmapState>(context, listen: false)
  //       .getAMapLocation(context: context, openDialog: _dialog);

  //   setState(() {
  //     widget.formState.model.details
  //       ..latitude = aMapLocation.latitude
  //       ..longitude = aMapLocation.longitude
  //       ..address = aMapLocation.formattedAddress
  //       ..provinceStr = aMapLocation.province
  //       ..cityStr = aMapLocation.city
  //       ..districtStr = aMapLocation.district;
  //   });
  // }

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

    ShowDialogUtil.showChoseDiglog(context,
        '温馨提示：钉单平台无法保护您在电话、微信沟通和线下交易的可靠性及资金安全。请务必使用钉单平台的线上需求发布、钉单确认、合同签订、线上支付、对账单等系列功能，获得平台监督与仲裁服务。',
        () async {
      Function cancelFunc =
          BotToast.showLoading(clickClose: true, crossPage: false);
      BaseResponse response =
          await RequirementOrderRepository.newByType(widget.formState.model);
      Navigator.of(context).pop();
      cancelFunc.call();

      if (response != null && response.code == 1) {
        BotToast.showText(text: '创建成功');
        //埋点>>>需求发布成功
        // UmengPlugin.onEvent('requirement_publish_success');
        //根据code查询明
        RequirementOrderModel model = await RequirementOrderRepository()
            .getRequirementOrderDetail(response.msg);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) =>
                  PublishRequirementSuccessDialog(
                    model: model,
                  ),
            ),
            ModalRoute.withName('/'));
      } else if (response.code == 0) {
        BotToast.showText(text: '${response.msg}');
      } else {
        Navigator.of(context).pop();
      }
        }, height: 300, confirmButtonText: '我已知晓');
  }
}
