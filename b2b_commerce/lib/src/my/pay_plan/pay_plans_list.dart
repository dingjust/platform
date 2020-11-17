// import 'package:flutter/material.dart';
// import 'package:models/models.dart';
// import 'package:provider/provider.dart';
// import 'package:services/services.dart';
// import 'package:widgets/widgets.dart';

// ///外接订单View
// class CooperatorsView extends StatelessWidget {
//   const CooperatorsView({
//     Key key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<PayPlanState>(
//       builder: (context, PayPlanState state, _) => Container(
//         child: state.totalElements > -1
//             ? PayPlansList(state)
//             : Center(
//                 child: CircularProgressIndicator(),
//               ),
//       ),
//     );
//   }
// }

// ///外接订单列表
// class PayPlansList extends StatelessWidget {
//   final PayPlanState state;

//   ScrollController _scrollController;

//   PayPlansList(
//     this.state, {
//     Key key,
//   }) : super(key: key) {
//     this._scrollController = ScrollController();
//     //监听加载更多
//     _scrollController.addListener(() {
//       if (_scrollController.position.pixels ==
//           _scrollController.position.maxScrollExtent) {
//         state.loadMore();
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: RefreshIndicator(
//         child: ListView(
//             controller: _scrollController,
//             physics: const AlwaysScrollableScrollPhysics(),
//             children: [
//               state.getPayPlans().isNotEmpty
//                   ? Column(
//                       children: state
//                           .getPayPlans()
//                           .map((model) => Container(
//                                 margin: EdgeInsets.symmetric(
//                                     vertical: 5, horizontal: 10),
//                                 child: PayPlanItem(
//                                   isSelected: state?.selectedData
//                                       ?.any((e) => e.id == model.id),
//                                   onItemTap: state?.onItemTap,
//                                   model: model,
//                                 ),
//                               ))
//                           .toList(),
//                     )
//                   : NoDataInfoRow(),
//               ProgressIndicatorFactory.buildPaddedOpacityProgressIndicator(
//                 opacity: state.loadingMore ? 1.0 : 0,
//               ),
//               _buildEnd()
//             ]),
//         onRefresh: () async {
//           state.clear();
//         },
//       ),
//     );
//   }

//   Widget _buildEnd() {
//     return state.getEntry(status.code).currentPage + 1 ==
//             state.getEntry(status.code).totalPages
//         ? Container(
//             padding: EdgeInsets.only(bottom: 10),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[Text('已经到底了')],
//             ),
//           )
//         : Container();
//   }
// }
