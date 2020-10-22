import 'package:b2b_commerce/src/business/orders/fabric/fabric_requirement_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';

class FabricRequirementPage extends StatefulWidget {
  _FabricRequirementPage createState() => _FabricRequirementPage();
}

class _FabricRequirementPage extends State<FabricRequirementPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FabricRequirementState>(
      create: (context) => FabricRequirementState(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('面料需求'),
          centerTitle: true,
          elevation: 0.5,
        ),
        body: Container(
          child: FabricRequirementListPage(),
        ),
      ),
    );
  }
}
