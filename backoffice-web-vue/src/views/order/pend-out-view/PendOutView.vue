<!--
* @Description: 平台端查看所有外接外发单列表
* @Date 2021/07/02 10:50
* @Author L.G.Y
-->
<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <div class="orders-list-title">
          <h6>订单列表</h6>
        </div>
      </el-row>
      <div class="pt-2"></div>
      <pend-out-view-toolbar :queryFormData="queryFormData" @onAdvancedSearch="onAdvancedSearch" @onExport="onExport"
        @onExportByBill="onExportByBill" />
      <el-tabs v-model="activeName" @tab-click="handleClick">
        <template v-for="item in statuses">
          <el-tab-pane :label="item.name" :name="item.code" :key="item.code">
            <pend-out-view-list :page="page" @onAdvancedSearch="onAdvancedSearch" />
          </el-tab-pane>
        </template>
      </el-tabs>
    </el-card>
  </div>
</template>

<script>
  import {
    createNamespacedHelpers
  } from 'vuex';

  const {
    mapGetters,
    mapActions,
  } = createNamespacedHelpers(
    'PendOutOrderModule'
  );

  import PendOutViewToolbar from './toolbar/PendOutViewToolbar'
  import PendOutViewList from './list/PendOutViewList'

  import {
    formatDate
  } from '@/common/js/filters';
  import {
    exportTable
  } from '@/common/js/export'

  import {
    accMul
  } from '@/common/js/number';


  export default {
    name: 'PendOutView',
    components: {
      PendOutViewToolbar,
      PendOutViewList
    },
    computed: {
      ...mapGetters({
        page: 'page',
        keyword: 'keyword',
        queryFormData: 'queryFormData'
      }),
    },
    methods: {
      ...mapActions({
        searchAdvanced: 'searchAdvanced'
      }),
      onAdvancedSearch(page, size) {
        const query = this.queryFormData;

        const url = this.apis().searchPendOut();
        this.searchAdvanced({
          url,
          query,
          page,
          size
        });
      },
      handleClick(tab, event) {
        this.queryFormData.state = tab.name;
        this.onAdvancedSearch(0, this.page.size);
      },
      async onExport() {
        const totalElements = this.page.totalElements

        const exportData = await this.getExportData(totalElements)
        exportTable(exportData, '交易订单')
      },
      async getExportData(totalElements) {
        const query = this.queryFormData;

        const url = this.apis().searchPendOut();
        const result = await this.$http.post(url, query, {
          page: 0,
          size: totalElements
        })

        let exportData = [];
        exportData = result.content.map(e => {
          return {
            订单号: e.code,
            甲方公司: e.originCooperator ? e.originCooperator.name : '',
            乙方公司: e.belongTo ? e.belongTo.name : '',
            款数: e.entrySize ? e.entrySize : '',
            订单数量: e.totalQuantity ? e.totalQuantity : '',
            '服务费比例(%)': e.serviceFeePercent ? accMul(e.serviceFeePercent, 100) : '',
            订单金额: e.totalPrimeCost ? e.totalPrimeCost : '',
            结算金额: e.onlinePaidAmount ? e.onlinePaidAmount : '',
            创建时间: e.creationtime ? formatDate(new Date(e.creationtime), 'yyyy-MM-dd hh:mm:ss') : '',
            订单状态: this.getEnum('SalesProductionOrderState', e.state)
          }
        })

        return exportData
      },
      async onExportByBill() {
        const totalElements = this.page.totalElements

        const exportData = await this.getExportDataByBill(totalElements)
        exportTable(exportData, '交易流水订单')
      },
      async getExportDataByBill(totalElements) {
        const query = this.queryFormData;

        const url = this.apis().searchPendOut();
        const result = await this.$http.post(url, query, {
          page: 0,
          size: totalElements
        })

        let exportData = [];
        result.content.filter(item => item.paymentOrders && item.paymentOrders.length > 0).forEach(e => {
          e.paymentOrders.filter(i => i.state === 'PAID').forEach(paymentOrder => {
            exportData.push({
              订单号: e.code,
              线上支付: paymentOrder.orderType == 'offline' ? '否' : '是',
              商户订单号: paymentOrder.code,
              流水单号: paymentOrder.outOrderNo,
              流水金额: paymentOrder.totalAmount ? paymentOrder.totalAmount : paymentOrder.payAmount,
              流水支付时间: paymentOrder.paySuccessTime ? formatDate(new Date(paymentOrder.paySuccessTime),
                'yyyy-MM-dd hh:mm:ss') : '',
              甲方公司: e.originCooperator ? e.originCooperator.name : '',
              乙方公司: e.belongTo ? e.belongTo.name : '',
              款数: e.entrySize ? e.entrySize : '',
              订单数量: e.totalQuantity ? e.totalQuantity : '',
              '服务费比例(%)': e.serviceFeePercent ? accMul(e.serviceFeePercent, 100) : '',
              订单金额: e.totalPrimeCost ? e.totalPrimeCost : '',
              结算金额: e.onlinePaidAmount ? e.onlinePaidAmount : '',
              创建时间: e.creationtime ? formatDate(new Date(e.creationtime), 'yyyy-MM-dd hh:mm:ss') : '',
              订单状态: this.getEnum('SalesProductionOrderState', e.state)
            })
          })
        })

        return exportData
      }
    },
    data() {
      return {
        activeName: '',
        statuses: [{
          code: '',
          name: '全部'
        }, {
          code: 'TO_BE_SUBMITTED',
          name: '待提交'
        }, {
          code: 'AUDITING',
          name: '待审核'
        }, {
          code: 'AUDIT_REJECTED',
          name: '审核驳回'
        }, {
          code: 'TO_BE_ACCEPTED',
          name: '待确认'
        }, {
          code: 'AUDIT_PASSED',
          name: '生产中'
        }, {
          code: 'COMPLETED',
          name: '已完成'
        }, {
          code: 'CANCELED',
          name: '已取消'
        }]
      }
    },
    created() {
      this.onAdvancedSearch();
    }
  }

</script>

<style scoped>

</style>
