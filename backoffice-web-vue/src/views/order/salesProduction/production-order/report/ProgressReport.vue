<template>
  <div>
    <el-dialog :visible.sync="formVisible" width="70%" class="purchase-dialog" append-to-body
               :close-on-click-modal="false">
      <production-progress-order-form :purchaseOrder="order" :progress="slotData" :progressOrder="progressOrder"
                                      v-if="hackSet" @callback="onCallback" />
    </el-dialog>
    <el-dialog :visible.sync="viewVisible" width="70%" class="purchase-dialog" append-to-body
               :close-on-click-modal="false">
      <production-progress-order-view :purchaseOrder="order" :progress="slotData" :progressOrder="selectProgressOrder" />
    </el-dialog>
    <el-dialog :visible.sync="materialVisible" width="70%" class="purchase-dialog" append-to-body
               :close-on-click-modal="false">
      <production-progress-order-form-material :purchaseOrder="order" :progress="slotData" :progressOrder="progressOrder"
                                             v-if="materialVisible" @callback="onCallback" :isRead="isRead"/>
    </el-dialog>
    <el-dialog :visible.sync="sampleVisible" width="70%" class="purchase-dialog" append-to-body
               :close-on-click-modal="false">
      <production-progress-order-form-sample :purchaseOrder="order" :progress="slotData" :progressOrder="progressOrder"
                                             v-if="sampleVisible" @callback="onCallback" :isRead="isRead"/>
    </el-dialog>
    <el-row type="flex" justify="space-between">
      <el-col :span="4">
        <div class="report-list-title">
          <h6>{{getEnum('productionProgressPhaseTypes', slotData.phase)}}</h6>
        </div>
      </el-col>
      <el-col :span="6">
        <h6 style="width:300px;">数据最新更新时间：{{slotData.modifiedtime | timestampToTime}}</h6>
      </el-col>
    </el-row>
    <el-row type="flex" justify="start" class="report-basic-row" align="middle">
      <el-col :span="10" :offset="1">
        <el-row type="flex" align="middle">
          <h6 class="basic-title" style="width: 100px">预计完成时间：</h6>
          <h6 class="basic-title" v-if="!onEditEstimatedDateVisible">{{slotData.estimatedDate | timestampToTime}}</h6>
          <el-date-picker v-if="onEditEstimatedDateVisible" ref="datePicker" style="width: 50%;" :clearable="false"
                          v-model="slotData.estimatedDate" type="date" placeholder="选择日期"/>
          <el-button v-if="!readonly" class="edit-time-btn" type="text" @click="onEditEstimatedDate">{{onEditEstimatedDateVisible ? '确定' : '编辑'}}</el-button>
        </el-row>
      </el-col>
      <el-col :span="7">
        <el-row type="flex" align="middle">
          <el-col>
            <h6 class="basic-title">款号：{{order.product.skuID}}</h6>
          </el-col>
        </el-row>
      </el-col>
      <el-col :span="7">
        <el-row type="flex" align="middle">
          <el-col>
            <h6 class="basic-title">合作商：{{cooperatorName}}</h6>
          </el-col>
        </el-row>
      </el-col>
    </el-row>
    <el-row type="flex" justify="start" class="report-basic-row">
      <el-col :span="10" :offset="1">
        <el-row type="flex" align="middle">
          <h6 class="basic-title" style="width: 100px">实际完成时间：</h6>
          <h6 class="basic-title" v-if="!onEditEstimatedDateVisible">{{slotData.finishDate | timestampToTime}}</h6>
        </el-row>
      </el-col>
    </el-row>
    <el-row type="flex" justify="center" style="margin-top: 20px">
      <el-col :span="22">
