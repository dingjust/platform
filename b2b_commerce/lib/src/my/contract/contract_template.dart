class Contract {
  String code;
  String name;
  String parent;

  Contract({this.code, this.name, this.parent});
}

class ContractData{
  List<Contract> conList = [
    Contract(
      code: '1',
      name: '模asfv1',
      parent: '1',
    ),
    Contract(
      code: '2',
      name: '模gkgh2',
      parent: '1',
    ),
    Contract(
      code: '3',
      name: '模drfg1',
      parent: '2',
    ),
    Contract(
      code: '4',
      name: 'rqwrgd板2',
      parent: '2',
    ),
    Contract(
      code: '5',
      name: '大师傅士',
      parent: '2',
    ),
    Contract(
      code: '6',
      name: '模和板1',
      parent: '3',
    ),
    Contract(
      code: '7',
      name: '广泛的如',
      parent: '3',
    ),
    Contract(
      code: '8',
      name: 'gnf分发',
      parent: '4',
    ),
    Contract(
      code: '9',
      name: 'u与让我去',
      parent: '4',
    ),
    Contract(
      code: '10',
      name: '更加健康',
      parent: '4',
    ),
    Contract(
      code: '11',
      name: '爱吃醋现',
      parent: '4',
    ),
  ];

  List<Contract> getConList() {
    return conList;
  }
}

