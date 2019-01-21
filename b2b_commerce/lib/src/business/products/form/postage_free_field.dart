import 'package:flutter/material.dart';
import 'package:models/models.dart';

class PostageFreeField extends StatefulWidget {
  PostageFreeField(this.item);

  final ApparelProductModel item;

  @override
  State<StatefulWidget> createState() => _PostageFreeFieldState();
}

class _PostageFreeFieldState extends State<PostageFreeField> {
  bool _postageFree = false;
  
  @override
  void initState() {
//    _postageFree = widget.item.;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListTile(
        title: Text('是否免邮'),
        contentPadding: EdgeInsets.symmetric(horizontal: 0),
        trailing: Switch(
          value: _postageFree,
          activeColor: Colors.pink,
          onChanged: (bool val) {
            setState(() {
              _postageFree = val;
            });
          },
        ),
      ),
    );
  }
}