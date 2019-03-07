<template>
  <div class="animated fadeIn">
    <requirement-order-status-bar :status="slotData.status"></requirement-order-status-bar>
    <div v-show="isPendingApproval" class="pt-2"></div>
    <el-row v-show="isPendingApproval" :gutter="10">
      <el-col :span="12">
        <el-button class="btn-block" type="primary" size="mini"
                   @click="onConfirmRequirementAudit">
          确认
        </el-button>
      </el-col>
      <el-col :span="12">
        <el-button class="btn-block" type="primary" size="mini"
                   @click="onRejectRequirementAudit">
          拒绝
        </el-button>
      </el-col>
    </el-row>
    <div class="pt-2"></div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>需求信息</span>
        <span class="float-right" v-show="!readOnly">
           <el-button type="primary" size="mini" @click="onUpdateRequest">编辑</el-button>
        </span>
      </div>
      <requirement-order-request-form ref="requestForm"
                                      :slot-data="slotData"
                                      :read-only="true">
      </requirement-order-request-form>
    </el-card>
    <div class="pt-2"></div>
    <div v-show="isPendingApproval" class="pt-2"></div>
    <el-row v-show="isPendingApproval" :gutter="10">
      <el-col :span="12">
        <el-button class="btn-block" type="primary" size="mini"
                   @click="onConfirmRequirementAudit">
          确认
        </el-button>
      </el-col>
      <el-col :span="12">
        <el-button class="btn-block" type="primary" size="mini"
                   @click="onRejectRequirementAudit">
          拒绝
        </el-button>
      </el-col>
    </el-row>
    <div class="pt-2"></div>

    <el-dialog title="更新需求信息" width="60%"
               :visible.sync="requestFormDialogVisible" :close-on-click-modal="false" :modal="false">
      <requirement-order-request-form ref="requestForm"
                                      :slot-data="requestData"
                                      :read-only="false">
      </requirement-order-request-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="requestFormDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="onSubmitRequestForm">确 定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
  import RequirementOrderBaseForm from './RequirementOrderBaseForm';
  import RequirementOrderRequestForm from './RequirementOrderRequestForm';
  import RequirementOrderStatusBar from './RequirementOrderStatusBar';

  export default {
    name: 'RequirementOrderDetailsPage',
    props: ['slotData', 'readOnly', 'preview'],
    components: {
      RequirementOrderStatusBar,
      RequirementOrderRequestForm,
      RequirementOrderBaseForm,
    },
    methods: {
      onConfirmRequirementAudit() {
        this.$confirm('是否确认审核', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => this._onConfirmRequirementAudit());
      },
      async _onConfirmRequirementAudit() {
        const result = await this.$http.put('/b2b/orders/requirement/' + this.slotData.code + '/confirmRequirementAudit/');
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.$message.success('审核确认成功');
        this.$set(this.slotData, 'status', result);
      },
      onRejectRequirementAudit() {
        this.$confirm('是否拒绝审核', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => this._onRejectRequirementAudit());
      },
      async _onRejectRequirementAudit() {
        const result = await this.$http.put('/b2b/orders/requirement/' + this.slotData.code + '/rejectRequirementAudit', 'TODO：拒绝原因');
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.$message.success('审核拒绝成功');
        this.$set(this.slotData, 'status', result);
      },
      onUpdateRequest() {
        Object.assign(this.requestData.details, JSON.parse(JSON.stringify(this.slotData.details)));
        this.requestFormDialogVisible = true;
      },
      onSubmitRequestForm() {
        this.$refs['requestForm'].validate((valid) => {
          if (valid) {
            this._onSubmitRequestForm();

            return true;
          }

          return false;
        })
      },
      async _onSubmitRequestForm() {
        const result = await this.$http.put('/b2b/orders/requirement/' + this.slotData.code + '/request', {
          code: this.slotData.code,
          details: this.requestData.details
        });

        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.$message.success('更新需求信息成功');
        this.$set(this.slotData, 'details', this.requestData.details);
        this.requestFormDialogVisible = false;
      },
    },
    computed: {
      isPendingApproval: function () {
        return this.slotData.status === 'PENDING_APPROVAL';
      }
    },
    data() {
      return {
        requestFormDialogVisible: false,
        requestData: {
          id: null,
          code: '',
          details: {
            category: {
              code: '',
              name: ''
            },
            majorCategory: {
              code: '',
              name: ''
            },
            expectedMachiningQuantity: 0,
            expectedDeliveryDate: null,
            maxExpectedPrice: 0,
            machiningType: '',
            samplesNeeded: false,
            contactPerson: '',
            contactPHone: ''
          }
        },
      }
    }
  }
</script>
