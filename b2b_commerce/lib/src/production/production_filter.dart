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
      appBar: AppBar(
        title: Text('筛选条件'),
        centerTitle: true,
        elevation: 0.5,
        actions: <Widget>[
          GestureDetector(
              child: Container(
                padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                child: Center(
                  child: Text(
                    '确定',
                    style: TextStyle(
                        color: Colors.black),
                  ),
                ),
              ),
              onTap: () async {
                widget.bloc.setOrderType(widget._orderType);
                widget.bloc.setCurrentStatus(widget._currentStatus);
                widget.bloc.setStartDate(widget._startDate);
                widget.bloc.setEndDate(widget._endDate);
                widget.bloc.clear();
                widget.bloc.getData();
                Navigator.pop(context);
              }
          ),
        ],
      ),
      body: Container(
        color: Color.fromRGBO(245, 245, 245, 1),
        child: ListView(
          children: <Widget>[
            _buildConditionArea('订单类型', widget._orderType, 3),
            _buildConditionArea('目前节点', widget._currentStatus, 4),
            _buildDateArea()
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
          Row(
            children: <Widget>[
              Text(
                label,
                style: TextStyle(
                    color: Color.fromRGBO(150, 150, 150, 1), fontSize: 18),
              )
            ],
          ),
          GridView.count(
            primary: false,
            shrinkWrap: true,
            crossAxisCount: rowNum,
            // padding: const EdgeInsets.all(5),
            mainAxisSpacing: 0,
            crossAxisSpacing: 0,
            children: conditions
                .map(
                  (entry) => FilterChip(
                        label: Text('${entry.label}',
                            style: TextStyle(
                              fontSize: 18,
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
            children: <Widget>[
              Text(
                '交货日期',
                style: TextStyle(
                    color: Color.fromRGBO(150, 150, 150, 1), fontSize: 18),
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
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(245, 245, 245, 1),
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      children: <Widget>[
                        Text(widget._startDate == null
                            ? '选择起始日期'
                            : '${DateFormatUtil.formatYMD(widget._startDate)}'),
                        Icon(Icons.date_range)
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 50,
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
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(245, 245, 245, 1),
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      children: <Widget>[
                        Text(widget._endDate == null
                            ? '选择结束日期'
                            : '${DateFormatUtil.formatYMD(widget._endDate)}'),
                        Icon(Icons.date_range)
                      ],
                    ),
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
