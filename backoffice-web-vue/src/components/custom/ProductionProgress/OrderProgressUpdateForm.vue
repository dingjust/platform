<template>
  <div class="finance-form-body">
    <el-dialog :visible.sync="formVisible" width="70%" class="purchase-dialog" append-to-body>
      <progress-order-form :purchaseOrder="order" :progress="slotData"/>
    </el-dialog>
    <el-row class="info-title-row" type="flex" justify="space-between">
      <div class="info-title">
        <h6 class="info-title_text">{{getEnum('productionProgressPhaseTypes', slotData.phase)}}</h6>
      </div>
      <h6 class="info-title_text" style="width:300px;">数据最新更新时间：{{slotData.modifiedtime | timestampToTime}}</h6>
    </el-row>
    <div class="form-main">
      <el-row type="flex" align="middle" class="progress-update-form-row">
        <el-col :span="2">
          <h6 class="progress-update-form-text1">预计完成日期:</h6>
        </el-col>
        <el-col :span="6" :offset="1">
          <div style="width:100%;">
            <el-date-picker style="width:100%;" class="progress-update-form-datepicker" v-model="slotData.estimatedDate"
              type="date" placeholder="选择日期">
            </el-date-picker>
          </div>
        </el-col>
        <el-col :span="4" :offset="1">
          <h6 class="info-title_text">款号:{{order.product.skuID}}</h6>
        </el-col>
        <el-col :span="8">
          <h6 class="info-title_text">合作商:{{cooperatorName}}</h6>
        </el-col>
      </el-row>
      <el-row type="flex">
        <progress-color-size-table :orderEntries="order.entries" :noteEntries="slotData.productionProgressOrders"
          @onOrder="formVisible=true" :orderEntriesTotal="order.totalQuantity" />
      </el-row>
      <el-row type="flex" justify="end" align="center" class="show-btn-row">
        <i class="iconfont icon_arrow" v-if="!allOrdersShow" @click="allOrdersShow=true">&#xe714;&nbsp;展开全部单据</i>
        <i class="iconfont icon_arrow" v-if="allOrdersShow" @click="allOrdersShow=false">&#xe713;&nbsp;收回全部单据</i>
      </el-row>
      <el-row v-if="allOrdersShow">
        <progress-orders-table :orders="slotData.productionProgressOrders" />
      </el-row>
      <el-row type="flex" align="top" class="progress-update-form-row">
        <el-col :span="2">
          <h6 class="progress-update-form-text1">上传图片:</h6>
        </el-col>
        <el-col :span="22" :offset="1">
          <media-image-card-show :medias="slotData.medias" />
        </el-col>
      </el-row>
      <el-row type="flex" align="top" class="progress-update-form-row">
        <el-col :span="2">
          <h6 class="progress-update-form-text1">备注:</h6>
        </el-col>
        <el-col :span="22" :offset="1">
          <el-input type="textarea" readonly :rows="3" placeholder="填写备注" v-model="slotData.remarks">
          </el-input>
        </el-col>
      </el-row>
      <el-row type="flex" justify="center" align="top" class="progress-update-form-row">
        <el-button size="mini" class="update-form-submit" @click="onSubmit">确定</el-button>
      </el-row>
    </div>
  </div>
</template>

<script>
  import ImagesUpload from '../ImagesUpload';
  import ProgressColorSizeTable from './ProgressColorSizeTable';
  import MediaImageCardShow from './MediaImageCardShow';
  import ProgressOrdersTable from './ProgressOrdersTable';
  import ProgressOrderForm from './ProgressOrderForm';

  export default {
    name: 'OrderProgressUpdateForm',
    props: ['slotData', 'order'],
    components: {
      ImagesUpload,
      ProgressColorSizeTable,
      MediaImageCardShow,
      ProgressOrdersTable,
      ProgressOrderForm
    },
    mixins: [],
    computed: {
      cooperatorName: function () {
        if (this.order.cooperator.type == 'ONLINE') {
          return this.order.cooperator.partner.name;
        } else {
          return this.order.cooperator.name;
        }
      },

    },
    methods: {
      async onSubmit() {
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
    },
    data() {
      return {
        allOrdersShow: false,
        formVisible: false,
        form: {
          date: '',
          num: '',
          remarks: '',
          attachments: []
        }
      }
    },
    created() {

    },
    mounted() {}

  }

</script>
<style scoped>
  .progress-update-form-text1 {
    font-weight: 500;
    color: rgba(0, 0, 0, 0.85);
    font-size: 12px;
    padding-top: 5px;
  }

  .progress-update-form-datepicker {
    font-size: 12px;
  }

  .progress-update-form-row {
    margin-bottom: 10px;
  }

  .order-purchase-upload {}

  .order-purchase-upload>>>.el-upload--picture-card {
    width: 100px;
    height: 100px;
    line-height: 100px;
  }

  .order-purchase-upload>>>.el-upload-list--picture-card .el-upload-list__item {
    width: 100px;
    height: 100px;
  }

  .update-form-submit {
    background-color: #FFD60C;
    border-color: #FFD60C;
    color: #000;
    width: 150px;
    margin-top: 50px;
  }

  .form-main {
    padding-left: 50px;
    padding-right: 50px;
  }

  .show-btn-row {
    margin-bottom: 20px;
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

</style>
