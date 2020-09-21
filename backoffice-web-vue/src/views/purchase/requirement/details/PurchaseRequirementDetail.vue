<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row type="flex" justify="space-between">
        <el-col :span="6">
          <div class="purchase-list-title">
            <h6>采购需求详情</h6>
          </div>
        </el-col>
        <el-col :span="6">
          <h6>状态/标签：{{getEnum('PurchaseTaskState', formData.state)}}</h6>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <el-row type="flex" justify="start" class="basic-row">
        <el-col :span="6">
          <h6>任务单号：{{formData.code}}</h6>
        </el-col>
        <el-col :span="6">
          <h6>关联订单：{{formData.productionTask.code}}</h6>
        </el-col>
        <el-col :span="6">
          <h6>关联款号：{{formData.productionTask.product.skuID}}</h6>
        </el-col>
        <el-col :span="6">
          <h6>创建时间：{{formData.creationtime | timestampToTime}}</h6>
        </el-col>
      </el-row>
      <el-row type="flex" justify="start" class="basic-row">
        <el-col :span="6">
          <h6>是否含税：{{formData.auditNeed ? '是' : '否'}}</h6>
        </el-col>
        <el-col :span="6">
          <h6>品质要求：{{getEnum('QualityRequirementType', formData.quanlityRequirement)}}</h6>
        </el-col>
        <el-col :span="6">
          <h6>采购员：{{formData.merchandiser.name}}</h6>
        </el-col>
      </el-row>
      <el-row type="flex" justify="start" class="basic-row">
        <h6>收货地址：{{formData.shippingAddress.details}}</h6>
      </el-row>
      <purchase-requirement-table :formData="formData"/>
    </el-card>
  </div>
</template>

<script>
import PurchaseRequirementTable from '../components/PurchaseRequirementTable'

export default {
  name: 'PurchaseRequirementDetail',
  props: ['id'],
  components: {
    PurchaseRequirementTable
  },
  methods: {
    async getDetail () {
      const id = this.id;

      const url = this.apis().getPurchaseTask(id);
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
      let workOrders = []; 
      let data = Object.assign({}, resultData);
      resultData.workOrders.forEach(row => {
        if (row.materials && row.materials.specList && row.materials.specList.length > 0) {
          workOrders = workOrders.concat(row.materials.specList.map(item => {
            return {
              name: row.materials.name,
              code: row.materials.code,
              unit: row.materials.unit,
              materialsType: row.materials.materialsType,
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
              cooperatorName: row.cooperatorName,
              price: item.price,
              totalPrice: item.totalPrice
            }
          }));
        }
      })
      data.workOrders = workOrders;
      this.formData = Object.assign({}, data);
    }
  },
  data () {
    return {
      formData: {
        state: 'NOT_COMMITED',
        code: '',
        productionTask: {
          code: '',
          product: {
            skuID: ''
          }
        },
        auditNeed: false,
        quanlityRequirement: 'NO_REQUIREMENT',
        merchandiser: {
          name: ''
        },
        shippingAddress: {
          details: ''
        },
        workOrders: []
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
</style>