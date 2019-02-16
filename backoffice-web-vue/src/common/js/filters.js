export function formatDate(date, fmt) {
  if (!date) {
    return "";
  }
  if (/(y+)/.test(fmt)) {
    fmt = fmt.replace(
      RegExp.$1,
      (date.getFullYear() + "").substr(4 - RegExp.$1.length)
    );
  }
  let o = {
    "M+": date.getMonth() + 1,
    "d+": date.getDate(),
    "h+": date.getHours(),
    "m+": date.getMinutes(),
    "s+": date.getSeconds()
  };
  for (let k in o) {
    if (new RegExp(`(${k})`).test(fmt)) {
      let str = o[k] + "";
      fmt = fmt.replace(
        RegExp.$1,
        RegExp.$1.length === 1 ? str : padLeftZero(str)
      );
    }
  }
  return fmt;
}

const ENUMS = {
  //会员等级
  MemberRating: {
    NORMAL: {
      code: "NORMAL",
      name: "普通"
    },
    GOLD: {
      code: "GOLD",
      name: "黄金"
    },
    PLATINUX: {
      code: "PLATINUX",
      name: "黄金"
    },
    DIAMOND: {
      code: "DIAMOND",
      name: "铂金"
    }
  },
  //审核状态
  ArticleApprovalStatus: {
    check: {
      code: "check",
      name: "等待审核"
    },
    approved: {
      code: "approved",
      name: "审核通过"
    },
    unapproved: {
      code: "unapproved",
      name: "审核失败"
    }
  },
  //订单类型
  OrderType: {
    SALES_ORDER: {
      code: "SALES_ORDER",
      name: "销售订单"
    },
    REQUIREMENT_ORDER: {
      code: "REQUIREMENT_ORDER",
      name: "需求订单"
    }
  },
  //订单状态
  OrderStatus: {
    WAIT_FOR_PROCESSING: {
      code: "WAIT_FOR_PROCESSING",
      name: "待处理"
    },
    PENDING_APPROVAL: {
      code: "PENDING_APPROVAL",
      name: "待确认"
    },
    APPROVED: {
      code: "APPROVED",
      name: "已确认"
    },
    WAIT_FOR_OUT_OF_STORE: {
      code: "WAIT_FOR_OUT_OF_STORE",
      name: "待出库"
    },
    OUT_OF_STORE: {
      code: "OUT_OF_STORE",
      name: "已出库"
    },
    COMPLETED: {
      code: "COMPLETED",
      name: "已签收"
    },
    PENDING_PAYMENT: {
      code: "PENDING_PAYMENT",
      name: "待付款"
    },
    PENDING_DELIVERY: {
      code: "PENDING_DELIVERY",
      name: "待发货"
    },
    SHIPPED: {
      code: "SHIPPED",
      name: "已发货"
    }
  },
  //发料单状态
  PickOrderStatus: {
    WAIT_FOR_CONFIRM: {
      code: "WAIT_FOR_CONFIRM",
      name: "待处理"
    },
    CONFIRMED: {
      code: "CONFIRMED",
      name: "已确认"
    }
  },
  // 发货单状态
  ConsignmentStatus: {
    WAIT_FOR_ALLOCATION: {
      code: "WAIT_FOR_ALLOCATION",
      name: "待分配"
    },
    WAIT_FOR_PURCHASE: {
      code: "WAIT_FOR_PURCHASE",
      name: "备料中"
    },
    PENDING_CUTTING: {
      code: "PENDING_CUTTING",
      name: "待裁剪"
    },
    CUTTING: {
      code: "CUTTING",
      name: "裁剪中"
    },
    STITCHING: {
      code: "STITCHING",
      name: "车缝中"
    },
    QC: {
      code: "QC",
      name: "待验货"
    },
    PENDING_DELIVERY: {
      code: "PENDING_DELIVERY",
      name: "待发货"
    },
    DELIVERING: {
      code: "DELIVERING",
      name: "已发货"
    },
    DELIVERY_COMPLETED: {
      code: "DELIVERY_COMPLETED",
      name: "已完成"
    }
  },
  //是否延期状态
  DelayStatus:{
    true:{
      code:"true",
      name:"是"
    },
    false:{
      code:"false",
      name:"否"
    }
  },
  // 生产进度
  ProductionProgressPhase: {
    MATERIAL_PREPARATION: {
      code: "MATERIAL_PREPARATION",
      name: "备料"
    },
    SAMPLE_CONFIRM: {
      code: "SAMPLE_CONFIRM",
      name: "产前样衣确认"
    },
    CUTTING:{
      code: "CUTTING",
      name: "裁剪"
    },
    STITCHING: {
      code: "STITCHING",
      name: "车缝"
    },
    INSPECTION: {
      code: "INSPECTION",
      name: "验货"
    },
    DELIVERY: {
      code: "DELIVERY",
      name: "发货"
    }
  }
};

export function enumTranslate(enumVal, enumType) {
  if (!ENUMS[enumType][enumVal]) {
    return "UNKNOWN";
  }

  return ENUMS[enumType][enumVal].name;
}

function padLeftZero(str) {
  return ("00" + str).substr(str.length);
}

export function timestampToTime(timestamp) {
  const date = new Date(timestamp);//时间戳为10位需*1000，时间戳为13位的话不需乘1000
  const Y = date.getFullYear() + '-';//此时为四位数字表示 getYear()的话为两位数字表示
  const M = (date.getMonth() + 1 < 10 ? '0' + (date.getMonth() + 1) : date.getMonth() + 1) + '-';//当前月份(0-11,0代表1月)
  const D = date.getDate() + ' ';//当前日(1-31)
  /* const h = date.getHours() + ':';
   const  m = (date.getMinutes() < 10 ? '0' + date.getMinutes() : date.getMinutes()) + ':';
   const s = date.getSeconds() + ':';
   const ms = date.getMilliseconds();//毫秒值*/

  return Y + M + D;//此处可以自定义需要的显示类型
}

export function postponedDays (statuDateList) {
  console.log(statuDateList);
  const estimatedDate = statuDateList[0];
  const finishDate = statuDateList[1];
  const mss = finishDate - estimatedDate;
  const days = parseInt(mss / (1000 * 60 * 60 * 24));
  return days;
}
