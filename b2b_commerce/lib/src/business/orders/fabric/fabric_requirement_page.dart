import 'package:b2b_commerce/src/business/orders/fabric/fabric_requirement_list_page.dart';
import 'package:b2b_commerce/src/home/account/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:services/services.dart';
import 'package:core/core.dart';

class FabricRequirementPage extends StatefulWidget {
  _FabricRequirementPage createState() => _FabricRequirementPage();
}
  
class _FabricRequirementPage extends State<FabricRequirementPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => checkLoginStatus());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('面料需求'),
        centerTitle: true,
        elevation: 0.5,
      ),
      body: Container(
        child: FabricRequirementListPage(),
      ),
    );
  }

    ///检测用户登录状态
  void checkLoginStatus() {
    if (UserBLoC.instance.currentUser.status == UserStatus.OFFLINE) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => B2BLoginPage()),
          ModalRoute.withName('/'));
    }
  }
}