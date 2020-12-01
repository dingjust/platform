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
            <el-form-item label="发货单">
              <el-input v-model="formData.fastShippingSheets[0].code" :disabled="true"></el-input>
            </el-form-item>
          </div>
          <div>
            <el-button-group>
              <el-button type="primary" class="select-btn" @click="deliveryVisible = true">选择</el-button>
              <el-button @click="onCancel" v-if="formData.fastShippingSheets[0].id">取消</el-button>
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
    <el-dialog :visible.sync="cooperatorVisible" width="60%" class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <supplier-select v-if="cooperatorVisible" @onSelect="onSuppliersSelect" />
    </el-dialog>
  </div>
</template>

<script>
import DeliveryOrdersPage from '@/views/order/delivery-recon/delivery/DeliveryOrdersPage'
import { SupplierSelect } from '@/components'

export default {
  name: "ReconciliationOrdersFormV2Header",
  props: ["formData"],
  components: {
    DeliveryOrdersPage,
    SupplierSelect
  },
  computed: {
    canSelectCooperator: function () {
      return this.formData.fastShippingSheets[0].id !== '';
    }
  },
  data () {
    return {
      deliveryVisible: false,
      cooperatorVisible: false
    }
  },
  methods: {
    onSelect (row) {
      this.formData.fastShippingSheets[0].code = row.code;
      this.formData.fastShippingSheets[0].id = row.id;

      this.formData.cooperator = {
        id: row.targetCooperator.id,
        name: row.targetCooperator.type === 'ONLINE' ? row.targetCooperator.partner.name : row.targetCooperator.name
      }
      this.deliveryVisible = false;
    },
    onCancel () {
      this.formData.fastShippingSheets = [{
        code: '',
        id: ''
      }];
      this.formData.cooperator = '';
    },
    onSuppliersSelect (val) {
      this.formData.cooperator = val;
      this.cooperatorVisible = false;
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

</style>