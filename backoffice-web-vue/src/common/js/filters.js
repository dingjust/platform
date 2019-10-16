export function formatDate (date, fmt) {
  if (!date) {
    return '';
  }
  if (/(y+)/.test(fmt)) {
    fmt = fmt.replace(
      RegExp.$1,
      (date.getFullYear() + '').substr(4 - RegExp.$1.length)
    );
  }
  let o = {
    'M+': date.getMonth() + 1,
    'd+': date.getDate(),
    'h+': date.getHours(),
    'm+': date.getMinutes(),
    's+': date.getSeconds()
  };
  for (let k in o) {
    if (new RegExp(`(${k})`).test(fmt)) {
      let str = o[k] + '';
      fmt = fmt.replace(
        RegExp.$1,
        RegExp.$1.length === 1 ? str : padLeftZero(str)
      );
    }
  }
  return fmt;
}

const ENUMS = {
  // 会员等级
  MemberRating: {
    NORMAL: {
      code: 'NORMAL',
      name: '普通'
    },
    GOLD: {
      code: 'GOLD',
      name: '黄金'
    },
    PLATINUX: {
      code: 'PLATINUX',
      name: '黄金'
    },
    DIAMOND: {
      code: 'DIAMOND',
      name: '铂金'
    }
  },
  // 审核状态
  ArticleApprovalStatus: {
    check: {
      code: 'check',
      name: '等待审核'
    },
    approved: {
      code: 'approved',
      name: '审核通过'
    },
    unapproved: {
      code: 'unapproved',
      name: '审核失败'
    }
  },
  // 订单类型
  OrderType: {
    SALES_ORDER: {
      code: 'SALES_ORDER',
      name: '销售订单'
    },
    REQUIREMENT_ORDER: {
      code: 'REQUIREMENT_ORDER',
      name: '需求订单'
    }
  },
  RequirementOrderStatus: {
    PENDING_QUOTE: {
      code: 'PENDING_QUOTE',
      name: '报价中'
    },
    COMPLETED: {
      code: 'COMPLETED',
      name: '已完成'
    },
    CANCELLED: {
      code: 'CANCELLED',
      name: '已失效'
    }
  },
  // 订单状态
  OrderStatus: {
    WAIT_FOR_PROCESSING: {
      code: 'WAIT_FOR_PROCESSING',
      name: '待处理'
    },
    PENDING_APPROVAL: {
      code: 'PENDING_APPROVAL',
      name: '待确认'
    },
    APPROVED: {
      code: 'APPROVED',
      name: '已确认'
    },
    WAIT_FOR_OUT_OF_STORE: {
      code: 'WAIT_FOR_OUT_OF_STORE',
      name: '待出库'
    },
    OUT_OF_STORE: {
      code: 'OUT_OF_STORE',
      name: '已出库'
    },
    COMPLETED: {
      code: 'COMPLETED',
      name: '已签收'
    },
    PENDING_PAYMENT: {
      code: 'PENDING_PAYMENT',
      name: '待付款'
    },
    PENDING_DELIVERY: {
      code: 'PENDING_DELIVERY',
      name: '待发货'
    },
    SHIPPED: {
      code: 'SHIPPED',
      name: '已发货'
    }
  },
  // 发货单状态
  ConsignmentStatus: {
    WAIT_FOR_ALLOCATION: {
      code: 'WAIT_FOR_ALLOCATION',
      name: '待分配'
    },
    WAIT_FOR_PURCHASE: {
      code: 'WAIT_FOR_PURCHASE',
      name: '备料中'
    },
    PENDING_CUTTING: {
      code: 'PENDING_CUTTING',
      name: '待裁剪'
    },
    CUTTING: {
      code: 'CUTTING',
      name: '裁剪中'
    },
    STITCHING: {
      code: 'STITCHING',
      name: '车缝中'
    },
    QC: {
      code: 'QC',
      name: '待验货'
    },
    PENDING_DELIVERY: {
      code: 'PENDING_DELIVERY',
      name: '待发货'
    },
    DELIVERING: {
      code: 'DELIVERING',
      name: '已发货'
    },
    DELIVERY_COMPLETED: {
      code: 'DELIVERY_COMPLETED',
      name: '已完成'
    }
  },
  // 是否延期状态
  DelayStatus: {
    true: {
      code: 'true',
      name: '是'
    },
    false: {
      code: 'false',
      name: '否'
    }
  },
  // 生产进度
  ProductionProgressPhase: {
    MATERIAL_PREPARATION: {
      code: 'MATERIAL_PREPARATION',
      name: '备料'
    },
    SAMPLE_CONFIRM: {
      code: 'SAMPLE_CONFIRM',
      name: '产前样衣确认'
    },
    CUTTING: {
      code: 'CUTTING',
      name: '裁剪'
    },
    STITCHING: {
      code: 'STITCHING',
      name: '车缝'
    },
    INSPECTION: {
      code: 'INSPECTION',
      name: '验货'
    },
    DELIVERY: {
      code: 'DELIVERY',
      name: '发货'
    }
  },
  // 报价单状态
  QuoteState: {
    WAIT_FOR_CONFIRM: {
      code: 'WAIT_FOR_CONFIRM',
      name: '待处理'
    },
    CONFIRMED: {
      code: 'CONFIRMED',
      name: '已确认'
    }
  },
  // 账单流水来源
  FlowSource: {
    CASH_OUT: {
      code: 'CASH_OUT',
      name: '提现'
    },
    PROOFING: {
      code: 'PROOFING',
      name: '打样单'
    },
    PURCHASE_DEPOSIT: {
      code: 'PURCHASE_DEPOSIT',
      name: '生产单定金'
    },
    PURCHASE_BALANCE: {
      code: 'PURCHASE_BALANCE',
      name: '生产单尾款'
    }
  },
  // 资金流水类型
  AmountFlowType: {
    INFLOW: {
      code: 'INFLOW',
      name: '流入'
    },
    OUTFLOW: {
      code: 'OUTFLOW',
      name: '流出'
    }
  },
  // 资金状态
  AmountStatus: {
    AUDITING: {
      code: 'AUDITING',
      name: '未结算'
    },
    COMPLETED: {
      code: 'COMPLETED',
      name: '已完成'
    },
    CANCELED: {
      code: 'CANCELED',
      name: '已取消'
    },
    REJECTED: {
      code: 'REJECTED',
      name: '已拒绝'
    },
    IN_REVIEW: {
      code: 'IN_REVIEW',
      name: '审核中'
    },
    REVIEWED: {
      code: 'REVIEWED',
      name: '已审核'
    }
  },
  PayStatus: {
    UNPAID: {
      code: 'UNPAID',
      name: '未付'
    },
    PAID: {
      code: 'PAID',
      name: '已付'
    },
    ARREARS: {
      code: 'ARREARS',
      name: '欠款'
    }
  },
  payPlanType: {
    PHASEONE: {
      code: 'PHASEONE',
      name: '一期款'
    },
    PHASETWO: {
      code: 'PHASETWO',
      name: '二期款'
    },
    MONTHLY_SETTLEMENT: {
      code: 'MONTHLY_SETTLEMENT',
      name: '月结'
    }
  },
  // PaymentType: {
  //   PARTPAID: {
  //     code: 'PARTPAID',
  //     name: '部分付款'
  //   },
  //   ALLPAID: {
  //     code: 'ALLPAID',
  //     name: '全部付款'
  //   }
  // },
  TriggerType: {
    INSIDE: {
      code: 'INSIDE',
      name: '以内'
    },
    OUTSIDE: {
      code: 'OUTSIDE',
      name: '以外'
    }
  },
  PayMoneyType: {
    DEPOSIT: {
      code: 'DEPOSIT',
      name: '定金'
    },
    PHASEONE: {
      code: 'PHASEONE',
      name: '一期款'
    },
    PHASETWO: {
      code: 'PHASETWO',
      name: '二期款'
    },
    MONTHLY_SETTLEMENT: {
      code: 'MONTHLY_SETTLEMENT',
      name: '月结'
    }
  },
  TriggerEvent: {
    ORDER_CONFIRMED: {
      code: 'ORDER_CONFIRMED',
      name: '确认订单'
    },
    CONTRACT_SIGNED: {
      code: 'CONTRACT_SIGNED',
      name: '签署合同'
    },
    DELIVERY_CONFIRMED: {
      code: 'DELIVERY_CONFIRMED',
      name: '确认收货'
    },
    RECONCILIATION_CONFIRMED: {
      code: 'RECONCILIATION_CONFIRMED',
      name: '确认对账'
    },
    INVOICE_RECEIVED: {
      code: 'INVOICE_RECEIVED',
      name: '收到发票'
    }
  }
};

