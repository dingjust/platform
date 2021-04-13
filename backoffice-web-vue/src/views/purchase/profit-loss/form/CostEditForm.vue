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
        <el-form-item label="关联 工单 / 产品" prop="productionOrder.code" :rules="[{ required: true, message: '请选择关联订单', trigger: 'change' }]">
          <el-input v-model="formData.productionOrder.code" :disabled="true">
            <el-button slot="suffix" @click="selectVisible = true" v-if="!formData.id">选择</el-button>
          </el-input>
        </el-form-item>
        <el-form-item label="关联款号">
          <el-input v-model="formData.productionOrder.product.skuID" :disabled="true"></el-input>
        </el-form-item>
      </el-form>
      <purchase-requirement-table :formData="formData" :isFromCost="true"/>
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
import PurchaseRequirementTable from '@/views/purchase/requirement/components/PurchaseRequirementTable'
import AdditionalItem from '@/views/purchase/cost/components/AdditionalItem'
export default {
  name: 'CostEditForm',
  props: ['costOrder'],
  components: {
    PurchaseRequirementTable,
    AdditionalItem
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

      return totalCost.toFixed(2);
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
      let purchaseMaterials = [];
      if (resultData.purchaseMaterials && resultData.purchaseMaterials.length > 0) {
        resultData.purchaseMaterials.forEach(row => {
          if (row.specList && row.specList.length > 0) {
            purchaseMaterials = purchaseMaterials.concat(row.specList.map(item => {
              return {
                // id: row.id,
                materialsId: row.id,
                specListId: item.id,
                name: row.name,
                code: row.code,
                unit: row.unit,
                materialsType: row.materialsType,
                unitQuantity: item.unitQuantity,
                specName: item.specName,
                colorName: item.colorName,
                modelName: item.modelName,
                emptySent: item.emptySent,
                requiredAmount: item.requiredAmount,
                estimatedLoss: item.estimatedLoss,
                estimatedUsage: item.estimatedUsage,
                orderCount: item.orderCount,
                auditColor: item.auditColor,
                estimatedRecTime: item.estimatedRecTime,
                price: item.price,
                totalPrice: item.totalPrice
              }
            }))
          }
        })
      }

      let customRows = [];
      if (resultData.customRows) {
        resultData.customRows.forEach(row => {
          if (row.specList && row.specList.length > 0) {
            customRows = customRows.concat(row.specList.map(item => {
              return {
                materialsId: row.id,
                specListId: item.id,
                  name: row.name,
                  unit: row.unit,
                  customCategoryName: row.customCategoryName,
                  price: item.price,
              }
            }))
          }
        })
      }

      data.workOrders = purchaseMaterials;
      data.customRows = customRows;
      data.productionOrder.product = {
        skuID: data.productionOrder.productSkuID
      }

      this.formData = data;
    },
    arrangement () {
      let purchaseMaterials = [];

      this.formData.workOrders.forEach(item => {
        purchaseMaterials.push({
          id: item.materialsId ? item.materialsId : '',
          name: item.name,
          code: item.code,
          unit: item.unit,
          materialsType: item.materialsType,
          specList: [{
            id: item.specListId,
            unitQuantity: item.unitQuantity,
            specName: item.specName.trim(),
            colorName: item.colorName.trim(),
            modelName: item.modelName.trim(),
            emptySent: item.emptySent,
            requiredAmount: item.requiredAmount,
            estimatedLoss: item.estimatedLoss,
            estimatedUsage: item.estimatedUsage,
            orderCount: item.orderCount,
            price: item.price,
            totalPrice: item.totalPrice,
            estimatedRecTime: item.estimatedRecTime
          }]
        })
      })

      let customRows = []

      this.formData.customRows.forEach(item => {
        customRows.push({
          id: item.materialsId ? item.materialsId : '',
          name: item.name,
          code: item.code,
          unit: item.unit,
          customCategoryName: item.customCategoryName,
          specList: [{
            price: item.price
          }]
        })
      })

      // TODO: 处理选择产品时候的productionOrder数据
      return {
        id: this.formData.id ? this.formData.id : null, 
        productionOrder: this.formData.productionOrder,
        purchaseMaterials: purchaseMaterials,
        customRows: customRows
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