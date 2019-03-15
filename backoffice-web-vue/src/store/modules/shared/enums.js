const state = {
  requirementOrderStatuses: [
    {code: 'PENDING_QUOTE', name: '报价中'},
    {code: 'COMPLETED', name: '已完成'},
    {code: 'CANCELLED', name: '已失效'}
  ],
  requirementOrderStatusFlow: {
    PENDING_QUOTE: 0,
    COMPLETED: 1,
    CANCELLED: 1
  },
  purchaseOrderStatuses: [
    {code: 'PENDING_PAYMENT', name: '待付款'},
    {code: 'IN_PRODUCTION', name: '生产中'},
    {code: 'WAIT_FOR_OUT_OF_STORE', name: '待出库'},
    {code: 'OUT_OF_STORE', name: '已出库'},
    {code: 'COMPLETED', name: '已完成'},
    {code: 'CANCELLED', name: '已取消'},
  ],
  salesOrderStatuses: [
    {code: 'PENDING_PAYMENT', name: '待付款'},
    {code: 'PENDING_DELIVERY', name: '待发货'},
    {code: 'SHIPPED', name: '已发货'},
    {code: 'COMPLETED', name: '已完成'}
  ],
  salesOrderStatusProcessFlow: {
    'PENDING_PAYMENT': 0,
    'PENDING_DELIVERY': 1,
    'SHIPPED': 2,
    'COMPLETED': 3
  },
  quoteStates: [
    {code: 'SELLER_SUBMITTED', name: '待处理'},
    {code: 'BUYER_APPROVED', name: '通过'},
    {code: 'BUYER_REJECTED', name: '拒绝'}
  ],
  approvalStatuses: [
    {code: 'approved', name: '上架'},
    {code: 'unapproved', name: '下架'}
  ],
  machiningTypes: [
    {code: 'LABOR_AND_MATERIAL', name: '包工包料'},
    {code: 'LIGHT_PROCESSING', name: '清加工'}
  ],
  labelGroups: [
    {code: 'FACTORY', name: '工厂打标'},
    {code: 'PLATFORM', name: '平台打标'}
  ],
  // 商品风格
  productStyles: [
    {code: 'FG0001', name: '潮流'},
    {code: 'FG0002', name: '简约'},
    {code: 'FG0003', name: '都市'},
    {code: 'FG0004', name: '复古休闲'},
    {code: 'FG0005', name: '运动'},
    {code: 'FG0006', name: '甜美'},
    {code: 'FG0007', name: '田园'},
    {code: 'FG0008', name: '淑女'},
    {code: 'FG0009', name: '民族'},
    {code: 'FG0010', name: '学院'},
    {code: 'FG0011', name: '布衣'},
    {code: 'FG0012', name: '中性'},
    {code: 'FG0013', name: 'OL'},
    {code: 'FG0014', name: '日系'},
    {code: 'FG0015', name: '韩版'},
    {code: 'FG0016', name: '欧美'},
    {code: 'FG0017', name: '中国风'},
    {code: 'FG0018', name: '商务'},
    {code: 'FG0019', name: '英伦'},
    {code: 'FG0020', name: '街头'},
    {code: 'FG0021', name: '户外'},
    {code: 'FG0022', name: '波西米亚'},
    {code: 'FG0023', name: '工装'},
  ],
  // 面料成分
  fabricCompositions: [
    {code: 'B001', name: '纯棉'},
    {code: 'B002', name: '涤纶'},
    {code: 'B003', name: '锦纶（尼龙）'},
    {code: 'B004', name: '麻'},
    {code: 'B005', name: '氨纶'},
    {code: 'B006', name: '腈纶'},
    {code: 'B007', name: '羊绒/羊毛'},
    {code: 'B008', name: '海马毛'},
    {code: 'B009', name: '羊驼毛'},
    {code: 'B010', name: 'PU'},
    {code: 'B011', name: '真皮'},
    {code: 'B012', name: '其他'},
    {code: 'B013', name: '棉麻'}
  ],
  // 版型
  editionTypes: [
    {code: 'C001', name: '紧身'},
    {code: 'C002', name: '修身'},
    {code: 'C003', name: '合体'},
    {code: 'C004', name: '宽松'}
  ],
  // 款式
  productPatterns: [
    {code: 'D001', name: '双面款'},
    {code: 'D002', name: '假两件'},
    {code: 'D003', name: '常规款'},
    {code: 'D004', name: '短款'},
    {code: 'D005', name: '中长款'},
    {code: 'D006', name: '加长款'}
  ],
  // 袖型
  sleeveTypes: [
    {code: 'E001', name: '蝙蝠袖'},
    {code: 'E002', name: '插肩袖/连肩袖'},
    {code: 'E003', name: '常规袖'},
    {code: 'E004', name: '罗文收口袖'},
    {code: 'E005', name: '牛角袖'},
    {code: 'E006', name: '泡泡袖'},
    {code: 'E007', name: '荷叶袖'},
    {code: 'E008', name: '灯笼袖'},
    {code: 'E009', name: '羊腿袖'},
    {code: 'E010', name: '和服袖'},
    {code: 'E011', name: '其他'}
  ],
  // 袖长/裤腿
  sleeveLengths: [
    {code: 'F001', name: '中袖/五分袖'},
    {code: 'F002', name: '无袖'},
    {code: 'F003', name: '盖肩袖'},
    {code: 'F004', name: '七分袖'},
    {code: 'F005', name: '短袖'},
    {code: 'F006', name: '长袖'},
    {code: 'F007', name: '九分袖'},
    {code: 'F008', name: '加长袖'},
    {code: 'F009', name: '其他'}
  ],
  // 图案
  decorativePatterns: [
    {code: 'G001', name: '几何'},
    {code: 'G002', name: '纯色'},
    {code: 'G003', name: '动物'},
    {code: 'G004', name: '字母/数字/文字'},
    {code: 'G005', name: '动漫/卡通'},
    {code: 'G006', name: '涂鸦'},
    {code: 'G007', name: '植物'},
    {code: 'G008', name: '头像'},
    {code: 'G009', name: '格子'},
    {code: 'G010', name: '拼接色'},
    {code: 'G011', name: '迷彩'},
    {code: 'G012', name: '条纹'},
    {code: 'G013', name: '其他'}
  ],
  // 流行元素
  popularElements: [
    {code: 'H001', name: '铆钉'},
    {code: 'H002', name: '亮片'},
    {code: 'H003', name: '拉链'},
    {code: 'H004', name: '流苏'},
    {code: 'H005', name: '镂空'},
    {code: 'H006', name: '绣花'},
    {code: 'H007', name: '镶钻'},
    {code: 'H008', name: '做旧/洗水'},
    {code: 'H009', name: '印花'},
    {code: 'H010', name: '植绒'},
    {code: 'H011', name: '蕾丝'},
    {code: 'H012', name: '其他'}
  ],
  // 填充物
  productFillers: [
    {code: 'J001', name: '鸭绒'},
    {code: 'J002', name: '鹅绒'},
    {code: 'J003', name: '洗水棉'},
    {code: 'J004', name: '珍珠棉'},
    {code: 'J005', name: '太空棉'},
    {code: 'J006', name: '涤纶棉'}
  ],
  // 厚薄
  productThicknesses: [
    {code: 'K001', name: '薄款'},
    {code: 'K002', name: '适中'},
    {code: 'K003', name: '加厚'},
    {code: 'K004', name: '加绒'},
    {code: 'K005', name: '抓绒'},
    {code: 'K006', name: '毛内胆'},
    {code: 'K007', name: '棉内胆'}
  ],
  // 季节
  productSeasons: [
    {code: 'L001', name: '春季'},
    {code: 'L002', name: '夏季'},
    {code: 'L003', name: '秋季'},
    {code: 'L004', name: '冬季'},
    {code: 'L005', name: '春夏'},
    {code: 'L006', name: '秋冬'},
    {code: 'L007', name: '四季'}
  ],
  // 门襟
  plackets: [
    {code: 'M001', name: '拉链'},
    {code: 'M002', name: '单排扣'},
    {code: 'M003', name: '双排扣'},
    {code: 'M004', name: '暗扣'},
    {code: 'M005', name: '牛角扣'}
  ]
};

const mutations = {};

const actions = {
  getEnumByCode({dispatch, commit, state}, {enumsName, code}) {
    return state[enumsName].find(e => e.code === code);
  }
};

const getters = {
  approvalStatuses: state => state.approvalStatuses,
};

export default {
  namespaced: true,
  state,
  mutations,
  actions,
  getters
}
