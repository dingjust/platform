<template>
  <div>
    <el-form :inline="true">
      <el-row type="flex" justify="space-between">
        <el-col :span="20" style="padding-top: 5px">
          <el-form-item label="订单信息" prop="name">
            <el-input placeholder="请输入订单号，订单名称" v-model="queryFormData.keywords"></el-input>
          </el-form-item>
          <el-form-item label="负责人" prop="name">
            <el-input placeholder="请输入跟单员姓名" v-model="queryFormData.productionLeaderName"></el-input>
          </el-form-item>
          <el-form-item label="合作商" prop="name">
            <el-input placeholder="请输入合作商名称" v-model="queryFormData.cooperator"></el-input>
          </el-form-item>
          <el-button-group>
            <el-button type="primary" class="toolbar-search_input" @click="onAdvancedSearch">搜索</el-button>
            <el-button native-type="reset" @click="onReset">重置</el-button>
          </el-button-group>
        </el-col>
        <el-col :span="4" v-if="!isSelect">
          <el-row type="flex" justify="end">
            <authorized :permission="['OUT_ORDER_CREATE']">
              <el-button type="primary" class="create-button" @click="createOutboundOrder">创建外发订单</el-button>
            </authorized>
            <el-button type="primary" class="create-button" @click="createProductionOrder">创建生产工单</el-button>
          </el-row>
        </el-col>
      </el-row>
    </el-form>
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

  import SalesProductionStatusBar from '../../components/SalesProductionStatusBar';
  export default {
    name: 'ProdcutionTaskToolbar',
    props: {
      isSelect: {
        type: Boolean,
        default: false
      }
    },
    components: {
      SalesProductionStatusBar
    },
    computed: {
      ...mapGetters({
        queryFormData: 'queryFormData'
      })
    },
    methods: {
      ...mapMutations({
        setKeyword: 'keyword',
        setQueryFormData: 'queryFormData'
      }),
      onAdvancedSearch() {
        this.setQueryFormData(this.queryFormData);
        this.$emit('onAdvancedSearch', 0);
      },
      onReset() {
        this.queryFormData.keywords = '';
        this.queryFormData.productionLeaderName = '';
        this.queryFormData.cooperator = '';
      },
      createOutboundOrder() {
        this.$emit('createOutboundOrder');
      },
      createProductionOrder() {
        this.$emit('createProductionOrder');
      }
    },
    data() {
      return {
        // queryFormData: {
        //   keywords: '',
        //   productionLeaderName: '',
        //   cooperator: '',
        //   status: ''
        // },
        statuses: this.$store.state.EnumsModule.SalesProductionStatuses
      }
    }
  }

</script>

<style scoped>
  .toolbar-search_input {
    background-color: #ffd60c;
    border-color: #ffd60c;
  }

  .create-button {
    background-color: #ffd60c;
    border-color: #DCDFE6;
    width: 100px;
    height: 40px;
    color: #606266;
  }

  .el-form-item--mini.el-form-item,
  .el-form-item--small.el-form-item {
    margin-bottom: 5px !important;
  }

</style>
