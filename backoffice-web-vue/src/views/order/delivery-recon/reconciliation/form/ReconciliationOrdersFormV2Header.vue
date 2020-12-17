<template>
  <div>
    <el-row type="flex" justify="start" align="top">
      <el-form-item label="标题" prop="title" :rules="{ required: true, message: '不能为空', trigger: 'change' }">
        <el-input v-model="formData.title"></el-input>
      </el-form-item>
    </el-row>
    <el-row type="flex" align="top">
      <el-col>
        <div style="display: flex;">
          <div>
            <el-form-item label="单据" >
              <el-input v-if="formData.type === 'fastShippingSheets'" v-model="formData.fastShippingSheets[0].code" :disabled="true"></el-input>
              <el-input v-if="formData.type === 'shippingSheets'" v-model="formData.shippingSheets[0].code" :disabled="true"></el-input>
            </el-form-item>
          </div>
          <div>
            <el-button-group>
              <el-button type="primary" class="select-btn" @click="selectVisible = true">选择</el-button>
              <el-button @click="onCancel" v-if="canCancel">取消</el-button>
            </el-button-group>
          </div>
        </div>
      </el-col>
      <el-col>
        <div style="display: flex;">
          <div>
            <el-form-item label="合作商" prop="cooperator" :rules="{ required: true, message: '不能为空', trigger: 'change' }">
              <el-input v-model="formData.cooperator.name" :disabled="true"></el-input>
            </el-form-item>
          </div>
          <div>
            <el-button type="primary" class="select-btn" @click="cooperatorVisible = true" :disabled="formData.fastShippingSheets[0].id !== ''">选择</el-button>
          </div>
        </div>
      </el-col>
    </el-row>
    <el-dialog :visible.sync="deliveryVisible" width="80%" append-to-body class="purchase-dialog" :close-on-click-modal="false">
      <delivery-orders-page v-if="deliveryVisible" :isSelection="true" :selectedId="formData.fastShippingSheets.id" @onSelect="onSelect"/>
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
  props: ["formData"],
  components: {
    DeliveryOrdersPage,
    SupplierSelect,
    ShippingOrdersPage
  },
  computed: {
    canSelectCooperator: function () {
      return this.formData.fastShippingSheets[0].id !== '';
    },
    canCancel: function () {
      return (this.formData.type === 'fastShippingSheets' && this.formData.fastShippingSheets[0].id) ||
              (this.formData.type === 'shippingSheets' && this.formData.shippingSheets[0].id);
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
    onSelect (row) {
      if (this.formData.type = 'shippingSheets') {
        this.formData.shippingSheets[0].code = row.code;
        this.formData.shippingSheets[0].id = row.id;

        this.formData.cooperator = {
          id: row.shipParty.id,
          name: row.shipParty.name,
          approvalStatus: row.shipParty.approvalStatus
        }

        this.shippingListVisible = false;
      } else if (this.formData.type = 'fastShippingSheets') {
        this.formData.fastShippingSheets[0].code = row.code;
        this.formData.fastShippingSheets[0].id = row.id;
  
        this.formData.cooperator = {
          id: row.cooperator.id,
          name: row.cooperator.type === 'ONLINE' ? row.cooperator.partner.name : row.cooperator.name,
          approvalStatus: row.cooperator.type === 'ONLINE' ? row.cooperator.partner.approvalStatus : ''
        }

        this.deliveryVisible = false;
      }
    },
    onCancel () {
      this.formData.fastShippingSheets = [{
        code: '',
        id: ''
      }];
      this.formData.cooperator = '';
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