<!--
* @Description: 支付订单列表（平台
* @Date 2021/12/02 11:30
* @Author L.G.Y
-->
<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <div class="orders-list-title">
          <h6>支付单列表</h6>
        </div>
      </el-row>
      <div class="pt-2"></div>
      <payment-toolbar :queryFormData="queryFormData" @onAdvancedSearch="onAdvancedSearch" @onExport="onExport"/>
      <payment-list :page="page" @onAdvancedSearch="onAdvancedSearch"/>
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
  'PaymentOrderModule'
);

import { formatDate } from '@/common/js/filters';
import { exportTable } from '@/common/js/export'

import PaymentToolbar from './toolbar/PaymentToolbar'
import PaymentList from './list/PaymentList'

export default {
  name: 'PaymentOrderPage',
  components: {
    PaymentToolbar,
    PaymentList
  },
  computed: {
    ...mapGetters({
      page: 'page',
      queryFormData: 'queryFormData'
    }),
  },
  methods: {
    ...mapActions({
      searchAdvanced: 'searchAdvanced'
    }),
    onAdvancedSearch(page, size) {
      const query = this.queryFormData;

      const url = this.apis().searchPaymentOrder();
      this.searchAdvanced({ url, query, page, size });
    },
    async onExport () {
      const totalElements = this.page.totalElements
      const exportData = await this.getExportData(totalElements)
      exportTable(exportData, '支付单')
    },
    async getExportData (totalElements) {
      const query = this.queryFormData;

      const url = this.apis().searchPaymentOrder();
      const result = await this.$http.post(url, query, {
        page: 0,
        size: totalElements
      })

      let exportData = [];
      result.content.forEach(item => {
        exportData.push({
          系统单号: item.code,
          关联订单: item.originCode,
          交易编号: item.outOrderNo,
          支付金额: item.totalAmount ? item.totalAmount : item.payAmount,
          支付方式: this.getEnum('PayMethod', item.payType),
          支付时间: item.paySuccessTime ? formatDate(new Date(item.paySuccessTime), 'yyyy-MM-dd hh:mm:ss') : '',
          支付类型: item.orderType === 'offline' ? '线下支付' : '线上支付'
        })
      })
      return exportData
    }
  },
  created() {
    this.onAdvancedSearch();
  }
}
</script>

<style scoped>

</style>
