import 'package:b2b_commerce/src/business/members/membership_form.dart';
import 'package:b2b_commerce/src/common/app_enums.dart';
import 'package:b2b_commerce/src/common/app_image.dart';
import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

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
        centerTitle: true,
        title: Text('会员管理'),
        actions: <Widget>[
          IconButton(
            // action button
            icon: Icon(Icons.person_add),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[200],
        child: Column(
          children: <Widget>[
            Menu('', <MenuItem>[
              MenuItem(
                Icons.phone,
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
              MaterialPageRoute(builder: (context) => MembershipForm()),
            );
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
              Text('${item.customer.name} ${item.customer.mobileNumber}'),
              Text(
                '会员等级：' + AppEnums.MemberRatings[item.level],
              )
            ],
          ),
          trailing: Icon(Icons.more_horiz),
        ),
      ),
    );
  }
}
