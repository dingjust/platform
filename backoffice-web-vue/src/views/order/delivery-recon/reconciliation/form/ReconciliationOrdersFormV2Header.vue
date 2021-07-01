<template>
  <div>
    <el-row type="flex" justify="start" align="top">
      <el-form-item label="标题" prop="title" :rules="{ required: true, message: '不能为空', trigger: 'change' }">
        <el-input v-model="formData.title"></el-input>
      </el-form-item>
    </el-row>
    <el-row type="flex">
      <div>
        <el-form-item label="合作商" prop="cooperator" :rules="{ required: true, message: '不能为空', trigger: 'change' }">
          <el-input v-model="formData.cooperator.name" :disabled="true"></el-input>
        </el-form-item>
      </div>
      <div>
        <el-button type="primary" class="select-btn" @click="cooperatorVisible = true" :disabled="canSelectCooperator">选择</el-button>
      </div>
    </el-row>
    <el-row type="flex" align="top">
      <el-form-item label="单据" style="margin: 0px">
        <template slot="label"><span style="padding-left: 10px">单据</span></template>
        <el-button type="primary" size="mini" class="select-btn" @click="selectVisible = true">选择</el-button>
      </el-form-item>
    </el-row>
    <el-row v-if="formData.shippingSheets.length > 0" style="margin-left: 10px;">
      发货单：
      <el-tag v-for="tag in formData.shippingSheets" :key="tag.id" closable @close="onShippingClose(tag)" style="margin-right: 10px;">
        {{tag.code}}
      </el-tag>
    </el-row>
    <el-row v-if="formData.fastShippingSheets.length > 0" style="margin: 10px 0px 0px 10px;">
      出货单：
      <el-tag v-for="tag in formData.fastShippingSheets" :key="tag.id" closable @close="onFastShippingClose(tag)" style="margin-right: 10px;">
        {{tag.code}}
      </el-tag>
    </el-row>
    <el-row v-if="formData.salesProductionOrder" style="margin: 10px 0px 0px 10px;">
      {{formData.salesProductionOrder.showName}}：
      <el-tag closable @close="closeSalesProductionOrder" style="margin-right: 10px;">
        {{formData.salesProductionOrder.code}}
      </el-tag>
    </el-row>
    <el-row type="flex">
      <el-form-item label="我的身份" label-width="70px">
        <el-radio v-model="formData.belongRoleType" label="PARTYA" :disabled="canChange">我是甲方</el-radio>
        <el-radio v-model="formData.belongRoleType" label="PARTYB" :disabled="canChange">我是乙方</el-radio>
      </el-form-item>
    </el-row>
    <el-dialog :visible.sync="deliveryVisible" width="80%" append-to-body class="purchase-dialog" :close-on-click-modal="false">
      <delivery-orders-page v-if="deliveryVisible" :isSelection="true" @onSelect="onSelect"/>
    </el-dialog>
    <el-dialog :visible.sync="shippingListVisible" width="80%" class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <shipping-orders-page :mode="mode" v-if="shippingListVisible" :isSelection="true" @onSelect="onSelect"/>
    </el-dialog>
    <el-dialog :visible.sync="outboundVisible" width="80%" class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <outbound-order-select-page-v2 v-if="outboundVisible" :singleChoice="true" @onSelect="onSelect"/>
    </el-dialog>
    <el-dialog :visible.sync="pendingVisible" width="80%" class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <pending-sales-select-page v-if="pendingVisible" :singleChoice="true" @onSelect="onSelect"/>
    </el-dialog>
    <el-dialog :visible.sync="cooperatorVisible" width="60%" class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <supplier-select v-if="cooperatorVisible" @onSelect="onSuppliersSelect" />
    </el-dialog>
    <el-dialog :visible.sync="selectVisible" title="选择订单类型" width="400px" append-to-body :close-on-click-modal="false">
      <h6 style="color: #F56C6C">外发/外接订单 与 发货/出货单不能同时选择</h6>
      <el-row type="flex" justify="space-around" align="middle">
        <el-button size="medium" plain class="order-btn" :disabled="formData.salesProductionOrder != null" @click="onShipping">发货单</el-button>
        <el-button size="medium" plain class="order-btn" :disabled="formData.salesProductionOrder != null" @click="onDelivery">出货单</el-button>
        <el-button size="medium" plain class="order-btn" @click="onOutbound" 
                  :disabled="formData.fastShippingSheets.length > 0 || formData.shippingSheets.length > 0">外发单</el-button>
        <el-button size="medium" plain class="order-btn" @click="onPending"
                  :disabled="formData.fastShippingSheets.length > 0 || formData.shippingSheets.length > 0">外接单</el-button>
      </el-row>
    </el-dialog>
  </div>
