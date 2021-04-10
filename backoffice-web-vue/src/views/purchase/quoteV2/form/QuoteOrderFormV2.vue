<!--
* @Description: 报价单表单（v2
* @Date 2021/03/16 15:34
* @Author L.G.Y
-->
<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col>
          <div class="quote-order-title">
            <h6>{{this.id ? '编辑' : '创建'}}报价单</h6>
          </div>
        </el-col>
      </el-row>
      <div class="purchase-form-row">
        <el-form ref="form" :model="formData" :inline="true" label-position="left">
          <div class="purchase-form">
            <el-form-item label="系统单号">
              <el-input placeholder="系统生成" v-model="formData.code" :disabled="true"></el-input>
            </el-form-item>
            <el-form-item label="关联成本单">
              <el-input v-model="formData.refCostOrderCode" :disabled="true"></el-input>
            </el-form-item>
            <el-form-item label="关联款号">
              <el-input v-model="formData.costOrder.product.skuID" :disabled="true"></el-input>
            </el-form-item>
          </div>
        </el-form>
        <cost-purchase-table :formData="formData.costOrder" />
        <additional-item ref="additional" class="additional-container" :formData="formData.costOrder"/>
        <quote-order-total-part ref="totalPart" :formData="formData"/>
      </div>
      <quote-order-btn-gruop class="additional-container" :id="id" @onCreate="onCreate"/>
    </el-card>
  </div>
</template>

<script>
import CostSelectList from '@/views/purchase/cost/components/CostSelectList'
import CostPurchaseTable from '@/views/purchase/components/CostPurchaseTable'
import AdditionalItem from '@/views/purchase/cost/components/AdditionalItem'
import QuoteOrderTotalPart from './QuoteOrderTotalPart'
import QuoteOrderBtnGruop from './QuoteOrderBtnGruop.vue'

export default {
  name: 'QuoteOrderFormV2',
  props: ['id'],
  components: {
    CostSelectList,
    CostPurchaseTable,
    AdditionalItem,
    QuoteOrderTotalPart,
    QuoteOrderBtnGruop
  },
  data () {
    return {
      formData: {
        id: null,
        code: '',
        costOrder: {
          id: null,
          code: '',
          product: {
            skuID: ''
          },
          workOrders: [],
          customRows: [],
          purchaseMaterials: []
        },
        profitRate: '',
        stallQuote: '',
        companyPricing: '',
        remarks: ''
      }
    }
  },
  methods: {
    // 封装Promise对象
    getFormPromise(form) {
      return new Promise(resolve => {
        form.validate(res => {
          resolve(res);
        })
      })
    },
    async validateForms() {
      var formArr = [];
      formArr.push(this.$refs.form);
      formArr.push(this.$refs.additional.$refs.form);
      formArr.push(this.$refs.totalPart.$refs.form);
      
      // 使用Promise.all 并行去校验结果
      let res = await Promise.all(formArr.map(this.getFormPromise));

      return res.every(item => !!item);
    },
    arrangement () {
      let purchaseMaterials = [];

      this.formData.costOrder.workOrders.forEach(item => {
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

      this.formData.costOrder.customRows.forEach(item => {
        customRows.push({
          id: item.materialsId ? item.materialsId : '',
          name: item.name,
          code: item.code,
          unit: item.unit,
          customCategoryName: item.customCategoryName,
          specList: [{
            id: item.specListId,
            price: item.price
          }]
        })
      })

      return {
        id: this.formData.id,
        costOrder: {
          id: this.formData.costOrder.id,
          product: {
            id: this.formData.costOrder.product.id
          },
          purchaseMaterials: purchaseMaterials,
          customRows: customRows
        },
        refCostOrderId: this.formData.refCostOrderId,
        refCostOrderCode: this.formData.refCostOrderCode,
        profitRate: Number.isNaN(Number.parseFloat(this.formData.profitRate)) ? 0 : Number.parseFloat(this.formData.profitRate) / 100,
        stallQuote: this.formData.stallQuote,
        companyPricing: this.formData.companyPricing,
        remarks: this.formData.remarks
      };    
    },
    async onCreate () {
      const valid = await this.validateForms();
      if (valid) {
        if (this.id) {
          this.onEdit(this.arrangement());
        } else {
          this._onCreate(this.arrangement());
        }
      }
    },
    async _onCreate (data) {
      const url = this.apis().createQuoteOrderV2();
      const result = await this.$http.post(url, data);

      if (result.code === 1) {
        this.$message.success('创建成功！');
        this.$router.push('/purchase/quote/' + result.msg);
      } else if (result['errors']) {
        this.$message.error(result['errors'][0].message);
      } else if (result.code === 0) {
        this.$message.error(result.msg);
      } else {
        this.$message.error('操作失败！');
      }
    },
    async onEdit (data) {
      const url = this.apis().updateQuoteOrderV2();
      const result = await this.$http.put(url, data);

      if (result.code === 1) {
        this.$message.success('编辑成功！');
        this.$router.push('/purchase/quote/' + this.id);
      } else if (result['errors']) {
        this.$message.error(result['errors'][0].message);
      } else if (result.code === 0) {
        this.$message.error(result.msg);
      } else {
        this.$message.error('操作失败！');
      }
    },
    async getDetail () {
      const url = this.apis().getQuoteOrderV2(this.id);
      const result = await this.$http.get(url);

      if (result.code === 1) {
        this.initData(result.data);
      }
    },
    initData (resultData) {
      let data = Object.assign({}, resultData);
      let purchaseMaterials = [];
      if (resultData.costOrder.purchaseMaterials && resultData.costOrder.purchaseMaterials.length > 0) {
        resultData.costOrder.purchaseMaterials.forEach(row => {
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
      if (resultData.costOrder.customRows) {
        resultData.costOrder.customRows.forEach(row => {
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
        })
      }

      data.costOrder.workOrders = purchaseMaterials;
      data.costOrder.customRows = customRows;
      data.profitRate = data.profitRate * 100;

      this.$set(this, 'formData', data);
    }
  },
  created () {
    if (this.$route.params.costOrder) {
      this.formData.refCostOrderId = this.$route.params.costOrder.id;
      this.formData.refCostOrderCode = this.$route.params.costOrder.code;
      this.formData.costOrder = {
        id: null,
        product: {
          id: this.$route.params.costOrder.product.id,
          code: this.$route.params.costOrder.product.code,
          skuID: this.$route.params.costOrder.product.skuID
        },
        workOrders: this.$route.params.costOrder.workOrders,
        customRows: this.$route.params.costOrder.customRows
      }
    }
    if (this.id) {
      this.getDetail();
    }
  }
}
</script>

<style scoped>
  .quote-order-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .purchase-form-row {
    margin-left: 20px;
  }

  .purchase-form {
    display: flex;
    flex-wrap: wrap;
    justify-content: space-between;
    align-items: center;
  }

  .additional-container {
    margin-top: 20px
  }
</style>
