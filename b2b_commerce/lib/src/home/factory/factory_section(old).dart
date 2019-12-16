// import 'dart:async';

// import 'package:b2b_commerce/src/home/pool/requirement_pool_all.dart';
// import 'package:b2b_commerce/src/home/pool/requirement_pool_recommend.dart';
// import 'package:b2b_commerce/src/production/production_offline_order_from(old).dart';
// import 'package:b2b_commerce/src/production/production_unique_code.dart';
// import 'package:flutter/material.dart';
// import 'package:models/models.dart';
// import 'package:services/services.dart';
// import 'package:widgets/widgets.dart';
// import 'package:core/core.dart';

// class FactoryRequirementPoolSection extends StatefulWidget {
//   _FactoryRequirementPoolSection createState() =>
//       _FactoryRequirementPoolSection();
// }

// class _FactoryRequirementPoolSection
//     extends State<FactoryRequirementPoolSection> {
//   int requirementAll = 0;
//   bool hasGetRequirementAll = false;
//   int requirementRecommend = 0;
//   final StreamController _reportsStreamController =
//       StreamController<Reports>.broadcast();

//   void queryReports() async {
//     Reports response = await ReportsRepository().reportRequirementCount();
//     if (response != null) {
//       _reportsStreamController.add(response);
//       requirementAll = response.ordersCount8;
//       requirementRecommend = response.ordersCount9;
//     }
//   }

//   void getAllRequirementCount() async {
//     int count = await ReportsRepository().offlineRequirementCount();
//     if (count != null) {
//       setState(() {
//         requirementAll = count;
//         hasGetRequirementAll = true;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final UserBLoC bloc = BLoCProvider.of<UserBLoC>(context);
//     if (bloc.currentUser.status != UserStatus.OFFLINE) {
//       queryReports();
//     } else if (bloc.currentUser.status == UserStatus.OFFLINE &&
//         requirementAll == 0 &&
//         !hasGetRequirementAll) {
//       getAllRequirementCount();
//     }
//     return Container(
//       padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: <Widget>[
//           StreamBuilder<Reports>(
//             stream: _reportsStreamController.stream,
//             initialData: Reports(),
//             builder: (BuildContext context, AsyncSnapshot<Reports> snapshot) {
//               return GestureDetector(
//                 onTap: () async {
//                   await ProductRepositoryImpl()
//                       .majorCategories()
//                       .then((categories) {
//                     if (categories != null) {
//                       Navigator.of(context).push(
//                         MaterialPageRoute(
//                           builder: (context) =>
//                               RequirementPoolAllPage(categories: categories),
//                         ),
//                       );
//                     }
//                   });
//                 },
//                 child: Container(
//                   color: Colors.white,
//                   padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
//                   child: AllRequirementMenuItem(count: requirementAll),
//                 ),
//               );
//             },
//           ),
//           DividerFactory.buildVerticalSeparator(35),
//           StreamBuilder<Reports>(
//             stream: _reportsStreamController.stream,
//             initialData: Reports(),
//             builder: (BuildContext context, AsyncSnapshot<Reports> snapshot) {
//               return GestureDetector(
//                 onTap: () async {
//                   await ProductRepositoryImpl()
//                       .majorCategories()
//                       .then((categories) {
//                     if (categories != null) {
//                       Navigator.of(context).push(MaterialPageRoute(
//                           builder: (context) => RequirementPoolRecommend(
//                                 categories: categories,
//                               )));
//                     }
//                   });
//                 },
//                 child: Container(
//                   padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
//                   color: Colors.white,
//                   child: RecommendedRequirementMenuItem(
//                       count: requirementRecommend),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// class AllRequirementMenuItem extends StatelessWidget {
//   const AllRequirementMenuItem({Key key, @required this.count})
//       : super(key: key);

