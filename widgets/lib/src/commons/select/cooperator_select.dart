import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

class CooperatorSelect extends StatefulWidget {
  CooperatorModel? model;

  final ValueChanged<CooperatorModel?>? onChanged;

  CooperatorSelect({this.model, this.onChanged});

  @override
  _CooperatorSelectState createState() => _CooperatorSelectState();
}

class _CooperatorSelectState extends State<CooperatorSelect> {
  CooperatorModel? selectedCooperators = null;

  @override
  void initState() {
    if (widget.model != null) {
      selectedCooperators = widget.model;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder:
          (BuildContext context, AsyncSnapshot<CooperatorResponse?> snapshot) {
        if (snapshot.data != null) {
          return Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('取消'),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: BorderSide(width: 0.1)),
                    ),
                    FlatButton(
                      onPressed: () {
                        widget.onChanged!(selectedCooperators);
                      },
                      child: Text('确定'),
                      color: Color.fromRGBO(255, 214, 12, 1),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: ListView(children: _buildItems(snapshot.data!)),
                ),
              )
            ],
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
      initialData: null,
      future: _getData(),
    );
  }

  List<Widget> _buildItems(CooperatorResponse response) {
    return response.content
        .map((cooperator) => GestureDetector(
              onTap: () {
                if (selectedCooperators?.id == cooperator.id) {
                  setState(() {
                    selectedCooperators = null;
                  });
                } else {
                  setState(() {
                    selectedCooperators = cooperator;
                  });
                }
              },
              child: Container(
                color: cooperator.id == selectedCooperators?.id
                    ? Color.fromRGBO(255, 214, 12, 0.5)
                    : Colors.white,
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                        '${cooperator.type == CooperatorType.ONLINE ? cooperator.partner.name : cooperator.name}')
                  ],
                ),
              ),
            ))
        .toList();
  }

  Future<CooperatorResponse> _getData() async {
    CooperatorResponse response = await CooperatorRepositoryImpl().list();
    return response;
  }
}
