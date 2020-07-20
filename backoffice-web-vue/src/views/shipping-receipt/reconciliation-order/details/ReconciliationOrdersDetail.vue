<template>
  <div class="animated fadeIn">
    <el-card>
      <el-row type="flex" justify="space-between">
        <el-col :span="4">
          <div class="title">
            <h6>对账单详情</h6>
          </div>
        </el-col>
        <el-col :span="4">
          <div>
            <h6>状态: {{getEnum('ReconciliationOrderState',formData.state)}}</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <el-form :inline="true" ref="form">
        <el-row type="flex" style="padding-left: 10px">
          <el-col :span="24">
            <reconciliation-orders-detail-head :formData="formData" />
          </el-col>
        </el-row>
        <el-row type="flex" style="padding-left: 10px">
          <el-col :span="24">
            <shipping-orders-list :formData="formData" />
          </el-col>
        </el-row>
        <el-row type="flex" style="padding-left: 10px;margin-top: 20px">
          <el-col :span="24">
            <reconciliation-orders-form-foot :formData="formData" :readOnly="readOnly" ref="footComp" :isForm="false"/>
          </el-col>
        </el-row>
        <el-row type="flex" justify="end" style="padding-left: 10px;margin-top: 20px">
          <el-col :span="6" v-if="readOnly">
            <h5>应付金额：{{formData.amountDue?formData.amountDue.toFixed(2):0}}元</h5>
          </el-col>
          <el-col :span="6" v-else>
            <h5>应付金额：{{payable}}元</h5>
          </el-col>
        </el-row>
        <el-row type="flex" v-if="isShipPart&&formData.state=='APPROVAL_RETURN'">
          <el-col :span="12">
            <h5 style="color:red">驳回理由：<span style="color:black">{{formData.auditWorkOrder.auditMsg}}</span></h5>
          </el-col>
        </el-row>
        <el-row type="flex"
          v-if="isReceiptPart&&formData.originAuditWorkOrder&&formData.originAuditWorkOrder.state=='AUDITED_FAILED'">
          <el-col :span="12">
            <h5 style="color:red">驳回理由：<span style="color:black">{{formData.originAuditWorkOrder.auditMsg}}</span></h5>
          </el-col>
        </el-row>
        <el-row type="flex" v-if="formData.state=='REJECTED'">
          <el-col :span="12">
            <h5 style="color:red">拒绝理由：<span style="color:black">{{formData.remarks}}</span></h5>
          </el-col>
        </el-row>
        <detail-btn-group :formData="formData" :readOnly="readOnly" @callback="getDetail" @onReject="onReject"
          @onAccept="onAccept" @onUpdate="onUpdate" @onSave="onSave" @onApproval="onApproval"
          @onOriginApproval="onOriginApproval" />
      </el-form>
    </el-card>
  </div>
</template>

