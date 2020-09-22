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
          <h6>状态/标签：{{formData.state}}</h6>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <el-row type="flex" justify="start" class="basic-row">
        <el-col :span="6">
          <h6>工单号：{{formData.code}}</h6>
        </el-col>
        <el-col :span="6">
          <h6>关联款号：{{'MJ-D206030'}}</h6>
        </el-col>
        <el-col :span="6">
          <h6>关联需求：{{'PO41002810'}}</h6>
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
            <h6>物料属性：{{formData.materials.materialsType}}</h6>
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
            <h6>是否含税：{{'含税'}}</h6>
          </el-col>
          <el-col :span="6">
            <h6>品质要求：{{'合格品'}}</h6>
          </el-col>
          <el-col :span="6">
            <h6>是否批色：{{'是'}}</h6>
          </el-col>
        </el-row>
        <el-row type="flex" justify="start" class="basic-row">
          <h6>收货地址：{{'广东省广州市海珠区云顶同创汇'}}</h6>
        </el-row>
      </div>
      <el-divider></el-divider>
      <purchase-info-table :materials="materials"/>
      <purchase-order-list-info :formData="formData"/>
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
    onFinish () {

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
        entries: [{
            name: '物料名称1',
            color: '白色',
            spec: '40cm',
            guige: '50kg',
            unitQuantity: 12,
            lossQuantity: 0.12,
            totalQuantity: 13.44,
            orderCount: 2000,
            spaceDiff: 100,
            needQuantity: 2000,
            materialPrice: 123,
            totalPrice: 9000000
          }, {
            name: '物料名称2',
            color: '白色',
            spec: '40cm',
            guige: '50kg',
            unitQuantity: 12,
            lossQuantity: 0.12,
            totalQuantity: 13.44,
            orderCount: 2000,
            spaceDiff: 100,
            needQuantity: 2000,
            materialPrice: 123,
            totalPrice: 9000000
        }],
        order: [{
            name: '123',
            code: '123'
          }, {
            code: '321',
            name: '3221'
        }]
      }
    }
  },
  created () {
    this.getDetail();
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