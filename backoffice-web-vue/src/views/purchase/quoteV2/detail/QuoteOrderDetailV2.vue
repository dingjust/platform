<!--
* @Description: 报价单详情V2
* @Date 2021/03/30 17:51
* @Author L.G.Y
-->
<template>
  <div class="animated fadeIn content">
    <el-card>
      <div id="quote-order-detail">
        <el-row type="flex" justify="space-between">
          <div class="quote-order-title">
            <h6 style="margin: 0px">报价单详情</h6>
          </div>
          <div v-if="detail.status === 'CANCELLED'">
            <h6 style="margin: 0px; color: #F56C6C">
              订单已取消
            </h6>
          </div>
        </el-row>
        <div class="pt-2"></div>
        <el-row type="flex" justify="start" class="detail-container">
          <el-col :span="6">
            <h6>任务单号：{{detail.code}}</h6>
          </el-col>
          <el-col :span="6">
            <h6>关联成本单：
              <el-button type="text" @click="costVisible = true" class="code-btn">{{detail.refCostOrderCode}}</el-button>
            </h6>
          </el-col>
          <el-col :span="6">
            <h6>创建时间：{{detail.creationtime | timestampToTime}}</h6>
          </el-col>
        </el-row>
        <div class="detail-container">
          <cost-purchase-table :formData="detail.costOrder" :readOnly="true"/>
        </div>
        <div class="detail-container">
          <h6 class="additional-title">附加项</h6>
          <el-table :data="detail.costOrder.customRows">
            <el-table-column label="类型" prop="customCategoryName"></el-table-column>
            <el-table-column label="名称" prop="name"></el-table-column>
            <el-table-column label="单位" prop="unit"></el-table-column>
            <el-table-column label="单价" prop="price"></el-table-column>
          </el-table>
        </div>
        <quote-order-detail-total class="detail-container" :detail="detail" />
      </div>
      <el-row type="flex" justify="center" style="margin-top: 20px" :gutter="50" v-if="detail.status !== 'CANCELLED'">
        <el-button type="text" @click="onCancel">取消</el-button>
        <el-button class="create-btn" @click="onEdit">编辑</el-button>
      </el-row>
      <el-row type="flex" justify="center" style="margin-top: 10px">
        <printer-button v-print="'#quote-order-detail'" />
      </el-row>
    </el-card>
    <el-dialog :visible.sync="costVisible" width="80%" append-to-body :close-on-click-modal="false">
      <cost-order-detail v-if="costVisible" :id="detail.refCostOrderId" :isFormDialog="true" @callback="costVisible = false"/>
    </el-dialog>
  </div>
</template>

<script>
import CostOrderDetail from '../../cost/details/CostOrderDetail.vue';
import CostPurchaseTable from '@/views/purchase/components/CostPurchaseTable'
import QuoteOrderDetailTotal from './QuoteOrderDetailTotal'
import { PrinterButton } from '@/components/index.js'

export default {
  name: 'QuoteOrderDetailV2',
  props: ['id'],
  components: { CostOrderDetail, CostPurchaseTable, QuoteOrderDetailTotal, PrinterButton },
  data () {
    return {
      detail: {
        id: null, 
        code: '',
        refCostOrderId: '',
        refCostOrderCode: '',
        costOrder: {
          customRows: [],
          purchaseMaterials: [],
          workOrders: []
        }
      },
      costVisible: false
    }
  },
  methods: {
    async getDetail (id) {
      const url = this.apis().getQuoteOrderV2(id);
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
                materialsId: row.id,
                specListId: item.id,
                name: row.name,
                code: row.code,
                unit: row.unit,
                materialsType: row.materialsType,
                factoryName: row.factoryName,
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
                totalPrice: item.totalPrice,
                composition: item.composition,
                purpose: item.purpose,
                quoteLossRate: item.quoteLossRate,
                quoteAmount: item.quoteAmount,
                remarks: item.remarks
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

      this.$set(this, 'detail', data);
    },
    onCancel () {
      this.$confirm('是否执行取消报价单操作?', '', {
        confirmButtonText: '是',
        cancelButtonText: '否',
        type: 'warning'
      }).then(() => {
        this._onCancel();
      });
    },
    async _onCancel () {
      const url = this.apis().cancelQuoteOrderV2(this.id);
      const result = await this.$http.put(url);

      if (result.code === 1) {
        this.$message.success('取消报价单成功！');
        this.getDetail();
      } else if (result.code === 0) {
        this.$message.error(result.msg);
      } else if (result['errors']) {
        this.$message.error(result['errors'][0].message);
      } else {
        this.$message.error('操作失败！');
      }
    },
    onEdit () {
      this.$router.push('/purchase/quote/edit/' + this.id);
    }
  },
  created () {
    this.getDetail(this.id);
  },
  beforeRouteUpdate(to, from, next) {
    if (to.name === from.name && to.params.id != from.params.id) {
      this.costVisible = false;
      this.getDetail(to.params.id);
    }
    next();
  }
}
</script>

<style scoped>
  .quote-order-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .detail-container {
    margin: 0px 0px 10px 20px;
  }

  .code-btn {
    font-size: 14px;
    padding: 0px;
  }

  .additional-title {
    font-size: 14px;
    color: #606266;
  }

  .create-btn {
    background-color: #ffd60c;
    border-color: #FFD5CE;
    color: #000;
    width: 120px;
    height: 40px;
  }
</style>