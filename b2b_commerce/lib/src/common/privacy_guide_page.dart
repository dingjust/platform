import 'package:b2b_commerce/src/_shared/widgets/app_bar_factory.dart';
import 'package:flutter/material.dart';

///隐私同意指引页面内
class PrivacyGuidePage extends StatefulWidget {
  const PrivacyGuidePage({Key key}) : super(key: key);

  @override
  _PrivacyGuidePageState createState() => _PrivacyGuidePageState();
}

class _PrivacyGuidePageState extends State<PrivacyGuidePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarFactory.buildDefaultAppBar('个人信息处理说明'),
      bottomNavigationBar: _buildBottom(),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: ListView(
          children: [
            _buildTitle1(),
            _buildTitle2(),
            _Text(
                '1. 我们不公开您在本网站内的个人资料。本网站不会公开个人联系方法除非因法律程序的要求。我们收集您的个人资料目的是为了向您提供最大程度的个性化体验，通过对您多了解一点， 我们就能向您发送与您更为相关的信息，从而向您提供更好的服务；不过在任何情况下，广告商是无法得到您的个人帐户资料的，除非您明确授权可以这么做。'),
            _Text(
                '2. 我们不使用任何您在本网站的个人个人信息或网上浏览的信息，也不将其告诉其它人。我们的系统自动收集您使用我们的服务过程中到达某一区域或网址的信息，我们不会和其它公司共享这些数据， 我们汇总这些用户浏览信息以了解我们的用户作为一个整体是如何使用我们的服务的，以便能够改善我们的服务。 我们也将和我们的合作伙伴（有保密责任约束的）分享汇总的用户浏览信息，但我们不公开。我们不追踪您浏览互联网的信息。一旦您点击了一个链向其它网站的链接，我们的隐私政策不再有效。'),
            _Text(
                '3. 我们不出售您的注册信息（姓名、电话、地址等等），除非您授权我们这么做。我们不出售或交换您的姓名、地址、电话、 email address、或任何其它注册信息，除非事先得到您的专门授权。 对这条规定我们有两个例外情况：我们会在有关法律的强制下公布您的个人信息，我们会和我们的合作伙伴（有保密责任约束的）共享汇总了的注册信息。'),
            _Text('4. 账号注册'),
            _Text(
                '（1）您注册并登录钉单账号时，需要按照我们的指引完成一系列注册程序，在此过程中，您需要向我们提供以下信息：姓名、手机号码（个人敏感信息，用于接受验证码匹配个人身份）。您只有提供真实准确的上述信息，才能成功注册钉单账号并使用产品和/或服务的核心功能。如果您选择不提供上述为实现钉单核心产品功能的必备信息，或将导致我们无法为您提供该核心产品功能。'),
            _Text(
                '（2）我们的产品支持您使用第三方平台的账号（微信账号/钉钉账号）进行登录，如您使用第三方平台的账号登录的，我们将根据您的授权获取该第三方账号下的相关信息（包括：用户名、昵称、头像等）以及身份验证信息（个人敏感信息）。我们承诺，收集上述信息是用于为您提供账号登录服务以及保障您的账号安全，防范安全风险。如您拒绝授权此类信息，则您将无法使用第三方平台的账号登录我们平台，但不影响我们提供的其他产品和服务的正常使用。'),
            _Text(
                '（3）同时，您需理解，手机号码或电子邮箱地址和验证码匹配结果属于您的个人敏感信息，我们收集该类信息是基于法律法规的相关要求，如您拒绝提供可能导致您无法注册账号并使用相关产品功能，请您谨慎考虑后再选择是否提供。'),
            _Text(
                '（4）我们使用安全的技术、隐私保护的管理手段，和限制雇员接触隐私资料，以保护您的个人隐私。只有被授权的工作人员才能接触到您的个人资料，并且为数很少。'),
            _Text(
                '5.我们的产品集成友盟+SDK，友盟+SDK需要收集您的设备Mac地址、唯一设备识别码（IMEI/android ID/IDFA/OPENUDID/GUID、SIM 卡 IMSI 信息）以提供统计分析服务，并通过地理位置校准报表数据准确性，提供基础反作弊能力。'),
            _Text(
                '6.我们的产品集成高德地图，高德地图需要手机您设备的地理位置信息，通过位置信息匹配更精准的工厂客户给用户，以瞒住用户找工厂找订单的需求。'),
            _Text('7.我们的产品集成腾讯开放平台SDK,提供用户绑定微信账号进行登录注册，微信支付等功能。'),
            _Text(
                '8.我们的产品集成极光推送SDK和华为推送，推送SDK需要收集您的设备设备信息（IMEI、IDFA、Android ID、MAC、OAID、IMSI等相关信息）、应用信息（应用崩溃信息、通知开关状态、软件列表等相关信息）、设备参数及系统信息（设备类型、设备型号、操作系统及硬件相关信息），地理位置、网络信息,通过识别设备信息为App赋予推送能力，用于消息推送；地理位置和网络信息用于创建智能标签，实现区域、分群推送功能。单独的某一设备信息是无法识别特定自然人身份的信息。如果我们将这类非个人信息与其他信息结合识别特定自然人身份，或将其与个人信息结合使用，则在结合使用期间，这类非个人信息将被视为个人信息，除非取得您的授权或法律法规另有规定外，我们会将这类信息做匿名化、去标识化处理。根据相关法律法规，极光SDK为实现如下业务功能、需要收集最终用户的“网络信息”和/或“位置信息”时，前提是最终用户需要授权开启“读写SD卡权限”、“网络访问权限”、“设备信息权限”和/或“位置权限”。如果您的终端用户不想被收集上述信息，可以通过关闭“读写SD卡权限”、“网络访问权限”、“设备信息权限”和/或“位置权限”实现。'),
            _Text('我们鼓励我们的合作伙伴也清楚地公布他们的隐私政策。请务必浏览他们的隐私政策，如有疑问请和他们联系。'),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle1() {
    return Container(
      margin: EdgeInsets.only(top: 38, bottom: 20),
      child: Row(
        children: [
          Text(
            '欢迎使用[钉单]',
            style: TextStyle(
                color: Color(0xFF222222),
                fontWeight: FontWeight.bold,
                fontSize: 22),
          )
        ],
      ),
    );
  }

  Widget _buildTitle2() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Row(
        children: [
          Expanded(
              child: Text(
            '请充分阅读并理解我们的《个人信息保护指引》和《隐私协议》，这将帮助你了解我们如何收集、处理你的个人信息：',
            style: TextStyle(
                color: Color(0xFF222222),
                fontWeight: FontWeight.bold,
                fontSize: 12),
          ))
        ],
      ),
    );
  }

  Widget _buildBottom() {
    return Container(
      height: 60,
      child: Row(children: [
        Expanded(
            child: GestureDetector(
          onTap: onAgree,
          child: Container(
              height: 60,
              color: Colors.grey[100],
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
            color: Color(0xFFFED800),
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

  void onAgree() {
    Navigator.popUntil(context, ModalRoute.withName('/'));
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
