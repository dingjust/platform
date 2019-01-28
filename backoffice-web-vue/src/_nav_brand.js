export default {
  items: [
    {
      title: true,
      name: "品牌",
      class: "",
      wrapper: {
        element: "span",
        attributes: {}
      }
    },
    {
      name: "仪表盘",
      url: "/brand/dashboard",
      icon: "icon-speedometer"
    },
    {
      name: "产品管理",
      url: "/brand/product",
      icon: "icon-puzzle",
      children: [
        {
          name: "产品",
          url: "/brand/product/product",
          icon: "fa fa-check",
          children:[
            {
              name: "产品",
              url: "/brand/product",
              icon: "iconNone",
            },
            {
              name: "产品（已删除）",
              url: "/brand/product/deleted",
              icon: "iconNone",
            }
          ]
        },
        {
          name: "库存",
          url: "/brand/product/inventory",
          icon: "iconNone"
        }
      ]
    },
    {
      name: "订单管理",
      url: "/brand/order",
      icon: "icon-puzzle",
      children: [
        {
          name: "销售订单",
          url: "/brand/order/order",
          icon: "iconNone"
        },
        {
          name: "需求订单",
          url: "/brand/order/request",
          icon: "iconNone"
        },
        {
          name: "生产订单",
          url: "/brand/order/consignment",
          icon: "iconNone"
        }
      ]
    },
    {
      name: "报表管理",
      url: "/brand/report",
      icon: "icon-puzzle",
      children: [
        {
          name: "销售报表",
          url: "/brand/report/sales",
          icon: "iconNone"
        },
        {
          name: "库存报表",
          url: "/brand/report/inventory",
          icon: "iconNone"
        },
        {
          name: "订单报表",
          url: "/brand/report/order",
          icon: "iconNone"
        }
      ]
    },
    {
      name: "店铺管理",
      url: "/brand/account",
      icon: "icon-puzzle",
      children: [
        {
          name: "店铺",
          url: "/brand/account/store",
          icon: "iconNone"
        },
        {
          name: "员工",
          url: "/brand/account/employee",
          icon: "iconNone"
        },
        {
          name: "会员",
          url: "/brand/account/member",
          icon: "iconNone"
        },
        {
          name: "组织架构",
          url: "/brand/account/org",
          icon: "iconNone"
        },
        {
          name: "角色",
          url: "/brand/account/role",
          icon: "iconNone"
        },
        {
          name: "我的关注",
          url: "/brand/account/follower",
          icon: "iconNone"
        }
      ]
    }, {
      name: "系统管理",
      url: "/brand/system/zone",
      icon: "icon-puzzle",
      children: [
        {
          name: "运费模板",
          url: "/brand/system/zone",
          icon: "iconNone"
        },
        {
          name:"地址管理",
          url: "/brand/system/address",
          icon: "iconNone"
        }
      ]
    }
  ]
};
