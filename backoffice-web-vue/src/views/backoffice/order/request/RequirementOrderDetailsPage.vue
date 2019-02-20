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
        <span class="float-right" v-show="!readOnly">
          <!-- 基本信息始终放开 -->
           <el-button type="primary" size="mini" @click="onUpdateBase">
             编辑
           </el-button>
          <!--<el-button type="primary" size="mini" @click="onUpdateStatus">更新状态</el-button>-->
        </span>
      </div>
      <requirement-order-base-form :slot-data="slotData"
                                   :read-only="true">
      </requirement-order-base-form>
    </el-card>
    <div class="pt-2"></div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>需求信息</span>
        <span class="float-right" v-show="!readOnly">
           <el-button type="primary" size="mini" @click="onUpdateRequest" v-show="!disableEdit">
             编辑
           </el-button>
        </span>
      </div>
      <requirement-order-request-form ref="requestForm"
                                      :slot-data="slotData"
                                      :read-only="true">
      </requirement-order-request-form>
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

    <el-dialog title="更新基本信息"
               :visible.sync="baseFormDialogVisible" :close-on-click-modal="false" :modal="false">
      <requirement-order-base-form ref="statusForm"
                                   :slot-data="baseData"
                                   :belong-to-editable="false"
                                   :read-only="false">
      </requirement-order-base-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="baseFormDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="onSubmitBaseForm">确 定</el-button>
      </div>
    </el-dialog>
    <el-dialog title="更新订单状态" width="240px"
               :visible.sync="statusFormDialogVisible" :close-on-click-modal="false" :modal="false">
      <requirement-order-update-status-form ref="statusForm"
                                            :slot-data="statusData"
                                            :read-only="false">
      </requirement-order-update-status-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="statusFormDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="onSubmitStatusForm">确 定</el-button>
      </div>
    </el-dialog>
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
  import RequirementOrderUpdateStatusForm from './RequirementOrderUpdateStatusForm';
  import RequirementOrderStatusBar from './RequirementOrderStatusBar';

  export default {
    name: 'RequirementOrderDetailsPage',
    props: ['slotData', 'readOnly', 'preview'],
    components: {
      RequirementOrderStatusBar,
      RequirementOrderRequestForm,
      RequirementOrderBaseForm,
      RequirementOrderUpdateStatusForm,
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
        const result = await this.$http.put('/djbackoffice/processes/requirementOrder/requirementAudit/' + this.slotData.code);
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
        const result = await this.$http.put('/djbackoffice/processes/requirementOrder/confirmProduction/' + this.slotData.code);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.$message.success('确认生产成功');
        // 待出库
        this.$set(this.slotData, 'status', result);
      },
      onUpdateBase() {
        Object.assign(this.baseData, {
          code: this.slotData.code,
          belongTo: this.slotData.belongTo
        });

        this.baseFormDialogVisible = true;
      },
      async onSubmitBaseForm() {
        const result = await this.$http.put('/djbackoffice/requirementOrder/base', this.baseData);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.$message.success('更新基本信息成功');

        this.baseFormDialogVisible = false;
      },
      onUpdateStatus() {
        this.statusFormDialogVisible = true;
      },
      async onSubmitStatusForm() {
        const result = await this.$http.put('/djbackoffice/requirementOrder/status', {
          code: this.slotData.code,
          status: this.statusData.status
        });

        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.$message.success('更新订单状态成功');
        this.$set(this.slotData, 'status', this.statusData.status);
        this.statusFormDialogVisible = false;
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
        const result = await this.$http.put('/djbackoffice/requirementOrder/request', {
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
      isWaitForProcessing: function () {
        return this.slotData.status === 'WAIT_FOR_PROCESSING';
      },
      isApproved: function () {
        return this.slotData.status === 'APPROVED';
      },
      disableEdit: function () {
        // 只有待处理状态下才允许修改信息
        return this.slotData.status !== 'WAIT_FOR_PROCESSING';
      }
    },
    data() {
      return {
        baseFormDialogVisible: false,
        baseData: {
          id: null,
          code: this.slotData.code,
        },
        statusFormDialogVisible: false,
        statusData: {
          id: null,
          code: this.slotData.code,
          status: this.slotData.status
        },
        requestFormDialogVisible: false,
        requestData: {
          id: null,
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
