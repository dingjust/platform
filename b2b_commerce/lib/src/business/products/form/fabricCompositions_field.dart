import 'dart:async';

import 'package:b2b_commerce/src/common/order_payment.dart';
import 'package:b2b_commerce/src/home/product/order_confirm_form.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:toast/toast.dart';
import 'package:widgets/widgets.dart';

class FabricCompositionsField extends StatefulWidget {
  FabricCompositionsField(this.fabricCompositions, {this.enabled = false});

  final List<String> fabricCompositions;
  final bool enabled;

  @override
  _FabricCompositionsFieldState createState() => _FabricCompositionsFieldState();
}

class _FabricCompositionsFieldState extends State<FabricCompositionsField> {

  List<String> _selectFabric = [];

  @override
  void initState() {
    super.initState();

    if(widget.fabricCompositions != null){
      _selectFabric = List.from(widget.fabricCompositions);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('面料成分'),
        elevation: 0.5,
        centerTitle: true,
        actions: <Widget>[
          widget.enabled
              ? IconButton(
                  icon: Text('确定'),
                  onPressed: () {
                    Navigator.pop(context,_selectFabric);
                  })
              : Container()
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Container(
      padding: EdgeInsets.only(top: 10,left: 10,right: 10),
      color: Colors.white,
      child: GridView.count(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        crossAxisCount: 3,
        childAspectRatio: 2.5,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        padding: EdgeInsets.zero,
        children: List.generate(FabricCompositionEnum.length,
                (index) {
              return Container(
                child: ChoiceChip(
                  padding: EdgeInsets.all(0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: BorderSide(color: _selectFabric.contains(FabricCompositionEnum[index].code)?Colors.white:Colors.grey),
                  ),
                  backgroundColor: Colors.white,
                  avatar: null,
                  selectedColor: Color(0xffffd60c),
//                                      key: ValueKey<String>(snapshot.data[index].name),
                  label: Container(
                    width: 100,
                    child: Center(
                      child: Text(
                        FabricCompositionEnum[index].name,
                      ),
                    ),
                  ),
                  selected: _selectFabric.contains(FabricCompositionEnum[index].code),
                  onSelected: (value) {
                    setState(() {
                      if (value) {
                        _selectFabric.add(FabricCompositionEnum[index].code);
                      } else {
                        _selectFabric.remove(FabricCompositionEnum[index].code);
                      }
                    });
                  },
                ),
              );
            }),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
