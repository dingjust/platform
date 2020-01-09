import 'package:flutter/material.dart';
import 'package:models/models.dart';

///筛选条件选择器
class FilterConditionSelector extends StatefulWidget {
  final Function(FilterConditionEntry) callBack;

  final List<FilterConditionEntry> entries;

  const FilterConditionSelector({Key key, this.callBack, this.entries})
      : super(key: key);

  @override
  _FilterConditionSelectorState createState() =>
      _FilterConditionSelectorState();
}

class _FilterConditionSelectorState extends State<FilterConditionSelector> {
  FilterConditionEntry selectEntry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: widget.entries.length,
        // item 的个数
        separatorBuilder: (BuildContext context, int index) =>
            Divider(height: 1.0),
        // 添加分割线
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectEntry = widget.entries[index];
              });
              widget.callBack(widget.entries[index]);
            },
            child: Container(
              height: 40,
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Text(
                      '${widget.entries[index].label}',
                      style: TextStyle(
                        color: selectEntry == widget.entries[index]
                            ? Colors.orange
                            : Colors.black,
                      ),
                    ),
                  ),
                  selectEntry == widget.entries[index]
                      ? Icon(
                          Icons.check,
                          color: Colors.orange,
                          size: 16,
                        )
                      : SizedBox(),
                  SizedBox(
                    width: 16,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
