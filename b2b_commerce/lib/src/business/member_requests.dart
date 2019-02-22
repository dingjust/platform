import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

import 'search/member_request_search.dart';

/// 会员审核
class MemberRequestsPage extends StatelessWidget {
  final List<MemberRequestModel> items = <MemberRequestModel>[
    MemberRequestModel.fromJson({
      'customer': {
        'profilePicture': 'http://jspang.com/static/myimg/blogtouxiang.jpg',
        'uid': 'c00000001',
        'name': '小勇',
        'mobileNumber': '13198765432'
      },
      'level': 'A'
    }),
    MemberRequestModel.fromJson({
      'customer': {
        'profilePicture': 'http://jspang.com/static/myimg/blogtouxiang.jpg',
        'uid': 'c00000001',
        'name': '小勇',
        'mobileNumber': '13198765432'
      },
      'level': 'B'
    })
  ];

  @override
  Widget build(BuildContext context) {
    List<MemberRequestItem> _items = items.map((item) {
      return MemberRequestItem(item);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('会员审核'),
        actions: <Widget>[
          IconButton(
            icon: Icon(B2BIcons.search,size: 20,),
            onPressed: () => showSearch(context: context, delegate: MemberRequestSearchDelegate()),
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[200],
        child: Column(
          children: <Widget>[
            ListView.builder(
              shrinkWrap: true,
              itemCount: _items.length,
              itemBuilder: (context, index) {
                return _items[index];
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: <Widget>[
            Expanded(
              child: RaisedButton(
                textColor: Theme.of(context).primaryColor,
                onPressed: () {},
                child: Text('通过'),
              ),
            ),
            Expanded(
              child: RaisedButton(
                textColor: Theme.of(context).primaryColor,
                onPressed: () {},
                child: Text('不通过'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MemberRequestItem extends StatelessWidget {
  MemberRequestItem(this.item);

  final MemberRequestModel item;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: Card(
        margin: EdgeInsets.all(0),
        child: ListTile(
          onTap: () {
            // TODO: toggle the checkbox
          },
          leading: CircleAvatar(
            backgroundImage: NetworkImage(
              item.customer.profilePicture,
            ),
            radius: 30.0,
          ),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('${item.customer.name}'),
            ],
          ),
          trailing: Checkbox(value: true, onChanged: null),
        ),
      ),
    );
  }
}
