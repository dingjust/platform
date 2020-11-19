// import 'package:b2b_commerce/src/_shared/widgets/app_bar_factory.dart';
// import 'package:b2b_commerce/src/_shared/widgets/tab_factory.dart';
// import 'package:core/core.dart';
// import 'package:flutter/material.dart';
// import 'package:models/models.dart';
// import 'package:provider/provider.dart';
// import 'package:services/services.dart';
// import 'package:widgets/widgets.dart';

// ///合作商列表页
// class PayPlansPage extends StatefulWidget {
//   ///数据选择数组
//   final List<CompanyPayPlanModel> selectedData;

//   ///选择模式
//   final bool selectingMode;

//   ///选择模式下最大限制
//   final int max;

//   /// [selectingMode]=true 时为选择合作商
//   ///
//   /// 示例：
//   ///
//   /// ```dart preamble
//   /// List<CompanyPayPlanModel> cooperators = await Navigator.push(
//   ///     context,
//   ///     MaterialPageRoute(
//   ///         builder: (context) => PayPlansPage(
//   ///               selectingMode: true,
//   ///               max:1
//   ///             )));
//   /// ```

//   const PayPlansPage({
//     Key key,
//     this.selectedData,
//     this.selectingMode = false,
//     this.max = 99,
//   }) : super(key: key);

//   @override
//   _PayPlansPageState createState() => _PayPlansPageState();
// }

// class _PayPlansPageState extends State<PayPlansPage> {
//   bool isSearching = false;
//   TextEditingController controller;
//   FocusNode focusNode;

//   ///用于选择模式中的数据
//   List<CompanyPayPlanModel> selectedData;

//   ///类型
//   List<EnumModel> statuses;

//   @override
//   void initState() {
//     controller = TextEditingController();
//     focusNode = FocusNode();

//     selectedData = [];
//     if (widget.selectedData != null) {
//       selectedData.addAll(widget.selectedData);
//     }
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider<PayPlanState>(
//       create: (context) => PayPlanState(
//           selectedData: selectedData,
//           onItemTap: widget.selectingMode ? onItemTap : null),
//       child: Scaffold(
//         appBar: _buildAppbar(),
//         body: DefaultTabController(
//           length: statuses.length,
//           child: Scaffold(
//             appBar: TabFactory.buildDefaultTabBar(statuses, scrollable: false),
//             body: TabBarView(
//               children: statuses
//                   .map((status) => CooperatorsView(status: status))
//                   .toList(),
//             ),
//           ),
//         ),
//         floatingActionButton: _AddButton(),
//         floatingActionButtonLocation: widget.selectingMode
//             ? FloatingActionButtonLocation.centerDocked
//             : null,
//         bottomSheet: _buildBottomBtns(),
//         resizeToAvoidBottomInset: false,
//       ),
//     );
//   }

//   Widget _buildSearchButton() {
//     return IconButton(
//         icon: const Icon(B2BIcons.search, size: 20),
//         onPressed: () {
//           setState(() {
//             isSearching = true;
//           });
//         });
//   }

//   Widget _buildAppbar() {
//     return isSearching
//         ? AppBar(
//             elevation: 0,
//             automaticallyImplyLeading: true,
//             title: Consumer<PayPlanState>(
//               builder: (context, PayPlanState state, _) => SearchAppbarTitle(
//                 controller: controller,
//                 focusNode: focusNode,
//                 hintText: '请输入方案名称',
//                 onSearch: () {
//                   state.setKeyword(controller.text);
//                   if (controller.text == '') {
//                     setState(() {
//                       isSearching = false;
//                     });
//                   }
//                 },
//                 onChange: (v) {
//                   state.setKeyword(controller.text);
//                 },
//               ),
//             ))
//         : AppBarFactory.buildDefaultAppBar('账务方案',
//             actions: <Widget>[_buildSearchButton()]);
//   }

//   Widget _buildBottomBtns({double height = 55}) {
//     return widget.selectingMode
//         ? Container(
//             height: height,
//             decoration: BoxDecoration(
//               color: Colors.white,
//             ),
//             child: Row(
//               children: [
//                 Expanded(
//                     flex: 1,
//                     child: Container(
//                       height: height,
//                       child: FlatButton(
//                           shape: RoundedRectangleBorder(),
//                           disabledColor: Colors.grey,
//                           onPressed: () {
//                             setState(() {
//                               selectedData.clear();
//                             });
//                           },
//                           child: Text('重置',
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 color: Colors.red,
//                               ))),
//                     )),
//                 Expanded(
//                     flex: 1,
//                     child: Container(
//                       height: height,
//                       child: FlatButton(
//                           shape: RoundedRectangleBorder(),
//                           disabledColor: Colors.grey,
//                           onPressed: () {
//                             Navigator.of(context).pop(selectedData);
//                           },
//                           color: Constants.THEME_COLOR_MAIN,
//                           child: Text('确定',
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 color: Colors.white,
//                               ))),
//                     ))
//               ],
//             ),
//           )
//         : Container(
//             height: 0,
//           );
//   }

//   ///选择
//   void onItemTap(CompanyPayPlanModel model) {
//     setState(() {
//       if (selectedData.any((element) => element.id == model.id)) {
//         selectedData.removeWhere((element) => element.id == model.id);
//       } else {
//         //单选情况
//         if (widget.max == 1) {
//           selectedData.clear();
//           selectedData.add(model);
//         } else {
//           if (selectedData.length < widget.max) {
//             selectedData.add(model);
//           }
//         }
//       }
//     });
//   }
// }

// class _AddButton extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return FloatingActionButton(
//       onPressed: () {},
//       child: Icon(
//         Icons.add,
//         color: Colors.white,
//       ),
//     );
//   }
// }
