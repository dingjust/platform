<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row type="flex" justify="space-between">
        <el-col class="list-title">
          <h6>对账单详情</h6>
        </el-col>
        <el-col>
          <h6>出货单号：{{order.code}}</h6>
        </el-col>
        <el-col>
          <h6>创建日期：{{order.creationtime | timestampToTime}}</h6>
        </el-col>
        <el-col>
          <h6>状态：{{getEnum('ReconciliationV2Type', order.state)}}</h6>
        </el-col>
      </el-row>
      <reconciliation-detail-header :order="order" />
      <reconciliation-detail-table class="basic-container" v-if="order.id" :order="order"/>
      <el-row type="flex" class="basic-container">
        <div><h6>附件：</h6></div>
        <files-upload :slotData="order.medias" :readOnly="true" :disabled="true"/>
      </el-row>
      <template v-if="order.auditWorkOrder && order.auditWorkOrder.processes && order.auditWorkOrder.processes.length > 0">
        <order-audit-detail class="basic-container" :processes="order.auditWorkOrder.processes" />
      </template>
    </el-card>
  </div>
</template>

<script>
import ReconciliationDetailTable from './ReconciliationDetailTable'
import ReconciliationDetailHeader from './ReconciliationDetailHeader'
import { OrderAuditDetail } from '@/views/order/salesProduction/components/'
import { FilesUpload } from '@/components'

export default {
  name: 'ReconciliationOrdersDetailV2',
  props: ['id'],
  components: {
    ReconciliationDetailTable,
    OrderAuditDetail,
    FilesUpload,
    ReconciliationDetailHeader
  },
  data () {
    return {
      order: {
        receiveParty: {},
        shipParty: {}
      }
    }
  },
  methods: {
    async getDetail () {
      const url = this.apis().getReconciliationV2Detail(this.id);
      const result = await this.$http.get(url);

      if (result['errors']) {
        this.$message.error(result['errors'][0].message);
        return;
      }
      if (result.code === 0) {
        this.$message.error(result.msg);
        return;
      }

      this.order = result.data;  
    },
  },
  created () {
    this.getDetail();
  }
}
</script>

<style scoped>
  .list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
    height: 16px;
  }

  .basic-container {
    margin: 0 0 20px 12px;
  }

</style>