<template>
  <div class="info-remarks-body" @mouseenter="onShowButton(true)" @mouseleave="onShowButton(false)">
    <el-dialog :visible.sync="estimatedFormVisible" width="30%" class="purchase-dialog" append-to-body>
      <progress-date-setting-form :slotData="slotData" @afterSubmit="onAfterSubmit" />
    </el-dialog>
    <el-row type="flex" justify="space-between" align="middle" class="info-title-row">
      <div class="info-title">
        <h6 class="info-title_text">生产进度</h6>
      </div>
    </el-row>
    <el-row>
      <purchase-order-progress :slotData="slotData" />
    </el-row>
    <div class="progress-modal" v-show="showButton" v-if="modalExist">
      <el-row type="flex" justify="center" align="middle" class="progress-modal-row">
        <el-button type="primary" plain @click="estimatedFormVisible=true">设置预计完成时间</el-button>
      </el-row>
    </div>
  </div>
</template>

<script>
  import PurchaseOrderProgress from '@/components/custom/ProductionProgress/PurchaseOrderProgress';
  import ProgressDateSettingForm from '../components/ProgressDateSettingForm';

  export default {
    name: 'PurchaseOrderInfoProgress',
    props: ['slotData'],
    components: {
      PurchaseOrderProgress,
      ProgressDateSettingForm
    },
    mixins: [],
    computed: {
      modalExist: function () {
        if (this.isFactory() && this.slotData.status == 'IN_PRODUCTION') {
          var result = false;
          this.slotData.progresses.forEach(element => {
            if (element.estimatedDate == null || element.estimatedDate == '') {
              result = true;
            }
          });
          return result;
        } else {
          return false;
        }
      }
    },
    methods: {
      onAfterCreate() {
        this.deliverFormVisible = false;
      },
      onShowButton(value) {
        this.showButton = value;
      },
      async refreshData() {
        const url = this.apis().getPurchaseOrder(this.slotData.code);
        const result = await this.$http.get(url);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }
        //跟新slotData
        this.$set(this.slotData, 'progresses', result.progresses);
      },
      onAfterSubmit() {
        this.estimatedFormVisible=false;
        this.refreshData();
      }
    },
    data() {
      return {
        deliverFormVisible: false,
        showButton: false,
        estimatedFormVisible: false,
      }
    },
    created() {}
  }

</script>
<style>
  .info-remarks-body {
    position: relative;
    width: 100%;
    margin-top: 20px;
  }

  .info-remarks-img {
    width: 50px;
    height: 50px;
    border-radius: 10px;
    margin-right: 10px;
  }

  .info-remarks-row {
    margin-top: 20px;
  }

  .info-remarks-textarea {
    width: 100%;
    border: 0.5px solid rgba(0, 0, 0, 0.15);
    padding: 5px 10px;
    border-radius: 3px;
  }

  .info-remarks-textarea_text {
    font-size: 10px;
    color: rgba(0, 0, 0, 0.45);
  }

  .info-detail-logistics_info-btn1 {
    width: 70px;
    height: 25px;
    background: #FFD60C;
    font-weight: 400;
    color: rgba(0, 0, 0, 0.85);
    font-size: 10px;
    border-radius: 0px;
    border: 0px solid #FFD60C;
  }

  .progress-modal {
    position: absolute;
    background-color: rgba(0, 0, 0, 0.35);
    width: 100%;
    height: 100%;
    left: 0px;
    top: 0px;
    z-index: 2;
  }

  .progress-modal-row {
    height: 100%;
    width: 100%;
  }

</style>