export function enumTranslate (enumVal, enumType) {
  if (!ENUMS[enumType][enumVal]) {
    return 'UNKNOWN';
  }

  return ENUMS[enumType][enumVal].name;
}

function padLeftZero (str) {
  return ('00' + str).substr(str.length);
}

export function timestampToTime (timestamp) {
  const date = new Date(timestamp);// 时间戳为10位需*1000，时间戳为13位的话不需乘1000
  const Y = date.getFullYear() + '-';// 此时为四位数字表示 getYear()的话为两位数字表示
  const M = (date.getMonth() + 1 < 10 ? '0' + (date.getMonth() + 1) : date.getMonth() + 1) + '-';// 当前月份(0-11,0代表1月)
  const D = date.getDate() + ' ';// 当前日(1-31)
  /* const h = date.getHours() + ':';
   const  m = (date.getMinutes() < 10 ? '0' + date.getMinutes() : date.getMinutes()) + ':';
   const s = date.getSeconds() + ':';
   const ms = date.getMilliseconds();//毫秒值 */

  return Y + M + D;// 此处可以自定义需要的显示类型
}

export function postponedDays (statuDateList) {
  console.log(statuDateList);
  const estimatedDate = statuDateList[0];
  const finishDate = statuDateList[1];
  const mss = finishDate - estimatedDate;
  const days = parseInt(mss / (1000 * 60 * 60 * 24));
  return days;
}

// 两个数相除
export function numDiv (num1, num2) {
  var baseNum1 = 0, baseNum2 = 0;
  var baseNum3, baseNum4;
  try {
    baseNum1 = num1.toString().split('.')[1].length;
  } catch (e) {
    baseNum1 = 0;
  }
  try {
    baseNum2 = num2.toString().split('.')[1].length;
  } catch (e) {
    baseNum2 = 0;
  }
  baseNum3 = Math.Number(num1.toString().replace('.', ''));
  baseNum4 = Math.Number(num2.toString().replace('.', ''));
  return (baseNum3 / baseNum4) * Math.pow(10, baseNum2 - baseNum1);
};

// 两个数相乘
export function floatFormat (num1, count) {
  return (Math.round(num1 * 100) / 100).toFixed(count);
}
