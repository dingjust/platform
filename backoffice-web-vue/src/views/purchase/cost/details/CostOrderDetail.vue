<!--
* @Description: 成本单-详情
* @Date 2021/03/01 18:19
* @Author L.G.Y
-->
<template>
  <div class="animated fadeIn">
    <el-card>
      <el-row type="flex" justify="space-between">
        <div class="cost-order-title">
          <h6>成本单详情</h6>
        </div>
        <div>
          <h6>订单状态：
            <span :style="formData.status === 'CANCELLED' ? 'color: #F56C6C' : ''">
              {{getEnum('CostOrderType', formData.status)}}
            </span>
          </h6>
        </div>
      </el-row>
      <div class="pt-2"></div>
      <el-row type="flex" justify="start" class="detail-container">
        <el-col :span="6">
          <h6>任务单号：{{formData.code}}</h6>
        </el-col>
        <el-col :span="6">
          <h6>关联工单：
            <el-button type="text" @click="onProductDetail(formData.productionOrder.id)" class="code-btn">{{formData.productionOrder.code}}</el-button>
          </h6>
        </el-col>
        <el-col :span="6">
          <h6>关联款号：{{formData.productionOrder.product.skuID}}</h6>
        </el-col>
        <el-col :span="6">
          <h6>创建时间：{{formData.creationtime | timestampToTime}}</h6>
        </el-col>
      </el-row>
      <div class="detail-container">
        <purchase-requirement-table :formData="formData" :readCostOnly="true" :isFromCost="true"/>
      </div>
      <div class="detail-container">
        <h6 class="additional-title">附加项</h6>
        <el-table :data="formData.customRows">
          <el-table-column label="类型" prop="customCategoryName"></el-table-column>
          <el-table-column label="名称" prop="name"></el-table-column>
          <el-table-column label="单位" prop="unit"></el-table-column>
          <el-table-column label="单价" prop="price"></el-table-column>
        </el-table>
      </div>
      <div class="detail-container" v-if="formData.purchaseTask && formData.purchaseTask.id" style="margin-top: 20px">
        <h6>关联采购需求：
          <el-button type="text" @click="onPurchaseDetail(formData.purchaseTask.id)" class="code-btn">{{formData.purchaseTask.code}}</el-button>
        </h6>
      </div>
      <el-row type="flex" justify="center" style="margin-top: 20px" :gutter="50" v-if="formData.status === 'PENDING_ACCOUNT'">
        <el-button type="text" @click="onCancel">取消</el-button>
        <el-button class="create-btn" @click="onEdit">编辑</el-button>
      </el-row>
    </el-card> 
    <el-dialog :visible.sync="productionVisible" width="80%" append-to-body :close-on-click-modal="false">
      <production-order-detail v-if="productionVisible" :id="productionId" />
    </el-dialog>
    <el-dialog :visible.sync="purchaseVisible" width="80%" append-to-body :close-on-click-modal="false">
      <purchase-requirement-detail v-if="purchaseVisible" :id="purchaseId"/>
    </el-dialog>
  </div>
</template>

<script>
import PurchaseRequirementTable from '@/views/purchase/requirement/components/PurchaseRequirementTable'
import ProductionOrderDetail from '@/views/order/salesProduction/production-order/details/ProductionOrderDetail'
import PurchaseRequirementDetail from '@/views/purchase/requirement/details/PurchaseRequirementDetail'

export default {
  name: 'CostOrderDetail',
  props: ['id'],
  components: {
    PurchaseRequirementTable,
    ProductionOrderDetail,
    PurchaseRequirementDetail
  },
  data () {
    return {
      formData: {
        code: '',
        productionOrder: {
          code: '',
          product: {
            skuID: ''
          }
        },
        customRows: [],
        purchaseMaterials: []
      },
      productionId: '',
      productionVisible: false,
      purchaseId: '',
      purchaseVisible: false
    }
  },
  methods: {
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

      data.workOrders = purchaseMaterials;
      data.customRows = customRows;
      data.productionOrder.product = {
        skuID: data.productionOrder.productSkuID
      }

      this.$set(this, 'formData', data);
    },
    onProductDetail (id) {
      this.productionId = id;
      this.productionVisible = true;
    },
    onPurchaseDetail (id) {
      this.purchaseId = id;
      this.purchaseVisible = true;
    },
    onEdit () {
      this.$confirm('是否执行编辑成本单操作?', '', {
        confirmButtonText: '是',
        cancelButtonText: '否',
        type: 'warning'
      }).then(() => {
        this._onEdit();
      });
    },
    _onEdit () {
      this.$router.push({
        name: '创建成本单',
        params: {
          formData: Object.assign({}, this.formData)
        }
      });
    },
    onCancel () {
      this.$confirm('是否执行取消成本单操作?', '', {
        confirmButtonText: '是',
        cancelButtonText: '否',
        type: 'warning'
      }).then(() => {
        this._onCancel();
      });
    },
    async _onCancel () {
      const url = this.apis().cancelCostOrder(this.formData.id);
      const result = await this.$http.put(url);

      if (result.code === 1) {
        this.$message.success('成本单取消成功！');
        this.$router.push('/purchase/cost');
      } else if (result.code === 0) {
        this.$message.error(result.msg);
      } else if (result['errors']) {
        this.$message.error(result['errors'][0].message);
      }
    }
  },
  created () {
    this.getDetail();
  }  
}
</script>

<style scoped>
  .cost-order-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .detail-container {
    margin: 0px 0px 10px 20px;
  }

  .additional-title {
    font-size: 14px;
    color: #606266;
  }

  .code-btn {
    font-size: 14px;
    padding: 0px;
  }

  .create-btn {
    background-color: #ffd60c;
    border-color: #FFD5CE;
    color: #000;
    width: 120px;
    height: 40px;
  }
</style>