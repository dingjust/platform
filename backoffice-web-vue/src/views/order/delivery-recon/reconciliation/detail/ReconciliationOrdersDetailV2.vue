<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row type="flex" justify="space-between">
        <el-col class="list-title">
          <h6>对账单详情</h6>
        </el-col>
        <el-col>
          <h6>出货单号：{{order.code}}</h6>
        </el-col>
        <el-col>
          <h6>创建日期：{{order.creationtime | timestampToTime}}</h6>
        </el-col>
        <el-col>
          <h6>状态：{{getEnum('ReconciliationV2Type', order.state)}}</h6>
        </el-col>
      </el-row>
      <reconciliation-detail-header :order="order" @showPDF="showPDF"/>
      <reconciliation-detail-table class="basic-container" v-if="order.id" :order="order"/>
      <el-row type="flex" class="basic-container">
        <div><h6>附件：</h6></div>
        <files-upload v-if="order.medias && order.medias.length > 0" :slotData="order.medias" :readOnly="true" :disabled="true"/>
      </el-row>
      <div v-if="isReceiveParty">
        <template v-if="order.auditWorkOrder && order.auditWorkOrder.processes && order.auditWorkOrder.processes.length > 0">
          <order-audit-detail class="basic-container" :processes="order.auditWorkOrder.processes" />
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
      </div>
      <el-row v-if="canConfirm" type="flex" justify="center">
        <el-button class="material-btn" @click="toConfirm">确认</el-button>
      </el-row>
    </el-card>
    <!-- 展示pdf组件 -->
    <el-dialog :visible.sync="pdfVisible" :show-close="true" width="80%" style="width: 100%" append-to-body :close-on-click-modal="false">
      <doc-signatures v-if="pdfVisible" :fileUrl="fileUrl" :pdfItem="pdfItem" :order="order"/>
    </el-dialog>
  </div>
</template>

<script>
import ReconciliationDetailTable from './ReconciliationDetailTable'
import ReconciliationDetailHeader from './ReconciliationDetailHeader'
import { OrderAuditDetail } from '@/views/order/salesProduction/components/'
import { FilesUpload } from '@/components'
import DocSignatures from '@/views/order/delivery-recon/components/DocSignatures'

export default {
  name: 'ReconciliationOrdersDetailV2',
  props: ['id'],
  components: {
    ReconciliationDetailTable,
    OrderAuditDetail,
    FilesUpload,
    ReconciliationDetailHeader,
    DocSignatures
  },
  computed: {
    isReceiveParty: function () {
      return this.order.receiveParty.uid === this.$store.getters.currentUser.companyCode;
    },
    canAudit: function () {
      if (this.order.state !== 'PENDING_APPROVAL') {
        return false;
      }
      // 订单审核状态在待审核且登陆账号为审核人
      if (this.order.approvers != null) {
        let flag = this.order.approvers.some(item => item.uid === this.$store.getters.currentUser.uid);
        return this.order.auditWorkOrder.currentUserAuditState == 'AUDITING' && flag;
      } else {
        return false;
      }
    },
    canConfirm: function () {
      // 出货方 && 合同为线下合同 && 订单状态为待乙方签署
      // 乙方需要进行确认操作
      return !this.isReceiveParty && 
        this.order.docSignatures[0].signMethod === 'OFFLINE_SIGN' && 
        this.order.state=== 'PENDING_B_SIGN';
    }
  },
  data () {
    return {
      order: {
        receiveParty: {},
        shipParty: {},
        cooperator: {
          partner: ''
        }
      },
      pdfVisible: false,
      fileUrl: '',
      pdfItem: ''
    }
  },
  methods: {
    async getDetail () {
      const url = this.apis().getReconciliationV2Detail(this.id);
      const result = await this.$http.get(url);

      if (result['errors']) {
        this.$message.error(result['errors'][0].message);
        return;
      }
      if (result.code === 0) {
        this.$message.error(result.msg);
        return;
      }

      this.$set(this, 'order', result.data);
    },
    async showPDF (item) {
      await this.getDetail();

      const index = this.order.docSignatures.findIndex(val => val.id === item.id);
      if (index > -1) {
        this.pdfItem = this.order.docSignatures[index];
        this.fileUrl = this.order.docSignatures[index].docPdf.url;
      } else {
        this.pdfItem = '';
        this.fileUrl = '';
      }

      this.pdfVisible = true;
    },
    //审批
    onApproval(isPass) {
      if (this.order.auditWorkOrder.auditingUser.uid === this.$store.getters.currentUser.uid &&
        this.order.auditWorkOrder.currentUserAuditState === 'AUDITING') {
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
      } else if (this.order.auditWorkOrder.currentUserAuditState === 'AUDITING' &&
        this.order.auditWorkOrder.auditingUser.uid !== this.$store.getters.currentUser.uid) {
        this.$message.warning('此订单暂未轮到您进行审批。')
      } else if (this.order.auditWorkOrder.currentUserAuditState === 'PASSED') {
        this.$message.warning('您已对此订单进行了审批。');
      }
    },
    async _onApproval(isPass, auditMsg) {
      let formData = {
        id: this.order.auditWorkOrder.id,
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
    toConfirm () {
      this.$confirm('是否进行确认操作?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this._toConfirm();
      });
    },
    async _toConfirm () {
      const id = this.order.id;

      const url = this.apis().ReconciliationPartyBConfirm(id);
      const result = await this.$http.put(url);

      if (result['errors']) {
        this.$message.error(result['errors'][0].message);
        return;
      }
      if (result.code === 0) {
        this.$message.error(result.msg);
        return;
      }
      this.$message.success('操作成功！');
      this.getDetail();
    }
  },
  created () {
    this.getDetail();
  }
}
</script>

<style scoped>
  .list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
    height: 16px;
  }

  .basic-container {
    margin: 0 0 20px 12px;
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