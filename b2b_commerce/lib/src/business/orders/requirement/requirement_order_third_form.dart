// import 'package:b2b_commerce/src/business/orders/form/production_areas_field.dart';
// import 'package:b2b_commerce/src/home/requirement/requirement_publish_success.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:models/models.dart';
// import 'package:services/services.dart';
// import 'package:widgets/widgets.dart';

// import 'RequirementFormMixins.dart';

// /// 产品分类选择页
// class RequirementOrderThirdForm extends StatefulWidget {
//   RequirementOrderThirdForm({
//     this.formState,
//   });

//   final RequirementOrderFormState formState;

//   _RequirementOrderThirdFormState createState() =>
//       _RequirementOrderThirdFormState();
// }

// class _RequirementOrderThirdFormState extends State<RequirementOrderThirdForm>
//     with RequirementFormMixin {
//   GlobalKey _scaffoldKey = GlobalKey();

//   @override
//   void initState() {
//     super.initForm();
//     super.initCreate(widget.formState.model);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       appBar: AppBar(
//         elevation: 0.5,
//         centerTitle: true,
//         title: Text('需求发布(3/3)'),
//         actions: <Widget>[
//         ],
//       ),
//       bottomNavigationBar: Container(
//         margin: EdgeInsets.all(10),
//         padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
//         height: 50,
//         child: RaisedButton(
//             color: Color.fromRGBO(255, 214, 12, 1),
//             child: Text(
//               '确认发布',
//               style: TextStyle(
//                 color: Colors.black,
//                 fontWeight: FontWeight.w500,
//                 fontSize: 18,
//               ),
//             ),
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.all(Radius.circular(50))),
//             onPressed: () async {
//               onPublish();
//             }),
//       ),
//       body: Container(
//         color: Colors.grey[100],
//         child: ListView(
//           children: <Widget>[
//             Container(
//               color: Colors.white,
//               padding: const EdgeInsets.all(15.0),
//               child: RichText(
//                 text: TextSpan(
//                   children: <TextSpan>[
//                     TextSpan(
//                       text: '非必填-其他详细要求（',
//                       style: TextStyle(
//                         color: Colors.grey,
//                         fontSize: 16.0,
//                       ),
//                     ),
//                     TextSpan(
//                       text: '提高匹配率',
//                       style: TextStyle(
//                         color: Colors.red,
//                         fontSize: 16.0,
//                       ),
//                       recognizer: TapGestureRecognizer()
//                         ..onTap = () async {
//                           print('点击事件');
//                           //这里做点击事件
// //                        String url = 'http://www.baidu.com';
// //                        if (await canlaunch(url)){
// //                          await launch(url);
// //                        }
//                         },
//                     ),
//                     TextSpan(
//                       text: '）',
//                       style: TextStyle(
//                         color: Color(0xffff0000),
//                         fontSize: 20.0,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Container(
//               color: Colors.white,
//               child: ProductionAreasField(widget.formState.model),
//             ),
//             Container(
//               color: Colors.white,
//               padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   Text('加工类型',style: TextStyle(fontSize: 16),),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: MachiningType.values
//                         .map((type) =>
//                         ChoiceChip(
//                             label: Text(MachiningTypeLocalizedMap[type]),
//                             backgroundColor: Colors.grey[100],
//                             selectedColor: Color.fromRGBO(255, 214, 12, 1),
//                             selected: widget.formState.model.details.machiningType == type,
//                             onSelected: (bool selected) {
//                               setState(() {
//                                 widget.formState.model.details.machiningType = type;
//                               });
//                             }))
//                         .toList(),
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//                 color: Colors.white,
//                 padding: EdgeInsets.symmetric(
//                   horizontal: 15,vertical: 5
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: <Widget>[
//                     Expanded(
//                       flex: 1,
//                       child: Text('是否需要打样',style: TextStyle(fontSize: 16),),
//                     ),
//                     Row(
//                       children: <Widget>[
//                         Text(
//                             widget.formState.model.details.proofingNeeded
//                                 ? '需要'
//                                 : '不需要',
//                             style: TextStyle(color: Colors.grey,fontSize: 16,)),
//                         Switch(
//                           value: widget.formState.model.details.proofingNeeded,
//                           onChanged: (val) {
//                             setState(() {
//                               widget.formState.model.details.proofingNeeded =
//                                   val;
//                             });
//                           },
//                         ),
//                       ],
//                     ),
//                   ],
//                 )),
//             Container(
//                 color: Colors.white,
//                 padding: EdgeInsets.symmetric(
//                   horizontal: 15,vertical: 5
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: <Widget>[
//                     Expanded(
//                       flex: 1,
//                       child: Text('是否开具发票',style: TextStyle(fontSize: 16),),
//                     ),
//                     Row(
//                       children: <Widget>[
//                         Text(
//                             widget.formState.model.details.invoiceNeeded
//                                 ? '开'
//                                 : '不开',
//                             style: TextStyle(color: Colors.grey,fontSize: 16,)),
//                         Switch(
//                           value: widget.formState.model.details.invoiceNeeded,
//                           onChanged: (val) {
//                             setState(() {
//                               widget.formState.model.details.invoiceNeeded =
//                                   val;
//                             });
//                           },
//                         ),
//                       ],
//                     ),
//                   ],
//                 )),
//             Container(
//               color: Colors.white,
//               padding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
//               child: Column(children: <Widget>[
//                 Align(
//                   alignment: Alignment.centerLeft,
//                   child: Text(
//                     "订单备注",
//                     style: TextStyle(
//                       fontSize: 16,
//                     ),
//                   ),
//                 ),
//                 Container(
//                   color: Colors.white,
//                   child: TextFieldComponent(
//                     padding: EdgeInsets.symmetric(vertical: 5),
//                     dividerPadding: EdgeInsets.only(),
//                     focusNode: remarksFocusNode,
//                     hintText: '填写',
//                     autofocus: false,
//                     inputType: TextInputType.text,
//                     textAlign: TextAlign.left,
//                     hideDivider: true,
//                     maxLines: null,
//                     maxLength: 120,
//                     controller: remarksController,
//                     onChanged: (v){
//                       widget.formState.model.remarks = remarksController.text;
//                     },
//                   ),
//                 )
//               ]),
//             ),
//             Container(
//               color: Colors.white,
//               child: Column(
//                 children: <Widget>[
//                   Container(
//                     margin:
//                     EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 10),
//                     child: Row(
//                       children: <Widget>[
//                         Text(
//                           '附件',
//                           style: TextStyle(fontSize: 16),
//                         ),
//                       ],
//                     ),
//                   ),
//                   EditableAttachments(
//                     list: widget.formState.model.attachments,
//                     maxNum: 5,
//                   )
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   /// 发布
//   void onPublish() async {
//     showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (_) {
//           return RequestDataLoading(
//             requestCallBack: RequirementOrderRepository().publishNewRequirement(widget.formState.model,null,false),
//             outsideDismiss: false,
//             loadingText: '正在保存。。。',
//             entrance: '',
//           );
//         }).then((code)async {
//       if (code != null && code != '') {
//         widget.formState.model.code = code;
//         //根据code查询明
//         RequirementOrderModel model = await RequirementOrderRepository()
//             .getRequirementOrderDetail(code);
//         Navigator.of(context).pushAndRemoveUntil(
//             MaterialPageRoute(
//               builder: (context) => PublishRequirementSuccessDialog(
//                 model: model,
//               ),
//             ),
//             ModalRoute.withName('/'));
//       }
//     });

// //      String code = await RequirementOrderRepository().publishNewRequirement(widget.formState.model,null,false);
// //      if (code != null && code != '') {
// //        widget.formState.model.code = code;
// //        //根据code查询明
// //        RequirementOrderModel model = await RequirementOrderRepository()
// //            .getRequirementOrderDetail(code);
// //        Navigator.of(context).pushAndRemoveUntil(
// //            MaterialPageRoute(
// //              builder: (context) => PublishRequirementSuccessDialog(
// //                model: model,
// //              ),
// //            ),
// //            ModalRoute.withName('/'));
// //      }
// //      String code =
// //      await RequirementOrderRepository().updateRequirement(widget.order);
// //      if (code != null) {
// //        Navigator.of(context).pushAndRemoveUntil(
// //            MaterialPageRoute(
// //              builder: (context) => RequirementOrderDetailPage(code),
// //            ),
// //            ModalRoute.withName('/'));
// //      } else {
// //        showDialog<void>(
// //          context: context,
// //          builder: (context) {
// //            return AlertDialog(
// //              title: Text('更新失败'),
// //            );
// //          },
// //        );
// //      }
//   }
// }
