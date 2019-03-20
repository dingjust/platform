import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

import '../common/app_enums.dart';
import '../common/app_routes.dart';
import 'members/membership_form.dart';
import 'search/membership_search.dart';

class MembershipsPage extends StatelessWidget {
  final List<MembershipModel> items = <MembershipModel>[
    MembershipModel.fromJson({
      'customer': {
        'profilePicture': 'http://jspang.com/static/myimg/blogtouxiang.jpg',
        'uid': 'c00000001',
        'name': '小勇',
        'mobileNumber': '13198765432'
      },
      'level': 'A'
    }),
    MembershipModel.fromJson({
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
    List<MembershipItem> _items = items.map((item) {
      return MembershipItem(item);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        centerTitle: true,
        title: Text('会员管理'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              B2BIcons.search,
              size: 20,
            ),
            onPressed: () => showSearch(
                context: context, delegate: MembershipSearchDelegate()),
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[200],
        child: Column(
          children: <Widget>[
            Menu('', <MenuItem>[
              MenuItem(
                Icon(Icons.phone),
                '会员审核',
                AppRoutes.ROUTE_MEMBER_REQUESTS,
              )
            ]),
            SizedBox(
              height: 5,
            ),
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MembershipForm(null)),
          );
        },
      ),
    );
  }
}

class MembershipItem extends StatelessWidget {
  MembershipItem(this.item);

  final MembershipModel item;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: Card(
        margin: EdgeInsets.all(0),
        child: ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MembershipForm(item)),
            );
          },
          leading: CircleAvatar(
//            backgroundImage: NetworkImage(
//              item.customer.profilePicture,
//            ),
            radius: 30.0,
          ),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('${item.customer.name} ${item.customer.mobileNumber}'),
              Text(
                '会员等级：' + AppEnums.MemberRatings[item.level].name,
              )
            ],
          ),
          trailing: Icon(Icons.more_horiz),
        ),
      ),
    );
  }
}
