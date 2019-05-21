import 'package:b2b_commerce/src/_shared/users/employee_item.dart';
import 'package:b2b_commerce/src/_shared/users/employee_list.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'employees/employee_form.dart';

class EmployeesPage extends StatefulWidget {
  @override
  _EmployeesPageState createState() => _EmployeesPageState();
}

class _EmployeesPageState extends State<EmployeesPage> {
  final List<B2BCustomerModel> items = <B2BCustomerModel>[
    B2BCustomerModel.fromJson(
        {'uid': 'zhan', 'name': '湛红波', 'mobileNumber': '13556179554'}),
    B2BCustomerModel.fromJson(
        {'uid': 'zhan1', 'name': '湛红波1', 'mobileNumber': '13556179554'})
  ];
  B2BCustomerModel employee;

  @override
  void initState() {
    if (employee == null) employee = B2BCustomerModel();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<EmployeeItem> _items = items.map((item) {
      return EmployeeItem(item);
    }).toList();

    return new Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        centerTitle: true,
        elevation: 0.5,
        title: const Text('员工管理'),
        actions: <Widget>[
//          IconButton(
//            icon: Icon(
//              B2BIcons.search,
//              size: 20,
//            ),
//            onPressed: () => showSearch(
//                context: context, delegate: EmployeeSearchDelegate()),
//          ),
        ],
      ),
      body: Container(
        color: Colors.grey[200],
        child: BLoCProvider<EmployeeBLoC>(
          bloc: EmployeeBLoC.instance,
          child: EmployeeList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  EmployeeFormPage(
                    item: employee,
                    newlyCreated: true,
                  ),
            ),
          );
        },
      ),
    );
  }
}
