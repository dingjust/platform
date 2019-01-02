import 'package:flutter/material.dart';

class ApparelProductPrivacySelectPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('隐私保护'),
      ),
      body: ApparelProductPrivacySelect(),
    );
  }
}

class ApparelProductPrivacySelect extends StatelessWidget {
  ApparelProductPrivacySelect({this.privacy = false});

  final bool privacy;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('是否免邮'),
            contentPadding: EdgeInsets.symmetric(horizontal: 0),
            trailing: Switch(
              value: privacy,
              activeColor: Colors.pink,
              onChanged: (bool val) {
                /* setState(() {
                      privacy = val;
                    });*/
              },
            ),
          ),
          CheckboxListTile(
            title: Text('A级会员可见'),
            value: true,
            onChanged: (T) {},
          ),
          CheckboxListTile(
            title: Text('B级会员可见'),
            value: true,
            onChanged: (T) {},
          ),
          CheckboxListTile(
            title: Text('C级会员可见'),
            value: true,
            onChanged: (T) {},
          )
        ],
      ),
    );
  }
}
