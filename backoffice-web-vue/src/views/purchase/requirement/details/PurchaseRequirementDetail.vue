<template>
  <div class="animated fadeIn">
    <el-card>
      <div id="purchase-requirement-detail">
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
            <h6>关联信息：{{contextInfo}}</h6>
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
      </div>
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
      <el-row type="flex" justify="center" align="middle" style="margin-top: 20px">
        <el-button v-if="canReturn" class="sumbit-btn" @click="onReturn">撤回</el-button>
        <el-button v-if="formData.state === 'NOT_COMMITED'" class="sumbit-btn" @click="onEdit">编辑</el-button>
      </el-row>
      <el-row type="flex" justify="center">
        <printer-button v-print="'#purchase-requirement-detail'" />
      </el-row>
    </el-card>
    <el-dialog :visible.sync="costOrderVisible" width="80%" append-to-body :close-on-click-modal="false">
      <cost-order-detail v-if="costOrderVisible" :id="costOrderId"/>
    </el-dialog>
  </div>
</template>

<script>
import PurchaseRequirementTable from '../components/PurchaseRequirementTable'
import { OrderAuditDetail } from '@/views/order/salesProduction/components/'
import ProductionOrderDetail from '@/views/order/salesProduction/production-order/details/ProductionOrderDetail'
import { PrinterButton } from '@/components/index.js'
import CostOrderDetail from '@/views/purchase/cost/details/CostOrderDetail'
import RelationCostOrder from '../components/RelationCostOrder'

export default {
  name: 'PurchaseRequirementDetail',
  props: ['id'],
  components: {
    PurchaseRequirementTable,
    OrderAuditDetail,
    ProductionOrderDetail,
    PrinterButton,
    CostOrderDetail,
    RelationCostOrder
  },
  computed: {
    contextInfo: function () {
      if (this.formData.profitLossAnalysisEntry) {
        return this.formData.profitLossAnalysisEntry.skuID + ' / ' + this.formData.profitLossAnalysisEntry.colors.map(item => item.name).toString()
      }
    },
    canReturn: function () {
      if (this.formData.state !== 'AUDITING') {
        return false;
      }
      return this.formData.creator.uid === this.$store.getters.currentUser.uid;
    },
    canAudit: function () {
      if (this.formData.state !== 'AUDITING') {
        return false;
      }
      // 订单审核状态在待审核且登陆账号为审核人
      const flag = this.formData.auditWorkOrder && 
                    this.formData.auditWorkOrder.auditingUser.uid === this.$store.getters.currentUser.uid &&
                    this.formData.auditWorkOrder.currentUserAuditState == 'AUDITING';
                    
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
    onCostDetail (id) {
      this.costOrderId = id;
      this.costOrderVisible = true;
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
    async onReturn () {
      const id = this.formData.id;

      const url = this.apis().revokeTask(id);
      const result = await this.$http.delete(url);

      if (result['errors']) {
        this.$message.error(result['errors'][0].message);
        return;
      }
      if (result.code === 1) {
        this.$message.success('审核撤回成功！');
        
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
      } else if (result.code === 0) {
        this.$message.error(result.msg);
        return;
      } else {
        this.$message.error('审核撤回失败！');
      }
    },
    initData (resultData) {
      let workOrders = []; 
      let data = Object.assign({}, resultData);
      resultData.workOrders.forEach(row => {
        if (row.materials && row.materials.specList && row.materials.specList.length > 0) {
          workOrders = workOrders.concat(row.materials.specList.map(item => {
            return {
              id: row.id,
              state: row.state,
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
              totalPrice: item.totalPrice,
              actuallyOrderQuantity: item.actuallyOrderQuantity,
              actuallyPrice: item.actuallyPrice,
              actuallyTotalPrice: item.actuallyTotalPrice,
              receiveQuantity: item.receiveQuantity,
              remainQuantity: item.remainQuantity,
              completeTime: row.completeTime,
              composition: item.composition,
              purpose: item.purpose,
              quoteLossRate: item.quoteLossRate,
              quoteAmount: item.quoteAmount,
              remarks: item.remarks
            }
          }));
        }
      })
      data.workOrders = workOrders;
      this.formData = Object.assign({}, data);
    },
    onEdit () {
      this.$confirm('是否前往编辑采购需求页面?', '', {
        confirmButtonText: '是',
        cancelButtonText: '否',
        type: 'warning'
      }).then(() => {
        this._onEdit();
      });
    },
    _onEdit () {
      let data = Object.assign({}, this.formData);
      if (!data.approvers) {
        data.approvers = [null];
        data.auditNeeded = false
      } else {
        data.auditNeeded = true;
      }

      this.$router.push({
        name: '创建采购需求',
        params: {
          formData: data
        }
      });
    }
  },
  data () {
    return {
      costOrderId: '',
      costOrderVisible: false,
      formData: {
        state: 'NOT_COMMITED',
        code: '',
        costOrder: {
          id: '',
          code: '',
          productionOrder: {
            productSkuID: ''  
          }
        },
        // productionTask: {
        //   code: '',
        //   product: {
        //     skuID: ''
        //   }
        // },
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

  .sumbit-btn {
    width: 100px;
    color: #606266;
    background-color: #ffd60c;
  }

  .code-btn {
    font-size: 14px;
    padding: 0px;
  }
</style>