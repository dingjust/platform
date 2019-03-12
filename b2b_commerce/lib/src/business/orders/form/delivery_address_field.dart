import 'package:b2b_commerce/src/common/address_picker.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

class DeliveryAddressField extends StatefulWidget {
  final RequirementOrderModel item;

  DeliveryAddressField(this.item);

  DeliveryAddressFieldState createState() => DeliveryAddressFieldState();
}

class DeliveryAddressFieldState extends State<DeliveryAddressField> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        child: ListTile(
          leading: Text(
            '送货地址',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: Text(
            widget.item.details.region != null
                ? '${widget.item.details.region?.name}${widget.item.details.city?.name}${widget.item.details.cityDistrict?.name}'
                : '选取',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey),
          ),
        ),
      ),
      onTap: () {
        AddressPicker(cacel: () {
          setState(() {
            widget.item.details.region = null;
            widget.item.details.city = null;
            widget.item.details.cityDistrict= null;
          });
          Navigator.pop(context);
        }).showAddressPicker(
          context,
          selectProvince: (province) {
            widget.item.details.region = RegionModel.fromJson(province);
          },
          selectCity: (city) {
            widget.item.details.city = CityModel.fromJson(city);
          },
          selectArea: (area) {
            setState(() {
              widget.item.details.cityDistrict = DistrictModel.fromJson(area);
            });
          },
        );
      },
    );
  }
}
