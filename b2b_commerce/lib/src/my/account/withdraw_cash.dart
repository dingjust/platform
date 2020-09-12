import 'package:b2b_commerce/src/home/account/login_page.dart';
import 'package:b2b_commerce/src/my/my_account.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class WithdrawCash extends StatefulWidget {
  CompanyWalletModel wallet;

  BankCardModel bankCardModel;

  WithdrawCash(this.wallet, this.bankCardModel, {Key key}) : super(key: key);

  @override
  _WithdrawCashState createState() => _WithdrawCashState();
}

class _WithdrawCashState extends State<WithdrawCash> {
  ScrollController _scrollController = ScrollController();
  TextEditingController _numController = TextEditingController();
  TextField _numField;

  bool validate = false;

  @override
  void initState() {
    _numField = TextField(
      autofocus: false,
      keyboardType: TextInputType.number,
      controller: _numController,
      onChanged: (value) {
        formValidate();
      },
      decoration: InputDecoration(
        hintText: '输入金额',
        border: InputBorder.none,
      ),
      textAlign: TextAlign.right,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color.fromRGBO(245, 245, 245, 1),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 200,
              pinned: true,
              elevation: 0.5,
              backgroundColor: const Color.fromRGBO(255, 219, 0, 1),
              centerTitle: true,
              title: Text(
                '提现',
                style: TextStyle(
                  color: Color.fromRGBO(36, 38, 41, 1),
                  fontSize: 22,
                ),
              ),
              brightness: Brightness.dark,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[_buildHeader(context)],
                ),
              ),
            ),
            SliverList(
                delegate: SliverChildListDelegate([
                  _buildRow1(),
                  Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Center(
                        child: Text(
                          '提现到帐户',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      )),
                  _buildRow2(),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Center(
                      child: Text(
                        '预计3天后到账',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ),
                  ),
                ])),
          ],
        ),
      ),
      bottomSheet: Container(
        height: 50,
        width: double.infinity,
        child: FlatButton(
          onPressed: validate ? onSubmit : null,
          color: const Color.fromRGBO(255, 219, 0, 1),
          child: Text(
            '确认提交',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildTotal(),
          Text(
            '可取金额',
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildTotal() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 50, 0, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                      child: Text(
                        "￥",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromRGBO(36, 38, 41, 1),
                        ),
                      )),
                  Container(
                      child: Text(
                        "${widget.wallet.canCashOut}",
                        overflow: TextOverflow.visible,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromRGBO(36, 38, 41, 1),
                        ),
                      ))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow1() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Column(
        children: <Widget>[
          InputRow(
            label: '提现金额￥',
            labelWidth: 95,
            field: _numField,
          ),
          InfoRow(
            label: '手续费(自动计算)',
            value: '0.00',
          )
        ],
      ),
    );
  }

  Widget _buildRow2() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Column(
        children: <Widget>[
          InfoRow(
            label: '户名',
            value: '${widget.bankCardModel.accountName}',
          ),
          InfoRow(
            label: '银行卡号',
            value: '${widget.bankCardModel.cardNumber}',
          ),
          InfoRow(
            label: '银行',
            value: '${widget.bankCardModel.bankName}',
          ),
          InfoRow(
            label: '开户网点',
            value: '${widget.bankCardModel.bankOutlet}',
          )
        ],
      ),
    );
  }

  void formValidate() {
    double cashNum = double.parse(_numController.text);
    setState(() {
      validate = _numController.text != '' &&
          cashNum <= widget.wallet.canCashOut &&
          cashNum > 0;
    });
  }

  void onSubmit() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) {
          return CustomizeDialog(
            dialogType: DialogType.CONFIRM_DIALOG,
            contentText2: '确定提现？',
            isNeedConfirmButton: true,
            isNeedCancelButton: true,
            confirmButtonText: '确定',
            cancelButtonText: '取消',
            dialogHeight: 180,
            confirmAction: () async {
              AmountFlowRepository()
                  .cashOut(double.parse(_numController.text))
                  .then((result) {
                if (result) {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => MyAccountPage()),
                      ModalRoute.withName('/'));
                } else {
                  Navigator.of(context).pop();
                }
              });
            },
          );
        });
  }
}

class InfoRow extends StatelessWidget {
  final String label;

  final String value;

  const InfoRow({Key key, this.label, this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: Text(
              label,
              style:
              TextStyle(color: Color.fromRGBO(36, 38, 41, 1), fontSize: 18),
            ),
          ),
          Text(
            '$value',
            style: TextStyle(color: Colors.grey),
          )
        ],
      ),
    );
  }
}
