<template>
  <div class="animated fadeIn">
    <el-card>
      <div id="purchase-order-detail">
        <el-row type="flex" justify="space-between"> 
          <el-col :span="6">
            <div class="purchase-list-title">
              <h6>采购单详情</h6>
            </div>
          </el-col>
          <el-col :span="6">
            <h6>状态/标签：{{getEnum('PurchaseOrderState', orderDetail.state)}}</h6>
          </el-col>
        </el-row>
        <div class="pt-2"></div>
        <div class="basic-row">
          <purchase-order-basic-info :formData="orderDetail.workOrder" :order="orderDetail" :readOnly="true"/>
          <el-divider></el-divider>
          <el-row type="flex" justify="start">
            <h6>采购信息</h6>
          </el-row>
          <el-row type="flex" justify="start">
            <h6>供应商：{{cooperator}}</h6>
          </el-row>
          <purchase-material-table :order="orderDetail" :readOnly="true"/>
          <purchase-order-detail-tabs :order="orderDetail" @callback="callback" @getDetail="getDetail" :paymentList="paymentList"/>
          <template v-if="orderDetail.currentAuditWork &&orderDetail.currentAuditWork.processes&& orderDetail.currentAuditWork.processes.length > 0">
            <order-audit-detail :processes="orderDetail.currentAuditWork.processes" />
          </template>
        </div>
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
      </el-row>
      <el-row type="flex" justify="center">
        <printer-button v-print="'#purchase-order-detail'" />
      </el-row>
    </el-card>
  </div>
</template>

<script>
import PurchaseOrderBasicInfo from '../components/PurchaseOrderBasicInfo'
import PurchaseMaterialTable from '../components/PurchaseMaterialTable'
import PurchaseOrderDetailTabs from './PurchaseOrderDetailTabs'
import { OrderAuditDetail } from '@/views/order/salesProduction/components/'
import { PrinterButton } from '@/components/index.js'

export default {
  name: 'PurchaseOrderDetail',
  props: ['id'],
  components: {
    PurchaseOrderBasicInfo,
    PurchaseMaterialTable,
    PurchaseOrderDetailTabs,
    OrderAuditDetail,
    PrinterButton
  },
  computed: {
    canReturn: function () {
      if (this.orderDetail.state !== 'AUDITING') {
        return false;
      }

      return this.orderDetail.workOrder.task.merchandiser.uid === this.$store.getters.currentUser.uid;
    },
    cooperator: function () {
      if (!this.orderDetail.cooperator && this.orderDetail.cooperatorName) {
        return this.orderDetail.cooperatorName;
      }
      if (this.orderDetail.cooperator) {
        return this.orderDetail.cooperator.type === 'ONLINE' ? this.orderDetail.cooperator.partner.name : this.orderDetail.cooperator.name;
      }
    },
    canAudit: function () {
      if (this.orderDetail.state !== 'AUDITING') {
        return false;
      }
      // 订单审核状态在待审核且登陆账号为审核人
      let flag = this.orderDetail.currentAuditWork && 
                 this.orderDetail.currentAuditWork.processes && 
                 this.orderDetail.currentAuditWork.processes.length > 0 &&
                 this.orderDetail.currentAuditWork.currentUserAuditState && 
                 this.orderDetail.currentAuditWork.currentUserAuditState === 'AUDITING';
      if (flag) {
        return true;
      }
      return false;
    },
  },
  methods: {
    async getDetail () {
      const url = this.apis().searchPurchaseOrderById(this.id);
      const result = await this.$http.get(url);
      if (result['errors']) {
        this.$message.error(result['errors'][0].message);
        return;
      }
      if (result.code === 1) {
        this.orderDetail = result.data;
        this.orderDetail.entries.forEach(item => {
          if (!item.receiveQuantity) {
            this.$set(item, 'receiveQuantity', 0);
          }
          if (!item.remark) {
            this.$set(item, 'remark', '');
          }
        })
        if (!this.orderDetail.attachAgreements) {
          this.$set(this.orderDetail, 'attachAgreements', []);
        }
      } else if (result.code === 0) {
        this.$message.error(result.msg);
        return;
      }
    },
    async getPayment () {
      const url = this.apis().getPaymentRequestByOrder(this.id);
      const result = await this.$http.get(url);
      if (result['errors']) {
        this.$message.error(result['errors'][0].message);
      }
      this.paymentList = result.data.filter(item => item.paymentRecords);
    },
    onApproval(isPass) {
      if (this.orderDetail.currentAuditWork.auditingUser.uid === this.$store.getters.currentUser.uid &&
        this.orderDetail.currentAuditWork.currentUserAuditState === 'AUDITING') {
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
      } else if (this.orderDetail.currentAuditWork.currentUserAuditState === 'AUDITING' &&
        this.orderDetail.currentAuditWork.auditingUser.uid !== this.$store.getters.currentUser.uid) {
        this.$message.warning('此订单暂未轮到您进行审批。')
      } else if (this.orderDetail.currentAuditWork.currentUserAuditState === 'PASSED') {
        this.$message.warning('您已对此订单进行了审批。');
      }
    },
    async _onApproval(isPass, auditMsg) {
      let formData = {
        id: this.orderDetail.currentAuditWork.id,
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
      const id = this.id;

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
          this.callback();
        }, 1000);
      } else if (result.code === 0) {
        this.$message.error(result.msg);
        return;
      } else {
        this.$message.error('审核撤回失败！');
      }
    },
    callback () {
      this.$emit('callback');
    }
  },
  data () {
    return {
      paymentList: [],
      orderDetail: {
        code: '',
        state: 'WAIT_TO_REV_MATERIALS',
        entries: [],
        workOrder: {
          materials: {
            code: '',
            specList: [{
            }]
          },
          task: {
            productionTask: {
              product: {
                skuID: ''
              }
            },
            shippingAddress: {
              details: ''
            },
            merchandiser: {
              uid: ''
            }
          }
        }
      }
    }
  },
  created () {
    this.getDetail();
    this.getPayment();
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
</style>