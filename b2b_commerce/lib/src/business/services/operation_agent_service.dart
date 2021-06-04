import 'package:b2b_commerce/src/common/webview_page.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

import 'package:b2b_commerce/src/helper/contract_helper.dart';

import 'package:core/core.dart';
import 'package:services/services.dart';

import 'service_apply_form.dart';

///代运营服务申请页面
class OperationAgentServiceApplyPage extends StatefulWidget {
  @override
  _OperationAgentServiceApplyPageState createState() =>
      _OperationAgentServiceApplyPageState();
}

class _OperationAgentServiceApplyPageState
    extends State<OperationAgentServiceApplyPage> {
  ///服务内容URL(存放在OSS,CDN分发)
  final String doucumentUrl =
      'https://cdn-oss.nbyjy.net/document/operation_agent_service.html';

  final double bottomHeight = 60.0;
  bool show = true;

  //当前服务状态
  Map agentOperationInfo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<Map>(
      builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
        if (snapshot.data != null) {
          return Column(
            children: [
              Expanded(
                child: show
                    ? WebviewPage(
                        url: '$doucumentUrl',
                        title: '钉单店铺代运营技术服务',
                      )
                    : Container(),
              ),
              _buildBottom(snapshot.data)
            ],
          );
        } else {
          return Container(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
      future: _getData(),
    ));
  }

  ///底部
  Widget _buildBottom(Map info) {
    Widget bottomWidget;

    //判断状态
    switch (info['status']) {
      //审核中
      case 'REVIEWING':
        bottomWidget = _ReviewingInfo();
        break;
      //通过（签署协议）
      case 'REVIEW_PASSED':
        bottomWidget = _ReviewPassInfo(
          code: info['userAgreementCode'],
          color: Colors.yellow[600],
          status: '待签署协议',
          btnText: '签署协议',
          before: () {
            setState(() {
              show = false;
            });
          },
          afterPop: () {
            setState(() {
              show = true;
            });
          },
        );
        break;
      //已签署
      case 'COMPLETED':
        bottomWidget = _ReviewPassInfo(
          code: info['userAgreementCode'],
          color: Colors.green,
          status: '已签署协议',
          btnText: '查看协议',
          before: () {
            setState(() {
              show = false;
            });
          },
          afterPop: () {
            setState(() {
              show = true;
            });
          },
        );
        break;

      default:
        bottomWidget = _buildAplyBtn();
    }

    return Container(
        color: Colors.white, height: bottomHeight, child: bottomWidget);
  }

  ///申请按钮
  Widget _buildAplyBtn() {
    return Row(
      children: [
        Expanded(
            child: FlatButton(
          height: bottomHeight,
          child: Text('马上申请'),
          color: Constants.THEME_COLOR_MAIN,
          textColor: Colors.white,
          onPressed: () {
            setState(() {
              show = false;
            });
            Navigator.of(context)
                .push(MaterialPageRoute(
                    builder: (context) => ServiceApplyFormPage()))
                .then((value) {
              setState(() {
                show = true;
              });
            });
          },
        ))
      ],
    );
  }

  ///获取申请状态
  Future<Map<String, dynamic>> _getData() async {
    // if (agentOperationInfo == null) {
    BaseResponse baseResponse = await OperationAgentRepository.getInfo();
    if (baseResponse != null) {
      if (baseResponse.code == 1) {
        //接口成功，数据为空则未申请
        if (baseResponse.data == null) {
          return {};
        }
        return baseResponse.data;
      } else if (baseResponse.code == 0) {
        BotToast.showText(text: '${baseResponse.msg}');
      }
    }
    // }
    return null;
  }
}

///审核中
class _ReviewingInfo extends StatelessWidget {
  const _ReviewingInfo({Key, key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.,
        children: [
          RichText(
              text: TextSpan(
                  text: '当前状态：',
                  style: TextStyle(color: Colors.black87),
                  children: [
                TextSpan(text: '待平台审核', style: TextStyle(color: Colors.orange))
              ])),
          Expanded(
              child: Container(
            margin: EdgeInsets.only(left: 20),
            child: Text(
              '您已提交申请，请耐心等待平台审核',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ))
        ],
      ),
    );
  }
}

///通过（待签）
class _ReviewPassInfo extends StatelessWidget {
  ///协议编号
  final String code;

  ///点击前
  final VoidCallback before;

  ///页面返回
  final VoidCallback afterPop;

  final String status;

  final Color color;

  final String btnText;

  const _ReviewPassInfo(
      {Key,
      key,
      this.code,
      this.before,
      this.afterPop,
      this.status,
      this.color,
      this.btnText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        RichText(
            text: TextSpan(
                text: '当前状态：',
                style: TextStyle(color: Colors.black87),
                children: [
              TextSpan(text: '$status', style: TextStyle(color: color))
            ])),
        FlatButton(
          child: Text(
            '$btnText',
            style: TextStyle(color: Colors.white),
          ),
          color: Colors.blueAccent,
          onPressed: () async {
            before?.call();
            Function cancelFunc =
                BotToast.showLoading(clickClose: true, crossPage: false);
            var contractModel = await ContractRepository().getContract(code);
            ContractHelper.open(context: context, model: contractModel.data)
                .then((value) {
              afterPop?.call();
            });
          },
        )
      ],
    );
  }
}