<!--        <progress-report-material :orderEntries="order.entries" :noteEntries="slotData.productionProgressOrders"-->
<!--                                :orderEntriesTotal="order.totalQuantity" :readonly="readonly" @onOrder="onOrder"/>-->
<!--        <progress-report-sample :orderEntries="order.entries" :noteEntries="slotData.productionProgressOrders"-->
<!--                                :orderEntriesTotal="order.totalQuantity" :readonly="readonly" @onOrder="onOrder"/>-->
        <progress-report-common :orderEntries="order.entries" :noteEntries="slotData.productionProgressOrders"
                                @onOrder="onOrder" :orderEntriesTotal="order.totalQuantity" :readonly="readonly"/>
        <el-row type="flex" justify="end" align="center" class="show-btn-row">
          <i class="iconfont icon_arrow" v-if="!allOrdersShow" @click="allOrdersShow=true">&#xe714;&nbsp;展开全部单据</i>
          <i class="iconfont icon_arrow" v-if="allOrdersShow" @click="allOrdersShow=false">&#xe713;&nbsp;收回全部单据</i>
        </el-row>
        <el-row v-if="allOrdersShow">
          <production-progress-orders-table :orders="slotData.productionProgressOrders" @onDetail="onDetail" @onCencel="onCencel"
                                            :readonly="readonly" @onUpdate="onUpdate" />
        </el-row>
        <el-row type="flex" align="top" class="progress-update-form-row" style="margin-top:20px;">
          <el-col :span="2">
            <h6 class="progress-update-form-text1">上传图片:</h6>
          </el-col>
          <el-col :span="21" :offset="1">
            <production-media-image-card-show :medias="allMedias" />
          </el-col>
        </el-row>
        <el-row type="flex" align="top" class="report-basic-row">
          <el-col :span="2">
            <h6 class="progress-update-form-text1">备注:</h6>
          </el-col>
          <el-col :span="22" :offset="1">
            <el-input type="textarea" readonly :rows="3" v-model="slotData.remarks">
            </el-input>
          </el-col>
        </el-row>
      </el-col>
    </el-row>
    <el-row type="flex" justify="center" align="top" v-if="!readonly">
      <el-button size="mini" class="update-form-submit" @click="onSubmit">确定</el-button>
    </el-row>
  </div>
</template>

