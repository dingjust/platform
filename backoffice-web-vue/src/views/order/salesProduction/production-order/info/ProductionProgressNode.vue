<template>
  <div class="info-remarks-body" @mouseenter="onShowButton(true)" @mouseleave="onShowButton(false)">
    <el-row>
      <production-progress-node-info :slot-data="slotData"/>
    </el-row>
    <div class="progress-modal" v-show="showButton" v-if="modalExist">
      <el-row type="flex" justify="center" align="middle" class="progress-modal-row">
        <el-button type="primary" plain @click="estimatedFormVisible=true">设置预计完成时间</el-button>
      </el-row>
    </div>
    <el-dialog :visible.sync="estimatedFormVisible" width="30%" class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <production-progress-date-setting-form :slotData="slotData" @afterSubmit="onAfterSubmit" />
    </el-dialog>
  </div>
</template>

<script>
  import ProductionProgressDateSettingForm from '../form/ProductionProgressDateSettingForm';
  import ProductionProgressNodeInfo from './ProductionProgressNodeInfo';
  export default {
    name: 'ProductionProgressNode',
    components: {ProductionProgressNodeInfo, ProductionProgressDateSettingForm},
    props: ['slotData'],
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
      onShowButton (value) {
        this.showButton = value;
      },
      onAfterSubmit () {
        this.estimatedFormVisible = false;
        // this.refreshData();
      },
      async refreshData () {
        const url = this.apis().getPurchaseOrder(this.slotData.code);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        // 跟新slotData
        this.$set(this.slotData, 'progresses', result.progresses);
      }
    },
    data () {
      return {
        showButton: false,
        estimatedFormVisible: false
      }
    }
  }
</script>

<style scoped>
  .info-remarks-body {
    position: relative;
    width: 100%;
    margin-top: 20px;
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
