import 'dart:io';

import 'package:b2b_commerce/src/_shared/widgets/app_bar_factory.dart';
import 'package:b2b_commerce/src/helper/local_storage_helper.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:url_launcher/url_launcher.dart';

///隐私同意指引页面内
class PrivacyGuidePage extends StatefulWidget {
  const PrivacyGuidePage({Key key}) : super(key: key);

  @override
  _PrivacyGuidePageState createState() => _PrivacyGuidePageState();
}

class _PrivacyGuidePageState extends State<PrivacyGuidePage> {
  TapGestureRecognizer _serviceRecognizer;
  TapGestureRecognizer _privacyRecognizer;

  @override
  void initState() {
    _serviceRecognizer = TapGestureRecognizer()..onTap = _onService;
    _privacyRecognizer = TapGestureRecognizer()..onTap = _onPrivacy;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Color(0xFF666666),
          child: Center(
            child: Container(
              height: 400,
              margin: EdgeInsets.symmetric(horizontal: 40),
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Text(
                          '服务协议与隐私政策',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      Expanded(
                        child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Scrollbar(
                              child: ListView(
                                padding: EdgeInsets.zero,
                                children: [
                                  // _buildTitle1(),
                                  _buildTitle2(),
                                  _Text(
                                      '1. 在你浏览、评价、发布内容是，我们可能会收集、使用你的设备信息（包括设备型号、唯一设备标识符如IMEI/IMSI信息、设备MAC地址、IP地址、软件安装列表、软件版本号等）、日志信息等;'),
                                  _Text(
                                      '2.根据你在使用钉单过程中的不同服务或场景，可能需要你开通一些设备权限，包括位置权限、通知、读取软件安装列表、存储、相册、相机、手机通讯、麦克风、蓝牙、日历权限;'),
                                  _Text(
                                      '3. 上述权限均不会默认或强制开启，你有权拒绝且你的拒绝不会影响钉单提供的基本功能服务;'),
                                  _Text(
                                      '4. 我们会努力采取各种安全技术保护你的个人信息，未经你同意，我们不会从第三方获取、共享或对外提供你的信息；'),
                                  _Text(
                                      '5.我们的产品集成友盟+SDK，友盟+SDK需要收集您的设备Mac地址、唯一设备识别码（IMEI/android ID/IDFA/OPENUDID/GUID、SIM 卡 IMSI 信息）以提供统计分析服务，并通过地理位置校准报表数据准确性，提供基础反作弊能力。'),
                                  _Text(
                                      '6.我们的产品集成高德地图，高德地图需要手机您设备的地理位置信息，通过位置信息匹配更精准的工厂客户给用户，以满足用户找工厂找订单的需求。'),
                                  _Text(
                                      '7.我们的产品集成腾讯开放平台SDK,提供用户绑定微信账号进行登录注册，微信支付等功能。'),
                                  _Text(
                                      '8.我们的产品集成极光推送SDK和华为推送，推送SDK需要收集您的设备设备信息（IMEI、IDFA、Android ID、MAC、OAID、IMSI等相关信息）、应用信息（应用崩溃信息、通知开关状态、软件列表等相关信息）、设备参数及系统信息（设备类型、设备型号、操作系统及硬件相关信息），地理位置、网络信息,通过识别设备信息为App赋予推送能力，用于消息推送；地理位置和网络信息用于创建智能标签，实现区域、分群推送功能。单独的某一设备信息是无法识别特定自然人身份的信息。如果我们将这类非个人信息与其他信息结合识别特定自然人身份，或将其与个人信息结合使用，则在结合使用期间，这类非个人信息将被视为个人信息，除非取得您的授权或法律法规另有规定外，我们会将这类信息做匿名化、去标识化处理。根据相关法律法规，极光SDK为实现如下业务功能、需要收集最终用户的“网络信息”和/或“位置信息”时，前提是最终用户需要授权开启“读写SD卡权限”、“网络访问权限”、“设备信息权限”和/或“位置权限”。如果您的终端用户不想被收集上述信息，可以通过关闭“读写SD卡权限”、“网络访问权限”、“设备信息权限”和/或“位置权限”实现。'),
                                  _Text(
                                      '9.我们的产品支持您使用第三方平台的账号（微信账号/钉钉账号）进行登录，如您使用第三方平台的账号登录的，我们将根据您的授权获取该第三方账号下的相关信息（包括：用户名、昵称、头像等）以及身份验证信息（个人敏感信息）。我们承诺，收集上述信息是用于为您提供账号登录服务以及保障您的账号安全，防范安全风险。如您拒绝授权此类信息，则您将无法使用第三方平台的账号登录我们平台，但不影响我们提供的其他产品和服务的正常使用。'),
                                  _Text(
                                      '10.同时，您需理解，手机号码或电子邮箱地址和验证码匹配结果属于您的个人敏感信息，我们收集该类信息是基于法律法规的相关要求，如您拒绝提供可能导致您无法注册账号并使用相关产品功能，请您谨慎考虑后再选择是否提供。'),
                                  _Text(
                                      '11.我们使用安全的技术、隐私保护的管理手段，和限制雇员接触隐私资料，以保护您的个人隐私。只有被授权的工作人员才能接触到您的个人资料，并且为数很少。'),
                                  _Text(
                                      '12.我们尊重你的选择权，你可以访问、更正、删除你的个人信息并管理你的授权，我们也为你提供注销、联系我们的渠道'),
                                  _Text(
                                      '我们鼓励我们的合作伙伴也清楚地公布他们的隐私政策。请务必浏览他们的隐私政策，如有疑问请和他们联系。'),
                                ],
                              ),
                            )),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: RichText(
                            textAlign: TextAlign.left,
                            text: TextSpan(
                                text: '阅读完整版',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF222222),
                                ),
                                children: [
                                  _service(),
                                  TextSpan(text: '和'),
                                  _privacy()
                                ])),
                      ),
                      _buildBottom()
                    ],
                  )),
            ),
          )),
    );
  }

  Widget _buildTitle2(
      {TextStyle style = const TextStyle(
          color: Color(0xFF222222),
          fontWeight: FontWeight.bold,
          fontSize: 12)}) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: RichText(
          text: TextSpan(text: '请充分阅读并理解我们的', style: style, children: [
        _service(),
        TextSpan(text: '和'),
        _privacy(),
        TextSpan(text: '，这将帮助你了解我们如何收集、处理你的个人信息：')
      ])),
    );
  }

  TextSpan _service() {
    return TextSpan(
        text: '《服务协议》',
        style: TextStyle(color: Colors.blue, fontSize: 12),
        recognizer: _serviceRecognizer);
  }

  TextSpan _privacy() {
    return TextSpan(
        text: '《隐私政策》',
        style: TextStyle(color: Colors.blue, fontSize: 12),
        recognizer: _privacyRecognizer);
  }

  Widget _buildBottom() {
    return Container(
      height: 60,
      child: Row(children: [
        Expanded(
            child: GestureDetector(
          onTap: onDisaAgree,
          child: Container(
              height: 60,
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                  )),
              child: Center(
                child: Text(
                  '不同意',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              )),
            )),
        Expanded(
            child: GestureDetector(
              onTap: onAgree,
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                    color: Color(0xFFFED800),
                    borderRadius:
                    BorderRadius.only(bottomRight: Radius.circular(20))),
                child: Center(
                  child: Text(
                    '同意并继续',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )),
      ]),
    );
  }

  void _onService() {
    launch('https://www.nbyjy.net/service.html');
  }

  void _onPrivacy() {
    launch('https://www.nbyjy.net/policy.html');
  }

  void onDisaAgree() {
    exit(1);
  }

  void onAgree() async {
    Provider.of<LocalStorageHelper>(context, listen: false)
      ..setPrivacyAgreeTime();

    //执行友盟初始化
    // UmengPlugin.initCommon();
    // Navigator.popUntil(context, ModalRoute.withName('/'));
  }
}

class _Text extends StatelessWidget {
  final String val;

  const _Text(this.val, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Expanded(
            child: Text('$val',
                style: TextStyle(color: Color(0xFF222222), fontSize: 12)),
          )
        ],
      ),
    );
  }
}
