<template>
  <div>
    <!--确认方(发货方) -->
    <template v-if="isShipPart">
      <!-- 接单确认(跟单员) -->
      <el-row type="flex" justify="center" align="middle" style="margin-top: 20px"
        v-if="formData.state=='PENDING_CONFIRM'&&(formData.originAuditWorkOrder==null||formData.originAuditWorkOrder.state=='AUDITED_FAILED')&&isShipOperator">
        <!-- 未确认提交以及审核失败 -->
        <el-col :span="4">
          <authorized :permission="['RECONCILIATION_SHEET_CONFIRM_REJECT']">
            <el-button class="create-btn" @click="onReject">拒绝</el-button>
          </authorized>
        </el-col>
        <el-col :span="4">
          <authorized :permission="['RECONCILIATION_SHEET_CONFIRM_REJECT']">
            <el-button class="create-btn" @click="onAccept">确认</el-button>
          </authorized>
        </el-col>
      </el-row>
      <!-- 确认审核（审核人） -->
      <el-row type="flex" justify="center" align="middle" style="margin-top: 20px"
        v-if="formData.originAuditWorkOrder!=null&&isOriginApprover&&formData.originAuditWorkOrder.state=='AUDITING'">
        <el-col :span="4">
          <authorized :permission="['DO_AUDIT']">
            <el-button class="create-btn_red" @click="onOriginApproval(false)">驳回</el-button>
          </authorized>
        </el-col>
        <el-col :span="4">
          <authorized :permission="['DO_AUDIT']">
            <el-button class="create-btn" @click="onOriginApproval(true)">通过</el-button>
          </authorized>
        </el-col>
      </el-row>
    </template>
    <!-- 创建方（收货方） -->
    <template v-if="isReceiptPart">
      <!-- 被拒绝或审核修改(跟单员) -->
      <el-row type="flex" justify="center" align="middle" style="margin-top: 20px"
        v-if="formData.state=='REJECTED'||formData.state=='APPROVAL_RETURN'&&isCreator">
        <el-col :span="4" v-if="readOnly">
          <authorized :permission="['RECONCILIATION_SHEET_CREATE_UPDATE']">
            <el-button class="create-btn" @click="onUpdate">修改</el-button>
          </authorized>
        </el-col>
        <el-col :span="4" v-if="!readOnly">
          <authorized :permission="['RECONCILIATION_SHEET_CREATE_UPDATE']">
            <el-button class="create-btn" @click="onSave">提交</el-button>
          </authorized>
        </el-col>
      </el-row>
      <!-- 创建/更新审核(审核人) -->
      <el-row type="flex" justify="center" align="middle" style="margin-top: 20px"
        v-if="isApprover&&formData.state=='PENDING_APPROVAL'&&formData.auditWorkOrder.currentUserAuditState === 'AUDITING'">
        <el-col :span="4">
          <authorized :permission="['DO_AUDIT']">
            <el-button class="create-btn_red" @click="onApproval(false)">驳回</el-button>
          </authorized>
        </el-col>
        <el-col :span="4">
          <authorized :permission="['DO_AUDIT']">
            <el-button class="create-btn" @click="onApproval(true)">通过</el-button>
          </authorized>
        </el-col>
      </el-row>
    </template>
  </div>
</template>
<script>
  export default {
    name: 'DetailBtnGroup',
    props: {
      formData: {
        type: Object,
        required: true
      },
      readOnly: {
        type: Boolean,
        default: true
      }
    },
    computed: {
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
      //发货方跟单员
      isShipOperator: function () {
        if (this.formData.merchandiser) {
          return this.formData.merchandiser.uid == this.currentUser.uid;
        }
        return false;
      },
      //创建人
      isCreator: function () {
        if (this.currentUser.uid == this.formData.creator.uid) {
          return true;
        } else {
          return false;
        }
      },
      //创建方审核人员
      isApprover: function () {
        if (this.formData.approvers) {
          let index = this.formData.approvers.findIndex(element => element.uid == this.currentUser.uid);
          return index != -1;
        } else {
          return false;
        }
      },
      //确认方审核人员
      isOriginApprover: function () {
        if (this.formData.originApprovers) {
          let index = this.formData.originApprovers.findIndex(element => element.uid == this.currentUser.uid);
          return index != -1;
        } else {
          return false;
        }
      },

    },
    methods: {
      onReject() {
        this.$emit('onReject');
      },
      onAccept() {
        this.$emit('onAccept');
      },
      onUpdate() {
        this.$emit('onUpdate');
      },
      onSave() {
        this.$emit('onSave');
      },
      onApproval(val) {
        this.$emit('onApproval', val);
      },
      //确认方审核
      onOriginApproval(val) {
        this.$emit('onOriginApproval', val);
      }
    },
    data() {
      return {
        currentUser: this.$store.getters.currentUser,
      }
    },
  }

</script>

<style scoped>
  .sumbit-btn {
    width: 70px;
    background-color: #ffd60c;
  }

  .create-btn {
    background-color: #ffd60c;
    border-color: #FFD5CE;
    color: #000;
    width: 120px;
    height: 40px;
    border-radius: 10px;
  }

  .create-btn_red {
    background-color: red;
    border-color: red;
    color: white;
    width: 120px;
    height: 40px;
    border-radius: 10px;
  }

</style>
