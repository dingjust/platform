import 'package:b2b_commerce/src/business/apparel_products.dart';
import 'package:b2b_commerce/src/business/orders/proofing_order_quantity_input.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

class ProofingOrderFormPage extends StatefulWidget {
  ProofingModel item;

  ProofingOrderFormPage(this.item);

  ProofingOrderFormPageState createState() => ProofingOrderFormPageState();
}

class ProofingOrderFormPageState extends State<ProofingOrderFormPage> {
  FocusNode _remarksFocusNode = FocusNode();
  TextEditingController _remarksController = TextEditingController();
  List<ColorModel> _colorFilters = <ColorModel>[];
  List<SizeModel> _sizeFilters = <SizeModel>[];
  Map<ColorModel, List<SizeQuantityItem>> _items = Map();
  Map<ColorModel, List<SizeQuantityItem>> _newItems;
  int _totalQuantity;

  Widget _buildProduct(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
      child: Row(
        children: <Widget>[
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: widget.item.product.thumbnail != null
                      ? NetworkImage(widget.item.product.thumbnail)
                      : AssetImage(
                          'temp/picture.png',
                          package: "assets",
                        ),
                  fit: BoxFit.cover,
                )),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              height: 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.item.product.name,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(3, 1, 3, 1),
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      '货号：' + widget.item.product.skuID,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(3, 1, 3, 1),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 243, 243, 1),
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      "${widget.item.product?.minorCategory?.name}",
                      style: TextStyle(
                          fontSize: 15,
                          color: Color.fromRGBO(255, 133, 148, 1)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('创建打样订单'),
        centerTitle: true,
        elevation: 0.5,
        actions: <Widget>[
          IconButton(
              icon: Text(
                '确定',
                style: TextStyle(color: Color(0xffFF9516)),
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(8),
                child: CircleAvatar(
                  backgroundImage:
                      NetworkImage(widget.item.belongTo.profilePicture),
                  radius: 40.0,
                ),
              ),
              Text(
                widget.item.belongTo.name,
                textScaleFactor: 1.3,
              ),
            ],
          ),
          SizedBox(
            height: 3,
            child: Container(
              color: Colors.grey[200],
            ),
          ),
          GestureDetector(
            child: Container(
              height: 100,
              child: Card(
                elevation: 0,
                color: Colors.white10,
                child: widget.item.product == null
                    ? Center(child: Text('商品选择/创建'))
                    : _buildProduct(context),
              ),
            ),
            onTap: () async {
              dynamic result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ApparelProductsPage(
                            isRequirement: true,
                          )));
              if (result != null) {
                widget.item.product = result;
              }

              //选择完商品，生成数量item
              List<String> colorCodes = [];
              List<String> sizeCodes = [];
              _colorFilters.clear();
              _sizeFilters.clear();
              if(widget.item.product.variants !=null){
                widget.item.product.variants.forEach((variant){
                  if(!colorCodes.contains(variant.color.code)) {
                    colorCodes.add(variant.color.code);
                    _colorFilters.add(variant.color);
                  }
                  if(!sizeCodes.contains(variant.size.code)){
                    sizeCodes.add(variant.size.code);
                    _sizeFilters.add(variant.size);
                  }
                });
              }

              _totalQuantity = 0;

              _newItems = Map.from(_items);
              _items.clear();
              _colorFilters.forEach((color) {
                ColorModel itemColor = _newItems.keys.firstWhere(
                        (key) => key.code == color.code,
                    orElse: () => null);

                if (itemColor != null) {
                  _items[itemColor] = _sizeFilters.map((size) {
                    SizeQuantityItem item = _newItems[itemColor].firstWhere(
                            (SizeQuantityItem) =>
                        SizeQuantityItem.size.code == size.code,
                        orElse: () => null);
                    if (item != null) {
                      _totalQuantity += int.parse(item.quantityController.text == ''
                          ? '0'
                          : item.quantityController.text);
                      return item;
                    } else {
                      return SizeQuantityItem(size: size);
                    }
                  }).toList();
                } else {
                  _items[color] = _sizeFilters
                      .map((size) => SizeQuantityItem(size: size))
                      .toList();
                }
              });
            },
          ),
          SizedBox(
            height: 3,
            child: Container(
              color: Colors.grey[200],
            ),
          ),
          InkWell(
            onTap: () async {
              dynamic result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProofingOrderQuantityInputPage(
                        items: _items,
                      ),
                ),
              );

              if (result != null) _items = result;

              _totalQuantity = 0;
              _items.forEach((color, items) {
                items.forEach((item) {
                  _totalQuantity += int.parse(item.quantityController.text == ''
                      ? '0'
                      : item.quantityController.text);
                });
              });
            },
            child: ShowSelectTile(
              leadingText: '样衣数量',
              tralingText:
                  _totalQuantity == null ? '' : _totalQuantity.toString(),
            ),
          ),
          Divider(
            height: 0,
          ),
          InkWell(
            onTap: ()async {
              dynamic result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PopupWindowPage(
                        fieldText: '打样费',
                        inputType: TextInputType.number,
                        text: widget.item.unitPrice == null ? '': widget.item.unitPrice.toString() ,
                      ),
                ),
              );

              if(result == ''){
                widget.item.unitPrice = null;
              }else{
                widget.item.unitPrice = double.parse(result);
              }

            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: Text(
                    '打样费',
                    style: TextStyle(fontSize: 16),
                  )),
                  Text(
                    '￥ ${widget.item.unitPrice ?? ''}',
                    style: TextStyle(color: Colors.red, fontSize: 17),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 40, bottom: 20),
            child: Row(
              children: <Widget>[
                Expanded(child: Text('')),
                Text(
                  '总计 ',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                Text(
                  '￥ ${(_totalQuantity ?? 0) * (widget.item.unitPrice??0)}',
                  style: TextStyle(color: Color(0xffFF9516), fontSize: 17),
                ),
              ],
            ),
          ),
          Divider(
            height: 0,
          ),
          TextFieldComponent(
            focusNode: _remarksFocusNode,
            controller: _remarksController,
            leadingText: '备注',
            hintText: '请输入备注',
          ),
        ],
      ),
    );
  }
}
