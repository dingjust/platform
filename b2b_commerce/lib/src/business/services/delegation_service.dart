import 'package:b2b_commerce/src/_shared/widgets/app_bar_factory.dart';
import 'package:b2b_commerce/src/business/orders/sales_production/external_sale_order/form/form_components.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'text_field_border_component_V2.dart';

///托管服务申请
class DelegationServicePage extends StatefulWidget {
  const DelegationServicePage({Key key}) : super(key: key);

  @override
  _DelegationServicePageState createState() => _DelegationServicePageState();
}

class _DelegationServicePageState extends State<DelegationServicePage> {
  FocusNode contactPhoneFocusNode;
  TextEditingController contactController;

  FocusNode wechatFocusNode;
  TextEditingController wechatController;

  bool isPhoneSame = false;

  UserModel user = UserBLoC.instance.currentUser;

  @override
  void initState() {
    contactPhoneFocusNode = FocusNode();
    contactController =
        TextEditingController(text: '${user.contactPhone ?? ''}');

    wechatFocusNode = FocusNode();
    wechatController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xffF7F7F7),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 240.0,
              pinned: true,
              elevation: 0,
              brightness: Brightness.light,
              title: Text('钉单托管'),
              centerTitle: true,
              flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    color: Color(0xffF7F7F7),
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        Align(
                            alignment: Alignment.topCenter,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => _Explain()));
                              },
                              child: Container(
                                child: Image.asset(
                                  'temp/index/delegation.png',
                                  package: 'assets',
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            ))
                      ],
                    ),
                  )),
            ),
            SliverList(
              delegate: SliverChildListDelegate(<Widget>[
                Container(
                    margin: EdgeInsets.symmetric(vertical: 24),
                    child: Text(
                      '请留下您的联系方式',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color(0xff222222),
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    )),
                _card1(),
                _card2(),
                // _buildSubBtn(),
              ]),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildSubBtn(),
      resizeToAvoidBottomInset: true,
    );
  }

  Widget _card1() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          Container(
            height: 48,
            decoration: BoxDecoration(
                color: Color(0xffFFF5D7),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12))),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 20, right: 8),
                  child: Icon(
                    B2BIconsV2.phone_circle,
                    color: Color(0xFFAA6E15),
                    size: 24,
                  ),
                ),
                Text(
                  '联系电话',
                  style: TextStyle(
                      color: Color(0xffAA6E15),
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                  child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: TextFieldBorderComponentV2(
                      padding: EdgeInsets.symmetric(horizontal: 0),
                      hideDivider: true,
                      isRequired: true,
                      textAlign: TextAlign.left,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      inputType: TextInputType.number,
                      hintText: '输入手机号',
                      controller: contactController,
                      focusNode: contactPhoneFocusNode,
                      onChanged: (v) {
                        setState(() {
                          if (isPhoneSame) {
                            wechatController.text = v;
                          }
                        });
                      },
                    ),
                  )),
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 12),
            child: Divider(
              color: Color(0xFFE7E7E7),
              height: 0,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                    height: 48,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12))),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '钉单将通过隐私通话服务保障您的信息安全',
                          style:
                          TextStyle(color: Color(0xFFFF4D4F), fontSize: 12),
                        ),
                      ],
                    )),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _card2() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Column(
        children: [
          Container(
            height: 48,
            decoration: BoxDecoration(
                color: Color(0xffFFF5D7),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12))),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 20, right: 8),
                  child: Icon(
                    B2BIconsV2.wechat_circle,
                    color: Color(0xFFAA6E15),
                    size: 24,
                  ),
                ),
                Text(
                  '微信号',
                  style: TextStyle(
                      color: Color(0xffAA6E15),
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12)),
            ),
            child: Row(
              children: [
                Expanded(
                    child: Container(
                      color: Colors.white,
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: TextFieldBorderComponentV2(
                        padding: EdgeInsets.symmetric(horizontal: 0),
                        hideDivider: true,
                        isRequired: true,
                        textAlign: TextAlign.left,
                        hintText: '输入微信号',
                        controller: wechatController,
                        focusNode: wechatFocusNode,
                        onChanged: (v) {},
                      ),
                    )),
                _buildIsSame()
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildIsSame() {
    return Padding(
        padding: EdgeInsets.only(right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.only(right: 4),
              child: B2BCheckbox(
                value: isPhoneSame,
                onChanged: (value) {
                  setState(() {
                    isPhoneSame = value;
                    if (value) {
                      wechatController.text = contactController.text;
                    }
                  });
                },
              ),
            ),
            Text('与手机同号',
                style: TextStyle(fontSize: 15, color: Color(0xFF222222)))
          ],
        ));
  }

  Widget _buildSubBtn() {
    return Container(
      color: Color(0xFFF7F7F7),
      child: GestureDetector(
        onTap: _onSubmit,
        child: Container(
            margin: EdgeInsets.fromLTRB(12, 6, 12, 14),
            decoration: BoxDecoration(
                color: Color(0xFFFED800),
                borderRadius: BorderRadius.circular(24)),
            height: 48,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '确定',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ],
            )),
      ),
    );
  }

  void _onSubmit() async {
    if (validateForm()) {
      Function cancelFunc =
      BotToast.showLoading(crossPage: false, clickClose: true);

      BaseResponse response = await DelegationServiceRepository.apply(
          contactController.text, wechatController.text);
      cancelFunc.call();
      if (response != null && response.code == 1) {
        showDialog(
            context: context,
            child: CupertinoAlertDialog(
              title: Text('提交成功'),
              content: Text('钉单客服将会联系您，稍后请留意来电和微信联系'),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text('我知道了'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
      } else if (response != null && response.code == 0) {
        BotToast.showText(text: '${response.msg}', align: Alignment.center);
      } else {
        BotToast.showText(text: '操作失败', align: Alignment.center);
      }
    }
  }

  ///表单校验
  bool validateForm() {
    List<FormValidateItem> items = [
      FormValidateItem(
          (contactController.text == '' || contactController.text.length != 11),
          '请填写正确手机号'),
    ];

    FormValidateItem item =
        items.firstWhere((element) => element.result, orElse: () => null);

    if (item != null) {
      BotToast.showText(
          text: '${item.message}',
          onlyOne: true,
          crossPage: false,
          clickClose: true);
      return false;
    } else {
      return true;
    }
  }
}

class _Explain extends StatelessWidget {
  const _Explain({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarFactory.buildDefaultAppBar(
        '钉单托管',
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 12),
        color: Color(0xFFF7F7F7),
        child: ListView(
          children: [
            _Item(
              title: '什么是【钉单托管】?',
              val:
              '钉单托管是钉单平台运用自身16年供应链管理经验和历年合作积累下来的工厂合作资源进行的生产待管理服务。可以帮您节省用人、费用、精力和提升效率的平台功能。钉单团队将会根据您的需求，匹配合适您质量要求和定位的工厂资源。深入到跟单和QC等生产环节，在实质上解决您在生产过程中可能遇到的困难，保护和监控订单顺利完成。',
            ),
            _Item(
              title: '怎么进行托管',
              val:
              '有两个方式可以找到我们的平台客服。A∶ 点击下方【托管申请】，将会有平台客服联系您并收集相关信息。B∶ 您可直接发布一条新的需求，将有客服人员对您的需求进行回访，' +
                  '您表达想要托管的意愿。请尽量给予我们客服人员详细的需求描述，可加快我们匹配合适工厂的速度噢。',
            ),
            _Item(
              title: '如何保证资金安全?',
              val:
              '钉单平台是生产管控型的专业平台，对委托的双方都会进行资质收集、公示、实名认证等功能配备。且相关功能和短信均链接到具备法律效力的合作企业，对生产合作中的双方确定行为、' +
                  '签约人员均需要进行审核和认定。所以可以放心把工作交给钉单团队代为运作。',
            ),
            _Item(
              title: '托管怎么收费?',
              val: '托管服务对于业务发单方不收取任何费用。',
            )
          ],
        ),
      ),
      bottomSheet: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Container(
            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            decoration: BoxDecoration(
                color: Color.fromRGBO(255, 214, 12, 1),
                borderRadius: BorderRadius.circular(24)),
            height: 48,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '申请托管',
                  style: TextStyle(
                    color: Color(0xFF222222),
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ],
            )),
      ),
    );
  }
}

class _TiTle extends StatelessWidget {
  final String val;

  const _TiTle({Key key, this.val}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
              child: Text(
                '$val',
                style: TextStyle(
                    color: Color(0xffAA6E15),
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ))
        ],
      ),
    );
  }
}

class _Info extends StatelessWidget {
  final String val;

  const _Info({Key key, this.val}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Expanded(
              child: Text(
                '$val',
                style: TextStyle(
                  color: Color(0xff666666),
                  fontSize: 14,
                ),
              ))
        ],
      ),
    );
  }
}

class _Item extends StatelessWidget {
  final String title;

  final String val;

  const _Item({Key key, this.title, this.val}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 12),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          _TiTle(
            val: '$title',
          ),
          _Info(
            val: '$val',
          )
        ],
      ),
    );
  }
}
