<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col :span="6">
          <div class="progress-list-title">
            <h6>{{code == undefined ? '创建进度工单' : '编辑进度工单'}}</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <el-form :inline="true">
        <progress-order-receiving-form :formData="formData" :isRead="false"/>
        <progress-order-production-info-form :formData="formData" :isRead="false"/>
        <progress-order-node-form ref="nodeForm" :formData="formData"/>
      </el-form>
      <el-row type="flex" justify="center" align="middle">
        <el-button class="material-btn" @click="updateProgress">保存</el-button>
      </el-row>
    </el-card>
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
    'ProgressOrderModule'
  );

  import ProgressOrderReceivingForm from '../form/ProgressOrderReceivingForm';
  import ProgressOrderProductionInfoForm from '../form/ProgressOrderProductionInfoForm';
  import ProgressOrder from '../../components/progress-order';
  import ProgressOrderNodeForm from './ProgressOrderNodeForm';
  export default {
    name: 'ProgressOrderDetail',
    props: ['code'],
    components: {
      ProgressOrderNodeForm,
      ProgressOrder,
      ProgressOrderProductionInfoForm,
      ProgressOrderReceivingForm
    },
    computed: {
      ...mapGetters({
        formData: 'formData'
      })
    },
    methods: {
      ...mapActions({
        getOrderDetail: 'getDetail',
        clearFormData: 'clearFormData'
      }),
      async getDetail () {
        const code = this.code;
        await this.getOrderDetail(code);
      },
      updateProgress () {
        if (this.formData.id) {
          this._updateProgress();
        } else {
          this.createProgressOrder();
        }
      },
      async _updateProgress () {
        let formData = {
          id: this.formData.id,
          priorityLevel: this.formData.priorityLevel,
          personInCharge: this.formData.personInCharge,
          progresses: this.formData.progresses
        }
        const url = this.apis().updateProgressOrder();
        const result = await this.$http.put(url, formData);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        }
        await this.$router.go(-1);
      },
      async createProgressOrder () {
        const id = this.$route.params.order.taskOrderEntries[0].id;
        let formData = {
          priorityLevel: this.formData.priorityLevel,
          personInCharge: this.formData.personInCharge,
          progresses: this.formData.progresses
        }
        const url = this.apis().createProgressOrder(id);
        const result = await this.$http.post(url, formData);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        }
        await this.$router.go(-1);
      }
    },
    data () {
      return {

      }
    },
    created () {
      console.log(this.$route.params.order);
      if (this.code == undefined && this.$route.params.order != null) {
        const order = this.$route.params.order;
        this.formData.belongTo = order.creator;
        this.formData.machiningType = order.cooperationMode;
        this.formData.orderCode = order.code;
        this.formData.product = order.taskOrderEntries[0].product;
        this.formData.expectedDeliveryDate = order.taskOrderEntries[0].deliveryDate;
        this.formData.colorSizeEntries = order.taskOrderEntries[0].colorSizeEntries;
        this.formData.progresses = [];
        this.$nextTick(() => {
          this.$refs.nodeForm.getPhaseList();
        })
      } else if (this.code != undefined){
        this.getDetail();
        this.$nextTick(() => {
          this.$refs.nodeForm.getPhaseList();
        })
      }
    },
    destroyed () {
      this.clearFormData();
    }
  }
</script>

<style scoped>
  .progress-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .material-btn {
    background-color: #ffd60c;
    /* border-color: #000000; */
    color: #000;
    width: 100px;
    /* height: 35px; */
    margin-top: 20px;
  }
</style>
