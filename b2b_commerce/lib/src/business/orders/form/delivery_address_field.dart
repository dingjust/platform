import 'package:b2b_commerce/src/common/address_picker.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

class DeliveryAddressField extends StatefulWidget {
  final RequirementOrderModel item;

  DeliveryAddressField(this.item);

  DeliveryAddressFieldState createState() => DeliveryAddressFieldState();
}

class DeliveryAddressFieldState extends State<DeliveryAddressField> {
  AddressModel addressModel = AddressModel(
    region: null,
    fullname: null,
    cellphone: null,
    city: null,
    cityDistrict: null,
    line1: null,
  );

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
            widget.item.deliveryAddress?.regionCityAndDistrict ?? '选取',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey),
          ),
        ),
      ),
      onTap: () {
        AddressPicker(cacel:(){
          setState(() {
            widget.item.deliveryAddress = null;
          });
          Navigator.pop(context);
        }).showAddressPicker(
          context,
          selectProvince: (province) {
            addressModel.region = RegionModel.fromJson(province);
          },
          selectCity: (city) {
            addressModel.city = CityModel.fromJson(city);
          },
          selectArea: (area) {
            addressModel.cityDistrict = DistrictModel.fromJson(area);
            setState(() {
              widget.item.deliveryAddress = addressModel;
            });
          },
        );
      },
    );
  }
}
