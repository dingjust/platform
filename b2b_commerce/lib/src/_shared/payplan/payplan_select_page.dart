import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class PayPlanSelectPage extends StatefulWidget {
  final CompanyPayPlanModel selectedModel;

  const PayPlanSelectPage({Key key, this.selectedModel}) : super(key: key);

  @override
  _PayPlanSelectPageState createState() => _PayPlanSelectPageState();
}

class _PayPlanSelectPageState extends State<PayPlanSelectPage> {
  CompanyPayPlanModel selectedModel;

  @override
  void initState() {
    super.initState();
    if (widget.selectedModel != null) {
      selectedModel = widget.selectedModel;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('账务方案'),
        elevation: 0.5,
        brightness: Brightness.light,
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            child: Text('确定'),
            onPressed: () {
              Navigator.of(context).pop(selectedModel);
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: PayPlanRepositoryImpl().all(),
        builder: (BuildContext context,
            AsyncSnapshot<CompanyPayPlanResponse> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            return _buildBody(snapshot.data.content);
          }
        },
      ),
    );
  }

  Widget _buildBody(List<CompanyPayPlanModel> plans) {
    return Container(
        child: Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '财务方案尚不支持手机端创建，请前往钉单平台设置',
                style: TextStyle(color: Colors.red),
              )
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: ListView(
              children: plans
                  .map((plan) => PayPlanItem(
                        model: plan,
                        selectModel: selectedModel,
                        onChanged: _handleModelChanged,
                      ))
                  .toList()),
        )
      ],
    ));
  }

  void _handleModelChanged(CompanyPayPlanModel model) {
    setState(() {
      selectedModel = model;
    });
  }
}

class PayPlanItem extends StatefulWidget {
  final CompanyPayPlanModel model;

  final CompanyPayPlanModel selectModel;

  final ValueChanged<CompanyPayPlanModel> onChanged;

  const PayPlanItem({Key key, this.model, this.onChanged, this.selectModel})
      : super(key: key);

  @override
  _PayPlanItemState createState() => _PayPlanItemState();
}

class _PayPlanItemState extends State<PayPlanItem> {
  bool showDetail = false;
  String depositStr = '';
  String phaseOneStr = '';
  String phaseTwoStr = '';
  String monthlySettlementStr = '';

  void _handleTap() {
    var selectModel = widget.selectModel;
    if (selectModel == null || selectModel.id != widget.model.id) {
      widget.onChanged(widget.model);
    } else {
      widget.onChanged(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: _handleTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelect()
              ? [BoxShadow(color: Constants.THEME_COLOR_MAIN, blurRadius: 12)]
              : [],
        ),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Text('${widget.model.name}',
                      textAlign: TextAlign.start,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '${getSubTitle()}',
                  style: TextStyle(color: Colors.grey),
                ),
                FlatButton(
                  child: Row(
                    children: <Widget>[
                      Text(
                        '${showDetail ? '收起' : '展开'}',
                        style: TextStyle(color: Colors.grey),
                      ),
                      Icon(
                        showDetail ? B2BIcons.arrowClose : B2BIcons.arrowOpen,
                        color: Colors.grey,
                      )
                    ],
                  ),
                  onPressed: () {
                    setState(() {
                      showDetail = !showDetail;
                    });
                  },
                )
              ],
            ),
            showDetail
                ? Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Text(
                    '${widget.model.previewText}',
                    overflow: TextOverflow.visible,
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              ],
            )
                : Container()
          ],
        ),
      ),
    );
  }

  String getSubTitle() {
    return '${widget.model.isHaveDeposit ? '有' : '无'}定金+${PayPlanTypeLocalizedMap[widget.model.payPlanType]}';
  }

  bool isSelect() {
    if (widget.selectModel == null) {
      return false;
    } else {
      return widget.selectModel.id == widget.model.id;
    }
  }
}
