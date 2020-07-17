<template>
  <div>
    <el-row type="flex" justify="start" v-if="!readOnly">
      <el-col :span="7">
        <el-form-item label="外发生产工单">
          <el-input :disabled="true" v-model="formData.productionTaskOrder.code"></el-input>
        </el-form-item>
      </el-col>
      <el-col :span="2" v-if="!disabled">
        <el-button class="sumbit-btn" @click="outboundOrderSelectVisible = !outboundOrderSelectVisible">选择</el-button>
      </el-col>
    </el-row>
    <el-row type="flex" justify="start" v-else>
      <h6>外发生产工单：{{formData.productionTaskOrder.code}}</h6>
    </el-row>
    <el-row type="flex" justify="start" class="basic-row" v-if="formData.productionTaskOrder.code != ''">
      <el-col :span="3">
        <img width="100px" height="100px"
          :src="formData.productionTaskOrder.product!=null?formData.productionTaskOrder.product.thumbnail.url:'static/img/nopicture.png'">
      </el-col>
      <el-col :span="21">
        <el-row type="flex" style="padding: 10px 0px">
          <el-col :span="8">
            <h6>产品名称：{{formData.productionTaskOrder.product?formData.productionTaskOrder.product.name:''}}</h6>
          </el-col>
          <el-col :span="8">
            <h6>货号：{{formData.productionTaskOrder.product?formData.productionTaskOrder.product.skuID:''}}</h6>
          </el-col>
          <el-col :span="8">
            <h6>合同：</h6>
          </el-col>
        </el-row>
        <el-row type="flex" style="padding-bottom: 10px">
          <el-col :span="8">
            <h6>单价：{{formData.productionTaskOrder.unitPrice}}</h6>
          </el-col>
          <el-col :span="8">
            <h6>数量：{{formData.productionTaskOrder.quantity}}</h6>
          </el-col>
        </el-row>
        <el-row type="flex" style="padding-bottom: 10px">
          <el-col :span="8">
            <h6>加工方式：{{getEnum('cooperationModes',formData.productionTaskOrder.cooperationMode)}}</h6>
          </el-col>
          <el-col :span="8">
            <h6>交货日期：{{formData.productionTaskOrder.deliveryDate|formatDateInday}}</h6>
          </el-col>
        </el-row>
      </el-col>
    </el-row>
    <el-dialog :visible.sync="outboundOrderSelectVisible" width="80%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <reconciliation-order-select @onSelect="onSelect" v-if="outboundOrderSelectVisible" />
    </el-dialog>
  </div>
</template>

<script>
  import ReconciliationOrderSelect from '../../../order/salesProduction/production-order/components/ReconciliationOrderSelect'

  export default {
    name: 'ReconciliationOrdersFormHead',
    props: {
      formData: {
        type: Object,
        required: true
      },
      readOnly: {
        type: Boolean,
        default: false
      },
      disabled:{
        type:Boolean,
        default:false
      }
    },
    components: {
      ReconciliationOrderSelect
    },
    computed: {

    },
    methods: {
      onSelect(rows) {
        this.outboundOrderSelectVisible = false;
        this.$emit('onOrderSelect', rows);
      }
    },
    data() {
      return {
        outboundOrderSelectVisible: false
      }
    },
    created() {

    }
  }

</script>

<style scoped>
  .sumbit-btn {
    width: 70px;
    background-color: #ffd60c;
  }

</style>
