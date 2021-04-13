<!--
* @Description: 成本单-表单
* @Date 2021/02/24 17:52
* @Author L.G.Y
-->
<template>
  <div class="animated fadeIn">
    <el-card>
      <el-row>
        <div class="cost-order-title">
          <h6>{{formData.id ? '编辑成本单' : '创建成本单'}}</h6>
        </div>
      </el-row>
      <div class="pt-2"></div>
      <div class="cost-row">
        <el-form ref="form" class="cost-form" :model="formData" :inline="true">
          <el-row type="flex" justify="start">
            <el-form-item label="系统单号">
              <el-input placeholder="系统生成" v-model="formData.code" :disabled="true"></el-input>
            </el-form-item>
          </el-row>
          <div class="basic-container">
            <el-form-item label="标题" prop="title" :rules="[{ required: true, message: '请填写标题', trigger: 'change' }]">
              <el-input v-model="formData.title"></el-input>
            </el-form-item>
            <el-form-item label="关联产品" prop="product.code" :rules="[{ required: true, message: '请选择关联订单', trigger: 'change' }]">
              <el-input v-model="formData.product.code" :disabled="true">
                <!-- <el-button slot="suffix" @click="productVisible = true" v-if="!formData.id">选择</el-button> -->
              </el-input>
            </el-form-item>
            <el-form-item label="关联款号">
              <el-input v-model="formData.product.skuID" :disabled="true"></el-input>
            </el-form-item>
          </div>
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
        <el-button class="create-btn" @click="onCreate">{{formData.id ? '修改' : '创建'}}</el-button>
      </el-row>
    </el-card> 
    <el-dialog :visible.sync="productVisible" width="80%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <sample-products-select-dialog v-if="productVisible" @onSelectSample="onSelectSample" :isSingleSelect="true"/>
    </el-dialog>
  </div>
</template>

<script>
import CostPurchaseTable from '@/views/purchase/components/CostPurchaseTable'
import AdditionalItem from '../components/AdditionalItem.vue'
import SampleProductsSelectDialog from '@/views/product/sample/components/SampleProductsSelectDialog'

export default {
  name: 'CostOrderForm',
  props: ['product', 'id'],
  components: {
    CostPurchaseTable,
    AdditionalItem,
    SampleProductsSelectDialog
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
      taskDialogVisible: false,
      selectVisible: false,
      productVisible: false,
      formData: {
        title: '',
        code: '',
        product: {
          id: '',
          code: '',
          skuID: ''
        },
        workOrders: [],
        purchaseMaterials: [],
        customRows: []
      }
    }
  },
  methods: {
    selectProduct () {
      this.selectVisible = false;
      this.productVisible = true;
    },
    onSelectSample (data) {
      if (data && data.length > 0) {
        this.formData.product = {
          id: data[0].id,
          code: data[0].code,
          skuID: data[0].skuID
        }
      }
      this.productVisible = false;
    },
    selectProduction (flag) {
      this.productionType = flag;
      this.selectVisible = false;
      this.taskDialogVisible = true;
    },
    // onSelectTask (data) {
    //   this.formData.productionOrder = {
    //     id: data[0] ? data[0].id : '',
    //     code: data[0] ? data[0].code : '',
    //     product: {
    //       skuID: data[0] ? data[0].product.skuID : '' 
    //     }
    //   };
    //   this.taskDialogVisible = false;
    // },
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
        // productionOrder: this.formData.productionOrder,
        type: 'PRODUCT',
        title: this.formData.title,
        product: this.formData.product,
        purchaseMaterials: purchaseMaterials,
        customRows: customRows
      };    
    },
    async _onCreate () {
      const form = this.arrangement();

      const url = this.apis().createCostOrder();
      const result = await this.$http.post(url, form);

      if (result.code === 1) {
        if (this.product.id) {
          this.$emit('callback');
          return;
        }
        this.$message.success('创建成功！');
        this.$router.push('/purchase/cost/' + result.msg);
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
        this.$router.push('/purchase/cost/' + this.id);
      } else if (result['errors']) {
        this.$message.error(result['errors'][0].message);
      } else if (result.code === 0) {
        this.$message.error(result.msg);
      } else {
        this.$message.error('创建失败！');
      }
    },
    async getDetail () {
      const url = this.apis().getCostOrder(this.id);
      const result = await this.$http.get(url);

      if (result['errors']) {
        this.$message.error(result['errors'][0].message);
        return;
      }
      if (result.code === 1) {
        this.initData(result.data);
      } else if (result.code === 0) {
        this.$message.error(result.msg);
      }
    },
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
                // cooperatorName: row.cooperatorName,
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

      this.$set(this, 'formData', Object.assign({}, data));
    }
  },
  created () {
    if (this.id) {
      this.getDetail();
    }
    if (this.product) {
      this.onSelectSample([this.product]);
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
  }

  .basic-container {
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