<script>
  import ProgressReportMaterial from './ProgressReportMaterial';
  import ProgressReportSample from './ProgressReportSample';
  import ProgressReportCommon from './ProgressReportCommon';
  import ProductionProgressOrdersTable from '../info/ProductionProgressOrderTable';
  import ProductionMediaImageCardShow from '../info/ProductionMediaImageCardShow';
  import ProductionProgressOrderForm from '../form/ProductionProgressOrderForm';
  import ProductionProgressOrderView from '../form/ProductionProgressOrderView';
  import ProductionProgressOrderFormSample from '../form/ProductionProgressOrderFormSample';
  import ProductionProgressOrderFormMaterial from '../form/ProductionProgressOrderFormMaterial';
  export default {
    name: 'ProgressReport',
    props: ['slotData', 'order', 'readonly'],
    components: {
      ProductionProgressOrderFormMaterial,
      ProductionProgressOrderFormSample,
      ProductionProgressOrderView,
      ProductionProgressOrderForm,
      ProductionMediaImageCardShow,
      ProductionProgressOrdersTable,
      ProgressReportCommon,
      ProgressReportSample,
      ProgressReportMaterial},
    computed: {
      cooperatorName: function () {
        if (this.order.cooperator == null) {
          if (this.isBrand()) {
            if (this.order.belongTo != null) {
              return this.order.belongTo.name;
            } else {
              return this.order.companyOfSeller;
            }
          } else {
            if (this.order.purchaser != null) {
              return this.order.purchaser.name;
            } else {
              return this.order.companyOfSeller;
            }
          }
        }
        if (this.order.cooperator.type == 'ONLINE') {
          return this.order.cooperator.partner.name;
        } else {
          return this.order.cooperator.name;
        }
      },
      allMedias: function () {
        var result = [];
        this.slotData.productionProgressOrders.filter(order => order.status == 'PASS').forEach(order => {
          order.medias.forEach(media => {
            result.push(media);
          });
        });
        return result;
      }
    },
    methods: {
      onUpdate (progressOrder) {
        // if (this.order.currentPhase == 'MATERIAL_PREPARATION') {
        //   this.progressOrder = progressOrder;
        //   this.materialVisible = true;
        //   this.isRead = false;
        // } else if (this.order.currentPhase == 'SAMPLE') {
        //   this.progressOrder = progressOrder;
        //   this.sampleVisible = true;
        //   this.isRead = false;
        // } else {
          this.progressOrder = progressOrder;
          this.formVisible = true;
        // }
      },
      onDetail (progressOrder) {
        // if (this.order.currentPhase == 'MATERIAL_PREPARATION') {
        //   this.progressOrder = progressOrder;
        //   this.materialVisible = true;
        //   this.isRead = true;
        // } else if (this.order.currentPhase == 'SAMPLE') {
        //   this.progressOrder = progressOrder;
        //   this.sampleVisible = true;
        //   this.isRead = true;
        // } else {
          this.selectProgressOrder = progressOrder;
          this.viewVisible = true;
        // }
      },
      onCencel (id) {
        this.$confirm('是否作废该单据?', '', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          this._onCancel(id);
        });
      },
      async _onCancel (id) {
        const url = this.apis().deleteProductionProgressOrder(this.order.id, id);
        const result = await this.$http.delete(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.$message.success('作废成功');
        this.$emit('callback');
      },
      onCallback () {
        this.formVisible = false;
        this.$emit('callback');
      },
      onOrder () {
        this.progressOrder = {
          medias: [],
          operator: {
            id: ''
          },
          reportTime: '',
          remarks: '',
          entries: []
        };
        // if (this.order.currentPhase == 'SAMPLE') {
        //   this.materialVisible = true;
        //   this.isRead = false;
        // } else if (this.order.currentPhase == 'MATERIAL_PREPARATION') {
        //   this.sampleVisible = true;
        //   this.isRead = false;
        // } else {
          this.formVisible = true;
        // }
      },
      async onSubmit () {
        // if (this.compareDate(new Date(), new Date(this.slotData.estimatedDate))) {
        //   this.$message.error('预计完成时间不能小于当前时间');
        //   return false;
        // }
        // const url = this.apis().updateProgressOfPurchaseOrder(this.orderCode, this.slotData.id);
        // const result = await this.$http.put(url, this.slotData);
        // if (result['errors']) {
        //   this.$message.error(result['errors'][0].message);
        //   return;
        // }
        // this.$message.success('更新成功');
        this.$emit('editSubmit');
      },
      onEditEstimatedDate () {
        this.onEditEstimatedDateVisible = !this.onEditEstimatedDateVisible;
        this.$nextTick(() => {
          this.$refs.datePicker.focus();
        })
      }
    },
    data () {
      return {
        formVisible: false,
        progressOrder: {},
        allOrdersShow: false,
        selectProgressOrder: {},
        hackSet: true,
        viewVisible: false,
        onEditEstimatedDateVisible: false,
        materialVisible: false,
        sampleVisible: false,
        isRead: true
      }
    },
    watch: {
      formVisible (newValue, oldValue) {
        this.hackSet = false;
        this.$nextTick(() => {
          this.hackSet = true;
        });
      }
    },
    created () {
    }
  }
</script>

<style scoped>
  .report-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .report-basic-row {
    margin-top: 10px;
  }

  .icon_arrow {
    font-family: "iconfont" !important;
    font-size: 12px;
    font-weight: 400;
    color: #66b1ff;
    font-style: normal;
    -webkit-font-smoothing: antialiased;
    -webkit-text-stroke-width: 0.2px;
    -moz-osx-font-smoothing: grayscale;
    cursor: pointer;
  }

  .edit-time-btn {
    /*padding-top: 0px;*/
    padding-left: 10px;
  }

  .progress-update-form-datepicker {
    font-size: 12px;
  }

  .basic-title {
    margin-bottom: 0px;
  }

  .update-form-submit {
    background-color: #FFD60C;
    border-color: #FFD60C;
    color: #000;
    width: 150px;
    margin-top: 50px;
  }
</style>
