import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

class ProductionFilterPage extends StatefulWidget {
  ProductionFilterPage({Key key, @required this.bloc}) : super(key: key) {
    //读取bloc中存储的条件数据

    //拷贝一个相同值的list
    _orderType = bloc.orderType.map((entry) {
      return FilterConditionEntry(
          label: entry.label, checked: entry.checked, value: entry.value);
    }).toList();
    _currentStatus = bloc.currentStatus.map((entry) {
      return FilterConditionEntry(
          label: entry.label, checked: entry.checked, value: entry.value);
    }).toList();

    _startDate = bloc.startDate;
    _endDate = bloc.endDate;
  }

  _ProductionFilterPageState createState() => _ProductionFilterPageState();

  List<FilterConditionEntry> _orderType = [];

  List<FilterConditionEntry> _currentStatus = [];

  DateTime _startDate;
  DateTime _endDate;

  ProductionBLoC bloc;
}

class _ProductionFilterPageState extends State<ProductionFilterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color.fromRGBO(245, 245, 245, 1),
        child: ListView(
          children: <Widget>[
            _buildConditionArea('订单类型', widget._orderType, 3),
            _buildConditionArea('目前节点', widget._currentStatus, 3),
            _buildDateArea(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 40,
                  margin: EdgeInsets.only(right: 15),
                  child: Center(
                    child: FlatButton(
                        padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 45),
                        color: Colors.grey,
                        child: const Text(
                          '重置',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                            const BorderRadius.all(Radius.circular(8))),
                        onPressed: () {
                          setState(() {
                            for(int i=0;i< widget._orderType.length;i++){
                              widget._orderType[i].checked = false;
                            }
                            for(int i=0;i< widget._currentStatus.length;i++){
                              widget._currentStatus[i].checked = false;
                            }
                            widget._startDate = null;
                            widget._endDate = null;
                          });
                        }),
                  ),
                ),
                Container(
                    height: 40,
                    margin: EdgeInsets.only(left: 10),
                    child: Center(
                      child: FlatButton(
                          padding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 45),
                          color: Color(0xFFFFD600),
                          child: const Text(
                            '确定',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                              const BorderRadius.all(Radius.circular(8))),
                          onPressed: () {
                            widget.bloc.setOrderType(widget._orderType);
                            widget.bloc.setCurrentStatus(widget._currentStatus);
                            widget.bloc.setStartDate(widget._startDate);
                            widget.bloc.setEndDate(widget._endDate);
                            widget.bloc.clear();
                            widget.bloc.getData();
                            Navigator.pop(context);
                          }),
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildConditionArea(
      String label, List<FilterConditionEntry> conditions, int rowNum) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      margin: EdgeInsets.only(bottom: 10),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 50,
                  height: 1,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.grey[300], width: 0.5))),
                ),
                Text(
                  '$label',
                  style: TextStyle(color: Color.fromRGBO(180, 180, 180, 1)),
                ),
                Container(
                  width: 50,
                  height: 1,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.grey[300], width: 0.5))),
                )
              ],
            ),
          ),
          GridView.count(
            primary: false,
            shrinkWrap: true,
            crossAxisCount: rowNum,
            // padding: const EdgeInsets.all(5),
            mainAxisSpacing: 5.0,
            crossAxisSpacing: 10.0,
            childAspectRatio: 2.0,
            children: conditions
                .map(
                  (entry) => ChoiceChip(
                        label: Text('${entry.label}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black
                            )),
                        selectedColor: Color.fromRGBO(255,214,12, 1),
                        backgroundColor: Colors.white,
                        selected: entry.checked,
                        onSelected: ((value) {
                          setState(() {
                            if (entry.value == 'ALL') {
                              for (int i = 0; i < conditions.length; i++) {
                                if (conditions[i].value != 'ALL') {
                                  conditions[i].checked = false;
                                }
                              }
                            }
                            if (entry.value != 'ALL') {
                              for (int i = 0; i < conditions.length; i++) {
                                if (conditions[i].value == 'ALL') {
                                  conditions[i].checked = false;
                                }
                              }
                            }
                            entry.checked = value;
                          });
                        }),
                      ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDateArea() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      margin: EdgeInsets.only(bottom: 10),
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 50,
                height: 1,
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.grey[300], width: 0.5))),
              ),
              Text(
                '交货日期',
                style: TextStyle(color: Color.fromRGBO(180, 180, 180, 1)),
              ),
              Container(
                width: 50,
                height: 1,
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.grey[300], width: 0.5))),
              )
            ],
          ),
          Container(
            padding: EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    showDatePicker(
                      context: context,
                      initialDate: widget._startDate == null
                          ? DateTime.now()
                          : widget._startDate,
                      firstDate: DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day),
                      lastDate: DateTime(2101),
                    ).then((value) {
                      setState(() {
                        widget._startDate = value;
                      });
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10,5,10,5),
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(20)),
                    child:
                        Text(widget._startDate == null
                            ? '选择起始日期'
                            : '${DateFormatUtil.formatYMD(widget._startDate)}',
                        style: TextStyle(fontSize: 14),),
                  ),
                ),
                Container(
                  width: 10,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                            width: 1,
                            color: Colors.grey[400],
                          ))),
                ),
                GestureDetector(
                  onTap: () {
                    showDatePicker(
                      context: context,
                      initialDate: widget._endDate == null
                          ? DateTime.now()
                          : widget._endDate,
                      firstDate: DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day),
                      lastDate: DateTime(2101),
                    ).then((value) {
                      setState(() {
                        widget._endDate = value;
                      });
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10,5,10,5),
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(20)),
                    child:
                        Text(widget._endDate == null
                            ? '选择结束日期'
                            : '${DateFormatUtil.formatYMD(widget._endDate)}',
                          style: TextStyle(fontSize: 14),),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
