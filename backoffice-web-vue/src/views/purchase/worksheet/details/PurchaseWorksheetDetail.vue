<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row type="flex" justify="space-between"> 
        <el-col :span="6">
          <div class="purchase-list-title">
            <h6>采购工单</h6>
          </div>
        </el-col>
        <el-col :span="6">
          <h6>状态/标签：{{getEnum('PurchaseWorksheetState', formData.state)}}</h6>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <el-row type="flex" justify="start" class="basic-row">
        <el-col :span="6">
          <h6>工单号：{{formData.code}}</h6>
        </el-col>
        <el-col :span="6">
          <h6>关联款号：{{formData.task.productionTask.product.skuID}}</h6>
        </el-col>
        <el-col :span="6">
          <h6>关联需求：{{formData.task.productionTask.code}}</h6>
        </el-col>
        <el-col :span="6">
          <h6>创建时间：{{formData.creationtime | timestampToTime}}</h6>
        </el-col>
      </el-row>
      <div class="basic-info-container">
        <el-row type="flex" justify="start" class="basic-row">
          <el-col :span="6">
            <h6>物料编号：{{formData.materials.code}}</h6>
          </el-col>
          <el-col :span="6">
            <h6>物料属性：{{getEnum('MaterialsType', formData.materials.materialsType)}}</h6>
          </el-col>
          <el-col :span="6">
            <h6>单位：{{formData.materials.unit}}</h6>
          </el-col>
          <el-col :span="6">
            <h6>供应商：{{formData.cooperatorName}}</h6>
          </el-col>
        </el-row>
        <el-row type="flex" justify="start" class="basic-row">
          <el-col :span="6">
            <div style="display: flex;flex-wrap: wrap;">
              <h6>是否含税：{{formData.task.includeTax ? '是' : '否'}}</h6>
              <h6 v-if="formData.task.includeTax" style="margin-left: 30px">税点：{{formData.task.taxPoint * 100}}%</h6>
            </div>
          </el-col>
          <el-col :span="6">
            <h6>品质要求：{{getEnum('QualityRequirementType', formData.task.qualityRequirement)}}</h6>
          </el-col>
          <!-- <el-col :span="6">
            <h6>是否批色：{{'是'}}</h6>
          </el-col> -->
        </el-row>
        <el-row type="flex" justify="start" class="basic-row">
          <h6>收货地址：{{formData.task.shippingAddress.details}}</h6>
        </el-row>
      </div>
      <el-divider></el-divider>
      <purchase-info-table :materials="materials"/>
      <purchase-order-list-info :formData="formData" :materials="materials" 
                                @callback="callback" :purchaseOrderList="purchaseOrderList"/>
      <el-divider></el-divider>
      <purchase-summary :formData="formData"/>
      <el-row type="flex" justify="center" style="margin: 40px 0px 0px 0px;">
        <el-button class="sumbit-btn" @click="onFinish">采购完成</el-button>
      </el-row>
    </el-card>
  </div>
</template>

<script>
import PurchaseInfoTable from '../components/PurchaseInfoTable'
import PurchaseOrderListInfo from '../components/PurchaseOrderListInfo'
import PurchaseSummary from '../components/PurchaseSummary'

export default {
  name: 'PurchaseWorksheetDetail',
  props: ['id'],
  components: {
    PurchaseInfoTable,
    PurchaseOrderListInfo,
    PurchaseSummary
  },
  methods: {
    async getDetail () {
      const id = this.id;
      const url = this.apis().getPurchaseWorkOrderDetail(id);
      const result = await this.$http.get(url);
      if (result['errors']) {
        this.$message.error(result['errors'][0].message);
        return;
      }
      if (result.code === 1) {
        this.formData = result.data;

        // 整理物料行
        this.materials = result.data.materials.specList.map(item => {
          return {
            id: item.id,
            name: result.data.materials.name,
            colorName: item.colorName,
            modelName: item.specName,
            specName: item.specName,
            unitQuantity: item.unitQuantity,
            estimatedLoss: item.estimatedLoss,
            estimatedUsage: item.estimatedUsage,
            orderCount: item.orderCount,
            emptySent: item.emptySent,
            requiredAmount: item.requiredAmount,
            price: item.price,
            totalPrice: item.totalPrice
          }
        })
      }
    },
    async getPurchaseOrder () {
      const id = this.id;
      const url = this.apis().searchPurchaseOrderByWorksheetId(id);
      const result = await this.$http.get(url);
      if (result['errors']) {
        this.$message.error(result['errors'][0].message);
        return;
      }
      if (result.code === 1) {
        this.purchaseOrderList = result.data;
      } else if (result.code === 0) {
        this.$message.error(result.msg);
        return;
      }
    },
    onFinish () {

    },
    callback () {
      this.getPurchaseOrder();
    }
  },
  data () {
    return {
      materials: [],
      formData: {
        state: 'WAIT_TO_PURCHASE',
        code: '',
        creationtime: '',
        materials: {
          code: '',
          name: '',
          materialsType: 'PLUS_MATERIAL',
          unit: ''
        },
        cooperatorName: '',
        task: {
          productionTask: {
            code: '',
            product: {
              skuID: ''
            }
          },
          shippingAddress: {
            details: ''
          }
        }
      },
      purchaseOrderList: []
    }
  },
  created () {
    this.getDetail();
    this.getPurchaseOrder();
  }  
}
</script>

<style scoped>
  .purchase-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .basic-row {
    margin: 0px 0px 10px 20px;
  }

  .basic-info-container {
    border: 2px solid #E5E5E5;
    border-radius: 6px;
    padding-top: 10px;
  }

  /deep/ .el-divider--horizontal {
    margin: 12px 0;
  }
  
  .sumbit-btn {
    width: 100px;
    color: #606266;
    background: #FFD60C;
  }
</style>