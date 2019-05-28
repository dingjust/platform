import 'package:b2b_commerce/src/_shared/users/employee_item.dart';
import 'package:b2b_commerce/src/_shared/widgets/scrolled_to_end_tips.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class EmployeeList extends StatefulWidget {
  String keyword;

  EmployeeList({this.keyword});

  EmployeeListState createState() => EmployeeListState();
}

class EmployeeListState extends State<EmployeeList> {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    var bloc = BLoCProvider.of<EmployeeBLoC>(context);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        bloc.loadingStart();
        bloc.loadingMoreByStatuses(widget.keyword);
      }
    });

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        EmployeeBLoC.instance.clear();
        return await EmployeeBLoC.instance.getB2BCustomerData(widget.keyword);
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: _scrollController,
        children: <Widget>[
          StreamBuilder<List<B2BCustomerModel>>(
            stream: EmployeeBLoC.instance.stream,
            // initialData: null,
            builder: (BuildContext context,
                AsyncSnapshot<List<B2BCustomerModel>> snapshot) {
              if (snapshot.data == null) {
//              if (widget.keyword == null) {
                EmployeeBLoC.instance.getB2BCustomerData(widget.keyword);
//              } else {
//                print('${widget.keyword}------------');
//                bloc.getData(widget.keyword);
//              }
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 200),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (widget.keyword != null && snapshot.data.length <= 0) {
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 200),
                      child: Image.asset(
                        'temp/logo2.png',
                        package: 'assets',
                        width: 80,
                        height: 80,
                      ),
                    ),
                    Container(child: Text('未找到含有该关键词的员工')),
//                    Container(
//                      child: Text('请点击右下角创建员工'),
//                    ),
                  ],
                );
              }
              if (snapshot.hasData) {
                return Column(
                  children: snapshot.data.map((employee) {
                    return EmployeeItem(employee);
                  }).toList(),
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
            },
          ),
          StreamBuilder<bool>(
            stream: EmployeeBLoC.instance.bottomStream,
            initialData: false,
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              // if (snapshot.data) {
              //   widget.scrollController.animateTo(widget.scrollController.offset - 70,
              //       duration: new Duration(milliseconds: 500),
              //       curve: Curves.easeOut);
              // }
              return ScrolledToEndTips(
                hasContent: snapshot.data,
                scrollController: _scrollController,
              );
            },
          ),
          StreamBuilder<bool>(
            stream: EmployeeBLoC.instance.loadingStream,
            initialData: false,
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Center(
                  child: new Opacity(
                    opacity: snapshot.data ? 1.0 : 0,
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
