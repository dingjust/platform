<template>
  <div class="animated fadeIn dashboard-card">
    <el-row type="flex" justify="space-between" align="middle">
      <h6 style="margin: 0px">待办事项</h6>
      <i class="el-icon-setting dashboard-setting-btn">设置</i>
    </el-row>
    <div style="display: flex;flex-wrap: wrap;">
      <template v-for="(item, Index) in ToDoList">
        <div :key="Index" class="list-contaner" v-if="item.isAuth">
          <div class="list-title">
            <h6 style="font-size: 14px">{{item.name}}</h6>
          </div>
          <div style="display: flex;">
            <template v-for="(val, listIndex) in item.list">
              <div :key="listIndex" class="content-title" style="margin-right: 15px">
                <el-button class="todo-button" type="text" @click="toJump(item)">
                  <h6>
                    <span style="font-size: 20px">{{reportData[val.title]}}</span>
                    <span style="font-size: 12px"> {{val.text}}</span>
                  </h6>
                </el-button>
              </div>
            </template>
          </div>
        </div>
      </template>
    </div>
  </div>
</template>

<script>
  export default {
    name: 'BusinessCard',
    components: {

    },
    computed: {
    },
    methods: {
      async getData() {
        const url = this.apis().getCompanyReport();
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.reportData = result;

        this.initData();
      },
      initData () {
        const permissions = sessionStorage.getItem('permissions');
        if (permissions != undefined && permissions != null && permissions != 'undefined' && permissions != 'null' && permissions != '') {
          const authList = JSON.parse(permissions);
          this.ToDoList.forEach(item => {
            if (authList.indexOf(item.auth) >= 0) {
              this.$set(item, 'isAuth', true);
            } else {
              this.$set(item, 'isAuth', false);
            }
          })
        }
      },
      toJump (item) {
        switch (item.auth) {
          case 'AUDIT_TASK':
            this.$router.push('/task/approval');
            break;
          case 'SALES_OUT_ORDER':
            this.$router.push('/sales/pending-order');
            break;
          case 'PRODUCTION_TASK_ORDER':
            this.$router.push('/sales/productionOrder ');
            break;
          case 'RECEIPT_SHEET':
            this.$router.push('/receipt/shipping-receipt-sheet');
            break;
          case 'SHIPPING_SHEET':
            this.$router.push('/shipping/shipping-receipt-sheet');
            break;
          case 'RECONCILIATION_SHEET':
            this.$router.push('/shipping/reconciliation-manage');
            break;
          case 'COMPANY_AGREEMENT':
            this.$router.push('/contract/manage');
            break;
        }
      }
    },
    data() {
      return {
        reportData: {
          pendingAudit: 0,              // 个未审批
          pendingAccepted: 0,           // 个待接订单
          pendingProduction: 0,         // 个工单待生产
          pendingReceive: 0,            // 个待收货
          pendingReturn: 0,             // 个待退货
          returnToBeReceived: 0,        // 个退货待收
          pendingReconsider: 0,         // 个待复议
          pendingReconciliation: 0,     // 个对账单待确认
          pendingSign: 0                // 个待签署
        },
        ToDoList: [
          {
            name: '审批',
            list: [{
              title: 'pendingAudit',
              text: '个未审批',
            }],
            auth: 'AUDIT_TASK'
          }, {
            name: '订单',
            list: [{
              title: 'pendingAccepted',
              text: '个待接订单',
            }],
            auth: 'SALES_OUT_ORDER'
          }, {
            name: '工单',
            list: [{
              title: 'pendingProduction',
              text: '个工单待生产',
            }],
            auth: 'PRODUCTION_TASK_ORDER'
          }, {
            name: '收货',
            list: [{
              title: 'pendingReceive',
              text: '个待收货'
            }, {
              title: 'pendingReturn',
              text: '个待退货'
            }],
            auth: 'RECEIPT_SHEET'
          }, {
            name: '发货',
            list: [{
              title: 'returnToBeReceived',
              text: '个退货待收'
            }, {
              title: 'pendingReconsider',
              text: '个待复议'
            }],
            auth: 'SHIPPING_SHEET'
          }, {
            name: '对账',
            list: [{
              title: 'pendingReconciliation',
              text: '个对账单待确认'
            }],
            auth: 'RECONCILIATION_SHEET'
          }, {
            name: '合同',
            list: [{
              title: 'pendingSign',
              text: '个待签署'
            }],
            auth: 'COMPANY_AGREEMENT'
          }
        ]
      };
    },
    created() {
      if (!this.isTenant()) {
        this.getData();
      }
    }
  };

</script>
<style scoped>
  .list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .count-title {
    font-size: 14px;
  }

  .content-title {
    margin-left: 10px;
  }

  .list-contaner {
    margin-top: 10px;
    width: 33.33%;
    min-width: 196px;
  }

  .todo-button {
    color: #606266;
  }

  .todo-button:hover {
    color: #409EFF;
  }
</style>
