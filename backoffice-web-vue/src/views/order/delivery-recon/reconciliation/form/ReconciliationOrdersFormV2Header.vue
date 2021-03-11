<template>
  <div>
    <el-row type="flex" justify="start" align="top">
      <el-form-item label="标题" prop="title" :rules="{ required: true, message: '不能为空', trigger: 'change' }">
        <el-input v-model="formData.title"></el-input>
      </el-form-item>
    </el-row>
    <el-row>
      <div style="display: flex;">
        <div>
          <el-form-item label="合作商" prop="cooperator" :rules="{ required: true, message: '不能为空', trigger: 'change' }">
            <el-input v-model="formData.cooperator.name" :disabled="true"></el-input>
          </el-form-item>
        </div>
        <div>
          <el-button type="primary" class="select-btn" @click="cooperatorVisible = true" :disabled="!canSelectCooperator">选择</el-button>
        </div>
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
    <el-dialog :visible.sync="deliveryVisible" width="80%" append-to-body class="purchase-dialog" :close-on-click-modal="false">
      <delivery-orders-page v-if="deliveryVisible" :isSelection="true" @onSelect="onSelect"/>
    </el-dialog>
    <el-dialog :visible.sync="shippingListVisible" width="80%" class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <shipping-orders-page :mode="mode" v-if="shippingListVisible" :isSelection="true" @onSelect="onSelect"/>
    </el-dialog>
    <el-dialog :visible.sync="cooperatorVisible" width="60%" class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <supplier-select v-if="cooperatorVisible" @onSelect="onSuppliersSelect" />
    </el-dialog>
    <el-dialog :visible.sync="selectVisible" title="选择订单类型" width="400px" append-to-body :close-on-click-modal="false">
      <el-row type="flex" justify="space-around" align="middle">
        <el-button size="medium" plain class="order-btn" @click="onShipping">发货单</el-button>
        <el-button size="medium" plain class="order-btn" @click="onDelivery">出货单</el-button>
      </el-row>
    </el-dialog>
  </div>
</template>

<script>
import ShippingOrdersPage from '@/views/shipping-receipt/shipping-order/ShippingOrdersPage'
import DeliveryOrdersPage from '@/views/order/delivery-recon/delivery/DeliveryOrdersPage'
import { SupplierSelect } from '@/components'

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
    ShippingOrdersPage
  },
  computed: {
    canSelectCooperator: function () {
      return this.formData.fastShippingSheets.length <= 0 && this.formData.shippingSheets.length <= 0;
    }
  },
  data () {
    return {
      deliveryVisible: false,
      cooperatorVisible: false,
      selectVisible: false,
      shippingListVisible: false,
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
            name: selection[0].cooperator.partner.name,
            approvalStatus: selection[0].cooperator.partner.approvalStatus
          }
        }
        this.deliveryVisible = false;
      }
    },
    appendEntries (selection) {
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
          deliveryDate: '',
          contractDate: '',
          orderQuantity: item.productionTaskOrder ? item.productionTaskOrder.totalQuantity : '',
          cutQuantity: '',
          packageQuantity: item.totalQuantity,
          storageQuantity: '',
          returnQuantity: '',
          unitContractPrice: '',
          loanAmount: '',
          expressFee: '',
          deductionAmount: '',
          settlementAmount: '',
          remarks: '',
          relationId: item.id
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
