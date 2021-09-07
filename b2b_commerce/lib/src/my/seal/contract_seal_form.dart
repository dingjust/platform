import 'dart:typed_data';
import 'dart:ui';

import 'package:bot_toast/bot_toast.dart';
import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'util/seal_generator.dart';

///印章创建表单
class ContractSealFormPage extends StatefulWidget {
  final SealType type;

  const ContractSealFormPage({Key key, this.type = SealType.OFFICAL})
      : super(key: key);

  @override
  _ContractSealFormPageState createState() => _ContractSealFormPageState();
}

class _ContractSealFormPageState extends State<ContractSealFormPage> {
  ByteData imgBytes;
  SealGenerator sealGenerator;

  ///公章尺寸
  double size = 171;

  ///个人章尺寸
  double pSize = 120;

  String name;
  CertificationInfo certInfo;

  TextEditingController sealNameController;
  FocusNode sealNameFocusNode;
  TextEditingController sealTitleController;
  FocusNode sealTitleFocusNode;
  TextEditingController sealNumController;
  FocusNode sealNumFocusNode;

  @override
  void initState() {
    sealGenerator = SealGenerator(kCanvasSize: size);
    sealNameController = TextEditingController();
    sealNameFocusNode = FocusNode();
    sealTitleController = TextEditingController();
    sealTitleFocusNode = FocusNode();
    sealNumController = TextEditingController();
    sealNumFocusNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: Text('创建印章'),
        centerTitle: true,
      ),
      body: FutureBuilder<CertificationInfo>(
        builder:
            (BuildContext context, AsyncSnapshot<CertificationInfo> snapshot) {
          if (snapshot.data != null) {
            return Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: ListView(
                children: [
                  _buildSeal(),
                  _buildRebuildBtn(),
                  Divider(),
                  _buildName(),
                  _buildSealName(),
                  for (Widget widgetItem in widget.type == SealType.OFFICAL
                      ? [_buildTitleText(), _buildNumText()]
                      : [])
                    widgetItem
                ],
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
        initialData: null,
        future: _getCertInfo(),
      ),
      bottomNavigationBar: _btn(),
    );
  }

  Widget _buildSeal() {
    return Container(
      child: FutureBuilder<ByteData>(
          initialData: null,
          future: _getData(),
          builder: (BuildContext context, AsyncSnapshot<ByteData> snapshot) {
            if (snapshot.data != null && imgBytes != null) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Center(
                        child: Image.memory(
                      Uint8List.view(imgBytes.buffer),
                      width: widget.type == SealType.OFFICAL ? size : pSize,
                      height: widget.type == SealType.OFFICAL ? size : pSize,
                    ))
                  ],
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  ///重新生成印章按钮
  Widget _buildRebuildBtn() {
    //Android不需要
    if (defaultTargetPlatform == TargetPlatform.android) {
      return Container();
    } else {
      return Container(
        child: TextButton(onPressed: previewSeal, child: Text('预览印章')),
      );
    }
  }

  ///章名
  Widget _buildName() {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Row(
        children: <Widget>[
          Text(
            '认证名称：$name',
            style: TextStyle(fontSize: 16, color: Colors.black),
          )
        ],
      ),
    );
  }

  ///印章名称
  Widget _buildSealName() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Row(
        children: <Widget>[
          RichText(
            text: TextSpan(children: [
              TextSpan(
                text: '印章名称',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              TextSpan(
                text: ' * ',
                style: TextStyle(fontSize: 16, color: Colors.red),
              )
            ]),
          ),
          Expanded(
            flex: 1,
            child: TextFieldBorderComponent(
              padding: EdgeInsets.all(0),
              hideDivider: true,
              isRequired: true,
              textAlign: TextAlign.left,
              hintText: '填写',
              controller: sealNameController,
              focusNode: sealNameFocusNode,
            ),
          ),
        ],
      ),
    );
  }

  ///横向文
  Widget _buildTitleText() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Row(
        children: <Widget>[
          RichText(
            text: TextSpan(children: [
              TextSpan(
                text: '横  向  文：',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ]),
          ),
          Expanded(
            flex: 1,
            child: TextFieldBorderComponent(
              padding: EdgeInsets.all(0),
              hideDivider: true,
              isRequired: true,
              textAlign: TextAlign.left,
              hintText: '填写',
              controller: sealTitleController,
              focusNode: sealTitleFocusNode,
              onChanged: (v) {
                print(v);
                reGenerateSeal();
              },
            ),
          ),
        ],
      ),
    );
  }

  ///防伪码
  Widget _buildNumText() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Row(
        children: <Widget>[
          RichText(
            text: TextSpan(children: [
              TextSpan(
                text: '编        码：',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ]),
          ),
          Expanded(
            flex: 1,
            child: TextFieldBorderComponent(
              padding: EdgeInsets.all(0),
              hideDivider: true,
              isRequired: true,
              textAlign: TextAlign.left,
              hintText: '填写',
              controller: sealNumController,
              focusNode: sealNumFocusNode,
              onChanged: (v) {
                reGenerateSeal();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _btn({double height = 55}) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        children: [
          Expanded(
              flex: 1,
              child: Container(
                height: height,
                child: FlatButton(
                    shape: RoundedRectangleBorder(),
                    disabledColor: Colors.grey,
                    onPressed: _onSubmit,
                    color: Constants.THEME_COLOR_MAIN,
                    child: Text('保存',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ))),
              ))
        ],
      ),
    );
  }

  Future<CertificationInfo> _getCertInfo() async {
    if (certInfo == null) {
      if (widget.type == SealType.OFFICAL) {
        // 查询明细
        certInfo = await ContractRepository().getAuthenticationInfoEnterprise();
      } else {
        // 查询明细
        certInfo = await ContractRepository().getAuthenticationInfo();
      }
      setState(() {
        name = certInfo.data.name;
      });
    }

    return certInfo;
  }

  void _onSubmit() async {
    await previewSeal();

    if (imgBytes == null) {
      BotToast.showText(text: '生成印章失败');
      throw Exception('[DingDan]印章生成失败');
    }

    if (sealNameController.text == null || sealNameController.text == '') {
      BotToast.showText(text: '请填写印章名称');
      throw Exception('[DingDan]印章名字为空');
    }

    Function cancelFunc =
        BotToast.showLoading(crossPage: false, clickClose: true);

    BaseResponse response =
        await SealRepository.create(imgBytes, sealNameController.text);

    cancelFunc.call();
    if (response != null && response.code == 1) {
      BotToast.showText(text: '创建成功');
      Navigator.of(context).pop(true);
    } else if (response != null && response.code == 0) {
      BotToast.showText(text: '${response.msg}');
    } else {
      BotToast.showText(text: '操作失败');
    }
  }

  ///生成印章
  Future<ByteData> _getData() async {
    if (imgBytes == null) {
      imgBytes = await _generateSeal();
    }
    return imgBytes;
  }

  ///重新生成印章
  void reGenerateSeal() async {
    ByteData data = await _generateSeal();
    //ANDROID平台直接刷新印章
    if (defaultTargetPlatform == TargetPlatform.android)
      setState(() {
        imgBytes = data;
      });
    else //其他平台不刷新
      imgBytes = data;
  }

  Future<void> previewSeal() async {
    ByteData data = await _generateSeal();
    setState(() {
      imgBytes = data;
    });
  }

  ///生成印章
  Future<ByteData> _generateSeal() async {
    ByteData data;
    //公章
    if (widget.type == SealType.OFFICAL) {
      data = await sealGenerator.generateOfficalSealImage(
          text: '$name',
          title: sealTitleController.text,
          textNum: sealNumController.text);
    } else if (widget.type == SealType.PERSONAL) {
      //个人
      data = await sealGenerator.generatePersonalSealImage(
        text: '$name',
      );
    }
    return data;
  }
}

enum SealType {
  ///公章
  OFFICAL,

  ////个人章
  PERSONAL
}
