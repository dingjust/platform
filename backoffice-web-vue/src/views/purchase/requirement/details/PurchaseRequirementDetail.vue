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
          <div style="display: flex;flex-wrap: wrap;">
            <h6>是否含税：{{formData.includeTax ? '是' : '否'}}</h6>
            <h6 v-if="formData.includeTax" style="margin-left: 30px">税点：{{formData.taxPoint * 100}}%</h6>
          </div>
        </el-col>
        <el-col :span="6">
          <h6>品质要求：{{getEnum('QualityRequirementType', formData.qualityRequirement)}}</h6>
        </el-col>
        <el-col :span="6">
          <h6>采购员：{{formData.merchandiser.name}}</h6>
        </el-col>
      </el-row>
      <el-row type="flex" justify="start" class="basic-row">
        <h6>收货地址：{{formData.shippingAddress.details}}</h6>
      </el-row>
      <purchase-requirement-table :formData="formData" :readOnly="true"/>
      <template v-if="formData.auditWorkOrder &&formData.auditWorkOrder.processes&& formData.auditWorkOrder.processes.length > 0">
        <order-audit-detail :processes="formData.auditWorkOrder.processes" />
      </template>
      <el-row type="flex" justify="space-around" align="middle" style="margin-top: 20px" v-if="canAudit">
        <el-col :span="3">
          <authorized :permission="['DO_AUDIT']">
            <el-button class="material-btn_red" @click="onApproval(false)">审核驳回</el-button>
          </authorized>
        </el-col>
        <el-col :span="3">
          <authorized :permission="['DO_AUDIT']">
            <el-button class="material-btn" @click="onApproval(true)">审核通过</el-button>
          </authorized>
        </el-col>
      </el-row>
    </el-card>
  </div>
</template>

<script>
import PurchaseRequirementTable from '../components/PurchaseRequirementTable'
import { OrderAuditDetail } from '@/views/order/salesProduction/components/'

export default {
  name: 'PurchaseRequirementDetail',
  props: ['id'],
  components: {
    PurchaseRequirementTable,
    OrderAuditDetail
  },
  computed: {
    canAudit: function () {
      if (this.formData.state !== 'AUDITING') {
        return false;
      }
      // 订单审核状态在待审核且登陆账号为审核人
      let flag = this.formData.auditWorkOrder && 
                 this.formData.auditWorkOrder.processes && 
                 this.formData.auditWorkOrder.processes.length > 0 &&
                 this.formData.auditWorkOrder.currentUserAuditState && 
                 this.formData.auditWorkOrder.currentUserAuditState === 'AUDITING';
      if (flag) {
        return true;
      }
      return false;
    },
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
    onApproval(isPass) {
      if (this.formData.auditWorkOrder.auditingUser.uid === this.$store.getters.currentUser.uid &&
        this.formData.auditWorkOrder.currentUserAuditState === 'AUDITING') {
        if (isPass) {
          this.$confirm('是否确认审核通过?', '提示', {
            confirmButtonText: '确定',
            cancelButtonText: '取消',
            type: 'warning'
          }).then(() => {
            this._onApproval(isPass, '');
          });
        } else {
          this.$prompt('请输入不通过原因', '提示', {
            confirmButtonText: '确定',
            cancelButtonText: '取消',
          }).then(({
            value
          }) => {
            this._onApproval(isPass, value);
          }).catch(() => {
            //TODO:取消操作
          });
        }
      } else if (this.formData.auditWorkOrder.currentUserAuditState === 'AUDITING' &&
        this.formData.auditWorkOrder.auditingUser.uid !== this.$store.getters.currentUser.uid) {
        this.$message.warning('此订单暂未轮到您进行审批。')
      } else if (this.formData.auditWorkOrder.currentUserAuditState === 'PASSED') {
        this.$message.warning('您已对此订单进行了审批。');
      }
    },
    async _onApproval(isPass, auditMsg) {
      let formData = {
        id: this.formData.auditWorkOrder.id,
        auditMsg: auditMsg,
        state: isPass ? 'PASSED' : 'AUDITED_FAILED'
      };
      const url = this.apis().taskAudit();
      const result = await this.$http.post(url, formData);
      if (result.code == 0) {
        this.$message.error(result.msg);
        return
      }
      this.$message.success('审批成功');

      const loading = this.$loading({
        lock: true,
        text: 'Loading',
        spinner: 'el-icon-loading',
        background: 'rgba(0, 0, 0, 0.7)'
      });
      setTimeout(() => {
        loading.close();
        this.getDetail();
      }, 1000);
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
        qualityRequirement: 'NO_REQUIREMENT',
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

  .material-btn {
    background-color: #ffd60c;
    border-color: #FFD5CE;
    color: #000;
    width: 90px;
    height: 35px;
  }

  .material-btn_red {
    background-color: red;
    /* border-color: #FFD5CE; */
    color: white;
    width: 90px;
    height: 35px;
  }
</style>