<script>
  import Bus from '../../js/bus';

  import ReconciliationOrdersDetailHead from './ReconciliationOrdersDetailHead'
  import ReconciliationOrdersFormFoot from '../form/ReconciliationOrdersFormFoot'
  import ShippingOrdersList from './ShippingOrdersList'
  import DetailBtnGroup from './DetailBtnGroup'

  export default {
    name: 'ReconciliationOrdersDetail',
    props: ['id'],
    components: {
      ReconciliationOrdersDetailHead,
      ReconciliationOrdersFormFoot,
      ShippingOrdersList,
      DetailBtnGroup
    },
    computed: {
      payable: function () {
        let totalNum = 0;
        //选中发货单收货总额
        if (this.formData.shippingSheets != null) {
          this.formData.shippingSheets.forEach(sheet => {
            if (sheet.receiptSheets != null) {
              sheet.receiptSheets.forEach(entry => {
                let num = parseInt(entry.totalQuantity);
                if (!Number.isNaN(num)) {
                  totalNum += num;
                }
              });
            }
          });
        }
        let unitPrice = 0;
        if (this.formData.productionTaskOrder.unitPrice != null) {
          unitPrice = this.formData.productionTaskOrder.unitPrice;
        }

        //扣款项
        let deduction = 0;
        this.formData.deductions.forEach(element => {
          let num = parseFloat(element.amount);
          if (!Number.isNaN(num)) {
            deduction += num;
          }
        });

        //增款项
        let increase = 0;
        this.formData.increases.forEach(element => {
          let num = parseFloat(element.amount);
          if (!Number.isNaN(num)) {
            increase += num;
          }
        });

        return (unitPrice * totalNum + increase - deduction).toFixed(2);
      },
      //发货方
      isShipPart: function () {
        if (this.formData.shipParty) {
          return this.currentUser.companyCode == this.formData.shipParty.uid;
        } else {
          return false;
        }
      },
      //收货方
      isReceiptPart: function () {
        if (this.formData.receiveParty) {
          return this.currentUser.companyCode == this.formData.receiveParty.uid;
        } else {
          return false;
        }
      },
    },
    methods: {
      async getDetail() {
        //获取对账单详情
        const url = this.apis().reconciliationDetail(this.id);
        const result = await this.$http.get(url);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        } else if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        }
        this.formData = result.data;
      },
      onReject() {
        this.$prompt('拒绝理由', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
        }).then(({
          value
        }) => {
          this._onReject(value);
        }).catch(() => {

        });
      },
      async _onReject(reason) {
        //获取对账单详情
        const url = this.apis().reconciliationReject(this.id);
        const result = await this.$http.put(url, {
          remarks: reason
        });
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        } else if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        } else if (result.code == '1') {
          this.$message.success(result.msg);
          this.getDetail();
          //通知对账任务刷新
          Bus.$emit('reconciliation-task-details_onRefresh');
        }
      },
      onAccept() {
        this.$confirm('提示：对账单一旦确认将不能进行修改，是否确定此操作', '提示', {
          confirmButtonText: '是',
          cancelButtonText: '否',
          type: 'warning'
        }).then(() => {
          this._onAccept();
        }).catch(() => {

        });
      },
      async _onAccept() {
        //是否需要审核
        let submitForm = {};
        if (this.formData.isOriginApproval) {
          submitForm = {
            isOriginApproval: true,
            originApprovers: this.formData.originApprovers
          }
        }

        //获取对账单详情
        const url = this.apis().reconciliationAccept(this.id);
        const result = await this.$http.put(url, submitForm);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        } else if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        } else if (result.code == '1') {
          this.$message.success(result.msg);
          this.getDetail();
          //通知对账任务刷新
          Bus.$emit('reconciliation-task-details_onRefresh');
        }
      },
      onUpdate() {
        this.readOnly = false;
      },
      onSave() {
        this.$refs.footComp.$refs.footForm.validate((valid) => {
          if (valid) {
            this._onSave();
          } else {
            return false;
          }
        });
      },
      async _onSave() {
        const url = this.apis().reconciliationUpdate();

        let submitForm = Object.assign({}, this.formData);
        //若不需要审核，则删除字段
        if (!submitForm.isApproval) {
          this.$delete(submitForm, 'approvers');
        }
        const result = await this.$http.put(url, this.formData);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        } else if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        } else if (result.code == '1') {
          this.$message.success(result.msg);
          this.readOnly = true;
          this.getDetail();
          //通知对账任务刷新
          Bus.$emit('reconciliation-task-details_onRefresh');
        }
      },
      //审批
      onApproval(isPass) {
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
        this.getDetail();
        //通知对账任务刷新
        Bus.$emit('reconciliation-task-details_onRefresh');
      },
      //确认方审批
      onOriginApproval(isPass) {
        if (isPass) {
          this.$confirm('是否确认审核通过?', '提示', {
            confirmButtonText: '确定',
            cancelButtonText: '取消',
            type: 'warning'
          }).then(() => {
            this._onOriginApproval(isPass, '');
          });
        } else {
          this.$prompt('请输入不通过原因', '提示', {
            confirmButtonText: '确定',
            cancelButtonText: '取消',
          }).then(({
            value
          }) => {
            this._onOriginApproval(isPass, value);
          }).catch(() => {
            //TODO:取消操作
          });
        }
      },
      async _onOriginApproval(isPass, auditMsg) {
        let formData = {
          id: this.formData.originAuditWorkOrder.id,
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
        this.getDetail();
        //通知对账任务刷新
        Bus.$emit('reconciliation-task-details_onRefresh');
      }
    },
    data() {
      return {
        currentUser: this.$store.getters.currentUser,
        readOnly: true,
        formData: {
          code: '',
          productionTaskOrder: {
            code: '',
            unitPrice: 0
          }
        }
      }
    },
    created() {
      this.getDetail();
    }
  }

</script>

<style scoped>
  .title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

</style>
