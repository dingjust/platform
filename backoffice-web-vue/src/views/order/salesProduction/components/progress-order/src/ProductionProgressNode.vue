<template>
  <div class="info-remarks-body" @mouseenter="onShowButton(true)" @mouseleave="onShowButton(false)">
    <el-row>
      <production-progress-node-info :slot-data="slotData" @callback="onCallback" :order="order"/>
    </el-row>
    <div class="progress-modal" v-show="showButton" v-if="modalExist">
      <el-row type="flex" justify="center" align="middle" class="progress-modal-row">
        <authorized :permission="['PROGRESS_WORK_ORDER_CREATE']">
          <el-button type="primary" plain @click="estimatedFormVisible=true" :disabled="!canEdit">设置预计完成时间</el-button>
        </authorized>
      </el-row>
    </div>
    <el-dialog :visible.sync="estimatedFormVisible" width="30%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <production-progress-date-setting-form v-if="estimatedFormVisible" :slotData="slotData"
        @afterSubmit="onAfterSubmit" />
    </el-dialog>
  </div>
</template>

<script>
  import ProductionProgressDateSettingForm from './form/ProductionProgressDateSettingForm';
  import ProductionProgressNodeInfo from './ProductionProgressNodeInfo';
  export default {
    name: 'ProductionProgressNode',
    components: {
      ProductionProgressNodeInfo,
      ProductionProgressDateSettingForm
    },
    props: ['slotData', 'canEdit', 'order'],
    computed: {
      //还没设置预计完成时间
      modalExist: function () {
        // 判断已外发并且是协同的生产工单不能设置
        if (this.order.outboundOrderCode && this.order.outboundOrderType === 'COLLABORATION') {
          return false;
        }

        if (this.slotData.status == 'IN_PRODUCTION') {
          var result = false;
          if (this.slotData != null) {
            this.slotData.progresses.forEach(element => {
              if (element.estimatedDate == null || element.estimatedDate == '') {
                result = true;
              }
            });
          }
          return result;
        } else {
          return false;
        }
      }
    },
    methods: {
      onShowButton(value) {
        this.showButton = value;
      },
      onAfterSubmit() {
        this.estimatedFormVisible = false;
        this.$emit('callback');
      },
      onCallback(data) {
        this.$emit('callback', data);
      }
    },
    data() {
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
