import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FabricRequirementListItem extends StatefulWidget {
  _FabricRequirementListItem createState() => _FabricRequirementListItem();
}

class _FabricRequirementListItem extends State<FabricRequirementListItem> {
  ///信息内容样式
  static const TextStyle infoTextStyle = TextStyle(fontSize: 13);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: _onTap,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[_buildBody(), _buildFoot()],
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8), color: Colors.white),
        ));
  }

  Widget _buildBody() {
    return Row(
      children: <Widget>[
        SizedBox(
            width: 80.0,
            height: 80.0,
            child: DecoratedBox(decoration: BoxDecoration(color: Colors.red))),
        Expanded(
          child: Container(
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text("黑色女式T恤潮流个性动感高档")),
                  Container(
                    alignment: Alignment.center,
                    child: Text("130米"),
                  )
                ],
              )),
        )
      ],
    );
  }

  Widget _buildFoot() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[Text("发布时间：2018-12-25"), Text("有效期：7天")],
    );
  }

  void _onTap() {
    BotToast.showCustomText(
        onlyOne: true,
        duration: null,
        clickClose: true,
        crossPage: false,
        backgroundColor: Colors.black38,
        toastBuilder: (cancelFunc) => AlertDialog(
              content: Container(
                height: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Text('提示'),
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Text(
                          '面料信息是直接发布在"搜布网"平台上的，后续所有信息将在搜布网上查询',
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
                            child: FlatButton(
                                onPressed: cancelFunc, child: Text('否'))),
                        Expanded(
                            child: FlatButton(
                                onPressed: cancelFunc, child: Text('是')))
                      ],
                    )
                  ],
                ),
              ),
            ));
  }
}
