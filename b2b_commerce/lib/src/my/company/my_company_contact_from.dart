import 'package:b2b_commerce/src/my/address/contact_address_form.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:widgets/widgets.dart';

class MyCompanyContactFromPage extends StatefulWidget{
  B2BUnitModel company;

  MyCompanyContactFromPage({this.company});

  _MyCompanyContactFromPageState createState() => _MyCompanyContactFromPageState();
}

class _MyCompanyContactFromPageState extends State<MyCompanyContactFromPage>{
  String btnText = '编辑';
  bool isEditing = false;
  AddressModel addressModel;

  TextEditingController personController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController telController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController QQController = TextEditingController();
  TextEditingController weCharController = TextEditingController();

  FocusNode personFocusNode = FocusNode();
  FocusNode phoneFocusNode = FocusNode();
  FocusNode telFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode QQFocusNode = FocusNode();
  FocusNode weCharFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if(widget.company.contactAddress != null){
      addressModel = widget.company.contactAddress;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('联系方式'),
        centerTitle: true,
        elevation: 0.5,
        actions: <Widget>[
          !isEditing?
          Container(
                width: 80,
                child: ActionChip(
                  shape:  RoundedRectangleBorder(
                      side: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  label: Text('编辑'),
                  onPressed: () async{
                    setState(() {
                      isEditing = !isEditing;
                      personController.text = widget.company.contactPerson;
                      phoneController.text = widget.company.contactPhone;
                      telController.text = widget.company.phone;
                      emailController.text = widget.company.email;
                      QQController.text = widget.company.qq;
                      weCharController.text = widget.company.wechat;
                    });
                  },
                  backgroundColor: Color.fromRGBO(255, 214, 12, 1),
                )
          ):Container(),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            _buildContactPerson(context),
            Divider(height: 1,),
            _buildContactPhone(context),
            Divider(height: 1,),
            _buildContactAddress(context),
            Divider(height: 1,),
            _buildCellPhone(context),
            Divider(height: 1,),
            _buildEmail(context),
            Divider(height: 1,),
            _buildQQ(context),
            Divider(height: 1,),
            _buildWeChar(context),
            Divider(height: 1,),
          ],
        ),
      ),
      bottomNavigationBar: isEditing?Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
        height: 50,
        child: RaisedButton(
            color: Color.fromRGBO(255, 214, 12, 1),
            child: Text(
              '保存',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))),
            onPressed: () async {
              setState(() {
                isEditing = false;
              });
              widget.company.contactAddress = addressModel;
              widget.company.contactPerson = personController.text==''?null:personController.text;
              widget.company.contactPhone = phoneController.text == '' ? null : phoneController.text;
              widget.company.email = emailController.text == '' ? null : emailController.text;
              widget.company.qq = QQController.text == '' ? null : QQController.text;
              widget.company.wechat = weCharController.text == '' ? null : weCharController.text;
              widget.company.phone = telController.text == ''? null : telController.text;
              if(UserBLoC.instance.currentUser.type == UserType.BRAND){
                UserRepositoryImpl().brandUpdate(widget.company);
              }else if(UserBLoC.instance.currentUser.type == UserType.FACTORY){
                UserRepositoryImpl().factoryUpdate(widget.company);
              }
            }),
      ):null,
    );
  }

  Widget _buildContactPerson(BuildContext context){
    return Container(
      child: isEditing?
      Container(
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: TextFieldComponent(
          padding: EdgeInsets.symmetric(vertical: 5),
          dividerPadding: EdgeInsets.only(),
          focusNode: personFocusNode,
          leadingText: Text('联系人',
              style: TextStyle(
                fontSize: 16,
              )),
          hintText: '填写',
          autofocus: false,
          inputType: TextInputType.text,
          textAlign: TextAlign.right,
          controller: personController,
        ),
      )
      :Container(
        child: ListTile(
         leading: Container(
                child: Text(
                  '联系人',
                  style: TextStyle(
                      fontSize: 16
                  ),
                ),
              ),
          trailing : Container(
              child: Text(
                '${widget.company.contactPerson==null?'':widget.company.contactPerson}',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey
                ),
              ),
            ),
        ),
      ),
    );
  }

  Widget _buildContactPhone(BuildContext context){
    return Container(
      child: isEditing?
      Container(
        color: Colors.white,
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: TextFieldComponent(
          padding: EdgeInsets.symmetric(vertical: 5),
          dividerPadding: EdgeInsets.only(),
          focusNode: phoneFocusNode,
          leadingText: Text('联系电话',
              style: TextStyle(
                fontSize: 16,
              )),
          hintText: '填写',
          autofocus: false,
          inputType: TextInputType.phone,
          textAlign: TextAlign.right,
          controller: phoneController,
        ),
      )
        :GestureDetector(
        child: ListTile(
          leading: Container(
            child: Text(
              '联系电话',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          trailing : Container(
            child: Text(
              '${widget.company.contactPhone==null?'':widget.company.contactPhone}',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey
              ),
            ),
          ),
        ),
        onTap: (){
          _selectActionButton(widget.company.contactPhone);
        },
      ),
    );
  }

  Widget _buildContactAddress(BuildContext context){
    return Container(
      child: GestureDetector(
        child: ListTile(
          leading: Container(
            child: Text(
              '经营地址',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          trailing : Container(
            child: Text(
              '${widget.company.contactAddress!=null && widget.company.contactAddress.details != null? widget.company.contactAddress.details:''}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey
              ),
            ),
          ),
        ),
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ContactAddressFormPage(
                address: widget.company.contactAddress,
              ),
            ),
          ).then((value){
            addressModel = value;
          });
        },
      ),
    );
  }

  Widget _buildCellPhone(BuildContext context){
    return Container(
      child: isEditing?
      Container(
        color: Colors.white,
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: TextFieldComponent(
          padding: EdgeInsets.symmetric(vertical: 5),
          dividerPadding: EdgeInsets.only(),
          focusNode: telFocusNode,
          leadingText: Text('座机号码',
              style: TextStyle(
                fontSize: 16,
              )),
          hintText: '填写',
          autofocus: false,
          inputType: TextInputType.phone,
          textAlign: TextAlign.right,
          controller: telController,
        ),
      )
          :GestureDetector(
        child: ListTile(
          leading: Container(
            child: Text(
              '座机号码',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          trailing : Container(
            child: Text(
              '${widget.company.phone== null ? '':widget.company.phone}',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey
              ),
            ),
          ),
        ),
        onTap: (){
          _selectActionButton(widget.company.phone);
        },
      ),
    );
  }

  Widget _buildEmail(BuildContext context){
    return Container(
      child: isEditing?
      Container(
        color: Colors.white,
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: TextFieldComponent(
          padding: EdgeInsets.symmetric(vertical: 5),
          dividerPadding: EdgeInsets.only(),
          focusNode: emailFocusNode,
          leadingText: Text('邮箱地址',
              style: TextStyle(
                fontSize: 16,
              )),
          hintText: '填写',
          autofocus: false,
          inputType: TextInputType.emailAddress,
          textAlign: TextAlign.right,
          controller: emailController,
        ),
      )
          :GestureDetector(
        child: ListTile(
          leading: Container(
            child: Text(
              '邮箱地址',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          trailing : Container(
            child: Text(
              '${widget.company.email==null?'':widget.company.email}',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey
              ),
            ),
          ),
        ),
        onTap: (){
          copyToClipboard(widget.company.email,context);
        },
      ),
    );
  }

  Widget _buildQQ(BuildContext context){
    return Container(
      child: isEditing?
      Container(
        color: Colors.white,
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: TextFieldComponent(
          padding: EdgeInsets.symmetric(vertical: 5),
          dividerPadding: EdgeInsets.only(),
          focusNode: QQFocusNode,
          leadingText: Text('QQ号码',
              style: TextStyle(
                fontSize: 16,
              )),
          hintText: '填写',
          autofocus: false,
          inputType: TextInputType.text,
          textAlign: TextAlign.right,
          controller: QQController,
        ),
      )
          :GestureDetector(
        child: ListTile(
          leading: Container(
            child: Text(
              'QQ号码',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          trailing : Container(
            child: Text(
              '${widget.company.qq==null?'':widget.company.qq}',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey
              ),
            ),
          ),
        ),
        onTap: (){
          copyToClipboard(widget.company.qq,context);
        },
      ),
    );
  }

  Widget _buildWeChar(BuildContext context){
    return Container(
      child: Container(
        child: isEditing?
        Container(
          color: Colors.white,
          margin: EdgeInsets.only(top: 10),
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: TextFieldComponent(
            padding: EdgeInsets.symmetric(vertical: 5),
            dividerPadding: EdgeInsets.only(),
            focusNode: weCharFocusNode,
            leadingText: Text('微信号码',
                style: TextStyle(
                  fontSize: 16,
                )),
            hintText: '填写',
            autofocus: false,
            inputType: TextInputType.text,
            textAlign: TextAlign.right,
            controller: weCharController,
          ),
        )
            :GestureDetector(
          child: ListTile(
            leading: Container(
              child: Text(
                '微信号码',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            trailing : Container(
              child: Text(
                '${widget.company.wechat==null?'':widget.company.wechat}',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey
                ),
              ),
            ),
          ),
          onTap: (){
            copyToClipboard(widget.company.wechat,context);
          },
        ),
      ),
    );
  }

  //拨打电话或发短信
  void _selectActionButton(String tel) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('拨打电话'),
              onTap: () async {
                var url = 'tel:' + tel;
                await launch(url);
              },
            ),
            tel.indexOf('-') > -1
                ? Container()
                : ListTile(
              leading: const Icon(Icons.message),
              title: const Text('发送短信'),
              onTap: () async {
                var url = 'sms:' + tel;
                await launch(url);
              },
            ),
          ],
        );
      },
    );
  }

  copyToClipboard(final String text, BuildContext context) {
    if (text == null) return;
    Clipboard.setData(ClipboardData(text: text));
    _neverCopyContent(context);
  }

  Future<void> _neverCopyContent(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: Text('消息'),
          content: Text('复制成功'),
          actions: <Widget>[
            FlatButton(
              child: Text('确定'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

}