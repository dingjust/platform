import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';

import 'package:core/core.dart';
import 'package:widgets/widgets.dart';

class ProductsConditionPage extends StatefulWidget {
  final ProductState state;

  const ProductsConditionPage({Key key, this.state}) : super(key: key);

  @override
  _ProductsConditionPageState createState() => _ProductsConditionPageState();
}

class _ProductsConditionPageState extends State<ProductsConditionPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          // Navigator.pop(context, widget.productCondition);
          return Future.value(false);
        },
        child: Scaffold(
          body: Container(
              color: Colors.white,
              child: Container(
                  child: Column(
                children: [
                  Expanded(
                    child: Consumer(
                      builder: (context, CategoryState categoryState, _) =>
                          FutureBuilder(
                        future: categoryState.getCascadedCategories(),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<CategoryModel>> snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          } else {
                            return SingleCategorySelect(
                              categories: snapshot.data,
                              categorySelect: widget.state.category,
                              onItemTap: (categoryModel) {
                                CategoryModel model =
                                    categoryModel as CategoryModel;
                                if (widget.state.category != null &&
                                    widget.state.category.code == model.code) {
                                  widget.state
                                    ..category = null
                                    ..clear();
                                } else {
                                  widget.state
                                    ..category = categoryModel
                                    ..clear();
                                }
                                Navigator.of(context).pop();
                              },
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  _buildBottom()
                ],
              ))),
        ));
  }

  Widget _buildBottom() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FlatButton(
              child: Text('确定',
                  style: TextStyle(
                    color: Colors.white,
                  )),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              color: Constants.THEME_COLOR_MAIN,
              onPressed: () {
                Navigator.of(context).pop();
              })
        ],
      ),
    );
  }

// Container(
//   height: 40,
//   margin: EdgeInsets.only(right: 10),
//   child: Center(
//     child: FlatButton(
//         padding:
//             const EdgeInsets.symmetric(vertical: 0, horizontal: 45),
//         color: Colors.grey,
//         child: const Text(
//           '重置',
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 16,
//           ),
//         ),
//         shape: const RoundedRectangleBorder(
//             borderRadius:
//                 const BorderRadius.all(Radius.circular(8))),
//         onPressed: () {
//           // Navigator.pop(context, widget.productCondition);
//         }),
//   ),
// ),
}
