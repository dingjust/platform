import 'package:b2b_commerce/src/home/requirement/fast_publish_requirement.dart';
import 'package:b2b_commerce/src/home/requirement/requirement_num_pick.dart';
import 'package:flutter/material.dart';

class RequirementDatePick extends StatefulWidget {
  FastRequirementForm fastRequirementForm;

  final DateTime nowTime;

  RequirementDatePick({Key key, this.fastRequirementForm, this.nowTime})
      : super(key: key);

  _RequirementDatePickState createState() => _RequirementDatePickState();
}

class _RequirementDatePickState extends State<RequirementDatePick> {
  @override
  void initState() {
    // TODO: implement initState
    widget.fastRequirementForm.deliveryDate = widget.nowTime;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // int firstDateYear = widget.fastRequirementForm.deliveryDate.year;
    // int firstDateMonth = widget.fastRequirementForm.deliveryDate.month;
    // int firstDateDay = widget.fastRequirementForm.deliveryDate.day;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('交货时间'),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => RequirementNumPick(
                        fastRequirementForm: widget.fastRequirementForm,
                      )));
            },
            child: Text(
              '下一步',
              style: TextStyle(color: Colors.black),
            ),
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            color: Color.fromRGBO(245, 244, 243, 1),
            child: Row(
              children: <Widget>[
                Text(
                  widget.fastRequirementForm.categories == null ? '':
                  '已填选结果: ${widget.fastRequirementForm.categories[0].name}',
                  style: TextStyle(
                      color: Color.fromRGBO(100, 100, 100, 1), fontSize: 18),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: MonthPicker(
              onChanged: (DateTime date) {
                setState(() {
                  widget.fastRequirementForm.deliveryDate = date;
                });
              },
              firstDate: DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day),
              lastDate: DateTime(2099),
              selectedDate: widget.fastRequirementForm.deliveryDate,
            ),
          )
        ],
      ),
    );
  }
}
