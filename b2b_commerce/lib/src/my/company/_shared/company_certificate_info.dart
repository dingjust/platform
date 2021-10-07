import 'package:b2b_commerce/src/home/factory/_shared/factory_info.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_group_sliver/flutter_group_sliver.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'package:b2b_commerce/src/_shared/widgets/info/info_widgets.dart';

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
        //未认证
        if (response.code == 0) {
          info = AuthenticationInfoModel();
        } else {
          info = AuthenticationInfoModel.fromJson(response.data);
          type = response.resultCode;
          //经营执照水印处理
          String imageProcess =
              'image_process=watermark,text_6ZKJ5Y2V,fill_1,color_F5F5F5,t_50';
          info.certImg.url = '${info.certImg.url}?$imageProcess';
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
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            margin: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                InfoTitle('企业信息'),
                InfoRow(label: '公司名称', val: info.name),
                InfoDivider(),
                InfoRow(label: '信用代码', val: info?.organization),
                InfoDivider(),
                InfoRow(label: '法人', val: info?.legal?.name),
                InfoDivider(),
                InfoRow(label: '代理人', val: info?.agent?.name),
              ],
            ),
          ),
        ),
        PicturesTitle(val: '营业执照'),
        SliverGroupBuilder(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            margin: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12))),
            child: SliverPadding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
                sliver: ImageSliverGrid(
                    medias: info.certImg != null ? [info.certImg] : [])))
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
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            margin: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                InfoTitle('个人信息'),
                InfoRow(label: '姓名', val: info.name),
                InfoDivider(),
                InfoRow(label: '身份证', val: info?.idCard),
                InfoDivider(),
                InfoRow(label: '手机号', val: info?.mobile),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
