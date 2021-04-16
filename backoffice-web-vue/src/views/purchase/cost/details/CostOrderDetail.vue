<!--
* @Description: 成本单-详情
* @Date 2021/03/01 18:19
* @Author L.G.Y
-->
<template>
  <div class="animated fadeIn">
    <el-card>
      <div id="cost-order-detail">
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
            <!-- <h6>关联工单：
              <el-button type="text" @click="onTaskDetail(formData.productionOrder.id)" class="code-btn">{{formData.productionOrder.code}}</el-button>
            </h6> -->
            <h6>关联产品：
              <el-button type="text" @click="onProductDetail(formData.product)" class="code-btn">{{formData.product.code}}</el-button>
            </h6>
          </el-col>
          <el-col :span="6">
            <h6>关联款号：{{formData.product.skuID}}</h6>
          </el-col>
          <el-col :span="6">
            <h6>创建时间：{{formData.creationtime | timestampToTime}}</h6>
          </el-col>
        </el-row>
        <div class="detail-container">
          <cost-purchase-table :formData="formData" :readOnly="true" :isFromCost="true"/>
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
        <el-row class="detail-container" style="margin-top: 30px" type="flex" justify="end">
          <el-col :span="4">
            <h5>成本总额：{{totalCost}}</h5>
          </el-col>
        </el-row>
        <div class="detail-container" v-if="formData.purchaseTask && formData.purchaseTask.id" style="margin-top: 20px">
          <h6>关联采购需求：
            <el-button type="text" @click="onPurchaseDetail(formData.purchaseTask.id)" class="code-btn">{{formData.purchaseTask.code}}</el-button>
          </h6>
        </div>
      </div>
      <el-row type="flex" justify="center" style="margin-top: 20px" :gutter="50" v-if="formData.status === 'PENDING_ACCOUNT'">
        <el-button type="text" @click="onCancel">取消</el-button>
        <el-button class="create-btn" @click="onEdit">编辑</el-button>
        <el-button class="create-btn" @click="onCreatePurchase">创建报价单</el-button>
      </el-row>
      <el-row type="flex" justify="center" style="margin-top: 10px">
        <printer-button v-print="'#cost-order-detail'" />
      </el-row>
    </el-card> 
    <!-- <el-dialog :visible.sync="productionVisible" width="80%" append-to-body :close-on-click-modal="false">
      <production-order-detail v-if="productionVisible" :id="productionId" />
    </el-dialog> -->
    <el-dialog :visible.sync="productVisible" width="80%" append-to-body :close-on-click-modal="false">
      <sample-product-details-page v-if="productVisible" :formData="sample" :readOnly="true" />
    </el-dialog>
    <el-dialog :visible.sync="purchaseVisible" width="80%" append-to-body :close-on-click-modal="false">
      <purchase-requirement-detail v-if="purchaseVisible" :id="purchaseId"/>
    </el-dialog>
  </div>
</template>

<script>
import {
  createNamespacedHelpers
} from 'vuex';

const {
  mapGetters,
  mapMutations,
  mapActions
} = createNamespacedHelpers('SampleProductsModule');
import ProductionOrderDetail from '@/views/order/salesProduction/production-order/details/ProductionOrderDetail'
import SampleProductDetailsPage from '@/views/product/sample/details/SampleProductDetailsPage'
import CostPurchaseTable from '@/views/purchase/components/CostPurchaseTable'
import { PrinterButton } from '@/components/index.js'
import { handleInitData } from '../../components/handleTableData'

export default {
  name: 'CostOrderDetail',
  props: ['id', 'isFormDialog'],
  components: {
    ProductionOrderDetail,
    PurchaseRequirementDetail:()=>import('@/views/purchase/requirement/details/PurchaseRequirementDetail'),
    SampleProductDetailsPage,
    CostPurchaseTable,
    PrinterButton
  },
  computed: {
    ...mapGetters({
      newFormData: 'newFormData',
    }),
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
        product: {
          code: ''
        },
        productionOrder: {
          code: '',
          product: {
            skuID: ''
          }
        },
        customRows: [],
        purchaseMaterials: [],
        workOrders: []
      },
      productionId: '',
      productionVisible: false,
      productVisible: false,
      purchaseId: '',
      purchaseVisible: false,
      sample: ''
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
      
      data.workOrders = handleInitData(resultData.purchaseMaterials, 'WORKORDERS');
      data.customRows = handleInitData(resultData.customRows, 'CUSTOMROWS');

      this.$set(this, 'formData', data);
    },
    async onProductDetail (product) {
      const url = this.apis().getSampleProduct(product.code);
      const result = await this.$http.get(url);
      if (result['errors']) {
        this.$message.error(result['errors'][0].message);
        return;
      }

      this.sample = result;
      Object.assign(this.newFormData, result);

      this.productVisible = true;
    },
    onTaskDetail (id) {
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
      this.$router.push('/purchase/cost/edit/' + this.formData.id);
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
        if (this.isFormDialog) {
          this.$emit('callback');
          return;
        }
        this.$router.push('/purchase/cost');
      } else if (result.code === 0) {
        this.$message.error(result.msg);
      } else if (result['errors']) {
        this.$message.error(result['errors'][0].message);
      }
    },
    onCreatePurchase () {
      this.$router.push({
        name: '创建报价单',
        params: {
          costOrder: this.formData
        }
      });
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