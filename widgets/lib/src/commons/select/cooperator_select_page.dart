import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

class CooperatorSelectOnPage extends StatefulWidget {
  CooperatorModel model;

  CooperatorSelectOnPage({this.model});

  @override
  _CooperatorSelectOnPageState createState() => _CooperatorSelectOnPageState();
}

class _CooperatorSelectOnPageState extends State<CooperatorSelectOnPage> {
  CooperatorModel selectedCooperators = null;

  @override
  void initState() {
    if (widget.model != null) {
      selectedCooperators = widget.model;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('选择供应商'),
        centerTitle: true,
        elevation: 0.5,
      ),
      body: FutureBuilder(
        builder:
            (BuildContext context, AsyncSnapshot<CooperatorResponse> snapshot) {
          if (snapshot.data != null) {
            return Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: ListView(children: _buildItems(snapshot.data)),
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
      ),
      bottomNavigationBar: Container(
        height: 50,
        child: RaisedButton(
            color: Color.fromRGBO(255, 214, 12, 1),
            child: Text(
              '确定',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))),
            onPressed: () async {
              Navigator.of(context).pop(selectedCooperators);
            }),
      ),
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
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                    color: cooperator.id == selectedCooperators?.id
                        ? Color.fromRGBO(255, 214, 12, 0.5)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text(
                            '${cooperator.type == CooperatorType.ONLINE ? cooperator.partner.name : cooperator.name}'),
                        Text(
                          '${cooperator.type == CooperatorType.ONLINE ? cooperator.partner.address ?? '' : ''}',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    Text('${CooperatorTypeLocalizedMap[cooperator.type]}')
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
