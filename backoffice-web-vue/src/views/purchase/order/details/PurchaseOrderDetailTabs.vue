<template>
  <div>
    <div class="over-tabs">
      <el-row type="flex">
        <template v-if="activeName === 'ACCEPTANCE'">
          <el-button class="material-btn" @click="onEdit">编辑</el-button>
          <el-button class="material-btn" @click="receiveComplete">收料完成</el-button>
        </template>
        <template v-if="activeName === 'FINANCE'">
          <el-button class="material-btn" style="width: 120px" @click="createPaymentOrder">创建付款申请单</el-button>
        </template>
      </el-row>
    </div>
    <el-tabs type="border-card" v-model="activeName" @tab-click="handleClick">
      <el-tab-pane label="物料验收" name="ACCEPTANCE">
        <purchase-material-acceptance :order="order"/>
        <el-row type="flex" justify="end">
          <h6>变更时间：2020.09.23</h6>
        </el-row>
      </el-tab-pane>
      <el-tab-pane label="财务信息" name="FINANCE">
        <el-table>
          <el-table-column label="付款次数"></el-table-column>
          <el-table-column label="付款方式"></el-table-column>
          <el-table-column label="付款金额"></el-table-column>
          <el-table-column label="付款内容"></el-table-column>
          <el-table-column label="付款时间"></el-table-column>
          <el-table-column label="付款凭证"></el-table-column>
        </el-table>
      </el-tab-pane>
    </el-tabs>
  </div>
</template>

<script>
import PurchaseMaterialAcceptance from '../components/PurchaseMaterialAcceptance'

export default {
  name: 'PurchaseOrderDetailTabs',
  props: ['order'],
  components: {
    PurchaseMaterialAcceptance
  },
  methods: {
    handleClick (tab, event) {
      this.activeName = tab.name;
    },
    onEdit () {

    },
    receiveComplete () {

    },
    createPaymentOrder () {

    }
  },
  data () {
    return {
      activeName: 'ACCEPTANCE'
    }
  }
}
</script>

<style scoped>
  .over-tabs {
    position: absolute;
    z-index: 100;
    right: 50px;
    margin-top: 2px;
  }

  .material-btn {
    background-color: #ffd60c;
    border-color: #FFD5CE;
    color: #000;
    width: 90px;
    height: 35px;
  }
</style>