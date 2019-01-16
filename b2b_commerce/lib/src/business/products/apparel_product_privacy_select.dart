import 'package:flutter/material.dart';

class ApparelProductPrivacySelectPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('款式保护'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.done),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: ApparelProductPrivacySelect(),
    );
  }
}

class ApparelProductPrivacySelect extends StatefulWidget {
  ApparelProductPrivacySelect({this.privacy = false});

  final bool privacy;

  ApparelProductPrivacySelectState createState() =>
      ApparelProductPrivacySelectState();
}

class ApparelProductPrivacySelectState
    extends State<ApparelProductPrivacySelect> {
  bool _privacy;
  bool _isShowA;
  bool _isShowB;
  bool _isShowC;

  @override
  void initState() {
    _privacy = widget.privacy;
    print(_isShowB);
      _isShowA = false;
      _isShowB = false;
      _isShowC = false;

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('是否隐私款'),
            contentPadding: EdgeInsets.symmetric(horizontal: 0),
            trailing: Switch(
              value: _privacy,
              activeColor: Colors.pink,
              onChanged: (bool val) {
                setState(() {
                  _privacy = val;
                });
              },
            ),
          ),
          Offstage(
            offstage: _privacy ? false : true,
            child: Column(
              children: <Widget>[
                CheckboxListTile(
                  title: Text('A级会员可见'),
                  value: _isShowA,
                  onChanged: (T) {
                    setState(() {
                      _isShowA = !_isShowA;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('B级会员可见'),
                  value: _isShowB,
                  onChanged: (T) {
                    setState(() {
                      _isShowB = !_isShowB;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('C级会员可见'),
                  value: _isShowC,
                  onChanged: (T) {
                    setState(() {
                      _isShowC = !_isShowC;
                    });
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
