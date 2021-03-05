<!--
* @Description: 成本单-表单
* @Date 2021/02/24 17:52
* @Author L.G.Y
-->
<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <div class="cost-order-title">
          <h6>创建成本单</h6>
        </div>
      </el-row>
      <div class="pt-2"></div>
      <div class="cost-row">
        <el-form ref="form" class="cost-form" :model="formData" :inline="true">
          <el-form-item label="系统单号">
            <el-input placeholder="系统生成" v-model="formData.code" :disabled="true"></el-input>
          </el-form-item>
          <el-form-item label="关联订单" prop="productionOrder.code" :rules="[{ required: true, message: '请选择关联订单', trigger: 'change' }]">
            <el-input v-model="formData.productionOrder.code" :disabled="true">
              <el-button slot="suffix" @click="taskDialogVisible = true">选择</el-button>
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
      </div>
      <el-row type="flex" justify="center" style="margin-top: 20px">
        <el-button class="create-btn" @click="onCreate">{{formData.id ? '修改' : '创建'}}</el-button>
      </el-row>
    </el-card> 
    <el-dialog :visible.sync="taskDialogVisible" width="80%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <production-task-select-dialog v-if="taskDialogVisible" @onSelectTask="onSelectTask" 
                                :isSingleChoice="true" selectType="PURCHASE_REQUIREMENT"/>
    </el-dialog>
  </div>
</template>

<script>
import ProductionTaskSelectDialog from '@/views/order/salesProduction/production-task/components/ProductionTaskSelectDialog'
import PurchaseRequirementTable from '@/views/purchase/requirement/components/PurchaseRequirementTable'
import AdditionalItem from '../components/AdditionalItem.vue'

export default {
  name: 'CostOrderForm',
  components: {
    ProductionTaskSelectDialog,
    PurchaseRequirementTable,
    AdditionalItem
  },
  data () {
    return {
      taskDialogVisible: false,
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
    onSelectTask (data) {
      this.formData.productionOrder = {
        id: data[0] ? data[0].id : '',
        code: data[0] ? data[0].code : '',
        product: {
          skuID: data[0] ? data[0].product.skuID : '' 
        }
      };
      this.taskDialogVisible = false;
    },
    onCreate () {
      const additionalForm = this.$refs.additional.$refs.form;
      this.$refs.form.validate((v1) => {
        additionalForm.validate(v2 => {
          if (v1 && v2) {
            this.$confirm('是否执行' + (this.formData.id ? '修改' : '创建') +'操作?', '', {
              confirmButtonText: '是',
              cancelButtonText: '否',
              type: 'warning'
            }).then(() => {
              if (this.formData.id) {
                this._onUpdate();
              } else {
                this._onCreate();
              }
            });
          } else {
            this.$message.error('请完善表单信息！');
          }
        })
      });
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

      return {
        id: this.formData.id ? this.formData.id : null, 
        productionOrder: this.formData.productionOrder,
        purchaseMaterials: purchaseMaterials,
        customRows: customRows
      };    

    },
    async _onCreate () {
      const form = this.arrangement();

      const url = this.apis().createCostOrder();
      const result = await this.$http.post(url, form);

      if (result.code === 1) {
        this.$message.success('创建成功！');
        this.$router.push('/purchase/cost');
      } else if (result['errors']) {
        this.$message.error(result['errors'][0].message);
      } else if (result.code === 0) {
        this.$message.error(result.msg);
      } else {
        this.$message.error('创建失败！');
      }
    },
    async _onUpdate () {
      const form = this.arrangement();

      const url = this.apis().updateCostOrder();
      const result = await this.$http.put(url, form);

      if (result.code === 1) {
        this.$message.success('编辑成功！');
        this.$router.push('/purchase/cost');
      } else if (result['errors']) {
        this.$message.error(result['errors'][0].message);
      } else if (result.code === 0) {
        this.$message.error(result.msg);
      } else {
        this.$message.error('创建失败！');
      }
    }
  },
  created () {
    if (this.$route.params.formData) {
      this.formData = this.$route.params.formData;
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