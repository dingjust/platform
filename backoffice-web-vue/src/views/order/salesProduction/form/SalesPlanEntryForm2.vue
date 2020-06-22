<template>
  <div class="animated fadeIn">
    <el-card>
      <el-row type="flex" justify="space-between">
        <el-col :span="6">
          <div class="sales-plan-form-title">
            <h6>订单详情</h6>
          </div>
        </el-col>
        <el-col :span="6">
          <!-- <h6>任务单号:&#12288;{{formData.entries[0].productionTask.code}}</h6> -->
        </el-col>
        <el-col :span="6">
          <!-- <h6>订单状态:&#12288;{{getEnum('ProductionState', scope.row.state)}}</h6> -->
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <receiving-details-form :slotData="formData" />
    </el-card>
  </div>
</template>

<script>
  import {
    createNamespacedHelpers
  } from 'vuex';

  const {
    mapGetters,
    mapActions,
    mapMutations
  } = createNamespacedHelpers(
    'ProductionTasksModule'
  );


  import ReceivingDetailsForm from '../production-task/form/ReceivingDetailsForm';

  export default {
    name: 'SalesPlanEntryForm',
    props: ['formData'],
    components: {
      ReceivingDetailsForm,
    },
    computed: {

    },
    methods: {

    },
    data() {
      return {

      }
    },
    created() {
    }
  }

</script>

<style scoped>
  .sales-plan-form-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .purchase-product-img {
    width: 120px;
    height: 120px;
    border-radius: 10px;
    margin-right: 20px;
  }

  .info-basic-row {
    margin-top: 10px;
  }

  .border-container {
    border: 1px solid #DCDFE6;
    border-radius: 5px;
    padding-top: 10px;
  }

  .production-task-btn {
    background-color: #ffd60c;
    border-color: #DCDFE6;
    width: 100px;
    height: 40px;
    color: #606266;
  }

</style>
