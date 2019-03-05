import 'package:flutter/material.dart';
import 'package:models/models.dart';

class MachiningTypeField extends StatefulWidget {
  final RequirementOrderModel item;

  MachiningTypeField(this.item);

  MachiningTypeFieldState createState() => MachiningTypeFieldState();
}

class MachiningTypeFieldState extends State<MachiningTypeField> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Container(
          child: ListTile(
            leading: Text(
              '加工类型',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Text(
              widget.item.details?.machiningType != null
                  ? widget.item.details.machiningType
                  : '选取',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
        ),
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                  height: 300,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: MachiningType.values.map((machiningType) {
                      return ListTile(
                        title: Text(MachiningTypeLocalizedMap[machiningType]),
                        onTap: () {
                          setState(() {
                            widget.item.details.machiningType = machiningType;
                          });
                          Navigator.pop(context);
                        },
                      );
                    }).toList(),
                  ));
            },
          );
        });
  }
}
