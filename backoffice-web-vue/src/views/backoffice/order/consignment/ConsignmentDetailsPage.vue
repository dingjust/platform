<template>
  <div class="animated fadeIn">
    <consignment-status-bar :status="slotData.status" :status-map="statusMap" :statu-days-map="statuDaysMap"></consignment-status-bar>
    <div v-show="needSampleConfirmed" class="pt-2"></div>
    <el-row v-show="needSampleConfirmed" :gutter="10">
      <el-col :span="24">
        <el-button class="btn-block" :disabled="isDisabled" type="primary" size="mini" @click="onSampleConfirm">
          样衣确认
        </el-button>
      </el-col>
    </el-row>
    <div v-show="needQC" class="pt-2"></div>
    <el-row v-show="needQC" :gutter="10">
      <el-col :span="24">
        <el-button class="btn-block" type="primary" size="mini" @click="onQC">
          验货完成
        </el-button>
      </el-col>
    </el-row>
    <div class="pt-2"></div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>基本信息</span>
        <!--<span class="float-right" v-show="!readOnly">
           <el-button type="primary" size="mini" @click="onUpdateStatus">更新状态</el-button>
        </span>-->
      </div>
      <consignment-base-form :slot-data="slotData" :read-only="true"></consignment-base-form>
    </el-card>
    <div class="pt-2"></div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>归属订单</span>
      </div>
      <order-base-form :slot-data="slotData.order" :read-only="true"></order-base-form>
    </el-card>
    <div class="pt-2"></div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>分配工厂</span>
        <span class="float-right" v-show="!readOnly">
           <el-button type="primary" size="mini"
                      @click="onUpdateFactory"
                      :disabled="!isWaitForAllocation">
             编辑
           </el-button>
        </span>
      </div>
      <consignment-factory-base-form :slot-data="slotData.assignedTo"
                                     :read-only="true">
      </consignment-factory-base-form>
    </el-card>
    <div class="pt-2"></div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>生产单行</span>
        <span class="float-right" v-show="!readOnly">
           <el-button type="primary" size="mini" @click="onUpdateEntries">编辑</el-button>
        </span>
      </div>
      <consignment-entries-form :slot-data="slotData" :read-only="true"></consignment-entries-form>
    </el-card>
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
        <span class="float-right" v-show="!readOnly">
           <el-button type="primary" size="mini" @click="onUpdateContracts">编辑</el-button>
        </span>
      </div>
      <consignment-contracts-form ref="contractsForm"
                                  :slot-data="slotData"
                                  :read-only="true">
      </consignment-contracts-form>
    </el-card>
    <div v-show="needSampleConfirmed" class="pt-2"></div>
    <el-row v-show="needSampleConfirmed" :gutter="10">
      <el-col :span="24">
        <el-button class="btn-block" :disabled="isDisabled"  type="primary" size="mini" @click="onSampleConfirm">
          样衣确认
        </el-button>
      </el-col>
    </el-row>
    <div v-show="needQC" class="pt-2"></div>
    <el-row v-show="needQC" :gutter="10">
      <el-col :span="24">
        <el-button class="btn-block" type="primary" size="mini" @click="onQC">
          验货完成
        </el-button>
      </el-col>
    </el-row>

    <el-dialog title="更新状态"
               :visible.sync="statusFormDialogVisible" :close-on-click-modal="false" :modal="false">
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
    <el-dialog title="更新生产单行" width="90%"
               :visible.sync="entriesFormDialogVisible" :close-on-click-modal="false" :modal="false">
      <consignment-entries-form ref="entriesForm"
                                :slot-data="entriesData"
                                :read-only="false">
      </consignment-entries-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="entriesFormDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="onSubmitEntriesForm">确 定</el-button>
      </div>
    </el-dialog>
    <el-dialog title="上传" width="60%"
               :visible.sync="contractsFormDialogVisible" :close-on-click-modal="false" :modal="false">
      <consignment-media-upload-form ref="contractsForm"
                                     :slot-data="contractsData"
                                     :order-data="slotData"
                                     :read-only="false">
      </consignment-media-upload-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="contractsFormDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="onSubmitContractsForm">确 定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
  import axios from 'axios';
  import OrderBaseForm from '../order/OrderBaseForm';
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
      OrderBaseForm,
      ConsignmentFactoryBaseForm,
      ConsignmentFactorySearchForm,
      ConsignmentContractsForm,
      ConsignmentProgressForm
    },
    props: ['slotData', 'readOnly'],
    methods: {
      onSampleConfirm() {
        if(this.slotData.assignedTo.uid == null){
          this.$message.error('请先分配工厂');
          return;
        }

        // 样衣确认
        this.$confirm('是否确认样衣', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          axios.put('/djbackoffice/processes/consignment/sampleConfirm/' + this.slotData.code)
            .then(response => {
              this.isDisabled = true;
              this.$message.success('样衣确认成功');
              this.$set(this.slotData, 'status', response.data);
            }).catch(error => {
            this.$message.error('样衣确认失败，原因：' + error.response.data);
            }
          );
        }).catch(() => {
        });
      },
      onQC() {
        this.$confirm('是否确认验货', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          axios.put('/djbackoffice/processes/consignment/qc/' + this.slotData.code)
            .then(response => {
              this.$message.success('验货确认成功');

              this.$set(this.slotData, 'status', response.data);
            }).catch(error => {
              this.$message.error('验货确认失败，原因：' + error.response.data);
            }
          );
        }).catch(() => {
        });
      },
      onUpdateStatus() {
        Object.assign(this.statusData, this.slotData);
        this.statusFormDialogVisible = true;
      },
      onSubmitStatusForm() {
        axios.put('/djbackoffice/consignment/status', {
          code: this.slotData.code,
          status: this.statusData.status
        }).then(() => {
          this.$message.success('更新状态成功');

          this.$set(this.slotData, 'status', this.statusData.status);
          this.$set(this.slotData, 'assignedTo', this.factoryData.assignedTo);

          this.statusFormDialogVisible = false;
        }).catch(error => {
          console.log(JSON.stringify(error));
          this.$message.error('更新状态失败，原因：' + error.response.data);
        });
      },
      onUpdateFactory() {
        Object.assign(this.factoryData.assignedTo, this.slotData.assignedTo);
        this.factoryFormDialogVisible = true;
      },
      onSubmitFactoryForm() {
        this.$refs['factoryForm'].validate((valid) => {
          if (valid) {
            axios.put('/djbackoffice/consignment/factory', {
              code: this.slotData.code,
              assignedTo: this.factoryData.assignedTo.uid
            }).then(response => {
              console.log(response.data);
              this.factoryFormDialogVisible = false;
              this.slotData.assignedTo = response.data;
              this.$set(this.slotData, 'status', 'WAIT_FOR_PURCHASE');

              this.$message.success('指定工厂成功');
            }).catch(error => {
              console.log(JSON.stringify(error));
              this.$message.error('指定工厂失败，原因：' + error.response.data);
            });

            return true;
          }

          return false;
        })
      },
      onUpdateEntries() {
        Object.assign(this.entriesData.consignmentEntries, this.slotData.consignmentEntries);
        this.entriesFormDialogVisible = true;
      },
      onSubmitEntriesForm() {
        if (this.$refs['entriesForm'].validate()) {
          axios.put('/djbackoffice/consignment/entries', {
            code: this.slotData.code,
            consignmentEntries: this.entriesData.consignmentEntries
          }).then(() => {
            this.$message.success('更新订单行成功');

            this.entriesFormDialogVisible = false;
          }).catch(error => {
            console.log(JSON.stringify(error));
            this.$message.error('更新订单行失败，原因：' + error.response.data);
          });
        }
      },
      onUpdateContracts() {
        this.contractsFormDialogVisible = true;
      },
      onSubmitContractsForm() {
        this.$refs['contractsForm'].onSubmit();
        this.contractsFormDialogVisible = false;
      }
    },
    computed: {
      isNewlyCreated: function () {
        return this.slotData.id === null;
      },
      isWaitForAllocation: function () {
        return this.slotData.status === 'WAIT_FOR_ALLOCATION';
      },
      needSampleConfirmed: function () {
        // 待分配，备料中，待裁剪 时都可以确认样衣
        return ['WAIT_FOR_ALLOCATION', 'WAIT_FOR_PURCHASE', 'PENDING_CUTTING'].some(value => {
          return value === this.slotData.status;
        });
      },
      needQC: function() {
        return this.slotData.status === 'QC';
      },
      statusMap:function () {
        let map = {};
        this.slotData.progresses.map(progress => {
          this.$set(map,progress.phase,progress.estimatedDate);
        });
        return map;
      },
      statuDaysMap:function () {
        let map = {};
        this.slotData.progresses.map(progress => {
          let days = 0;
          if(progress.estimatedDate != null){
            const estimated = progress.estimatedDate;
            let finish;
            if(progress.finishDate != null){
              finish = progress.finishDate;
            }else{
              finish = new Date().getTime();
            }
            days = parseInt((finish - estimated) / (1000 * 60 * 60 * 24));
          }
          this.$set(map,progress.phase,days);
        });
        return map;
      }
    },
    data() {
      return {
        isDisabled:this.slotData.sampleConfirmed,
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
        }
      }
    }
  }
</script>
