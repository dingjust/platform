<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col :span="6">
          <div class="outbound-list-title">
            <h6>外发订单详情</h6>
          </div>
        </el-col>
      </el-row>
      <outbound-order-top-info :slotData="formData" />
      <outbound-order-center-table :slot-data="formData" @onDetail="onDetail" />
      <el-row class="basic-form-row" type="flex" align="middle">
        <h6>备注及附件</h6>
      </el-row>
      <el-row type="flex" style="padding-left: 20px">
        <el-col>
          <el-input type="textarea" autosize v-model="formData.remarks" :autosize="{ minRows: 4, maxRows: 6 }" />
        </el-col>
      </el-row>
      <el-row type="flex" justify="center" align="middle" style="margin-top: 20px" v-if="isBelongTo">
        <el-button class="purchase-order-btn2" @click="onGenerateUniqueCode" v-if="canGenerate">唯一码</el-button>
        <el-button class="purchase-order-btn2" @click="onCancel" v-if="this.formData.status != ''">取消订单</el-button>
      </el-row>
    </el-card>
    <el-dialog :visible.sync="taskDetailVisible" width="80%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <production-task-details v-if="taskDetailVisible" :id="productionTaskId" :isOutboundRead="true" />
    </el-dialog>
    <el-dialog :visible.sync="uniqueCodeFormVisible" width="30%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <unique-code-generate-form :order="formData" />
    </el-dialog>
  </div>
</template>

<script>
  import {
    createNamespacedHelpers
  } from 'vuex';

  const {
    mapGetters,
    mapActions
  } = createNamespacedHelpers(
    'OutboundOrderModule'
  );

  import OutboundOrderTopInfo from '../form/OutboundOrderTopInfo';
  import OutboundOrderCenterTable from '../form/OutboundOrderCenterTable';
  import UniqueCodeGenerateForm from '../form/UniqueCodeGenerateForm';
  import ProductionTaskDetails from '../../production-task/details/ProductionTaskDetail';
  export default {
    name: 'OutboundOrderDetail',
    props: ['code'],
    components: {
      ProductionTaskDetails,
      OutboundOrderCenterTable,
      OutboundOrderTopInfo,
      UniqueCodeGenerateForm
    },
    computed: {
      ...mapGetters({
        formData: 'formData'
      }),
      isReceiver: function () {
        const uid = this.$store.getters.currentUser.companyCode;
        return !(uid == this.formData.belongTo.uid) && this.formData.status == 'PENDING_CONFIRM';
      },
      isBelongTo: function () {
        const uid = this.$store.getters.currentUser.companyCode;
        return uid == this.formData.belongTo.uid && this.formData.status != 'CONFIRMED' && this.formData.status !=
          'CANCELLED';
      },
      canGenerate: function () {
        if (this.formData.cooperator != null && this.formData.cooperator.type == 'OFFLINE' && this.formData.status ==
          'PENDING_CONFIRM') {
          //TODO判断有无唯一码
          return true;
        } else {
          return false;
        }
      }
    },
    methods: {
      ...mapActions({
        clearFormData: 'clearFormData'
      }),
      async getDetail() {
        const url = this.apis().getoutboundOrderDetail(this.code);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.$store.state.OutboundOrderModule.formData = Object.assign({}, result);
      },
      onDetail(row) {
        this.taskDetailVisible = true;
        this.productionTaskId = row.productionTask.id;
      },
      async onCancel() {
        const url = this.apis().cancelOutboundOrder(this.formData.code);
        const result = await this.$http.put(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.$message.success('取消订单成功');
        await this.getDetail();
      },
      async onConfirm() {
        const url = this.apis().acceptOutboundOrder(this.formData.code);
        const result = await this.$http.put(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.$message.success('接单成功');
        await this.getDetail();
      },
      async onRejected() {
        const url = this.apis().rejectedOutboundOrder(this.formData.code);
        const result = await this.$http.put(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.$message.success('拒绝接单成功');
        await this.getDetail();
      },
      async onGenerateUniqueCode() {
        this.uniqueCodeFormVisible = true;
      }
    },
    data() {
      return {
        productionTaskId: '',
        taskDetailVisible: false,
        uniqueCodeFormVisible: false
      }
    },
    created() {
      this.getDetail();
    },
    destroyed() {
      this.clearFormData();
    }
  }

</script>

<style scoped>
  .outbound-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .basic-form-row {
    margin-top: 20px;
    padding-left: 10px;
  }

  .purchase-order-btn2 {
    /* background: red;
    color: #fff; */
    width: 200px;
  }

  .purchase-order-btn {
    background: #FFD60C;
    color: rgba(0, 0, 0, 0.85);
    width: 200px;
  }

</style>
