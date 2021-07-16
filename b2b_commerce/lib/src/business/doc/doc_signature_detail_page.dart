import 'dart:async';

import 'package:b2b_commerce/src/helper/doc_signature_helper.dart';
import 'package:b2b_commerce/src/my/contract/pdf_reader.dart';
import 'package:b2b_commerce/src/my/seal/contract_seal_page.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:models/models.dart';
import 'package:open_file/open_file.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

///签署文档详情页
class DocSignatureDetailPage extends StatefulWidget {
  final DocSignatureModel doc;

  final String title;

  final bool disable;

  ///回退重路由
  Route route;

  ///PDF路径
  String pathPDF;

  final VoidCallback onEdit;

  DocSignatureDetailPage(
      {this.pathPDF = '',
      this.route,
      this.title = '账单详情',
      this.doc,
      this.disable = false,
      this.onEdit});

  @override
  _DocSignatureDetailPageState createState() =>
      new _DocSignatureDetailPageState();
}

class _DocSignatureDetailPageState extends State<DocSignatureDetailPage> {
  DocSignatureModel doc;
  List<SealModel> sealList;
  bool _showPdf = true;
  double bottomHeight = 50.0;

  UserModel user = UserBLoC.instance.currentUser;

  @override
  void initState() {
    super.initState();
    if (widget.doc != null) {
      this.doc = widget.doc;
    }
    // if (!needToSign()) {
    //   bottomHeight = 0;
    // }
    //安卓横屏
    if (defaultTargetPlatform == TargetPlatform.android) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft, //全屏时旋转方向，左边
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          height: 500,
          child: _showPdf
              ? PDFReader(
                  appBar: AppBar(
                    title: Text("${widget.title}"),
                    centerTitle: true,
                  ),
                  path: widget.pathPDF,
                  bottomHeight: bottomHeight,
                )
              : Center(
                  child: CircularProgressIndicator(),
                ),
        ),
        bottomSheet: _buildBottomSheet(),
      ),
    );
  }

  ///页面回退回调
  Future<bool> onPop() async {
    if (widget.route != null) {
      Navigator.pushReplacement(context, widget.route);
      return false;
    }
    return true;
  }

  Widget _buildBottomSheet() {
    return Container(
      height: bottomHeight,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildIconBtn(
              icon: Icon(Icons.open_in_browser, color: Colors.blueAccent),
              label: '其他应用打开',
              onPressed: () {
                OpenFile.open(widget.pathPDF);
              }),
          _buildIconBtn(
              show: canEdit(),
              onPressed: () {
                Navigator.of(context).pop();
                widget?.onEdit?.call();
              },
              icon: Icon(B2BIcons.edit, color: Colors.blueAccent),
              label: '修改'),
          _buildIconBtn(
              show: needToSign(),
              onPressed: _onSign,
              icon: Icon(B2BIcons.seal, color: Colors.blueAccent),
              label: '签署')
        ],
      ),
    );
  }

  Widget _buildIconBtn(
      {void Function() onPressed,
      Widget icon,
      String label,
      bool show = true}) {
    if (!show) {
      return Container();
    }

    return InkWell(
      onTap: onPressed,
      child: Container(
        height: bottomHeight,
        child: Column(
          children: [
            icon,
            Text(label, style: TextStyle(color: Colors.blueAccent))
          ],
        ),
      ),
    );
  }

  void _onSign() async {
    setState(() {
      _showPdf = false;
    });
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    SealModel seal = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ContractSealPage(
              isSelect: true,
            )));

    if (seal == null) {
      BotToast.showText(text: '请选择有效印章');
      setState(() {
        _showPdf = true;
      });
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft, //全屏时旋转方向，左边
      ]);
      throw Exception('印章为空');
    }

    bool result = await DocSignatureHelper.sign(
        context: context, sealCode: seal.code, docCode: doc.code);

    setState(() {
      _showPdf = true;
    });

    if (result) {
      Navigator.of(context).pop(true);
    }
  }

  ///判断知否需要去签署
  bool needToSign() {
    if (widget.disable) {
      return false;
    }

    if (widget.doc == null) {
      return false;
    }

    //甲方
    if (widget.doc.state == DocSignatureState.WAIT_PARTYA_SIGN) {
      return widget.doc.partyA.uid == UserBLoC.instance.currentUser.companyCode;
    } else if (widget.doc.state == DocSignatureState.WAIT_PARTYB_SIGN) {
      return widget.doc.partyB.uid == UserBLoC.instance.currentUser.companyCode;
    } else {
      return false;
    }
  }

  ///判断是否能修改
  bool canEdit() {
    if (widget.onEdit == null) {
      return false;
    }
    //没签署可以修改
    if (doc.state == DocSignatureState.WAIT_PARTYA_SIGN) {
      return user.companyCode != doc.partyA.uid;
    } else if (doc.state == DocSignatureState.WAIT_PARTYB_SIGN) {
      return user.companyCode != doc.partyB.uid;
    } else if (doc.state == DocSignatureState.WAIT_SIGN) {
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }
}
