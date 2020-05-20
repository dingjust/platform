<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col :span="4">
          <div class="sales-plan-form-title">
            <h6>生产任务列表</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <production-task-toolbar @createOutboundOrder="createOutboundOrder"/>
      <production-task-list :page="page"/>
    </el-card>
    <el-dialog :visible.sync="outboundOrderTypeSelect" width="60%" class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <outbound-order-type-select-form v-if="outboundOrderTypeSelect" :formData="formData"/>
    </el-dialog>
  </div>
</template>

<script>
  import ProductionTaskToolbar from './toolbar/ProdcutionTaskToolbar';
  import ProductionTaskList from './list/ProductionTaskList';
  import OutboundOrderTypeSelectForm from '../outbound-order/form/OutboundOrderTypeSelectForm';
  export default {
    name: 'ProductionTaskPage',
    components: {OutboundOrderTypeSelectForm, ProductionTaskList, ProductionTaskToolbar},
    methods: {
      createOutboundOrder () {
        this.outboundOrderTypeSelect = true;
      }
    },
    data () {
      return {
        outboundOrderTypeSelect: false,
        formData: this.$store.state.OutboundOrderModule.formData,
        page: {
          number: 0,
          size: 10,
          totalPages: 100,
          totalElements: 100,
          content: []
        }
      }
    }
  }
</script>

<style scoped>
  .sales-plan-form-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }
</style>
