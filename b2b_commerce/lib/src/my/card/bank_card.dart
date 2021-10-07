import 'package:b2b_commerce/src/_shared/widgets/app_bar_factory.dart';
import 'package:b2b_commerce/src/common/app_image.dart';
import 'package:b2b_commerce/src/helper/dialog_helper.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';

import 'bank_card_form.dart';
import 'bank_card_item.dart';

///银行卡
class BankCardPage extends StatefulWidget {
  ///选择模式
  final bool selectMode;

  const BankCardPage({Key key, this.selectMode = false}) : super(key: key);

  @override
  _BankCardPageState createState() => _BankCardPageState();
}

class _BankCardPageState extends State<BankCardPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BankCardState>(
      create: (context) => BankCardState(),
      child: Scaffold(
        appBar: AppBarFactory.buildDefaultAppBar('银行卡'),
        body: BankCardListPage(
          selectMode: widget.selectMode,
        ),
        floatingActionButton: _AddButton(),
      ),
    );
  }
}

class BankCardListPage extends StatelessWidget {
  ///选择模式
  final bool selectMode;

  const BankCardListPage({Key key, this.selectMode = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<BankCardState>(
      builder: (context, BankCardState state, _) => Container(
        child: state.cards != null
            ? BankCardListView(
                selectMode: selectMode,
                state: state,
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}

class BankCardListView extends StatelessWidget {
  final BankCardState state;

  ///选择模式
  final bool selectMode;

  BankCardListView({Key key, this.state, this.selectMode = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RefreshIndicator(
        child: ListView(children: [
          state.cards.isNotEmpty
              ? Column(
                  children: state.cards
                      .map((model) => BankCardItem(
                            model: model,
                            onTap:
                                selectMode ? () => onTap(context, model) : null,
                            onLongPress: () => onLongPress(model.id),
                          ))
                      .toList(),
                )
              : _NoDataInfoRow(),
        ]),
        onRefresh: () async {
          state.clear();
        },
      ),
    );
  }

  void onTap(BuildContext context, BankCardModel model) {
    Navigator.of(context).pop(model);
  }

  void onLongPress(int id) {
    DialogHelper.showConfirm(
        content: '是否确认删除银行卡?',
        confirm: () {
          onDel(id);
        });
  }

  void onDel(int id) async {
    Function cancelFunc =
        BotToast.showLoading(clickClose: false, crossPage: false);
    BaseResponse response = await BankCardRepository.del(id);
    cancelFunc.call();
    if (response != null) {
      if (response.code == 1) {
        BotToast.showText(
            text: '删除成功', align: Alignment.center, crossPage: true);
        state.clear();
      } else {
        BotToast.showText(text: '${response.msg}', align: Alignment.center);
      }
    } else {
      BotToast.showText(text: '未知错误', align: Alignment.center);
    }
  }
}

class _NoDataInfoRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.lightbulb_outline,
            color: Colors.orange,
          ),
          Text('暂无银行卡')
        ],
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        onPressed: () {
          ///添加银行卡
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => BankCardForm()))
              .then((value) {
            //是否需要刷新
            if (value ?? false) {
              Provider.of<BankCardState>(context, listen: false).clear();
            }
          });
        },
        child: B2BV2Image.fab());
  }
}
