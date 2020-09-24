<template>
  <div>
    <el-row type="flex" justify="start">
      <el-tabs type="border-card" style="width: 100%">
        <el-tab-pane label="采购单">
          <div style="display: flex;flex-wrap: wrap;">
            <template v-if="purchaseOrderList && purchaseOrderList.length > 0">
              <template v-for="item in purchaseOrderList">
                <div class="order-card" :key="item.code">
                  <el-row type="flex" justify="end">
                    <h6 style="margin: 10px 10px 0px 0px">{{getEnum('PurchaseOrderState', item.state)}}</h6>
                  </el-row>
                  <el-row type="flex" justify="center" style="height: 72%;">
                    <el-button type="text" @click="onDetail(item.id)">点击查看详情</el-button>
                  </el-row>
                </div>
              </template>
            </template>
            <div class="order-card order-card-create">
              <div>
                <el-button @click="onCreate">创建采购订单</el-button>
              </div>
            </div>
          </div>
        </el-tab-pane>
        <el-tab-pane label="其他信息">其他信息</el-tab-pane>
      </el-tabs>
    </el-row>
    <el-dialog :visible.sync="orderVisible" width="80%" append-to-body :close-on-click-modal="false">
      <purchase-order-form v-if="orderVisible" :formData="formData" :order="order" @callback="callback"/>
    </el-dialog>
    <el-dialog :visible.sync="detailVisible" width="80%" append-to-body :close-on-click-modal="false">
      <purchase-order-detail v-if="detailVisible" :orderDetail="orderDetail" @callback="onDetail(detailId)"/>
    </el-dialog>
  </div>
</template>

<script>
import PurchaseOrderForm from '@/views/purchase/order/form/PurchaseOrderForm'
import PurchaseOrderDetail from '@/views/purchase/order/details/PurchaseOrderDetail'

export default {
  name: 'PurchaseOrderListInfo',
  props: ['formData', 'materials', 'purchaseOrderList'],
  components: {
    PurchaseOrderForm,
    PurchaseOrderDetail
  },
  methods: {
    onCreate () {
      this.order = {
        cooperator: {},
        cooperatorName: this.formData.cooperatorName,
        approvers: [null],
        auditNeed: true,
        attachAgreements: [],
        workOrder: {
          id: this.formData.id
        },
        entries: []
      }
      this.order.entries = this.materials.map(item => {
        return {
          spec: {
            id: item.id
          },
          name: item.name,
          colorName: item.colorName,
          modelName: item.specName,
          specName: item.specName,
          orderQuantity: '',
          price: '',
          totalPrice: '',
          estimatedRecTime: ''
        }
      })
      this.orderVisible = true;
    },
    async onDetail (id) {
      this.detailId = id;

      const url = this.apis().searchPurchaseOrderById(id);
      const result = await this.$http.get(url);
      if (result['errors']) {
        this.$message.error(result['errors'][0].message);
        return;
      }
      if (result.code === 1) {
        this.orderDetail = result.data;
        this.orderDetail.entries.forEach(item => {
          this.$set(item, 'receiveQuantity', '');
          this.$set(item, 'remark', '');
        })
        if (!this.orderDetail.attachAgreements) {
          this.$set(this.orderDetail, 'attachAgreements', []);
        }
        this.detailVisible = true;
      } else if (result.code === 0) {
        this.$message.error(result.msg);
        return;
      }
    },
    callback () {
      this.orderVisible = false;
      this.$emit('callback');
    }
  },
  data () {
    return {
      orderVisible: false,
      detailVisible: false,
      order: [],
      orderDetail: '',
      detailId: ''
    }
  }  
}
</script>

<style scoped>
  .order-card {
    width: 200px;
    height: 200px;
    background-color: #EBEEF5;
    margin: 10px;
    border: 1px solid #cfd3da;
  }

  .order-card-create {
    display: flex;
    justify-content: center;
    align-items: center;
  }

  button {
    outline:none;
  }

  /deep/ .el-dialog__header {
    padding: 0px;
  }
</style>