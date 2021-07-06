import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';

import 'form/materiel_product_form.dart';
import 'materiel_product_grid.dart';

///面辅料管理
class MaterielProductManagePage extends StatefulWidget {
  @override
  _MaterielProductManagePageState createState() =>
      _MaterielProductManagePageState();
}

class _MaterielProductManagePageState extends State<MaterielProductManagePage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MaterielProductState>(
      create: (context) => MaterielProductState(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.5,
          centerTitle: true,
          title: Text('面辅料管理'),
        ),
        floatingActionButton: _AddButton(),
        body: Container(
          child: MaterielProductGrid(),
        ),
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context)
            .push(
                MaterialPageRoute(builder: (context) => MaterielProductForm()))
            .then((value) {
          if (value) {
            Provider.of<MaterielProductState>(context, listen: false).clear();
          }
        });
      },
      child: Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }
}
