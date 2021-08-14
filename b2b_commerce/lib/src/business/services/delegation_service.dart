import 'package:b2b_commerce/src/business/orders/sales_production/external_sale_order/form/form_components.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

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
      appBar: AppBar(
        title: Text('钉单托管'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: ListView(
          children: [
            _buildDetailCard(),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  _buildContactPhone(),
                  _buildInfo('钉单将通过隐私电话服务保障您的信息安全'),
                  _buildWechat(),
                  _buildIsSame(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: _buildSubBtn(),
    );
  }

  Widget _buildDetailCard() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => _Explain()));
      },
      child: Container(
        height: 100,
        margin: EdgeInsets.only(top: 12, bottom: 16),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 150,
                child: Text(
                  '超10年供应链管理团队为您的订单保驾护航',
                  style: TextStyle(color: Color(0xff222222), fontSize: 14),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                // width: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '了解详情',
                      style: TextStyle(color: Color(0xff666666), fontSize: 10),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: Color(0xff666666),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactPhone() {
    return Container(
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
          ),
        ],
      ),
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
            Checkbox(
              value: isPhoneSame,
              onChanged: (bool value) {
                setState(() {
                  isPhoneSame = value;
                  if (value) {
                    // widget.formState.model.details.contactWeChatNo =
                    //     widget.formState.model.details.contactPhone;
                    wechatController.text = contactController.text;
                  }
                });
              },
            ),
            Text('与手机同号'),
          ],
        ));
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
              controller: wechatController,
              focusNode: wechatFocusNode,
              onChanged: (v) {
                // widget.formState.model.details.contactWeChatNo = v;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubBtn() {
    return GestureDetector(
      onTap: _onSubmit,
      child: Container(
          color: Color.fromRGBO(255, 214, 12, 1),
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '确认',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
            ],
          )),
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
        BotToast.showText(text: '申请成功');
        //跳转到
        Navigator.pop(context);
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
      appBar: AppBar(
        title: Text('钉单托管'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 12),
        color: Colors.white,
        child: ListView(
          children: [
            _TiTle(
              val: '什么是【钉单托管】?',
            ),
            _Info(
              val:
              '钉单托管是钉单平台运用自身16年供应链管理经验和历年合作积累下来的工厂合作资源进行的生产待管理服务。可以帮您节省用人、费用、精力和提升效率的平台功能。',
            ),
            _Info(
              val:
              '钉单团队将会根据您的需求，匹配合适您质量要求和定位的工厂资源。深入到跟单和QC等生产环节，在实质上解决您在生产过程中可能遇到的困难，保护和监控订单顺利完成。',
            ),
            _TiTle(
              val: '怎么进行托管?',
            ),
            _Info(
              val:
              '有两个方式可以找到我们的平台客服。A∶ 点击下方【托管申请】，将会有平台客服联系您并收集相关信息。B∶ 您可直接发布一条新的需求，将有客服人员对您的需求进行回访，' +
                  '您表达想要托管的意愿。请尽量给予我们客服人员详细的需求描述，可加快我们匹配合适工厂的速度噢。',
            ),
            _TiTle(
              val: '如何保证资金安全?',
            ),
            _Info(
              val:
              '钉单平台是生产管控型的专业平台，对委托的双方都会进行资质收集、公示、实名认证等功能配备。且相关功能和短信均链接到具备法律效力的合作企业，对生产合作中的双方确定行为、' +
                  '签约人员均需要进行审核和认定。所以可以放心把工作交给钉单团队代为运作。',
            ),
            _TiTle(
              val: '托管怎么收费?',
            ),
            _Info(
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
            color: Color.fromRGBO(255, 214, 12, 1),
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '托管申请',
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
}

class _TiTle extends StatelessWidget {
  final String val;

  const _TiTle({Key key, this.val}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
              child: Text(
                '$val',
                style: TextStyle(
                    color: Color(0xff222222),
                    fontSize: 13,
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
      margin: EdgeInsets.only(bottom: 30),
      child: Row(
        children: [
          Expanded(
              child: Text(
                '$val',
                style: TextStyle(
                  color: Color(0xff666666),
                  fontSize: 12,
                ),
              ))
        ],
      ),
    );
  }
}
