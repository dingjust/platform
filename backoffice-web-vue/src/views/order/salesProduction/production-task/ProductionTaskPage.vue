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
  </div>
</template>

<script>
  import ProductionTaskToolbar from './toolbar/ProdcutionTaskToolbar';
  import ProductionTaskList from './list/ProductionTaskList';
  export default {
    name: 'ProductionTaskPage',
    components: {ProductionTaskList, ProductionTaskToolbar},
    methods: {
      createOutboundOrder () {

      }
    },
    data () {
      return {
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
