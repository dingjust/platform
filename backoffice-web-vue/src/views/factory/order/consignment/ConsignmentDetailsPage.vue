<template>
  <div class="animated fadeIn">
    <consignment-status-bar :status="slotData.status" :status-map="statusMap"
                            :statu-days-map="statuDaysMap"></consignment-status-bar>
    <div v-show="isPendingPurchase" class="pt-2"></div>
    <el-row v-show="isPendingPurchase" :gutter="10">
      <el-col :span="24">
        <el-button class="btn-block" type="primary" size="mini" @click="onCompleteGivingOut">
          备料完成
        </el-button>
      </el-col>
    </el-row>
    <div v-show="isCutting" class="pt-2"></div>
    <el-row v-show="isCutting" :gutter="10">
      <el-col :span="24">
        <el-button class="btn-block" type="primary" size="mini" @click="onCompleteCutting">
          裁剪完成
        </el-button>
      </el-col>
    </el-row>
    <div v-show="isStitching" class="pt-2"></div>
    <el-row v-show="isStitching" :gutter="10">
      <el-col :span="24">
        <el-button class="btn-block" type="primary" size="mini" @click="onCompleteStitching">
          车缝完成
        </el-button>
      </el-col>
    </el-row>
    <div v-show="isPendingDelivery" class="pt-2"></div>
    <el-row v-show="isPendingDelivery" :gutter="10">
      <el-col :span="24">
        <el-button class="btn-block" type="primary" size="mini" @click="onCompleteShipping">
          完成发货
        </el-button>
      </el-col>
    </el-row>
    <div class="pt-2"></div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>基本信息</span>
      </div>
      <consignment-base-form :slot-data="slotData" :read-only="true"></consignment-base-form>
    </el-card>
    <div class="pt-2"></div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>生产单行</span>
        <!-- <span class="float-right" v-show="!readOnly">
            <el-button type="primary" size="mini" @click="onUpdateEntries">编辑</el-button>
         </span>-->
      </div>
      <consignment-entries-form :slot-data="slotData" :read-only="true"></consignment-entries-form>
    </el-card>
    <!-- <div class="pt-2"></div>
     <el-card class="box-card">
       <div slot="header" class="clearfix">
         <span>分配工厂</span>
         <span class="float-right" v-show="!readOnly">
            <el-button type="primary" size="mini" @click="onUpdateFactory">编辑</el-button>
         </span>
       </div>
       <consignment-factory-base-form :slot-data="slotData.assignedTo"
                                      :read-only="true">
       </consignment-factory-base-form>
     </el-card>-->
    <div class="pt-2"></div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>生产进度</span>
        <!--<span class="float-right" v-show="!readOnly">
           <el-button type="primary" size="mini" @click="onUpdateEntries">编辑</el-button>
        </span>-->
      </div>
      <consignment-progress-form :slot-data="slotData"></consignment-progress-form>
    </el-card>
    <div class="pt-2"></div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>合同</span>
        <!--<span class="float-right" v-show="!readOnly">
           <el-button type="primary" size="mini" @click="onUpdateContracts">编辑</el-button>
        </span>-->
      </div>
      <consignment-contracts-form ref="contractsForm"
                                  :slot-data="slotData"
                                  :read-only="true">
      </consignment-contracts-form>
    </el-card>

    <div v-show="isPendingPurchase" class="pt-2"></div>
    <el-row v-show="isPendingPurchase" :gutter="10">
      <el-col :span="24">
        <el-button class="btn-block" type="primary" size="mini" @click="onCompleteGivingOut">
          备料完成
        </el-button>
      </el-col>
    </el-row>
    <div v-show="isCutting" class="pt-2"></div>
    <el-row v-show="isCutting" :gutter="10">
      <el-col :span="24">
        <el-button class="btn-block" type="primary" size="mini" @click="onCompleteCutting">
          裁剪完成
        </el-button>
      </el-col>
    </el-row>
    <div v-show="isStitching" class="pt-2"></div>
    <el-row v-show="isStitching" :gutter="10">
      <el-col :span="24">
        <el-button class="btn-block" type="primary" size="mini" @click="onCompleteStitching">
          车缝完成
        </el-button>
      </el-col>
    </el-row>
    <div v-show="isPendingDelivery" class="pt-2"></div>
    <el-row v-show="isPendingDelivery" :gutter="10">
      <el-col :span="24">
        <el-button class="btn-block" type="primary" size="mini" @click="onCompleteShipping">
          完成发货
        </el-button>
      </el-col>
    </el-row>

    <el-dialog title="更新状态" :close-on-click-modal="false"
               :visible.sync="statusFormDialogVisible" :modal="false">
      <consignment-update-status-form ref="statusForm"
                                      :slot-data="statusData"
                                      :read-only="false">
      </consignment-update-status-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="statusFormDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="onSubmitStatusForm">确 定</el-button>
      </div>
    </el-dialog>
    <el-dialog title="变更工厂"
               :visible.sync="factoryFormDialogVisible" :close-on-click-modal="false" :modal="false">
      <consignment-factory-search-form ref="factoryForm"
                                       :slot-data="factoryData">
      </consignment-factory-search-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="factoryFormDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="onSubmitFactoryForm">确 定</el-button>
      </div>
    </el-dialog>
    <el-dialog title="更新生产单行" width="90%" :close-on-click-modal="false"
               :visible.sync="entriesFormDialogVisible" :modal="false">
      <consignment-entries-form ref="entriesForm"
                                :slot-data="entriesData"
                                :read-only="false">
      </consignment-entries-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="entriesFormDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="onSubmitEntriesForm">确 定</el-button>
      </div>
    </el-dialog>
    <el-dialog title="上传" width="60%" :close-on-click-modal="false"
               :visible.sync="contractsFormDialogVisible" :modal="false">
      <consignment-media-upload-form ref="contractsForm"
                                     :slot-data="contractsData"
                                     :read-only="false">
      </consignment-media-upload-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="contractsFormDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="onSubmitContractsForm">确 定</el-button>
      </div>
    </el-dialog>

    <el-dialog title="填写物流单号" width="20%" :close-on-click-modal="false"
               :visible.sync="expressDialogVisible" :modal="false">
      <el-row :gutter="10">
        <el-col :span="24">
          <el-input v-model="express" placeholder="物流单号"></el-input>
        </el-col>
      </el-row>
      <div slot="footer" class="dialog-footer">
        <el-button @click="expressDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="onSubmitExpressOrder">确 定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
  import ConsignmentBaseForm from './ConsignmentBaseForm';
  import ConsignmentFactorySearchForm from './ConsignmentFactorySearchForm';
  import ConsignmentEntriesForm from './ConsignmentEntriesForm';
  import ConsignmentFactoryBaseForm from './ConsignmentFactoryBaseForm';
  import ConsignmentStatusBar from './ConsignmentStatusBar';
  import ConsignmentMediaUploadForm from './ConsignmentMediaUploadForm';
  import ConsignmentContractsForm from './ConsignmentContractsForm';
  import ConsignmentUpdateStatusForm from './ConsignmentUpdateStatusForm';
  import ConsignmentProgressForm from './ConsignmentProgressForm';

  export default {
    name: 'ConsignmentDetailsPage',
    components: {
      ConsignmentUpdateStatusForm,
      ConsignmentMediaUploadForm,
      ConsignmentStatusBar,
      ConsignmentEntriesForm,
      ConsignmentBaseForm,
      ConsignmentFactoryBaseForm,
      ConsignmentFactorySearchForm,
      ConsignmentContractsForm,
      ConsignmentProgressForm
    },
    props: ['slotData', 'readOnly'],
    methods: {
      onCompleteGivingOut() {
        this.$confirm('是否备料完成', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => this._onCompleteGivingOut());
      },
      async _onCompleteGivingOut() {
        const result = await this.$http.put('/djfactory/processes/consignment/completeGivingOut/' + this.slotData.code);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }
        this.$message.success('备料完成成功');
        this.$set(this.slotData, 'status', result);
      },
      onCompleteCutting() {
        this.$confirm('是否确认裁剪完成', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => this._onCompleteCutting());
      },
      async _onCompleteCutting() {
        const result = await this.$http.put('/djfactory/processes/consignment/completeCutting/' + this.slotData.code);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }
        this.$message.success('裁剪完成成功');
        this.$set(this.slotData, 'status', result);
      },
      onCompleteStitching() {
        // 车缝完成
        this.$confirm('是否确认车缝完成', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => this._onCompleteStitching());
      },
      async _onCompleteStitching() {
        const result = await this.$http.put('/djfactory/processes/consignment/completeStitching/' + this.slotData.code);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.$message.success('车缝完成成功');
        this.$set(this.slotData, 'status', result);
      },
      onCompleteShipping() {
        this.expressDialogVisible = true;
      },
      onSubmitExpressOrder() {
        this.$confirm('是否确认发货完成', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => this._onSubmitExpressOrder());
      },
      async _onSubmitExpressOrder() {
        const result = await this.$http.put('/djfactory/processes/consignment/completeShipping/' + this.slotData.code, this.express);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.$message.success('完成发货成功');
        this.$set(this.slotData, 'status', result);
        this.expressDialogVisible = false;
      },
      onUpdateStatus() {
        Object.assign(this.statusData, this.slotData);
        this.statusFormDialogVisible = true;
      },
      async onSubmitStatusForm() {
        const result = await this.$http.put('/djfactory/consignment/status', {
          code: this.slotData.code,
          status: this.statusData.status
        });

        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.$message.success('更新状态成功');
        this.$set(this.slotData, 'status', this.statusData.status);
        this.statusFormDialogVisible = false;
      },
      onUpdateFactory() {
        Object.assign(this.factoryData.assignedTo, this.slotData.assignedTo);
        this.factoryFormDialogVisible = true;
      },
      onSubmitFactoryForm() {
        this.$refs['factoryForm'].validate((valid) => {
          if (valid) {
            this._onSubmitFactoryForm();

            return true;
          }

          return false;
        })
      },
      async _onSubmitFactoryForm() {
        const result = await this.$http.put('/djfactory/consignment/factory', {
          code: this.slotData.code,
          assignedTo: this.factoryData.assignedTo.uid
        });

        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.factoryFormDialogVisible = false;
        this.$message.success('更新生产订单的工厂成功');
      },
      onUpdateEntries() {
        Object.assign(this.entriesData.consignmentEntries, this.slotData.consignmentEntries);
        this.entriesFormDialogVisible = true;
      },
      onSubmitEntriesForm() {
        if (this.$refs['entriesForm'].validate()) {
          this._onSubmitEntriesForm();
        }
      },
      async _onSubmitEntriesForm() {
        const result = await this.$http.put('/djfactory/consignment/entries', {
          code: this.slotData.code,
          consignmentEntries: this.entriesData.consignmentEntries
        });

        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.$message.success('更新订单行成功');
        this.entriesFormDialogVisible = false;
      },
      onUpdateContracts() {
        this.contractsFormDialogVisible = true;
      },
      onSubmitContractsForm() {
        this.$refs['contractsForm'].onSubmit();
      }
    },
    computed: {
      isNewlyCreated: function () {
        return this.slotData.id === null;
      },
      isPendingPurchase: function () {
        return this.slotData.status === 'WAIT_FOR_PURCHASE';
      },
      isCutting: function () {
        return this.slotData.status === 'CUTTING';
      },
      isStitching: function () {
        return this.slotData.status === 'STITCHING';
      },
      isPendingDelivery: function () {
        return this.slotData.status === 'PENDING_DELIVERY';
      },
      statusMap: function () {
        let map = {};
        this.slotData.progresses.map(progress => {
          this.$set(map, progress.phase, progress.estimatedDate);
        });
        return map;
      },
      statuDaysMap: function () {
        let map = {};
        this.slotData.progresses.map(progress => {
          let days = 0;
          if (progress.estimatedDate != null) {
            const estimated = progress.estimatedDate;
            let finish;
            if (progress.finishDate != null) {
              finish = progress.finishDate;
            } else {
              finish = new Date().getTime();
            }
            days = parseInt((finish - estimated) / (1000 * 60 * 60 * 24));
          }
          this.$set(map, progress.phase, days);
        });
        return map;
      }
    },
    data() {
      return {
        statusFormDialogVisible: false,
        statusData: {
          id: null,
          code: this.slotData.code
        },
        factoryFormDialogVisible: false,
        factoryData: {
          id: null,
          code: this.slotData.code,
          assignedTo: {
            uid: '',
            name: ''
          }
        },
        entriesFormDialogVisible: false,
        entriesData: {
          id: null,
          code: this.slotData.code,
          consignmentEntries: []
        },
        contractsFormDialogVisible: false,
        contractsData: {
          code: this.slotData.code
        },
        express: '',
        expressDialogVisible: false
      }
    }
  }
</script>
