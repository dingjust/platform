import 'package:b2b_commerce/src/my/integral/integral_exchange_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddshare/flutter_ddshare.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'components/invite_bottomsheet.dart';

class InvitePage extends StatefulWidget {
  @override
  _InvitePageState createState() => _InvitePageState();
}

class _InvitePageState extends State<InvitePage> {
  ///邀请码
  String code;

  ///邀请好友
  int recommendUser;

  ///可用积分
  int availablePoints;

  ///扣缴积分
  int withholdPoints;

  double barHeight = 250;

  @override
  void initState() {
    super.initState();
    initPlugin();
  }

  Future<void> initPlugin() async {
    //注册钉钉插件
    bool registerResult = await FlutterDdshare.registerApp(
        GlobalConfigs.DINGDING_APPID, GlobalConfigs.IOS_BUNDLE_ID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                // Color(0xFFdd6d07),
                Color(0xFFf57c07),
                Color(0xFFffb118)
              ])),
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                expandedHeight: barHeight,
                pinned: true,
                elevation: 0,
                backgroundColor: Color.fromRGBO(255, 255, 255, 0),
                actionsIconTheme: IconThemeData(color: Colors.grey[300]),
                brightness: Brightness.dark,
                leading: IconButton(
                    icon: Icon(
                      B2BIcons.left_fill,
                      color: Color.fromRGBO(0, 0, 0, 0.6),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Container(
                        height: barHeight,
                        child: CachedNetworkImage(
                          imageUrl:
                              'https://cdn-oss.nbyjy.net/activity/invite_activity.jpg',
                          fit: BoxFit.cover,
                          placeholder: (context, url) => SpinKitRing(
                            color: Color(0xFFfa981b),
                            lineWidth: 2,
                            size: 1,
                          ),
                          errorWidget: (context, url, error) => SpinKitRing(
                            color: Color(0xFFfa981b),
                            lineWidth: 2,
                            size: 1,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SliverList(
                  delegate: SliverChildListDelegate([
                _InviteCard(),
                FutureBuilder(
                  future: IntegralRepository.getIntegralInfo(),
                  builder: (BuildContext context,
                      AsyncSnapshot<UserIntegralInfo> snapshot) {
                    if (snapshot.hasData) {
                      return _MyCard(
                        availablePoints: snapshot.data.availablePoints,
                        withholdPoints: snapshot.data.withholdPoints,
                        recommendUser: snapshot.data.recommendUser,
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(
                                  builder: (context) => IntegralExchangePage()))
                              .then((value) {
                            setState(() {});
                          });
                        },
                      );
                    } else {
                      return _MyCard();
                    }
                  },
                ),
                _RuleCard(),
                _LOGO()
              ])),
            ],
          ),
        ),
        bottomSheet: FutureBuilder(
          future: InviteActivityRepository.getRecommendCode(),
          initialData: '',
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) =>
              InviteBottomeSheet(
                  title: '邀请您使用钉单APP',
                  description: '服装供应链专业平台',
                  imageUrl:
                      'https://cdn-oss.nbyjy.net/activity/invite_activity.jpg',
                  url:
                      '${GlobalConfigs.APP_TARO_CONTEXT_PATH}/#/pages/register/register?code=${snapshot.data}'),
        ));
  }
}

class _InviteCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        elevation: 0,
        color: Color(0xffeacb9f),
        child: Container(
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '每邀请1位好友',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFf57c07),
                    fontSize: 20),
                textAlign: TextAlign.center,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color(0xfff2445a)),
                child: Text(
                  '限时奖励活动',
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '你获',
                    style: TextStyle(color: Color(0xFFf57c07), fontSize: 18),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      '10',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFf23f5b),
                          fontSize: 26),
                    ),
                  ),
                  Text(
                    '积分',
                    style: TextStyle(color: Color(0xFFf23f5b), fontSize: 18),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _RuleCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        elevation: 0,
        color: Color(0xffeacb9f),
        child: Container(
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  color: Color(0xffeacb9f),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10))),
              child: Text(
                '规则说明',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff90562d)),
              ),
            ),
            _Text(
              text:
                  '1.将活动分享给好友，让好友通过你的分享链接注册并下载钉单 APP，你将获得对应积分奖励。积分可以兑换现金红包等噢！',
              margin: EdgeInsets.symmetric(vertical: 5),
            ),
            _Text(
                text: '2.被邀请的好友使用的设备及手机号必须是之前从未注册过钉单 APP的才记有效，手机号必须为中国大陆地区归属。'),
            _Text(text: '3.邀请好友无上限，邀请越多奖励越多！'),
            _Text(text: '4.积分兑换奖励需通过有效审核才可兑现。'),
            _Text(text: '5.若你有以下任何一种情况，钉单有权取消您的参与资格、获奖资格等：'),
            _Text(text: 'a.不符合参与资格；'),
            _Text(text: 'b.提供虚假信息；'),
            _Text(text: 'c.以任何第三方软件或以不正当方式参与活动；'),
            _Text(text: 'd.任何其他违反法规或者钉单相关协议规范的行为；'),
            _Text(
              text: '*本活动同时受《钉单平台服务协议》、《钉单隐私政策协议》相关协议规范约束。',
              style: TextStyle(
                  color: Color.fromRGBO(245, 124, 7, 0.69), fontSize: 10),
            ),
          ]),
        ),
      ),
    );
  }
}

///我的积分
class _MyCard extends StatelessWidget {
  ///邀请好友
  final int recommendUser;

  ///可用积分
  final int availablePoints;

  ///扣缴积分
  final int withholdPoints;

  final VoidCallback onTap;

  const _MyCard(
      {Key key,
      this.recommendUser = 0,
      this.availablePoints = 0,
      this.withholdPoints = 0,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        elevation: 0,
        color: Color(0xffeacb9f),
        child: Container(
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  color: Color(0xffeacb9f),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10))),
              child: Text(
                '我的奖励',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff90562d)),
              ),
            ),
            Row(
              children: [
                Expanded(
                    child: _buildItem(
                        title: '邀请好友', val: '$recommendUser', unit: '位')),
                Expanded(
                    child: _buildItem(
                  title: '可用积分',
                  val: '$availablePoints',
                )),
                Expanded(
                    child: _buildItem(
                  title: '扣缴积分',
                  val: '$withholdPoints',
                ))
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                      child: TextButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Color(0xFFf57c07))),
                          onPressed: onTap,
                          child: Text(
                            '兑换红包',
                            style: TextStyle(color: Colors.white),
                          )))
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }

  Widget _buildItem({String title = '', String val = '', String unit = '分'}) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '$title',
            style: TextStyle(color: Color(0xFFf57c07)),
          ),
          Text(
            '$val$unit',
            style: TextStyle(
              color: Color(0xFFf23f5b),
            ),
          )
        ],
      ),
    );
  }
}

class _LOGO extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(0, 20, 0, 110),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'temp/login_logo.png',
              package: 'assets',
              width: 50.0,
              height: 50.0,
            ),
          ],
        ));
  }
}

class _Text extends StatelessWidget {
  final String text;

  final TextStyle style;

  final EdgeInsetsGeometry margin;

  const _Text(
      {Key key,
      this.style = const TextStyle(color: Color(0xFFf57c07), fontSize: 12),
      this.text,
      this.margin = const EdgeInsets.only(bottom: 5)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Row(
        children: [
          Expanded(
              child: Text(
            '$text',
            style: style,
          ))
        ],
      ),
    );
  }
}
