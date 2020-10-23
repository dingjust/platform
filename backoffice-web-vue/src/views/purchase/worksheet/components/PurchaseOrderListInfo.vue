<template>
  <div>
    <el-row type="flex" justify="start">
      <div class="over-tabs">
        <authorized :permission="['PURCHASE_ORDER_CREATE']">
          <el-button class="material-btn" v-if="canCreateOrder" @click="onCreate">创建采购订单</el-button>
        </authorized>
      </div>
      <el-tabs type="border-card" style="width: 100%">
        <el-tab-pane label="采购单">
          <div style="overflow-x: auto;overflow-y: hidden;">
            <div class="order-list">
              <template v-if="purchaseOrderList && purchaseOrderList.length > 0">
                <template v-for="item in purchaseOrderList">
                  <el-button :key="item.code" class="order-card">
                    <div @click="onDetail(item)">
                      <el-row type="flex" justify="center">
                        <img style="width: 80px;height: 80px" src="static/img/purchase-order.png"/>
                      </el-row>
                      <el-row type="flex" justify="center">
                        <h6 style="font-size: 12px;margin-bottom: 0px">{{item.code}}</h6>
                      </el-row>
                      <el-row type="flex" justify="center">
                        <h6 style="font-size: 12px;margin-bottom: 0px">{{getEnum('PurchaseOrderState', item.state)}}</h6>
                      </el-row>
                    </div>
                  </el-button>
                </template>
              </template>
            </div>
          </div>
        </el-tab-pane>
        <!-- <el-tab-pane label="其他信息"></el-tab-pane> -->
      </el-tabs>
    </el-row>
    <el-dialog :visible.sync="orderVisible" width="80%" append-to-body :close-on-click-modal="false">
      <purchase-order-form v-if="orderVisible" :formData="formData" 
                          :order="order" @callback="callback" :isFormDialog="true"/>
    </el-dialog>
    <el-dialog :visible.sync="detailVisible" width="80%" append-to-body :close-on-click-modal="false">
      <purchase-order-detail v-if="detailVisible" :id="orderId" @callback="callback"/>
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
  computed: {
    canCreateOrder: function () {
      return this.formData.state !== 'COMPLETE' && 
              this.formData.state !== 'NONE' && 
              this.formData.task.merchandiser.uid === this.$store.getters.currentUser.uid;
    }
  },
  methods: {
    onDetail (item) {
      if (item.state === 'NOT_COMMITED' || item.state === 'AUDIT_FAILED') {
        this.order = {
          id: item.id,
          state: item.state,
          cooperator: item.cooperator ? item.cooperator : {},
          cooperatorName: item.cooperatorName ? item.cooperatorName : '',
          approvers: item.approvers ? item.approvers : [null],
          auditNeed: item.approvers && item.approvers.length >= 0,
          attachAgreements: item.attachAgreements ? item.attachAgreements : [],
          workOrder: {
            id: item.workOrder.id
          },
          entries: item.entries.map(val => {
            return {
              id: val.id,
              spec: {
                id: val.spec.id
              },
              name: item.workOrder.materials.name,
              colorName: val.spec.colorName,
              modelName: val.spec.modelName,
              specName: val.spec.specName,
              orderQuantity: val.orderQuantity,
              price: val.price,
              totalPrice: val.totalPrice,
              estimatedRecTime: val.estimatedRecTime
            }
          })
        }
        this.orderVisible = true;
      } else {
        this.detailVisible = true;
        this.orderId = item.id;
      }
    },
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
          modelName: item.modelName,
          specName: item.specName,
          orderQuantity: '',
          price: '',
          totalPrice: '',
          estimatedRecTime: ''
        }
      })
      this.orderVisible = true;
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
      orderId: ''
    }
  }  
}
</script>

<style scoped>
  .order-card {
    padding: 0px;
    /* height: 150px; */
    border: none;
    color: #606266;
  }

  .order-card:hover {
    background-color: #ffd60c;
  }

  .order-card:focus {
    background-color: none!important;
  }

  button {
    outline:none;
  }

  /deep/ .el-dialog__header {
    padding: 0px;
  }

  .over-tabs {
    position: absolute;
    z-index: 100;
    right: 10px;
    margin-top: 2px;
  }

  .material-btn {
    background-color: #ffd60c;
    border-color: #FFD5CE;
    color: #000;
    width: 100px;
    height: 35px;
  }
  
  .order-list {
    display: inline-flex;
  }
</style>