//   final int count;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 50,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: <Widget>[
//           Text(
//             '全部需求',
//             style: TextStyle(
//               color: Color.fromRGBO(36, 38, 41, 1),
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           RichText(
//             text: TextSpan(
//               text: '$count +',
//               style: TextStyle(
//                 color: Color.fromRGBO(255, 45, 45, 1),
//               ),
//               children: <TextSpan>[
//                 TextSpan(
//                   text: '需求等待回复',
//                   style: TextStyle(
//                     color: Color.fromRGBO(100, 100, 100, 1),
//                   ),
//                 )
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

// class RecommendedRequirementMenuItem extends StatelessWidget {
//   const RecommendedRequirementMenuItem({Key key, @required this.count})
//       : super(key: key);

//   final int count;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 50,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: <Widget>[
//           Container(
//             width: 100,
//             child: Stack(
//               alignment: Alignment.bottomCenter,
//               children: <Widget>[
//                 Text(
//                   '推荐需求',
//                   style: TextStyle(
//                     color: Color.fromRGBO(36, 38, 41, 1),
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 Positioned(
//                   right: 0,
//                   top: 0,
//                   child: Container(
//                     width: 18,
//                     height: 18,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Color.fromRGBO(255, 38, 38, 1),
//                     ),
//                     child: Center(
//                       child: Text(
//                         '$count',
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//           RichText(
//             text: TextSpan(
//                 text: '待我',
//                 style: TextStyle(
//                   color: Color.fromRGBO(100, 100, 100, 1),
//                 ),
//                 children: <TextSpan>[
//                   TextSpan(
//                       text: '报价',
//                       style: TextStyle(color: Color.fromRGBO(255, 45, 45, 1))),
//                   TextSpan(
//                       text: '的需求',
//                       style: TextStyle(color: Color.fromRGBO(100, 100, 100, 1)))
//                 ]),
//           )
//         ],
//       ),
//     );
//   }
// }

// /// 协同管理
// class FactoryCollaborationSection extends StatelessWidget {
//   Widget _buildTitle() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: <Widget>[
//         Text(
//           '协同管理',
//           style: TextStyle(
//             color: Color.fromRGBO(100, 100, 100, 1),
//             fontWeight: FontWeight.w600,
//             fontSize: 18,
//           ),
//         ),
//         Text(
//           '线下订单',
//           style: TextStyle(
//             color: Color.fromRGBO(150, 150, 150, 1),
//           ),
//         )
//       ],
//     );
//   }

//   Widget _buildCreateButton(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
//       padding: EdgeInsets.symmetric(horizontal: 20),
//       child: FlatButton(
//         color: Color.fromRGBO(255, 214, 12, 1),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => ProductionOfflineOrder(),
//             ),
//           );
//         },
//         child: Text(
//           '创建线下订单',
//           style: TextStyle(
//               color: Color.fromRGBO(36, 38, 41, 1),
//               fontWeight: FontWeight.bold),
//         ),
//       ),
//     );
//   }

//   Widget _buildCreationTips() {
//     return Container(
//       width: double.infinity,
//       margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
//       padding: EdgeInsets.symmetric(horizontal: 20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Text(
//             '• 使用钉单APP统一管理生产订单;',
//             style: TextStyle(color: Color.fromRGBO(150, 150, 150, 1)),
//           ),
//           Text(
//             '• 创建后生成唯一码，邀请品牌线上查看生产进度;',
//             style: TextStyle(color: Color.fromRGBO(150, 150, 150, 1)),
//           )
//         ],
//       ),
//     );
//   }

//   Widget _buildUniqueCodeInput(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ProductionUniqueCodePage(),
//           ),
//         );
//       },
//       child: Container(
//         width: double.infinity,
//         padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
//         margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
//         decoration: BoxDecoration(
//           color: Color.fromRGBO(232, 232, 232, 1),
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Text(
//           '请输入品牌发来的唯一码',
//         ),
//       ),
//     );
//   }

//   Widget _buildInputTips() {
//     return Container(
//       width: double.infinity,
//       margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
//       padding: EdgeInsets.symmetric(horizontal: 20),
//       child: Text(
//         '• 品牌已创建线下订单，直接通过唯一码导入;',
//         style: TextStyle(
//           color: Color.fromRGBO(150, 150, 150, 1),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
//       child: Column(
//         children: <Widget>[
//           _buildTitle(),
//           _buildCreateButton(context),
//           _buildCreationTips(),
//           DividerFactory.buildHorizontalSeparator(10, 20),
//           _buildUniqueCodeInput(context),
//           _buildInputTips(),
//         ],
//       ),
//     );
//   }
// }
