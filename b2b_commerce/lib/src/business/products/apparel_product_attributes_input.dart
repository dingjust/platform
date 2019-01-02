import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

class ApparelProductAttributesInputPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('属性'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.done,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: ApparelProductAttributesInput(),
    );
  }
}

class ApparelProductAttributesInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(children: <Widget>[
      InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EnumSelectPage(
                '选择风格',
                <EnumModel>[
                  EnumModel('R001', '针织'),
                  EnumModel('R002', '其他'),
                ],
              ),
            ),
          );
        },
        child: ListTile(
          title: Text('风格'),
          trailing: Icon(Icons.chevron_right),
        ),
      ),
      InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EnumSelectPage(
                '选择面料',
                <EnumModel>[
                  EnumModel('R001', '针织'),
                  EnumModel('R002', '其他'),
                ],
              ),
            ),
          );
        },
        child: ListTile(
          title: Text('面料'),
          trailing: Icon(Icons.chevron_right),
        ),
      ),
      InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EnumSelectPage(
                '选择版型',
                <EnumModel>[
                  EnumModel('R001', '针织'),
                  EnumModel('R002', '其他'),
                ],
              ),
            ),
          );
        },
        child: ListTile(
          title: Text('版型'),
          trailing: Icon(Icons.chevron_right),
        ),
      ),
      InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EnumSelectPage(
                '选择袖型',
                <EnumModel>[
                  EnumModel('R001', '针织'),
                  EnumModel('R002', '其他'),
                ],
              ),
            ),
          );
        },
        child: ListTile(
          title: Text('袖型'),
          trailing: Icon(Icons.chevron_right),
        ),
      ),
      InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EnumSelectPage(
                '选择袖长/裤长',
                <EnumModel>[
                  EnumModel('R001', '针织'),
                  EnumModel('R002', '其他'),
                ],
              ),
            ),
          );
        },
        child: ListTile(
          title: Text('袖长/裤长'),
          trailing: Icon(Icons.chevron_right),
        ),
      ),
      InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EnumSelectPage(
                '选择图案',
                <EnumModel>[
                  EnumModel('R001', '针织'),
                  EnumModel('R002', '其他'),
                ],
              ),
            ),
          );
        },
        child: ListTile(
          title: Text('图案'),
          trailing: Icon(Icons.chevron_right),
        ),
      ),
      InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EnumSelectPage(
                '选择流行元素',
                <EnumModel>[
                  EnumModel('R001', '针织'),
                  EnumModel('R002', '其他'),
                ],
              ),
            ),
          );
        },
        child: ListTile(
          title: Text('流行元素'),
          trailing: Icon(Icons.chevron_right),
        ),
      ),
      InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EnumSelectPage(
                '选择填充物',
                <EnumModel>[
                  EnumModel('R001', '针织'),
                  EnumModel('R002', '其他'),
                ],
              ),
            ),
          );
        },
        child: ListTile(
          title: Text('填充物'),
          trailing: Icon(Icons.chevron_right),
        ),
      ),
      InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EnumSelectPage(
                '选择厚薄',
                <EnumModel>[
                  EnumModel('R001', '针织'),
                  EnumModel('R002', '其他'),
                ],
              ),
            ),
          );
        },
        child: ListTile(
          title: Text('厚薄'),
          trailing: Icon(Icons.chevron_right),
        ),
      ),
      InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EnumSelectPage(
                '选择季节',
                <EnumModel>[
                  EnumModel('R001', '针织'),
                  EnumModel('R002', '其他'),
                ],
              ),
            ),
          );
        },
        child: ListTile(
          title: Text('季节'),
          trailing: Icon(Icons.chevron_right),
        ),
      ),
      InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EnumSelectPage(
                '选择吊牌',
                <EnumModel>[
                  EnumModel('R001', '针织'),
                  EnumModel('R002', '其他'),
                ],
              ),
            ),
          );
        },
        child: ListTile(
          title: Text('吊牌'),
          trailing: Icon(Icons.chevron_right),
        ),
      ),
      InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EnumSelectPage(
                '选择门襟',
                <EnumModel>[
                  EnumModel('R001', '针织'),
                  EnumModel('R002', '其他'),
                ],
              ),
            ),
          );
        },
        child: ListTile(
          title: Text('门襟'),
          trailing: Icon(Icons.chevron_right),
        ),
      ),
    ]);
  }
}
