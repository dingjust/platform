import 'package:b2b_commerce/src/my/capacity/capacity_search.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class CapacitySearch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CapacityMatchingState>(
        builder: (context, CapacityMatchingState state, _) => Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    child: Icon(
                      Icons.keyboard_arrow_left,
                      size: 32,
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      showSearch(
                        context: context,
                        delegate: CapacitySearchDelegate(state),
                      );
                    },
                    child: Container(
                      height: 28,
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey[300], width: 0.5),
                      ),
                      child: Row(
                        children: <Widget>[
                          const Icon(B2BIcons.search,
                              color: Colors.grey, size: 18),
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              state.keyword != null
                                  ? '${state.keyword}'
                                  : '找空闲产能',
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 16),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ));
  }
}

class CapacityCondition extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CapacityMatchingState>(
      builder: (context, CapacityMatchingState state, _) => Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FlatButton(
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '地区',
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      )),
                  FlatButton(
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '品类',
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      )),
                  FlatButton(
                      onPressed: () => onDateRangeSelect(context, state),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '空闲时间',
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onDateRangeSelect(
      BuildContext context, CapacityMatchingState state) async {
    DateTime firstDate;
    DateTime lastDate;

    if (state.dateStartPoint == null) {
      firstDate = DateTime.now();
      lastDate = firstDate.add(Duration(days: 7));
    } else {
      firstDate = state.dateStartPoint;
      if (state.dateEndPoint == null) {
        lastDate = firstDate.add(Duration(days: 7));
      } else {
        lastDate = state.dateEndPoint;
      }
    }

    final List<DateTime> picked = await DateRagePicker.showDatePicker(
        context: context,
        initialFirstDate: firstDate,
        initialLastDate: lastDate,
        firstDate: DateTime(2019),
        lastDate: DateTime(2099));
    if (picked != null && picked.length == 1) {
      state.setDateStartPoint(picked[0]);
      state.setDateEndPoint(null);
      state.clear();
    }

    if (picked != null && picked.length == 2) {
      state.setDateStartPoint(picked[0]);
      state.setDateEndPoint(picked[1]);
      state.clear();
    }
  }
}
