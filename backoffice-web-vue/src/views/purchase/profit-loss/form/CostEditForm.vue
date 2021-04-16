<!--
* @Description: 盈亏分析表 行成本单编辑表单
* @Date 2021/03/23 17:55
* @Author L.G.Y
-->
<template>
  <div>
    <el-row>
      <div class="cost-order-title">
        <h6>编辑成本单</h6>
      </div>
    </el-row>
    <div class="pt-2"></div>
    <div class="cost-row">
      <el-form ref="form" class="cost-form" :model="formData" :inline="true">
        <el-form-item label="系统单号">
          <el-input placeholder="系统生成" v-model="formData.code" :disabled="true"></el-input>
        </el-form-item>
        <el-form-item label="关联产品" prop="product.code" :rules="[{ required: true, message: '请选择关联订单', trigger: 'change' }]">
          <el-input v-model="formData.product.code" :disabled="true">
            <el-button slot="suffix" @click="selectVisible = true" v-if="!formData.id">选择</el-button>
          </el-input>
        </el-form-item>
        <el-form-item label="关联款号">
          <el-input v-model="formData.product.skuID" :disabled="true"></el-input>
        </el-form-item>
      </el-form>
      <cost-purchase-table :formData="formData" :isFromCost="true"/>
      <el-row class="additional-container">
        <additional-item ref="additional" :formData="formData"/>
      </el-row>
      <el-row class="additional-container" type="flex" justify="end">
        <el-col :span="4">
          <h5>成本总额：{{totalCost}}</h5>
        </el-col>
      </el-row>
    </div>
    <el-row type="flex" justify="center" style="margin-top: 20px">
      <el-button class="create-btn" @click="onEdit">修改</el-button>
    </el-row>
  </div>
</template>

<script>
import AdditionalItem from '@/views/purchase/cost/components/AdditionalItem'
import CostPurchaseTable from '@/views/purchase/components/CostPurchaseTable'
import { handleSumbitData, handleInitData } from '../../components/handleTableData'

export default {
  name: 'CostEditForm',
  props: ['costOrder'],
  components: {
    AdditionalItem,
    CostPurchaseTable
  },
  computed: {
    totalCost: function () {
      let totalCost = 0;
      this.formData.workOrders.forEach(item => {
        if (!Number.isNaN(Number.parseFloat(item.totalPrice))) {
          totalCost += Number.parseFloat(item.totalPrice);
        }
      })

      this.formData.customRows.forEach(item => {
        if (!Number.isNaN(Number.parseFloat(item.price))) {
          totalCost += Number.parseFloat(item.price);
        }
      })

      return totalCost.toFixed(4);
    }
  },
  data () {
    return {
      formData: {
        code: '',
        productionOrder: {
          id: '',
          code: '',
          product: {
            skuID: ''
          }
        },
        workOrders: [],
        purchaseMaterials: [],
        customRows: []
      }
    }
  },
  methods: {
    initData (resultData) {
      let data = Object.assign({}, resultData);

      data.workOrders = handleInitData(resultData.purchaseMaterials, 'WORKORDERS');
      data.customRows = handleInitData(resultData.customRows, 'CUSTOMROWS');

      this.formData = data;
    },
    arrangement () {
      let purchaseMaterials = handleSumbitData(this.formData.workOrders, 'WORKORDERS');
      let customRows = handleSumbitData(this.formData.customRows, 'CUSTOMROWS');

      // TODO: 处理选择产品时候的productionOrder数据
      return {
        id: this.formData.id ? this.formData.id : null, 
        productionOrder: this.formData.productionOrder,
        product: this.formData.product,
        purchaseMaterials: purchaseMaterials,
        customRows: customRows,
      };    
    },
    onEdit () {
      this.$emit('editCostForm', this.arrangement());
    }
  },
  created () {
    if (this.costOrder) {
      this.initData(this.costOrder);
    }
  }
}
</script>

<style scoped>
  .cost-order-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .cost-row {
    margin-left: 20px;
  }

  .cost-form {
    margin: 10px 0px 0px 10px;
    display: flex;
    flex-wrap: wrap;
    justify-content: space-between;
  }
  
  /deep/ .el-input__suffix {
    right: 0px;
  }

  .additional-container {
    margin-top: 30px
  }
  
  .create-btn {
    background-color: #ffd60c;
    border-color: #FFD5CE;
    color: #000;
    width: 120px;
    height: 40px;
  }
</style>