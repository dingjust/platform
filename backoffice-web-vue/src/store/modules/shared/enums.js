const state = {

  // 流水来源
  flowSources: [{
      code: 'CASH_OUT',
      name: '提现'
    },
    {
      code: 'PROOFING',
      name: '生产中'
    },
    {
      code: 'PURCHASE_DEPOSIT',
      name: '待出库'
    },
    {
      code: 'PURCHASE_BALANCE',
      name: '已出库'
    }
  ],
  // 资金流水类型
  amountFlowTypes: [{
      code: 'INFLOW',
      name: '流入'
    },
    {
      code: 'OUTFLOW',
      name: '流出'
    }
  ],
  // 资金状态
  amountStatuses: [{
      code: 'AUDITING',
      name: '未结算'
    },
    {
      code: 'COMPLETED',
      name: '已完成'
    },
    {
      code: 'CANCELED',
      name: '已取消'
    },
    {
      code: 'REJECTED',
      name: '已拒绝'
    },
    {
      code: 'IN_REVIEW',
      name: '审核中'
    },
    {
      code: 'REVIEWED',
      name: '已审核'
    }
  ],
  // 工厂星级
  starLevels: [{
      code: 1,
      name: '一星'
    },
    {
      code: 2,
      name: '两星'
    },
    {
      code: 3,
      name: '三星'
    },
    {
      code: 4,
      name: '四星'
    },
    {
      code: 5,
      name: '五星'
    }
  ],
  // 轮播图类型
  carouselGroups: [{
      code: 'B2B',
      name: 'B2B'
    },
    {
      code: 'C2B',
      name: 'C2B'
    }
  ],

  // 轮播图类型
  carouselTypes: [{
      code: 'CT001',
      name: '首页'
    },
    {
      code: 'CT002',
      name: '工厂首页'
    },
    {
      code: 'CT003',
      name: '品牌首页'
    }
  ],

  // 生产进度类型
  productionProgressPhaseTypes: [{
      code: 'MATERIAL_PREPARATION',
      name: '备料'
    },
    {
      code: 'CUTTING',
      name: '裁剪'
    },
    {
      code: 'STITCHING',
      name: '车缝'
    },
    {
      code: 'AFTER_FINISHING',
      name: '后整'
    },
    {
      code: 'INSPECTION',
      name: '验货'
    }
  ],
  // 样衣借还类型
  sampleCheckoutTypes: [{
      code: 'BORROW',
      name: '借入'
    },
    {
      code: 'LEND',
      name: '借出'
    }
  ],
  // 样衣借还状态
  returnStates: [{
      code: 'NOT_RETURNED',
      name: '未还'
    },
    {
      code: 'RETURNED',
      name: '已还'
    }
  ],
  // 需求订单状态
  requirementOrderStatuses: [{
      code: 'PENDING_QUOTE',
      name: '报价中'
    },
    {
      code: 'COMPLETED',
      name: '已完成'
    },
    {
      code: 'CANCELLED',
      name: '已关闭'
    }
  ],
  requirementOrderStatusFlow: {
    PENDING_QUOTE: 0,
    COMPLETED: 1,
    CANCELLED: 1
  },
  // 生产订单状态
  purchaseOrderStatuses: [{
      code: 'PENDING_CONFIRM',
      name: '待确认'
    },
    {
      code: 'PENDING_PAYMENT',
      name: '待付款'
    },
    {
      code: 'IN_PRODUCTION',
      name: '生产中'
    },
    {
      code: 'WAIT_FOR_OUT_OF_STORE',
      name: '待出库'
    },
    {
      code: 'OUT_OF_STORE',
      name: '已出库'
    },
    {
      code: 'COMPLETED',
      name: '已完成'
    },
    {
      code: 'CANCELLED',
      name: '已取消'
    }
  ],
  // 打样订单状态
  proofingOrderStatuses: [{
      code: 'PENDING_PAYMENT',
      name: '待付款'
    },
    {
      code: 'PENDING_DELIVERY',
      name: '待发货'
    },
    {
      code: 'SHIPPED',
      name: '已发货'
    },
    {
      code: 'COMPLETED',
      name: '已完成'
    },
    {
      code: 'CANCELLED',
      name: '已取消'
    }
  ],
  salesOrderStatuses: [{
      code: 'PENDING_PAYMENT',
      name: '待付款'
    },
    {
      code: 'PENDING_DELIVERY',
      name: '待发货'
    },
    {
      code: 'PENDING_CONFIRM',
      name: '待收货'
    },
    {
      code: 'COMPLETED',
      name: '已完成'
    },
    {
      code: 'CANCELLED',
      name: '已关闭'
    },
    {
      code: 'PENDING_RETURN',
      name: '退款/售后'
    }
  ],
  refundStatus: [{
      code: 'NONE',
      name: '无'
    },
    {
      code: 'PENDING_CONFIRM',
      name: '待确认'
    },
    {
      code: 'REJECT',
      name: '拒绝'
    },
    {
      code: 'IN_REFUND',
      name: '退款中'
    },
    {
      code: 'COMPLETED',
      name: '完成'
    },
    {
      code: 'CANCELED',
      name: '取消'
    }
  ],
  refundType: [{
    code: 'ONLY_MONEY',
    name: '仅退款'
  }, {
    code: 'MONEY_AND_PRODUCT',
    name: '退款退货'
  }],
  salesOrderStatusProcessFlow: {
    'PENDING_PAYMENT': 0,
    'PENDING_DELIVERY': 1,
    'SHIPPED': 2,
    'COMPLETED': 3
  },
  // 销售计划状态
  SalesProductionStatuses: [{
      code: 'PENDING_CONFIRM',
      name: '待接单'
    },
    {
      code: 'PENDING_PAYMENT',
      name: '待付款'
    },
    {
      code: 'IN_PRODUCTION',
      name: '生产中'
    },
    {
      code: 'WAIT_FOR_OUT_OF_STORE',
      name: '待出库'
    },
    {
      code: 'OUT_OF_STORE',
      name: '已出库'
    },
    {
      code: 'COMPLETED',
      name: '已完成'
    },
    {
      code: 'CANCELLED',
      name: '已取消'
    }
  ],
  // 报价单状态
  quoteStates: [{
      code: 'SELLER_SUBMITTED',
      name: '待处理'
    },
    {
      code: 'BUYER_APPROVED',
      name: '通过'
    },
    {
      code: 'BUYER_REJECTED',
      name: '拒绝'
    },
    {
      code: 'CANCELLED',
      name: '已取消'
    }
  ],
  approvalStatuses: [{
      code: 'approved',
      name: '已上架'
    },
    {
      code: 'unapproved',
      name: '已下架'
    },
    {
      code: 'deleted',
      name: '已删除'
    }
  ],
  machiningTypes: [{
      code: 'LABOR_AND_MATERIAL',
      name: '包工包料'
    },
    {
      code: 'LIGHT_PROCESSING',
      name: '清加工'
    }
  ],
  labelGroups: [{
      code: 'FACTORY',
      name: '工厂标签'
    },
    {
      code: 'PLATFORM',
      name: '平台标签'
    },
    {
      code: 'ORDER',
      name: '订单标签'
    },
    {
      code: 'INDUSTRIAL_CLUSTER',
      name: '产业集群标签'
    }
  ],
  // 产品风格
  productStyles: [{
      code: 'FG0001',
      name: '潮流'
    },
    {
      code: 'FG0002',
      name: '简约'
    },
    {
      code: 'FG0003',
      name: '都市'
    },
    {
      code: 'FG0004',
      name: '复古休闲'
    },
    {
      code: 'FG0005',
      name: '运动'
    },
    {
      code: 'FG0006',
      name: '甜美'
    },
    {
      code: 'FG0007',
      name: '田园'
    },
    {
      code: 'FG0008',
      name: '淑女'
    },
    {
      code: 'FG0009',
      name: '民族'
    },
    {
      code: 'FG0010',
      name: '学院'
    },
    {
      code: 'FG0011',
      name: '布衣'
    },
    {
      code: 'FG0012',
      name: '中性'
    },
    {
      code: 'FG0013',
      name: 'OL'
    },
    {
      code: 'FG0014',
      name: '日系'
    },
    {
      code: 'FG0015',
      name: '韩版'
    },
    {
      code: 'FG0016',
      name: '欧美'
    },
    {
      code: 'FG0017',
      name: '中国风'
    },
    {
      code: 'FG0018',
      name: '商务'
    },
    {
      code: 'FG0019',
      name: '英伦'
    },
    {
      code: 'FG0020',
      name: '街头'
    },
    {
      code: 'FG0021',
      name: '户外'
    },
    {
      code: 'FG0022',
      name: '波西米亚'
    },
    {
      code: 'FG0023',
      name: '工装'
    }
  ],
  // 面料成分
  fabricCompositions: [{
      code: 'B001',
      name: '纯棉'
    },
    {
      code: 'B002',
      name: '涤纶'
    },
    {
      code: 'B003',
      name: '锦纶（尼龙）'
    },
    {
      code: 'B004',
      name: '麻'
    },
    {
      code: 'B005',
      name: '氨纶'
    },
    {
      code: 'B006',
      name: '腈纶'
    },
    {
      code: 'B007',
      name: '羊绒/羊毛'
    },
    {
      code: 'B008',
      name: '海马毛'
    },
    {
      code: 'B009',
      name: '羊驼毛'
    },
    {
      code: 'B010',
      name: 'PU'
    },
    {
      code: 'B011',
      name: '真皮'
    },
    {
      code: 'B012',
      name: '其他'
    },
    {
      code: 'B013',
      name: '棉麻'
    }
  ],
  // 版型
  editionTypes: [{
      code: 'C001',
      name: '紧身'
    },
    {
      code: 'C002',
      name: '修身'
    },
    {
      code: 'C003',
      name: '合体'
    },
    {
      code: 'C004',
      name: '宽松'
    }
  ],
  // 款式
  productPatterns: [{
      code: 'D001',
      name: '双面款'
    },
    {
      code: 'D002',
      name: '假两件'
    },
    {
      code: 'D003',
      name: '常规款'
    },
    {
      code: 'D004',
      name: '短款'
    },
    {
      code: 'D005',
      name: '中长款'
    },
    {
      code: 'D006',
      name: '加长款'
    }
  ],
  // 袖型
  sleeveTypes: [{
      code: 'E001',
      name: '蝙蝠袖'
    },
    {
      code: 'E002',
      name: '插肩袖/连肩袖'
    },
    {
      code: 'E003',
      name: '常规袖'
    },
    {
      code: 'E004',
      name: '罗文收口袖'
    },
    {
      code: 'E005',
      name: '牛角袖'
    },
    {
      code: 'E006',
      name: '泡泡袖'
    },
    {
      code: 'E007',
      name: '荷叶袖'
    },
    {
      code: 'E008',
      name: '灯笼袖'
    },
    {
      code: 'E009',
      name: '羊腿袖'
    },
    {
      code: 'E010',
      name: '和服袖'
    },
    {
      code: 'E011',
      name: '其他'
    }
  ],
  // 袖长/裤腿
  sleeveLengths: [{
      code: 'F001',
      name: '中袖/五分袖'
    },
    {
      code: 'F002',
      name: '无袖'
    },
    {
      code: 'F003',
      name: '盖肩袖'
    },
    {
      code: 'F004',
      name: '七分袖'
    },
    {
      code: 'F005',
      name: '短袖'
    },
    {
      code: 'F006',
      name: '长袖'
    },
    {
      code: 'F007',
      name: '九分袖'
    },
    {
      code: 'F008',
      name: '加长袖'
    },
    {
      code: 'F009',
      name: '其他'
    }
  ],
  // 图案
  decorativePatterns: [{
      code: 'G001',
      name: '几何'
    },
    {
      code: 'G002',
      name: '纯色'
    },
    {
      code: 'G003',
      name: '动物'
    },
    {
      code: 'G004',
      name: '字母/数字/文字'
    },
    {
      code: 'G005',
      name: '动漫/卡通'
    },
    {
      code: 'G006',
      name: '涂鸦'
    },
    {
      code: 'G007',
      name: '植物'
    },
    {
      code: 'G008',
      name: '头像'
    },
    {
      code: 'G009',
      name: '格子'
    },
    {
      code: 'G010',
      name: '拼接色'
    },
    {
      code: 'G011',
      name: '迷彩'
    },
    {
      code: 'G012',
      name: '条纹'
    },
    {
      code: 'G013',
      name: '其他'
    }
  ],
  // 流行元素
  popularElements: [{
      code: 'H001',
      name: '铆钉'
    },
    {
      code: 'H002',
      name: '亮片'
    },
    {
      code: 'H003',
      name: '拉链'
    },
    {
      code: 'H004',
      name: '流苏'
    },
    {
      code: 'H005',
      name: '镂空'
    },
    {
      code: 'H006',
      name: '绣花'
    },
    {
      code: 'H007',
      name: '镶钻'
    },
    {
      code: 'H008',
      name: '做旧/洗水'
    },
    {
      code: 'H009',
      name: '印花'
    },
    {
      code: 'H010',
      name: '植绒'
    },
    {
      code: 'H011',
      name: '蕾丝'
    },
    {
      code: 'H012',
      name: '其他'
    }
  ],
  // 填充物
  productFillers: [{
      code: 'J001',
      name: '鸭绒'
    },
    {
      code: 'J002',
      name: '鹅绒'
    },
    {
      code: 'J003',
      name: '洗水棉'
    },
    {
      code: 'J004',
      name: '珍珠棉'
    },
    {
      code: 'J005',
      name: '太空棉'
    },
    {
      code: 'J006',
      name: '涤纶棉'
    }
  ],
  // 厚薄
  productThicknesses: [{
      code: 'K001',
      name: '薄款'
    },
    {
      code: 'K002',
      name: '适中'
    },
    {
      code: 'K003',
      name: '加厚'
    },
    {
      code: 'K004',
      name: '加绒'
    },
    {
      code: 'K005',
      name: '抓绒'
    },
    {
      code: 'K006',
      name: '毛内胆'
    },
    {
      code: 'K007',
      name: '棉内胆'
    }
  ],
  // 季节
  productSeasons: [{
      code: 'L001',
      name: '春季'
    },
    {
      code: 'L002',
      name: '夏季'
    },
    {
      code: 'L003',
      name: '秋季'
    },
    {
      code: 'L004',
      name: '冬季'
    },
    {
      code: 'L005',
      name: '春夏'
    },
    {
      code: 'L006',
      name: '秋冬'
    },
    {
      code: 'L007',
      name: '四季'
    }
  ],
  // 门襟
  plackets: [{
      code: 'M001',
      name: '拉链'
    },
    {
      code: 'M002',
      name: '单排扣'
    },
    {
      code: 'M003',
      name: '双排扣'
    },
    {
      code: 'M004',
      name: '暗扣'
    },
    {
      code: 'M005',
      name: '牛角扣'
    }
  ],
  ageRanges: [{
      code: 'AR001',
      name: '0-6'
    },
    {
      code: 'AR002',
      name: '7-12'
    },
    {
      code: 'AR003',
      name: '13-17'
    },
    {
      code: 'AR004',
      name: '18-23'
    },
    {
      code: 'AR005',
      name: '24-30'
    },
    {
      code: 'AR006',
      name: '31-40'
    },
    {
      code: 'AR007',
      name: '41以上'
    }
  ],
  priceRanges: [{
      code: 'PR001',
      name: '0-60'
    },
    {
      code: 'PR002',
      name: '61-120'
    },
    {
      code: 'PR003',
      name: '121-200'
    },
    {
      code: 'PR004',
      name: '201-300'
    },
    {
      code: 'PR005',
      name: '301-500'
    },
    {
      code: 'PR006',
      name: '500以上'
    }
  ],
  // 产值
  scaleRanges: [{
      code: 'SR001',
      name: '0-100万元'
    },
    {
      code: 'SR002',
      name: '100万元-500万元'
    },
    {
      code: 'SR003',
      name: '500万元-1000万元'
    },
    {
      code: 'SR004',
      name: '1000万元-5000万元'
    },
    {
      code: 'SR005',
      name: '5000万元以上'
    }
  ],
  // 月均产能
  monthlyCapacityRanges: [{
      code: 'MCR001',
      name: '0-5000件'
    },
    {
      code: 'MCR002',
      name: '5000-10000件'
    },
    {
      code: 'MCR003',
      name: '10000-30000件'
    },
    {
      code: 'MCR004',
      name: '30000件以上'
    }
  ],
  // 合作方式
  cooperationModes: [{
      code: 'LABOR_AND_MATERIAL',
      name: '包工包料'
    },
    {
      code: 'LIGHT_PROCESSING',
      name: '清加工'
    }
  ],
  // 人数
  populationScales: [{
      code: 'N01',
      name: '50人以下'
    },
    {
      code: 'N02',
      name: '51-100人'
    },
    {
      code: 'N03',
      name: '101-200人'
    },
    {
      code: 'N04',
      name: '200人以上'
    }
  ],
  // 生产模式
  ProductionModes: [{
      code: 'SINGLE_PIECE_PRODUCTION_LINE',
      name: '单件流水生产线'
    },
    {
      code: 'HANGING_PRODUCTION_LINE',
      name: '吊挂生产流水线'
    },
    {
      code: 'PIPELINE_PRODUCTION_LINE',
      name: '扎流生产线'
    }
  ],
  // 设计
  FactoryDesign: [{
      code: 'SUPPORTED',
      name: '支持'
    },
    {
      code: 'NOT_SUPPORTED',
      name: '不支持'
    }
  ],
  // 打板
  FactoryPattern: [{
      code: 'SUPPORTED',
      name: '支持'
    },
    {
      code: 'NOT_SUPPORTED',
      name: '不支持'
    }
  ],
  // 免费打样
  FactoryFreeProofing: [{
      code: 'SUPPORTED',
      name: '支持'
    },
    {
      code: 'NOT_SUPPORTED',
      name: '不支持'
    }
  ],
  // 服务
  FactoryService: [{
      code: 'SUPPORTED',
      name: '支持'
    },
    {
      code: 'NOT_SUPPORTED',
      name: '不支持'
    }
  ],
  // 质量等级
  FactoryQualityLevel: [{
      code: 'A_CHAIN',
      name: '一线大牌'
    },
    {
      code: 'REGIONAL_CHAIN',
      name: '区域品牌'
    },
    {
      code: 'STALL_WHOLESALE',
      name: '档口精品'
    },
    {
      code: 'ELECTRONIC_COMMERCE_QUALITY',
      name: '电商品质'
    },
    {
      code: 'WHOLESALE_TRADE',
      name: '外贸跑量'
    }
  ],
  // 裁剪部
  CuttingDepartment: [{
      code: 'COMPUTER_AUTOMATIC_CUTTING_MACHINE',
      name: '电脑全自动裁床'
    },
    {
      code: 'MANUAL_BED_CUTTING',
      name: '手工裁床'
    },
    {
      code: 'FULLY_AUTOMATIC_BROACHING_MACHINE',
      name: '全自动拉布机'
    },
    {
      code: 'SHRINKING_MACHINE',
      name: '缩水机'
    },
    {
      code: 'PRESSING_MACHINE',
      name: '压朴机'
    },
    {
      code: 'PLATE_CHANGING_MACHINE',
      name: '改板机'
    },
    {
      code: 'LOOSENING_MACHINE',
      name: '松布机'
    },
    {
      code: 'CLOTH_INSPECTING_MACHINE',
      name: '验布机'
    }
  ],
  // 生产车间
  ProductionWorkshop: [{
      code: 'COMPUTERIZED_FLATCAR',
      name: '电脑平车'
    },
    {
      code: 'COMPUTERIZED_THREE_LINE_OVERLOCK_SEWING_MACHINE',
      name: '电脑三线包缝机'
    },
    {
      code: 'COMPUTER_FIVE_LINE_SEWING_MACHINE',
      name: '电脑五线拼缝机'
    },
    {
      code: 'TWIN_NEEDLES_MACHINE',
      name: '双针车'
    },
    {
      code: 'POCKET_HOLE_SEWING_MACHINE',
      name: '开袋机'
    },
    {
      code: 'KNIFE_MACHINE',
      name: '刀车'
    },
    {
      code: 'FLATLOCK_MACHINE',
      name: '冚车'
    },
    {
      code: 'CHAIN_STITCH_FEED_OFF_ARM_MACHINE',
      name: '埋夹车'
    },
    {
      code: 'FOUR_LINE_FLAT_SEWING_MACHINE',
      name: '四线平缝车'
    },
    {
      code: 'FULLY_AUTOMATIC_TEMPLATE_MACHINE',
      name: '全自动模板车'
    },
    {
      code: 'AUTOMATIC_BAG_STICKING_MACHINE',
      name: '自动贴袋车'
    },
    {
      code: 'WOOL_FILLING_MACHINE',
      name: '充绒机'
    },
    {
      code: 'ZIGZAG_SEWING_MACHINE',
      name: '人字车'
    }
  ],
  // 尾部
  LastDepartment: [{
      code: 'EYELET_END_MACHINE',
      name: '凤眼车'
    },
    {
      code: 'DIRECT_EYE_MACHINE',
      name: '直眼车'
    },
    {
      code: 'BUTTON_ATTACHING_MACHINE',
      name: '钉扣机'
    },
    {
      code: 'JUJUBE_PRINTER_MACHINE',
      name: '打枣机'
    },
    {
      code: 'RIVET_MACHINE',
      name: '撞钉机'
    },
    {
      code: 'BLINDING_MACHINE',
      name: '挑脚机'
    },
    {
      code: 'BAHT_EDGE_MACHINE',
      name: '铢边'
    },
    {
      code: 'BRACE_MACHINE',
      name: '拉筋机'
    },
    {
      code: 'SUCTION_LINE_MACHINE',
      name: '吸线机'
    },
    {
      code: 'NEEDLE_INSPECTING_MACHINE',
      name: '验针机'
    }
  ],
  // 合同状态
  contractStates: [{
      code: 'INITIATE',
      name: '未签署'
    },
    {
      code: 'COMPLETE',
      name: '已签署'
    },
    {
      code: 'INVALID',
      name: '已作废'
    },
    {
      code: 'PARTY_A_SIGN',
      name: '待甲方签署'
    },
    {
      code: 'PARTY_B_SIGN',
      name: '待乙方签署'
    }
  ],
  contractStatesQuery: [{
      code: 'WAIT_SIGN',
      name: '待签署'
    },
    {
      code: 'COMPLETE',
      name: '已签署'
    },
    {
      code: 'INVALID',
      name: '已作废'
    }

  ],
  // 印章状态
  sealStates: [{
      code: 'NORMAL',
      name: '正常'
    },
    {
      code: 'DISABLING',
      name: '禁用'
    }
  ],
  // 订单类型
  salesApplication: [{
      code: 'BELOW_THE_LINE',
      name: '线下订单'
    },
    {
      code: 'ONLINE',
      name: '线上订单'
    }
  ],
  // 模板类型
  TemplateType: [{
      code: 'BCXY',
      name: '补充协议'
    },
    {
      code: 'WTSCHT',
      name: '委托生产合同'
    },
    {
      code: 'CGDD',
      name: '采购订单'
    },
    {
      code: 'KJXY',
      name: '框架协议'
    }
  ],
  // 支付类型
  PaymentType: [{
      code: 'PARTPAID',
      name: '部分付款'
    },
    {
      code: 'ALLPAID',
      name: '全部付款'
    }
  ],
  ReceiptType: [{
      code: 'PARTPAID',
      name: '部分收款'
    },
    {
      code: 'ALLPAID',
      name: '全部收款'
    }
  ],
  // 账期支付方式
  PayPlanType: [{
      code: 'PHASEONE',
      name: '一期款'
    },
    {
      code: 'PHASETWO',
      name: '二期款'
    },
    {
      code: 'MONTHLY_SETTLEMENT',
      name: '月结'
    }
  ],
  // 账期支付类型
  PayMoneyType: [{
      code: 'DEPOSIT',
      name: '定金'
    },
    {
      code: 'PHASEONE',
      name: '1期尾款'
    },
    {
      code: 'PHASETWO',
      name: '2期尾款'
    },
    {
      code: 'MONTHLY_SETTLEMENT',
      name: '月结'
    }
  ],
  TriggerEvent: [{
      code: 'ORDER_CONFIRMED',
      name: '确认订单'
    },
    {
      code: 'CONTRACT_SIGNED',
      name: '签署合同'
    },
    {
      code: 'DELIVERY_CONFIRMED',
      name: '确认收货'
    },
    {
      code: 'RECONCILIATION_CONFIRMED',
      name: '确认对账'
    },
    {
      code: 'INVOICE_RECEIVED',
      name: '收到发票'
    }
  ],
  TriggerType: [{
      code: 'INSIDE',
      name: '以内'
    },
    {
      code: 'OUTSIDE',
      name: '以外'
    }
  ],
  CooperatorType: [{
      code: 'ONLINE',
      name: '线上合作商'
    },
    {
      code: 'OFFLINE',
      name: '自定义合作商'
    }
  ],
  CooperatorCategory: [{
      code: 'SUPPLIER',
      name: '供应商'
    },
    {
      code: 'CUSTOMER',
      name: '客户'
    }
  ],
  // 收货单、对账单状态
  RemarksOrderStatus: [{
    code: 'PENDING_CONFIRM',
    name: '待确认'
  }, {
    code: 'IN_PRODUCTION',
    name: '生产中'
  }, {
    code: 'WAIT_FOR_OUT_OF_STORE',
    name: '待出库'
  }, {
    code: 'OUT_OF_STORE',
    name: '已出库'
  }, {
    code: 'COMPLETED',
    name: '已完成'
  }, {
    code: 'UNCOMMITTED',
    name: '未提交'
  }, {
    code: 'APPROVED',
    name: '已确定'
  }],
  // 质量等级
  SalesMarkets: [{
      code: 'A_CHAIN',
      name: '一线大牌'
    },
    {
      code: 'REGIONAL_CHAIN',
      name: '区域品牌'
    },
    {
      code: 'STALL_WHOLESALE',
      name: '档口精品'
    },
    {
      code: 'ELECTRONIC_COMMERCE_QUALITY',
      name: '电商品质'
    },
    {
      code: 'WHOLESALE_TRADE',
      name: '外贸跑量'
    }
  ],
  // 有效期限
  EffectiveDays: [{
      code: '7',
      name: '7天'
    },
    {
      code: '15',
      name: '15天'
    },
    {
      code: '30',
      name: '30天'
    },
    {
      code: '90',
      name: '90天'
    },
    {
      code: 'null',
      name: '长期有效'
    }
  ],
  /// 生产进度单据状态
  ProgressOrderStatus: [{
    code: 'PASS',
    name: '通过'
  }, {
    code: 'CANCEL',
    name: '作废'
  }],
  /// 产品类型
  ProductTypes: [{
      code: 'SPOT_GOODS',
      name: '现货'
    },
    {
      code: 'FUTURE_GOODS',
      name: '期货'
    },
    {
      code: 'TAIL_GOODS',
      name: '库存尾货'
    }
  ],
  SeeProductPlateType: [{
      code: 'TODAY_NEW',
      name: '今日新款'
    },
    {
      code: 'SEASON_HOT',
      name: '当季爆款'
    },
    {
      code: 'LIVE_BROADCAST_PROVIDE',
      name: '直播专供'
    },
    {
      code: 'RECOMMEND_FOR_YOU',
      name: '为你推荐'
    }
  ],
  MaterialsType: [{
      code: 'PLUS_MATERIAL',
      name: '面料'
    },
    {
      code: 'SUBSIDIARY_MATERIAL',
      name: '辅料'
    },
    {
      code: 'PACK',
      name: '包装'
    }
  ],
  MaterialsUnit: [{
      code: 'INDIVIDUAL',
      name: '个'
    },
    {
      code: 'CM',
      name: '厘米'
    },
    {
      code: 'MEASURE',
      name: '条'
    },
    {
      code: 'SHEET',
      name: '张'
    },
    {
      code: 'KE',
      name: '颗'
    },
    {
      code: 'KG',
      name: '千克'
    },
    {
      code: 'PACKAGE',
      name: '包'
    },
    {
      code: 'METER',
      name: '米'
    },
    {
      code: 'GRAM',
      name: '克'
    }
  ],
  // 销售企划类型
  SalesProductionOrderType: [{
      code: 'SALES_PLAN',
      name: '销售计划'
    },
    {
      code: 'SALES_ORDER',
      name: '销售订单'
    }
  ],
  // 销售企划订单行审核状态
  SalesProductionAuditStatus: [{
      code: 'NONE',
      name: '未提交'
    },
    {
      code: 'AUDITING',
      name: '审核中'
    },
    {
      code: 'PASSED',
      name: '审核通过'
    },
    {
      code: 'AUDITED_FAILED',
      name: '审核驳回'
    }
  ],
  // 生产任务状态
  ProductionState: [{
      code: 'DISPATCHING',
      name: '未外发'
    },
    {
      code: 'DISPATCHED',
      name: '已外发'
    }
  ],
  // 销售订单状态
  SalesProductionOrderState: [{
    code: 'TO_BE_SUBMITTED',
    name: '待提交'
  }, {
    code: 'TO_BE_ACCEPTED',
    name: '待接单'
  }, {
    code: 'AUDITING',
    name: '审核中'
  }, {
    code: 'AUDIT_REJECTED',
    name: '审核驳回'
  }, {
    code: 'AUDIT_PASSED',
    name: '生产中'
  }, {
    code: 'COMPLETED',
    name: '已完成'
  }, {
    code: 'CANCELED',
    name: '已取消'
  }],
  // 生产工单状态
  ProductionTaskOrderState: [{
    code: 'TO_BE_PRODUCED',
    name: '待生产'
  }, {
    code: 'PRODUCING',
    name: '生产中'
  }, {
    code: 'TO_BE_DELIVERED',
    name: '待出库'
  }, {
    code: 'TO_BE_RECONCILED',
    name: '待对账'
  }, {
    code: 'COMPLETED',
    name: '已完成'
  }, {
    code: 'CANCED',
    name: '已取消'
  }],
  // 工单类型
  ProductionTaskOrderType: [{
    code: 'SELF_PRODUCED',
    name: '自产'
  }, {
    code: 'FOUNDRY_PRODUCTION',
    name: '外发'
  }],
  // 外发订单状态
  OutboundOrderStatuses: [{
    code: 'TO_BE_SUBMITTED',
    name: '待提交'
  }, {
    code: 'AUDITING',
    name: '审核中'
  }, {
    code: 'AUDIT_REJECTED',
    name: '审核驳回'
  }, {
    code: 'TO_BE_ACCEPTED',
    name: '待接单'
  }, {
    code: 'AUDIT_PASSED',
    name: '生产中'
  }, {
    code: 'COMPLETED',
    name: '已完成'
  }, {
    code: 'CANCELED',
    name: '已取消'
  }],
  // 进度工单单据-物料类型状态
  ProgressReportMaterialStatus: [{
    code: 'ALL_CANCELLED',
    name: '全部完成'
  }, {
    code: 'PARTIALLY_COMPLETED',
    name: '部分完成'
  }, {
    code: 'PURCHASING',
    name: '采购中'
  }, {
    code: 'NOT_PURCHASED',
    name: '未采购'
  }],
  // 进度工单单据-产前样类型状态
  ProgressReportSampleStatus: [{
      code: 'IN_APPROVAL',
      name: '审核中'
    },
    {
      code: 'APPROVED',
      name: '审核通过'
    }
  ],
  // 任务中心-审核状态
  AuditState: [{
    code: 'NONE',
    name: '无'
  }, {
    code: 'AUDITING',
    name: '审核中'
  }, {
    code: 'PASSED',
    name: '审核通过'
  }, {
    code: 'AUDITED_FAILED',
    name: '审核驳回'
  }, {
    code: 'REVOKED',
    name: '撤回'
  }],
  // 进度工单-优先级
  priorities: [{
    code: 1,
    name: '普通'
  }, {
    code: 2,
    name: '加急'
  }, {
    code: 3,
    name: '特急'
  }],
  AuditLabel: [{
    code: 'SalesOrder',
    name: '销售订单'
  }, {
    code: 'SalesPlan',
    name: '销售计划'
  }, {
    code: 'OutboundOrder',
    name: '外发订单'
  }, {
    code: 'ReconciliationSheet',
    name: '对账单'
  }, {
    code: 'OriginReconciliationSheet',
    name: '对账单'
  }, {
    code: 'PaymentRequestTask',
    name: '付款申请单'
  }],
  // 外发模式
  ManagementMode: [{
    code: 'COLLABORATION',
    name: '协同'
  }, {
    code: 'AUTOGESTION',
    name: '自管'
  }],

  ////////////////////////////////////          收发货

  //发货单状态
  ShippingSheetState: [{
      code: 'PENDING_RECEIVED',
      name: '待收货'
    }, {
      code: 'PENDING_RETURNED',
      name: '待退货'
    }, {
      code: 'RETURNING',
      name: '退货中'
    }, {
      code: 'PENDING_RECONSIDER',
      name: '待复议'
    }, {
      code: 'IN_RECONSIDER',
      name: '复议中'
    }, {
      code: 'RECONSIDER_EXPIRED',
      name: '复议过期'
    },
    {
      code: 'IN_RECONCILED',
      name: '对账中'
    },
    {
      code: 'COMPLETED',
      name: '已完成'
    },

    //收货单状态
    {
      code: 'PENDING_VERIFIED',
      name: '待核验'
    }, {
      code: 'VERIFIED',
      name: '已核验'
    }, {
      code: 'PENDING_RECONCILED',
      name: '待对账'
    },

    //退货单状态  
    {
      code: 'RETURN_TO_BE_RECEIVED',
      name: '退货待收'
    },
    {
      code: 'RETURN_RECEIVED',
      name: '退货已收'
    },

    //复议单状态
    {
      code: 'RECONSIDER_SUCCESS',
      name: '复议成功'
    },
    {
      code: 'RECONSIDER_FAIL',
      name: '复议失败'
    },
  ],

  //收发货任务状态
  ReceiveDispatchTaskState: [{
    code: 'PENDING_DELIVERY',
    name: '待发货'
  }, {
    code: 'IN_DELIVERY',
    name: '发货中'
  }, {
    code: 'COMPLETED',
    name: '已完成'
  }, ],


  //对账单状态
  ReconciliationOrderState: [{
      code: 'PENDING_CONFIRM',
      name: '待确认'
    }, {
      code: 'PENDING_APPROVAL',
      name: '待审批'
    },
    {
      code: 'APPROVAL_RETURN',
      name: '审批驳回'
    },
    {
      code: 'REJECTED',
      name: '已拒绝'
    }, {
      code: 'CONFIRMED',
      name: '已确认'
    },
  ],

  //对账任务状态
  ReconciliationTaskState: [{
      code: 'INIT',
      name: '初始'
    },
    {
      code: 'PENDING_RECONCILIATION',
      name: '待对账'
    }, {
      code: 'IN_RECONCILIATION',
      name: '对账中'
    }, {
      code: 'COMPLETED',
      name: '已完成'
    },
  ],
  // 应收付状态
  financialState: [{
    code: 'WAIT_TO_PAY',
    name: '待付款'
  }, {
    code: 'PAYING',
    name: '付款中'
  }, {
    code: 'SETTLED',
    name: '已完成'
  }],
  // 请款单状态
  PaymentRequestState: [{
    code: 'AUDITING',
    name: '待审核',
  }, {
    code: 'AUDIT_FAIL',
    name: '已驳回'
  }, {
    code: 'WAIT_TO_PAY',
    name: '待付款'
  }, {
    code: 'PAID',
    name: '已付款'
  }],
  // 付款类型
  PaymentMethod: [{
    code: 'E_BANK',
    name: '网银'
  }, {
    code: 'CASH',
    name: '现金'
  }, {
    code: 'ACCEPTANCE',
    name: '承兑'
  }, {
    code: 'ALIPAY',
    name: '支付宝'
  }, {
    code: 'WECHAT_PAY',
    name: '微信支付'
  }]
};

const mutations = {};

const actions = {};

const getters = {};

export default {
  namespaced: true,
  state,
  mutations,
  actions,
  getters
}
