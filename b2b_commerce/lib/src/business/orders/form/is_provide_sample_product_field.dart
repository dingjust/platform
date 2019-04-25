import 'package:flutter/material.dart';
import 'package:models/models.dart';

class IsProvideSampleProductField extends StatefulWidget {
  final RequirementOrderModel item;

  IsProvideSampleProductField(this.item);

  IsProvideSampleProductFieldState createState() => IsProvideSampleProductFieldState();
}

class IsProvideSampleProductFieldState extends State<IsProvideSampleProductField> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Container(
          child: ListTile(
            leading: Text(
              '是否提供样衣',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            trailing: Text(
              widget.item.details?.samplesNeeded == null ? '选取' : widget.item.details.samplesNeeded ? '提供样衣':'不提供样衣',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey),
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
                    children: <Widget>[
                      ListTile(
                        title: Text('提供样衣'),
                        onTap: () async {
                          setState(() {
                            widget.item.details.samplesNeeded = true;
                          });
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: Text('不提供样衣'),
                        onTap: () async {
                          setState(() {
                            widget.item.details.samplesNeeded = false;
                          });
                          Navigator.pop(context);
                        },
                      )
                    ],
                  ));
            },
          );
        });
  }
}
