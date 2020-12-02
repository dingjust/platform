import 'dart:async';

import 'package:b2b_commerce/src/_shared/widgets/contract_seal_page.dart';
import 'package:b2b_commerce/src/helper/doc_signature_helper.dart';
import 'package:b2b_commerce/src/my/contract/pdf_reader.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

///签署文档详情页
class DocSignatureDetailPage extends StatefulWidget {
  final DocSignatureModel doc;

  final String title;

  final bool disable;

  ///回退重路由
  Route route;

  ///PDF路径
  String pathPDF;

  DocSignatureDetailPage(
      {this.pathPDF = '',
      this.route,
      this.title = '账单详情',
      this.doc,
      this.disable = false});

  @override
  _DocSignatureDetailPageState createState() =>
      new _DocSignatureDetailPageState();
}

class _DocSignatureDetailPageState extends State<DocSignatureDetailPage> {
  DocSignatureModel doc;
  List<SealModel> sealList;
  bool _showPdf = true;
  double bottomHeight = 50.0;

  @override
  void initState() {
    super.initState();
    if (widget.doc != null) {
      this.doc = widget.doc;
    }
    if (!needToSign()) {
      bottomHeight = 0;
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
    return needToSign()
        ? Container(
            height: bottomHeight,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                        onPressed: () {
                          _onSign();
                        },
                        child: Text('去签署')))
              ],
            ),
    )
        : Container(
      height: bottomHeight,
    );
  }

  void _onSign() async {
    setState(() {
      _showPdf = false;
    });

    SealModel seal = await Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => ContractSealSelectPage()));

    if (seal == null) {
      BotToast.showText(text: '请选择有效印章');
      setState(() {
        _showPdf = true;
      });
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
}
