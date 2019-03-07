<template>
  <div class="animated fadeIn">
    <requirement-order-status-bar :status="slotData.status"></requirement-order-status-bar>
    <div v-show="isWaitForProcessing" class="pt-2"></div>
    <el-row v-show="isWaitForProcessing" :gutter="10">
      <el-col :span="24">
        <el-button class="btn-block" type="primary" size="mini" @click="onRequirementAudit">
          提交审核
        </el-button>
      </el-col>
    </el-row>
    <div v-show="isApproved" class="pt-2"></div>
    <el-row v-show="isApproved" :gutter="10">
      <el-col :span="24">
        <el-button class="btn-block" type="primary" size="mini" @click="onConfirmProduction">
          确认生产
        </el-button>
      </el-col>
    </el-row>
    <div class="pt-2"></div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>基本信息</span>
      </div>
      <requirement-order-base-form :slot-data="slotData"
                                   :read-only="!isNewlyCreated">
      </requirement-order-base-form>
    </el-card>
    <div class="pt-2"></div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>需求信息</span>
      </div>
      <requirement-order-request-form ref="requestForm"
                                      :slot-data="slotData"
                                      :read-only="!isNewlyCreated">
      </requirement-order-request-form>
    </el-card>
    <div class="pt-2"></div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>附件</span>
      </div>
      <requirement-order-attachments-form ref="attachmentsForm"
                                          :slot-data="slotData"
                                          :read-only="!isNewlyCreated">
      </requirement-order-attachments-form>
    </el-card>
    <div class="pt-2"></div>
    <div v-show="isWaitForProcessing" class="pt-2"></div>
    <el-row v-show="isWaitForProcessing" :gutter="10">
      <el-col :span="24">
        <el-button class="btn-block" type="primary" size="mini" @click="onRequirementAudit">
          提交审核
        </el-button>
      </el-col>
    </el-row>
    <div v-show="isApproved" class="pt-2"></div>
    <el-row v-show="isApproved" :gutter="10">
      <el-col :span="24">
        <el-button class="btn-block" type="primary" size="mini" @click="onConfirmProduction">
          确认生产
        </el-button>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  import RequirementOrderBaseForm from './RequirementOrderBaseForm';
  import RequirementOrderRequestForm from './RequirementOrderRequestForm';
  import RequirementOrderAttachmentsForm from './RequirementOrderAttachmentsForm';
  import RequirementOrderStatusBar from './RequirementOrderStatusBar';

  export default {
    name: 'RequirementOrderDetailsPage',
    props: ['slotData', 'readOnly', 'preview'],
    components: {
      RequirementOrderStatusBar,
      RequirementOrderBaseForm,
      RequirementOrderRequestForm,
      RequirementOrderAttachmentsForm,
    },
    methods: {
      onRequirementAudit() {
        this.$confirm('是否确认提交审核', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => this._onRequirementAudit());
      },
      async _onRequirementAudit() {
        const result = await this.$http.put('/b2b/orders/requirement/' + this.slotData.code + '/requirementAudit/');
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.$message.success('提交审核成功');
        // 待确认
        this.$set(this.slotData, 'status', result);
      },
      onConfirmProduction() {
        this.$confirm('是否确认生产', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => this._onConfirmProduction());
      },
      async _onConfirmProduction() {
        const result = await this.$http.put('/b2b/orders/requirement/' + this.slotData.code + '/confirmProduction/');
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.$message.success('确认生产成功');
        // 待出库
        this.$set(this.slotData, 'status', result);
      },
    },
    computed: {
      isNewlyCreated: function () {
        return this.slotData.id === null;
      },
      isWaitForProcessing: function () {
        return this.slotData.status === 'WAIT_FOR_PROCESSING';
      },
      isApproved: function () {
        return this.slotData.status === 'APPROVED';
      }
    },
    data() {
      return {}
    }
  }
</script>
