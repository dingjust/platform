import 'package:flutter/material.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';

class DateRangeSelector extends StatefulWidget {
  final Function(DateTime star, DateTime end) callBack;

  const DateRangeSelector({Key key, this.callBack}) : super(key: key);

  @override
  _DateRangeSelectorState createState() => _DateRangeSelectorState();
}

class _DateRangeSelectorState extends State<DateRangeSelector> {
  DateTime _firstDate;
  DateTime _lastDate;
  DatePeriod _selectedPeriod;

  @override
  void initState() {
    super.initState();
    _firstDate = DateTime.now().subtract(Duration(days: 45));
    _lastDate = DateTime.now().add(Duration(days: 45));

    DateTime selectedPeriodStart = DateTime.now().subtract(Duration(days: 4));
    DateTime selectedPeriodEnd = DateTime.now().add(Duration(days: 8));
    _selectedPeriod = DatePeriod(selectedPeriodStart, selectedPeriodEnd);
  }

  @override
  Widget build(BuildContext context) {
    // DatePickerRangeStyles styles = DatePickerRangeStyles(
    //   selectedPeriodLastDecoration: BoxDecoration(
    //       color: selectedPeriodLastColor,
    //       borderRadius: BorderRadius.only(
    //           topRight: Radius.circular(10.0),
    //           bottomRight: Radius.circular(10.0))),
    //   selectedPeriodStartDecoration: BoxDecoration(
    //     color: selectedPeriodStartColor,
    //     borderRadius: BorderRadius.only(
    //         topLeft: Radius.circular(10.0), bottomLeft: Radius.circular(10.0)),
    //   ),
    //   selectedPeriodMiddleDecoration: BoxDecoration(
    //       color: selectedPeriodMiddleColor, shape: BoxShape.rectangle),
    // );

    return Column(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: RangePicker(
            selectedPeriod: _selectedPeriod,
            onChanged: _onSelectedDateChanged,
            firstDate: _firstDate,
            lastDate: _lastDate,
            // datePickerStyles: styles,
            // eventDecorationBuilder: _eventDecorationBuilder,
          ),
        ),
        Container(
          decoration: BoxDecoration(
              border:
                  Border(top: BorderSide(width: 0.5, color: Colors.grey[300]))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              FlatButton(
                  onPressed: () {
                    widget.callBack(null, null);
                  },
                  child: Text(
                    '重置',
                    style: TextStyle(color: Colors.grey),
                  )),
              FlatButton(
                  onPressed: () {
                    widget.callBack(_selectedPeriod.start, _selectedPeriod.end);
                  },
                  child: Text(
                    '确定',
                  )),
            ],
          ),
        )
      ],
    );
  }

  void _onSelectedDateChanged(DatePeriod newPeriod) {
    setState(() {
      _selectedPeriod = newPeriod;
    });
    // widget.callBack(_selectedPeriod.start, _selectedPeriod.end);
  }
}
