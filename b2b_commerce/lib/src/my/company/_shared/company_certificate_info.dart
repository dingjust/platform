import 'package:b2b_commerce/src/home/factory/_shared/factory_widgets.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

///公司认证信息
class CompanyCertificateInfo extends StatefulWidget {
  final String code;

  const CompanyCertificateInfo({Key key, this.code}) : super(key: key);

  @override
  _CompanyCertificateInfoState createState() => _CompanyCertificateInfoState();
}

class _CompanyCertificateInfoState extends State<CompanyCertificateInfo> {
  AuthenticationInfoModel info;

  ///null 未认证，0企业,1个人
  int type;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getData(),
      builder: (BuildContext context,
          AsyncSnapshot<AuthenticationInfoModel> snapshot) {
        if (info != null) {
          if (type == null) {
            return Container(
                margin: EdgeInsets.only(top: 50),
                child: Text(
                  '未认证',
                  textAlign: TextAlign.center,
                ));
          }
          return Container(
              child: type == 0 ? _EnterPriseInfo(info) : _PersonalInfo(info));
        } else {
          return Container(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  ///获取认证信息
  Future<AuthenticationInfoModel> _getData() async {
    if (info == null) {
      BaseResponse response = await CertificateRepository.get(widget.code);
      if (response == null) {
        BotToast.showText(text: '未知错误');
      } else {
        ///未认证
        if (response.code == 0) {
          info = AuthenticationInfoModel();
        } else {
          info = AuthenticationInfoModel.fromJson(response.data);
          type = response.resultCode;
        }
      }
    }
    return info;
  }
}

///企业信息
class _EnterPriseInfo extends StatelessWidget {
  final AuthenticationInfoModel info;

  const _EnterPriseInfo(this.info);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        FactoryDivider(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              FactoryTitle('企业信息'),
              Divider(),
              FactoryInfoRow(label: '公司名称', val: info.name),
              FactoryInfoRow(label: '信用代码', val: info?.organization),
              FactoryInfoRow(label: '法人', val: info?.legal?.name),
              FactoryInfoRow(label: '代理人', val: info?.agent?.name),
            ],
          ),
        ),
        FactoryDivider(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              FactoryTitle('营业执照'),
              Divider(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Row(
                  children: <Widget>[
                    Text(
                      '点击图片查看大图',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 15),
                child: Attachments(
                    list: info.certImg != null ? [info.certImg] : []),
              )
            ],
          ),
        ),
      ],
    );
  }
}

///个人信息
class _PersonalInfo extends StatelessWidget {
  final AuthenticationInfoModel info;

  const _PersonalInfo(this.info);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        FactoryDivider(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              FactoryTitle('个人信息'),
              Divider(),
              FactoryInfoRow(label: '姓名', val: info.name),
              FactoryInfoRow(label: '身份证', val: info?.idCard),
              FactoryInfoRow(label: '手机号', val: info?.mobile),
            ],
          ),
        ),
        FactoryDivider(),
        // _Ability(model)
      ],
    );
  }
}
