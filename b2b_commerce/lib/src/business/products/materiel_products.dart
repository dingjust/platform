import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';

import 'materiel_product_grid.dart';

///面辅料
class MaterielProductsPage extends StatefulWidget {
  @override
  _MaterielProductsPageState createState() => _MaterielProductsPageState();
}

class _MaterielProductsPageState extends State<MaterielProductsPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MaterielProductState>(
      create: (context) => MaterielProductState(isAll: true),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.5,
          centerTitle: true,
          title: Text('面辅料'),
        ),
        body: Container(
          child: MaterielProductStaggeredGrid(),
        ),
      ),
    );
  }
}
