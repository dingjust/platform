import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class PublishRequirementSuccessDialog extends StatefulWidget {
  final RequirementOrderModel model;

  const PublishRequirementSuccessDialog({Key key, this.model})
      : super(key: key);

  _PublishRequirementSuccessDialogState createState() =>
      _PublishRequirementSuccessDialogState();
}

class _PublishRequirementSuccessDialogState
    extends State<PublishRequirementSuccessDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FactoryTabSectionState>(
      create: (context) => FactoryTabSectionState(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.5,
          title: Text('发布成功'),
          centerTitle: true,
        ),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(child: _buildTitle()),
          ],
        ),
        bottomNavigationBar: Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          height: 50,
          child: RaisedButton(
              color: Color.fromRGBO(255, 214, 12, 1),
              child: Text(
                '完成',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              onPressed: () async {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/', (route) => false);
              }),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Row(
      children: <Widget>[
        Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              // color: Colors.white,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 50, 20),
                      child: Icon(
                        B2BIcons.publish_requirement_success,
                        size: 100,
                        color: Color.fromRGBO(255, 214, 12, 1),
                      ),
                    ),
                    Text(
                      '您的需求已发送平台进行审核',
                      style: TextStyle(
                          fontSize: 20, color: Color.fromRGBO(255, 214, 12, 1)),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        '预计在30分钟内完成',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                    _buildRow('需求审核：'),
                    _buildRow('● 需求内容是否清晰；'),
                    _buildRow('● 是否有合适您的工厂或客户进行推荐；'),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: _buildRow('审核期间，可能会有平台客服拨打您的电话或添加您的微信申请。敬请留意!'),
                    )
                  ],
                ),
              ),
            ))
      ],
    );
  }

  Widget _buildRow(String val) {
    return Row(
      children: [
        Expanded(
          child: Text('$val'),
        )
      ],
    );
  }
}
