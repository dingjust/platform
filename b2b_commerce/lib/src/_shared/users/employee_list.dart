import 'package:b2b_commerce/src/_shared/users/employee_item.dart';
import 'package:b2b_commerce/src/business/employees/employee_form.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

class EmployeeList extends StatefulWidget {
  EmployeeList();

  EmployeeListState createState() => EmployeeListState();
}

class EmployeeListState extends State<EmployeeList>{

  @override
  void initState() {


    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: (){
        return EmployeeBLoC.instance.getB2BCustomerData();
      },
      child: ListView(
        children: <Widget>[
          StreamBuilder<List<B2BCustomerModel>>(
            stream: EmployeeBLoC.instance.stream,
            // initialData: null,
            builder: (BuildContext context,
                AsyncSnapshot<List<B2BCustomerModel>> snapshot) {
              if (snapshot.data == null) {
//              if (widget.keyword == null) {
                EmployeeBLoC.instance.getB2BCustomerData();
//              } else {
//                print('${widget.keyword}------------');
//                bloc.getData(widget.keyword);
//              }
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 200),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (snapshot.hasData) {
                return Column(
                  children: snapshot.data.map((employee) {
                    return EmployeeItem(
                      employee
                    );
                  }).toList(),
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
            },
          ),
        ],
      ),
    );
  }

}