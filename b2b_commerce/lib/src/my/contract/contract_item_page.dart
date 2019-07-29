
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

class ContractItemPage extends StatefulWidget {
  ContractModel model;

  ContractItemPage({this.model});
  _ContractItemPageState createState() => _ContractItemPageState();
}

class _ContractItemPageState extends State<ContractItemPage>{

  static Map<ContractStatus, Color> _statusColors = {
    ContractStatus.INITIATE: Colors.red,
    ContractStatus.SIGN: Colors.yellow,
    ContractStatus.COMPLETE: Colors.green,
    ContractStatus.INVALID: Colors.grey,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(5,5,5,0),
      padding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
      child: Column(
        children: <Widget>[
          _buildHead(),
          _buildCenter(),
          _buildBottom(),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8)
      ),
    );
  }

  Widget _buildHead(){
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              child: Text(
                '${widget.model.title}',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          Container(
            child: Text(
              '${ContractStatusLocalizedMap[widget.model.state]}',
              textAlign: TextAlign.end,
              style: TextStyle(
                color: _statusColors[widget.model.state],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCenter(){
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              child: Text(
                '合同编号：${widget.model.code}',
                style: TextStyle(
                  color: Colors.black26,
                ),
              ),
            ),
          ),
          Container(
            child:  Text(
              '${DateFormatUtil.formatYMD(widget.model.createtime)}',
              style: TextStyle(
                color: Colors.black26,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottom(){
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            child: Text(
              '${widget.model.belongTo}',
              style: TextStyle(
                color: Colors.black38,
              ),
            ),
          ),
        ],
      ),
    );
  }

}