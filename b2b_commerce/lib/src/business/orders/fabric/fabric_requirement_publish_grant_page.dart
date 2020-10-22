import 'package:b2b_commerce/src/home/account/login_page.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:widgets/widgets.dart';

///面料需求发布授权页面
class FabricRequirementPublishGrantPage extends StatefulWidget {
  @override
  _FabricRequirementPublishGrantPageState createState() =>
      _FabricRequirementPublishGrantPageState();
}

class _FabricRequirementPublishGrantPageState
    extends State<FabricRequirementPublishGrantPage> {
  ///倒计时间
  int countdownTime = 60;

  final CountdownController controller = CountdownController();

  TextEditingController _captchaController;
  FocusNode _captchaFocusNode;

  ///信息内容样式
  static const TextStyle infoTextStyle = TextStyle(fontSize: 13);

  @override
  void initState() {
    _captchaController = TextEditingController();
    _captchaFocusNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        centerTitle: true,
        title: Text('面料需求发布确认'),
      ),
      body: _buildBody(),
      bottomNavigationBar: _buildBottom(),
    );
  }

  Widget _buildBody() {
    return Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: ListView(children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text('账号授权')],
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Row(
              children: [
                Expanded(
                    child: Text(
                        '检测到您的账号及手机188****5555在搜布网未注册相关账号，我方将使用你的手机、名称、地址等信息帮助你注册搜布网的相关账号，' +
                            '你发布的面料需求将同步到该账号内，你可以通过账号密码直接在搜布网登陆查看需求的相关信息，账号密码将通过短信发送至你的手机上。')
                    // Text(
                    //     '检测到您的手机123******2555在搜布网已经注册了相关账号，请通过手机短信验证码绑定该账号，你发布的面料需求将同步到该账号内。')
                    )
              ],
            ),
          ),
          _buildCodeRow()
        ]));
  }

  ///验证码行
  Widget _buildCodeRow() {
    return Container(
        margin: EdgeInsets.only(top: 20),
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: InputRow(
          field: TextField(
            autofocus: false,
            onChanged: (value) {
              // formValidate();
            },
            keyboardType: TextInputType.phone,
            //只能输入数字
            inputFormatters: <TextInputFormatter>[
              WhitelistingTextInputFormatter.digitsOnly,
            ],
            focusNode: _captchaFocusNode,
            controller: _captchaController,
            decoration:
                InputDecoration(hintText: '请输入短信验证码', border: InputBorder.none),
          ),
          surfix: Countdown(
            controller: controller,
            seconds: countdownTime,
            build: (_, double time) => FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              color: Color.fromRGBO(255, 214, 12, 1),
              onPressed: (time == 0 || time == countdownTime)
                  ? () async {
                      // bool legal = await validatePhone();
                      // if (legal) {
                      //   UserRepositoryImpl()
                      //       .sendCaptchaForLogin(_phoneController.text)
                      //       .then((a) {
                      //     controller.restart();
                      //   });
                      // }
                      controller.restart();
                    }
                  : null,
              child: Text(
                (time == 0 || time == countdownTime)
                    ? '获取验证码'
                    : '${time.toInt()}s',
                style: TextStyle(color: Colors.black),
              ),
            ),
            interval: Duration(milliseconds: 1000),
            onFinished: () {},
          ),
        ));
  }

  ///底部
  Widget _buildBottom() {
    return Row(
      children: [
        Expanded(
            child: FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('拒绝'))),
        Expanded(child: FlatButton(onPressed: _onAgress, child: Text('同意')))
      ],
    );
  }

  ///同意
  void _onAgress() {
    BotToast.showCustomText(
        onlyOne: true,
        duration: null,
        clickClose: false,
        crossPage: false,
        backgroundColor: Colors.black38,
        toastBuilder: (cancelFunc) => _identifyFailDialog(cancelFunc));
  }

  ///注册失败
  Widget _registerFailDialog(Function cancelFunc) {
    return AlertDialog(
      content: Container(
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Text('发布失败'),
            ),
            Row(
              children: [
                Expanded(
                    child: Text(
                  '你的面料信息发布失败',
                  style: infoTextStyle,
                ))
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: Text(
                  '失败原因：搜布网账号注册失败',
                  style: infoTextStyle,
                ))
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              child: Row(
                children: [
                  Text(
                    '重新提交',
                    style: infoTextStyle,
                  )
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                    child: FlatButton(onPressed: cancelFunc, child: Text('否'))),
                Expanded(
                    child: FlatButton(onPressed: cancelFunc, child: Text('是')))
              ],
            )
          ],
        ),
      ),
    );
  }

  ///已注册卖家身份
  Widget _identifyFailDialog(Function cancelFunc) {
    return AlertDialog(
      content: Container(
        height: 250,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Text('发布失败'),
            ),
            Row(
              children: [
                Expanded(
                    child: Text(
                  '检测到您的手机159*******6049在搜布网已经注册了身份为"卖家"相关账号，该账号不能发布相关的面料需求，请您在搜布网注册身份为"买家"的账号完成面料需求的发布。',
                  style: infoTextStyle,
                ))
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              child: Row(
                children: [
                  Text(
                    '是否前往搜布网',
                    style: infoTextStyle,
                  )
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                    child: FlatButton(onPressed: cancelFunc, child: Text('否'))),
                Expanded(
                    child: FlatButton(onPressed: cancelFunc, child: Text('是')))
              ],
            )
          ],
        ),
      ),
    );
  }

  ///发布成功
  Widget _successDialog(Function cancelFunc) {
    return AlertDialog(
      content: Container(
        height: 250,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Text('发布成功'),
            ),
            Row(
              children: [
                Expanded(
                    child: Text(
                  '您的面料需求信息发布成功，你可以登录搜布网查看需求的后续进度，你可以用账号密码或者短信验证码等的登录方式登录搜布网',
                  style: infoTextStyle,
                ))
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              child: Row(
                children: [
                  Text(
                    '是否前往搜布网',
                    style: infoTextStyle,
                  )
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                    child: FlatButton(onPressed: cancelFunc, child: Text('否'))),
                Expanded(
                    child: FlatButton(onPressed: cancelFunc, child: Text('是')))
              ],
            )
          ],
        ),
      ),
    );
  }
}