</template>

<script>
import ShippingOrdersPage from '@/views/shipping-receipt/shipping-order/ShippingOrdersPage'
import DeliveryOrdersPage from '@/views/order/delivery-recon/delivery/DeliveryOrdersPage'
import { SupplierSelect } from '@/components'
import OutboundOrderSelectPageV2 from '@/views/order/salesProduction/outbound-order/components/OutboundOrderSelectPageV2'
import PendingSalesSelectPage from '@/views/order/salesProduction/components/PendingSalesSelectPage'

export default {
  name: "ReconciliationOrdersFormV2Header",
  props: ['formData'],
  provide () {
    return {
      formData: this.formData
    }
  },
  components: {
    DeliveryOrdersPage,
    SupplierSelect,
    ShippingOrdersPage,
    OutboundOrderSelectPageV2,
    PendingSalesSelectPage
  },
  computed: {
    canChange: function () {
      // 已选择外接外发不能改变身份状态
      return this.formData.salesProductionOrder != null && this.formData.salesProductionOrder.id != null;
    },
    canSelectCooperator: function () {
      if (this.formData.salesProductionOrder) {
        return true;
      }
      if (this.formData.fastShippingSheets.length > 0 || this.formData.shippingSheets.length > 0) {
        return true;
      }
      return false;
    }
  },
  data () {
    return {
      deliveryVisible: false,
      cooperatorVisible: false,
      selectVisible: false,
      shippingListVisible: false,
      outboundVisible: false,
      pendingVisible: false,
      mode: 'export'
    }
  },
  methods: {
    onSelect (selection) {
      if (this.formData.type === 'shippingSheets') {
        this.formData.shippingSheets = selection;
        this.appendEntries(selection);

        if (!this.formData.name) {
          this.formData.cooperator = {
            partner: {
              id: selection[0].shipParty.id
            },
            name: selection[0].shipParty.name,
            approvalStatus: selection[0].shipParty.approvalStatus
          }
        }
        this.shippingListVisible = false;
      } else if (this.formData.type === 'fastShippingSheets') {
        this.formData.fastShippingSheets = selection;

        if (!this.formData.name) {
          this.formData.cooperator = {
            id: selection[0].cooperator.id,
            partner: {
              id: selection[0].cooperator.partner ? selection[0].cooperator.partner.id : null 
            },
            name: selection[0].cooperator.partner.name,
            approvalStatus: selection[0].cooperator.partner.approvalStatus
          }
        }
        this.deliveryVisible = false;
      } else if (this.formData.type === 'outbound') {
        this.formData.belongRoleType = 'PARTYA';

        this.$set(this.formData, 'salesProductionOrder', {
          id: selection[0].id,
          code: selection[0].code,
          showName: '外发订单'
        })

        this.formData.cooperator = {
          id: selection[0].targetCooperator.id,
          name: selection[0].targetCooperator.partner.name,
          approvalStatus: selection[0].targetCooperator.partner.approvalStatus
        }

        this.getOutboundDetail(selection[0].id)
      } else if (this.formData.type === 'pending') {
        this.formData.belongRoleType = 'PARTYB';

        this.$set(this.formData, 'salesProductionOrder', {
          id: selection[0].id,
          code: selection[0].code,
          showName: '外接订单'
        })
        if (selection[0].originCompany) {
          this.formData.cooperator = {
            id: selection[0].originCooperator.id,
            name: selection[0].originCooperator.partner.name,
            approvalStatus: selection[0].originCooperator.partner.approvalStatus
          }
        } else {
          this.formData.cooperator = {
            id: selection[0].targetCooperator.id,
            name: selection[0].targetCooperator.partner.name,
            approvalStatus: selection[0].targetCooperator.partner.approvalStatus
          }
        }

        this.getPendingDetail(selection[0].id)
      }
    },
    async getPendingDetail(id) {
      const url = this.apis().getSalesProductionOrderDetails(id);
      const result = await this.$http.get(url);

      if (result['errors']) {
        this.$message.error(result['errors'][0].message);
        return;
      }

      this.appendEntries(result.data.taskOrderEntries.map(item => {
        return {
          id: item.id,
          product: item.product,
          productionTaskOrder: {
            totalQuantity: item.quantity,
          },
          deliveryDate: item.deliveryDate,
          loanAmount: item.totalPrimeCost
        }
      }), true)

      this.pendingVisible = false;
    },
    async getOutboundDetail(id) {
      const url = this.apis().getoutboundOrderDetail(id);
      const result = await this.$http.get(url);
      if (result['errors']) {
        this.$message.error(result['errors'][0].message);
        return;
      }

      this.appendEntries(result.data.taskOrderEntries.map(item => {
        return {
          id: item.id,
          product: item.product,
          productionTaskOrder: {
            totalQuantity: item.quantity,
          },
          deliveryDate: item.deliveryDate,
          loanAmount: item.totalPrimeCost
        }
      }), true)

      this.outboundVisible = false;
    },
    appendEntries (selection, isOutorPending) {
      // 过滤已经没有选择的发货单的对账行
      this.formData.entries = this.formData.entries.filter(item => {
        if (item.relationId) {
          return selection.findIndex(val => val.id === item.relationId) > -1;
        }
        return true;
      });

      selection.forEach(item => {
        // 已存在对账行不再添加
        if (this.formData.entries.findIndex(val => val.relationId === item.id) > -1) {
          return;
        }

        this.formData.entries.push({
          product: {
            id: item.product.id,
            name: item.product.name,
            thumbnail: item.product.thumbnail,
            skuID: item.product.skuID
          },
          waveBand: '',
          orderItemNo: '',
          customizedMode: '',
          deliveryDate: item.deliveryDate ? item.deliveryDate : '',
          contractDate: '',
          orderQuantity: item.productionTaskOrder ? item.productionTaskOrder.totalQuantity : '',
          cutQuantity: '',
          packageQuantity: item.totalQuantity,
          storageQuantity: '',
          returnQuantity: '',
          unitContractPrice: '',
          loanAmount: item.loanAmount ? item.loanAmount : '',
          expressFee: '',
          deductionAmount: '',
          settlementAmount: item.settlementAmount ? item.settlementAmount : '',
          remarks: '',
          relationId: item.id,
          isOutorPending: isOutorPending
        })
      })
    },
    onShippingClose (tag) {
      const index = this.formData.shippingSheets.findIndex(item => item.id === tag.id);
      if (index > -1) {
        this.formData.shippingSheets.splice(index, 1);
      }
    },
    onFastShippingClose (tag) {
      const index = this.formData.fastShippingSheets.findIndex(item => item.id === tag.id);
      if (index > -1) {
        this.formData.fastShippingSheets.splice(index, 1);
      }
    },
    closeSalesProductionOrder () {
      this.$delete(this.formData, 'salesProductionOrder');
    },
    onSuppliersSelect (val) {
      if (val.id) {
        this.formData.cooperator = val;
      } else {
        this.formData.cooperator = '';
      }
      this.cooperatorVisible = false;
    },
    onDelivery () {
      this.formData.type = 'fastShippingSheets';
      this.selectVisible = false;
      this.deliveryVisible = true;
    },
    onShipping () {
      this.formData.type = 'shippingSheets';
      this.selectVisible = false;
      this.shippingListVisible = true;
    },
    onOutbound () {
      this.formData.type = 'outbound';
      this.selectVisible = false;
      this.outboundVisible = true;
    },
    onPending () {
      this.formData.type = 'pending';
      this.selectVisible = false;
      this.pendingVisible = true;
    }
  }
};
</script>

<style scoped>
  .select-btn {
    background-color: #ffd60c;
    border-color: #ffd60c;
    color: #606266;
  }

  .order-btn {
    background: #FFD60C;
    border-color: #FFD60C;
    color: #fff;
  }
  .order-btn:hover {
    color: #FFD60C;
    background: #fffbe7;
    border-color: #ffef9e;
  }
  .order-btn:focus {
    color: #FFD60C;
    background: #fffbe7;
    border-color: #ffef9e;
  }
</style>
